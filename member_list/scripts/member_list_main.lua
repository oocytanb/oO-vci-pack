-- SPDX-License-Identifier: MIT
-- Copyright (c) 2021 oO (https://github.com/oocytanb)

local settings = {
  vci_title = 'cykhu_member_list',
  title_text_name = 'title_text',
  list_name = 'member_list',
  list_text_name = 'list_text',
  list_body_name = 'list_body',
  list_body_offset = Vector3.__new(0, -0.035, 0),
  list_body_row_height = 0.0565,
  list_body_row_margin = 0.015,
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

local function noop(msg)
  -- noop
end

local get_game_object_transform = function (name) return assert(vci.assets.GetTransform(name)) end

local dlog = settings.output_debug_log and print or noop

local list_body = get_game_object_transform(settings.list_body_name)
local initial_list_body_scale = list_body.GetLocalScale()

local initial_update_complete = false
local pending_avatar_list_ = nil
local last_play_notification_se_time = TimeSpan.Zero

local function make_member_status(avatars)
  local size = 0
  local text = ''
  local members = {}

  for _k, ava in ipairs(avatars) do
    local id = ava.GetId()
    local name = ava.GetName()
    if id and name then
      local has_avatar_body = ava.GetPosition() ~= nil

      size = size + 1
      members[size] = {
        id = id,
        name = name,
        avatar = ava,
        has_avatar_body = has_avatar_body,
      }

      text = text ..
        (size == 1 and '' or '\n') ..
        (has_avatar_body and '* ' or '- ') .. name
    end
  end

  return {
    members = members,
    size = size,
    member_text = text,
  }
end

local function update_display(member_status)
  local scale = Vector3.__new(
    initial_list_body_scale.x,
    settings.list_body_row_height * math.max(1, member_status.size) +
      settings.list_body_row_margin,
    initial_list_body_scale.z
  )
  list_body.SetLocalScale(scale)
  vci.assets.SetText(settings.list_text_name, member_status.member_text)
  vci.assets.SetText(
    settings.title_text_name,
    string.format('%s [%d]', settings.vci_title, member_status.size)
  )
end

vci.message.On('notification', function (sender, messageName, message)
    dlog('# on notification: "' ..
      tostring(sender.name) .. '" ' ..
      tostring(message))

    local se_name = settings.notification_se_map[message]
    if se_name then
      local avatars_ = vci.studio.GetAvatars()
      if avatars_ then
        pending_avatar_list_ = avatars_

        local now = vci.me.UnscaledTime
        if now - settings.se_interval >= last_play_notification_se_time then
          last_play_notification_se_time = now
          vci.assets.audio.PlayOneShot(se_name, 1)
        end
      end
    end
end)

vci.message.On(user_loaded_message_name, function (sender, messageName, data)
  dlog('# on user_loaded: ' ..
    tostring(data.avatar_name) .. ' | ' ..
    tostring(data.avatar_id))
  pending_avatar_list_ = vci.studio.GetAvatars() or pending_avatar_list_
end)

function updateAll()
  if not initial_update_complete then
    local own_ava = vci.studio.GetLocalAvatar()
    if own_ava then
      initial_update_complete = true

      vci.message.EmitWithId(user_loaded_message_name, {
        avatar_id = own_ava.GetId() or '',
        avatar_name = own_ava.GetName() or '',
      }, vci.assets.GetInstanceId() or '')
    end
  end

  if pending_avatar_list_ then
    update_display(make_member_status(pending_avatar_list_))
    pending_avatar_list_ = nil
  end
end

function onUse(use)
  if use == settings.list_name then
    pending_avatar_list_ = vci.studio.GetAvatars() or pending_avatar_list_
  end
end
