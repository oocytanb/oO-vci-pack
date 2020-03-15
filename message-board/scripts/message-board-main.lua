-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

local textContent = tostring(require('text').textContent)

local tmpName = 'text-content'

local vciLoaded = false
local initialUpdateSkipped = false

updateAll = function ()
    if not initialUpdateSkipped then
        initialUpdateSkipped = true
        return
    end

    if not vciLoaded then
        -- ロード完了
        vciLoaded = true
        vci.assets.SetText(tmpName, textContent)
    end
end
