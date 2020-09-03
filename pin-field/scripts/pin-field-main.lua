-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)
---@type cytanb @See `cytanb_annotations.lua`
local cytanb = require('cytanb')(_ENV)

local vciLoaded = false

local UpdateCw = cytanb.CreateUpdateRoutine(
    function (deltaTime, unscaledDeltaTime)
        if deltaTime <= TimeSpan.Zero then
            return
        end
    end,
    function ()
        cytanb.LogTrace('OnLoad')
        vciLoaded = true

        --vci.assets.SetMaterialColorFromName('field-mat', Color.red)
        local field = vci.assets.GetSubItem('pin-field-base')
        print(tostring(field.GetPosition()))
    end
)

updateAll = function ()
    UpdateCw()
end

onGrab = function (target)
    if not vciLoaded then
        return
    end
end

onUngrab = function (target)
    if not vciLoaded then
        return
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end
end
