-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

print("Hello, World!")

-- SubItem をトリガーでつかむと呼び出される。
function onGrab(target)
    print("onGrab: " .. target)
end

-- グリップしてアイテムを使用すると呼び出される。
function onUse(use)
    print("onUse: " .. use)
end
