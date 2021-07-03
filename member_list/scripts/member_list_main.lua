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
}

local message_ns = 'com.github.oocytanb.oO-vci-pack.member_list'
local user_loaded_message_name = message_ns .. '.user_loaded'
local member_status_message_name = message_ns .. '.member_status'

---@param avatar_ ExportAvatar | nil
---@return boolean
local function avatar_is_owner(avatar_)
  return not not (avatar_ and avatar_.IsOwner())
end

local enable_debug_log = avatar_is_owner(vci.studio.GetLocalAvatar())

---@class MessageSender
---@field type string
---@field name string
---@field commentSource string

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
local dlog = enable_debug_log and print or noop

---@alias WorldTypeIndex number

---@class WorldType
---@field studio WorldTypeIndex
---@field room WorldTypeIndex
local WorldType = {
  studio = 1,
  room = 2,
}

---@type string[]
local world_type_string_list = {
  'Studio',
  'Room'
}

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
---@return string
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

---@return Member, boolean @first is own member info; second is state changed or not.
local own_member = (function ()
  local own_ava_ = vci.studio.GetLocalAvatar()

  local om = own_ava_ and
    member_from_avatar(own_ava_) or
    { id = '', name = '', visible = false }

  local next_time = TimeSpan.Zero
  local max_time = vci.me.UnscaledTime + settings.avatar_detection_max_time
  local timeout = false

  return function ()
    if not timeout then
      local now = vci.me.UnscaledTime
      if now <= max_time then
        if now >= next_time then
          next_time = now + settings.avatar_detection_interval

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

          return om, true
        end
      else
        timeout = true
        return om, true
      end
    end

    return om, false
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

---@class UserLoadedMessageParameters
---@field member Member
---@field count number
---@field visible_count number

---@class MemberStatusMessageParameters
---@field visible_member_ids string[]
---@field count number
---@field visible_count number

local member_list_item = get_sub_item(settings.list_name)

---@type table<string, ExportAudioSource>
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
local ready_to_play_notification_se_time = vci.me.UnscaledTime

---@type ExportAvatar[]
local pending_avatar_list = {}

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

---@param world_type_index WorldTypeIndex
---@param avatars ExportAvatar[]
---@return string
local function avatars_to_reporting_string(world_type_index, avatars)
  local buffer = 'member_list @ ' .. world_type_to_string(world_type_index)
  for i, ava in ipairs(avatars) do
    local m = member_from_avatar(ava)
    buffer = string.format(
      '%s\n[%d] %s | %s',
      buffer, i, member_to_string(m), m.id
    )
  end
  return buffer
end

---@type fun(avatars: ExportAvatar[])
local dlog_avatars = enable_debug_log and
  function (avatars)
    dlog(avatars_to_reporting_string(world_type(), avatars))
  end or
  noop

---@param sender MessageSender
---@param messageName string
---@param message string
local function on_notification(sender, messageName, message)
  dlog(string.format('# on notification: "%s" %s', sender.name, message))

  local se_ = notification_se_map[message]
  if se_ then
    local avatars_ = vci.studio.GetAvatars()
    if avatars_ then
      pending_avatar_list = avatars_

      local now = vci.me.UnscaledTime
      if now >= ready_to_play_notification_se_time then
        ready_to_play_notification_se_time = now + settings.se_interval
        se_.PlayOneShot(1)
      end
    end
  end
end

vci.message.On('notification', on_notification)

---@param sender MessageSender
---@param messageName string
---@param parameters UserLoadedMessageParameters
local function on_user_loaded_message(sender, messageName, parameters)
  local m_ = parameters.member
  if m_ then
    dlog(
      string.format('# on user_loaded: %s | %s', member_to_string(m_), m_.id)
    )

    member_status = merge_member(m_, member_status)
    update_display(member_status)

    if vci.assets.IsMine and
        parameters.visible_count < member_status.visible_count
    then
      ---@type MemberStatusMessageParameters
      local status_parameters = {
        visible_member_ids = visible_member_id_list(member_status),
        count = member_status.count,
        visible_count = member_status.visible_count,
      }
      emit_instance_message(member_status_message_name, status_parameters)
    end
  end
end

vci.message.On(user_loaded_message_name, on_user_loaded_message)

---@param sender MessageSender
---@param messageName string
---@param parameters MemberStatusMessageParameters
local function on_member_status_message(sender, messageName, parameters)
  if not vci.assets.IsMine and
      member_status.visible_count < parameters.visible_count
  then
    dlog(string.format(
      '# on member_status: visible_count = %s',
      parameters.visible_count
    ))

    for _, id in pairs(parameters.visible_member_ids) do
      member_status = merge_visible_id(id, member_status)
    end
    update_display(member_status)
  end
end

vci.message.On(member_status_message_name, on_member_status_message)

function updateAll()
  if not user_loaded then
    local om, changed = own_member()
    if changed then
      pending_avatar_list = vci.studio.GetAvatars() or pending_avatar_list
    end

    if om.visible then
      user_loaded = true

      ---@type UserLoadedMessageParameters
      local parameters = {
        member = om,
        count = member_status.count,
        visible_count = member_status.visible_count,
      }
      emit_instance_message(user_loaded_message_name, parameters)
    end
  end

  if pending_avatar_list[1] then
    member_status = make_member_status(
      world_type(),
      pending_avatar_list,
      member_status.members
    )
    pending_avatar_list = {}

    update_display(member_status)
  end
end

function onUse(use)
  if use == settings.list_name then
    pending_avatar_list = vci.studio.GetAvatars() or pending_avatar_list

    if pending_avatar_list[1] then
      dlog_avatars(pending_avatar_list)
    end
  end
end
