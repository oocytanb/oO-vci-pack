-- SPDX-License-Identifier: MIT
-- Copyright (c) 2021 oO (https://github.com/oocytanb)

local settings = {
  status_text_name = 'status_text',
  list_name = 'member_list',
  list_text_name = 'list_text',
  list_body_name = 'list_body',
  list_body_row_height = 0.0565,
  list_body_row_margin = 0.015,
  visible_symbol = '*',
  invisible_symbol = '~',
  avatar_detection_interval = TimeSpan.FromSeconds(20),
  avatar_detection_max_time = TimeSpan.FromMinutes(10),
  notification_se_map = {
    ['joined'] = 'entering_se',
    ['left'] = 'leaving_se',
  },
  se_interval = TimeSpan.FromSeconds(1),
  output_debug_log = (function (ava_)
    return not not (ava_ and ava_.IsOwner())
  end)(vci.studio.GetLocalAvatar()),
}

local message_ns = 'com.github.oocytanb.oO-vci-pack.member_list'
local user_loaded_message_name = message_ns .. '.user_loaded'
local member_status_message_name = message_ns .. '.member_status'

---@param name string
---@return ExportTransform
local function get_sub_item(name)
  return assert(vci.assets.GetSubItem(name))
end

---@param name string
---@return ExportTransform
local function get_game_object_transform(name)
  return assert(vci.assets.GetTransform(name))
end

---@param messageName string
---@param value any
local function emit_instance_message(messageName, value)
  vci.message.EmitWithId(messageName, value, vci.assets.GetInstanceId() or '')
end

local function noop()
  -- Do nothing
end

---@type fun(msg: string)
local dlog = settings.output_debug_log and print or noop

---@alias WorldTypeIndex number

---@class WorldType
---@field studio WorldTypeIndex
---@field room WorldTypeIndex
local WorldType = {
  studio = 1,
  room = 2,
}

local world_type_string_list = { 'Studio', 'Room' }

---@return WorldTypeIndex
local world_type = (function ()
  local studio_item_detected = false

  return function ()
    if not studio_item_detected then
      studio_item_detected = vci.studio.HasWindowCamera()
    end

    return studio_item_detected and WorldType.studio or WorldType.room
  end
end)()

---@param world_type_index WorldTypeIndex
local function world_type_to_string(world_type_index)
  return world_type_string_list[world_type_index] or 'Unknown'
end

---@class Member
---@field id string
---@field name string
---@field visible boolean

---@alias MemberMap table<string, Member>

---@param avatar ExportAvatar
---@return boolean
local function avatar_is_visible(avatar)
  return avatar.GetPosition() ~= nil
end

---@param avatar ExportAvatar
---@return Member
local function member_from_avatar(avatar)
  return {
    id = avatar.GetId() or '',
    name = avatar.GetName() or '',
    visible = avatar_is_visible(avatar),
  }
end

---@return Member
local own_member = (function ()
  local own_ava_ = vci.studio.GetLocalAvatar()

  local om = own_ava_ and
    member_from_avatar(own_ava_) or
    { id = '', name = '', visible = false }

  local last_time = vci.me.UnscaledTime
  local max_time = last_time + settings.avatar_detection_max_time
  local timeout = om.visible

  return function ()
    if not timeout then
      local now = vci.me.UnscaledTime
      if now <= max_time then
        if now - last_time >= settings.avatar_detection_interval then
          if not own_ava_ then
            own_ava_ = vci.studio.GetLocalAvatar()
            if own_ava_ then
              om = member_from_avatar(own_ava_)
            end
          else
            om.visible = avatar_is_visible(own_ava_)
          end

          if om.visible then
            timeout = true
          end
        end
      else
        timeout = true
      end
    end

    return om
  end
end)()

---@class MemberStatus
---@field world_type_index WorldTypeIndex
---@field members MemberMap
---@field count number
---@field visible_count number

---@param visible_id string
---@param status MemberStatus
---@return MemberStatus
local function merge_visible_id(visible_id, status)
  local m_ = status.members[visible_id]
  if m_ then
    if not m_.visible then
      m_.visible = true
      status.visible_count = status.visible_count + 1
    end
  end
  return status
end

---@param member Member
---@param status MemberStatus
---@return MemberStatus
local function merge_member(member, status)
  local id = member.id
  local m_ = status.members[id]
  if m_ then
    if not m_.visible and member.visible then
      status = merge_visible_id(id, status)
    end
  else
    status.members[id] = member
    status.count = status.count + 1
    if member.visible then
      status.visible_count = status.visible_count + 1
    end
  end

  return status
end

---@param world_type_index WorldTypeIndex
---@param avatars ExportAvatar[]
---@param prev_members MemberMap
---@return MemberStatus
local function make_member_status(world_type_index, avatars, prev_members)
  local s = {
    world_type_index = world_type_index,
    members = {},
    count = 0,
    visible_count = 0,
  }

  for _, ava in ipairs(avatars) do
    local m = member_from_avatar(ava)
    local id = m.id

    if not m.visible then
      local pm = prev_members[id]
      if pm and pm.visible then
        m.visible = true
      end
    end

    s = merge_member(m, s)
  end

  return s
end

---@param status MemberStatus
---@return string[]
local function visible_member_id_list(status)
  local j = 1
  local ls = {}
  for _, m in pairs(status.members) do
    if m.visible then
      ls[j] = m.id
      j = j + 1
    end
  end
  return ls
end

---@param member Member
---@return string
local function member_to_string(member)
  return (
    member.visible and
    settings.visible_symbol or
    settings.invisible_symbol
  ) .. ' ' .. member.name
end

---@param member Member
---@param str string
---@return string
local function append_member_string(member, str)
  return str == '' and
    member_to_string(member) or
    (str .. '\n' .. member_to_string(member))
end

---@class MemberStatusStrings
---@field status string
---@field body string

---@param status MemberStatus
---@return MemberStatusStrings
local function member_status_to_strings(status)
  local visible_buffer = ''
  local invisible_buffer = ''

  for _, m in pairs(status.members) do
    if m.visible then
      visible_buffer = append_member_string(m, visible_buffer)
    else
      invisible_buffer = append_member_string(m, invisible_buffer)
    end
  end

  local buffer = visible_buffer ..
    ((visible_buffer == '' or invisible_buffer == '') and '' or '\n') ..
    invisible_buffer

  local status_buffer = '[' ..
    world_type_to_string(status.world_type_index) ..
    ', ' .. status.count ..
    (
      status.visible_count < status.count and
      ' (' .. settings.visible_symbol .. ' ' .. status.visible_count .. ')' or
      ''
    ) .. ']'

  return {
    status = status_buffer,
    body = buffer,
  }
end

local member_list_item = get_sub_item(settings.list_name)

local notification_se_map = (function ()
  local audio_sources = {}
  for _, audio in pairs(member_list_item.GetAudioSources() or {}) do
    audio_sources[audio.ClipName or ''] = audio
  end

  local se_map = {}
  for k, clip_name in pairs(settings.notification_se_map) do
    se_map[k] = assert(audio_sources[clip_name])
  end
  return se_map
end)()

local list_body = get_game_object_transform(settings.list_body_name)
local initial_list_body_scale = list_body.GetLocalScale()

local user_loaded = false
local pending_avatar_list_ = nil
local last_play_notification_se_time = TimeSpan.Zero

local member_status = make_member_status(
  world_type(),
  vci.studio.GetAvatars() or {},
  {}
)

---@param status MemberStatus
local function update_display(status)
  local scale = Vector3.__new(
    initial_list_body_scale.x,
    settings.list_body_row_height * math.max(1, status.count) +
      settings.list_body_row_margin,
    initial_list_body_scale.z
  )
  list_body.SetLocalScale(scale)

  local s = member_status_to_strings(status)
  vci.assets.SetText(settings.list_text_name, s.body)
  vci.assets.SetText(settings.status_text_name, s.status)
end

---@param avatars ExportAvatar[]
local function dlog_avatars(avatars)
  if settings.output_debug_log then
    local buffer = 'member_list @ ' .. world_type_to_string(world_type())
    for i, ava in ipairs(avatars) do
      local m = member_from_avatar(ava)
      buffer = buffer .. '\n' ..
        '[' .. i .. '] ' .. member_to_string(m) ..
        ' | ' .. m.id
    end

    dlog(buffer)
  end
end

vci.message.On('notification', function (sender, messageName, message)
    dlog('# on notification: "' ..
      tostring(sender.name) .. '" ' ..
      tostring(message))

    local se_ = notification_se_map[message]
    if se_ then
      local avatars_ = vci.studio.GetAvatars()
      if avatars_ then
        pending_avatar_list_ = avatars_

        local now = vci.me.UnscaledTime
        if now - settings.se_interval >= last_play_notification_se_time then
          last_play_notification_se_time = now
          se_.PlayOneShot(1)
        end
      end
    end
end)

vci.message.On(user_loaded_message_name, function (sender, messageName, value)
  local m_ = value.member
  if m_ then
    dlog('# on user_loaded: ' ..
          member_to_string(m_) .. ' | ' ..
          tostring(m_.id))

    member_status = merge_member(m_, member_status)
    update_display(member_status)

    if vci.assets.IsMine and value.visible_count < member_status.visible_count
    then
      emit_instance_message(member_status_message_name, {
        visible_member_ids = visible_member_id_list(member_status),
        count = member_status.count,
        visible_count = member_status.visible_count,
      })
    end
  end
end)

vci.message.On(member_status_message_name, function (sender, messageName, value)
  if not vci.assets.IsMine and member_status.visible_count < value.visible_count
  then
    dlog('# on member_status: visible_count = ' .. value.visible_count)
    for _, id in pairs(value.visible_member_ids) do
      member_status = merge_visible_id(id, member_status)
    end
    update_display(member_status)
  end
end)

function updateAll()
  if not user_loaded then
    local om = own_member()
    if om.visible then
      user_loaded = true

      emit_instance_message(user_loaded_message_name, {
        member = om,
        count = member_status.count,
        visible_count = member_status.visible_count,
      })
    end
  end

  if pending_avatar_list_ then
    member_status = make_member_status(
      world_type(),
      pending_avatar_list_,
      member_status.members
    )
    pending_avatar_list_ = nil
    update_display(member_status)
  end
end

function onUse(use)
  if use == settings.list_name then
    pending_avatar_list_ = vci.studio.GetAvatars() or pending_avatar_list_

    if pending_avatar_list_ then
      dlog_avatars(pending_avatar_list_)
    end
  end
end
