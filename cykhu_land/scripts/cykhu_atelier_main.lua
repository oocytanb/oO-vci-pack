-- SPDX-License-Identifier: MIT
-- Copyright (c) 2021 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local settings = (function ()
   local transform_switch_name = 'atelier_transform_switch'

   return {
      atelier_mesh_name = 'atelier_mesh',
      bounds_name = 'atelier_bounds',
      bounds_scale_factor = 10.0,
      flag_potential = 2048,
      controller_name = 'atelier_controller',
      transform_switch_name = transform_switch_name,
      controller_attention_name = 'controller_guest_attention',
      controller_attention_offset = Vector3.__new(0, 0, -0.011),

      switch_parameters = cytanb.ListToMap(
         {
            {
               colliderName = transform_switch_name,
               baseName = 'transform_knob_position',
               knobName = 'transform_knob',
               minValue = 0,
               maxValue = 1,
               value = 0,
            },
         },
         function (entry)
            local minValue = entry.minValue or 0
            local maxValue = entry.maxValue or 100

            return entry.colliderName, {
               colliderName = entry.colliderName,
               baseName = entry.baseName,
               knobName = entry.knobName,
               minValue = minValue,
               maxValue = maxValue,
               value = entry.value or 0,
               tickFrequency = 1,
               tickVector =
                  Vector3.__new(0.0, 0.06 / (maxValue - minValue), 0.0),
            }
         end
      ),
      initial_transform = false,
      initial_offset = Vector3.__new(0, 1, 6),
      initial_scale = Vector3.__new(0.05, 0.05, 0.05),
      output_debug_log = true,
   }
end)()

local message_ns = 'com.github.oocytanb.oO-vci-pack.cykhu_atelier'
local status_message_name = message_ns .. '.status'
local query_status_message_name = message_ns .. '.query_status'

local function noop()
   -- do nothing
end

---@param name string
---@return ExportTransform
local function get_game_object_transform(name)
   return assert(vci.assets.GetTransform(name))
end

---@param name string
---@return ExportTransform
local function get_sub_item(name)
   return assert(vci.assets.GetSubItem(name))
end

---@return boolean
local function is_vci_owner()
   local ava = vci.studio.GetLocalAvatar()
   return ava and ava.IsOwner()
end

cytanb.SetOutputLogLevelEnabled(true)
if settings.output_debug_log then
   cytanb.SetLogLevel(cytanb.LogLevelAll)
end

local vci_loaded = false

local slide_switch_map
local transform_switch

local function is_switch_value_on(value)
   return value >= 1
end

---@class TransformStatus
---@field mesh ExportTransform
---@field bounds_item ExportTransform
---@field enabled boolean
---@field grabbed boolean
local transform_status = {
   mesh = get_sub_item(settings.atelier_mesh_name),
   bounds_item = get_sub_item(settings.bounds_name),
   enabled = false,
   grabbed = false,
}

---@param status TransformStatus
local function emit_status(status)
   cytanb.EmitInstanceMessage(status_message_name, {
      sender_id = cytanb.OwnID(),
      transform_enabled = status.enabled,
   })
end

---@param enabled boolean
---@param status TransformStatus
---@return TransformStatus
local function set_transform_enabled(enabled, status)
   status.enabled = enabled

   if enabled then
      status.bounds_item.SetActive(true)
   end

   if status.bounds_item.IsMine then
      if enabled then
         status.bounds_item.SetLocalScale(
            status.mesh.GetLocalScale() * settings.bounds_scale_factor
         )
         cytanb.AlignSubItemOrigin(status.mesh, status.bounds_item)
      else
         local m = settings.bounds_scale_factor
         status.bounds_item.SetLocalScale(Vector3.__new(m, m, m))
         status.bounds_item.SetPosition(
            status.mesh.GetPosition() +
            Vector3.__new(0, settings.flag_potential, 0)
         )
      end
   end

   if not enabled then
      status.bounds_item.SetActive(false)
   end

   return status
end

---@param status TransformStatus
---@return TransformStatus
local function transform_mesh_to_bounds(status)
   local scale = status.bounds_item.GetLocalScale() /
      settings.bounds_scale_factor
   if not cytanb.VectorApproximatelyEquals(scale, status.mesh.GetLocalScale())
   then
      status.mesh.SetLocalScale(scale)
   end

   cytanb.AlignSubItemOrigin(status.bounds_item, status.mesh)

   return status
end

---@param status TransformStatus
---@return TransformStatus
local function transform_bounds_to_mesh(status)
   local scale = status.mesh.GetLocalScale() * settings.bounds_scale_factor
   if not cytanb.VectorApproximatelyEquals(
      scale,
      status.bounds_item.GetLocalScale())
   then
      status.bounds_item.SetLocalScale(scale)
   end

   cytanb.AlignSubItemOrigin(status.mesh, status.bounds_item)

   return status
end

---@param status TransformStatus
---@return TransformStatus
local function update_transform(status)
   if status.grabbed then
      if status.bounds_item.IsMine then
         return transform_mesh_to_bounds(status)
      else
         status.grabbed = false
         return status
      end
   elseif status.bounds_item.IsMine then
      return transform_bounds_to_mesh(status)
   else
      return transform_mesh_to_bounds(status)
   end
end

local update_cw; update_cw = cytanb.CreateUpdateRoutine(
   function (deltaTime, unscaledDeltaTime)
      for name, switch in pairs(slide_switch_map) do
         switch.Update()
      end

      transform_status = update_transform(transform_status)
   end,

   function ()
      cytanb.LogTrace('on load')
      vci_loaded = true

      if vci.assets.IsMine and is_vci_owner() and settings.initial_transform
      then
         local mesh = transform_status.mesh
         mesh.SetLocalScale(settings.initial_scale)
         mesh.SetLocalPosition(
            mesh.GetLocalPosition() +
            mesh.GetLocalRotation() * settings.initial_offset
         )
      end

      slide_switch_map = {}
      for k, parameters in pairs(settings.switch_parameters) do
         local switch = cytanb.CreateSlideSwitch(
            cytanb.Extend({
               colliderItem = get_sub_item(parameters.colliderName),
               baseItem = get_game_object_transform(parameters.baseName),
               knobItem = get_game_object_transform(parameters.knobName),
            }, parameters, false, true)
         )

         slide_switch_map[parameters.colliderName] = switch
      end

      transform_switch = assert(
         slide_switch_map[settings.transform_switch_name]
      )

      transform_switch.AddListener(function (source, value)
         cytanb.LogTrace('switch[',
            source.GetColliderItem().GetName(),
            '] value changed: ',
            value)

         transform_status = set_transform_enabled(
            is_switch_value_on(value),
            transform_status
         )

         if transform_switch.GetColliderItem().IsMine then
            emit_status(transform_status)
         end
      end)

      cytanb.OnInstanceMessage(
         status_message_name,
         function (sender, name, parameterMap)
            if parameterMap.sender_id ~= cytanb.OwnID() then
               transform_switch.SetValue(
                  parameterMap.transform_enabled and 1 or 0
               )
            end
         end
      )

      cytanb.OnInstanceMessage(
         query_status_message_name,
         function (sender, name, parameterMap)
            if vci.assets.IsMine then
               emit_status(transform_status)
            end
      end)

      transform_status = set_transform_enabled(
         is_switch_value_on(transform_switch.GetValue()),
         transform_status
      )

      cytanb.EmitInstanceMessage(query_status_message_name, {})
   end,

   function (reason)
      cytanb.LogError('Error on update routine: ', reason)
      update_cw = noop
   end
)

function updateAll()
   update_cw()
end

function onGrab(target)
   if not vci_loaded then
         return
   end

   local switch_ = slide_switch_map[target]
   if switch_ then
      switch_.DoGrab()
   elseif target == settings.bounds_name then
      transform_status.grabbed = true
   end
end

function onUngrab(target)
   if not vci_loaded then
         return
   end

   local switch_ = slide_switch_map[target]
   if switch_ then
      switch_.DoUngrab()
   elseif target == settings.bounds_name then
      transform_status.grabbed = false
   end
end

function onUse(use)
   if not vci_loaded then
      return
   end

   local switch_ = slide_switch_map[use]
   if switch_ then
      switch_.DoUse()
   end
end

function onUnuse(use)
   if not vci_loaded then
      return
   end

   local switch_ = slide_switch_map[use]
   if switch_ then
      switch_.DoUnuse()
   end
end
