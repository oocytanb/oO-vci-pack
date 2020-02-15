-- SPDX-License-Identifier: MIT
-- Copyright (c) 2019 oO (https://github.com/oocytanb)

--- テクスチャーなどの設定。構成に合わせて、適宜変更する。
local conf = {
    --- 全絵柄組の数。
    patternCount = 6,

    --- 横方向の絵柄組の数。
    horizontalPatternCount = 3,

    --- テクスチャーの横座標のオフセット。
    offsetU = (3840 / 4096) / 3,

    --- テクスチャーの縦座標のオフセット。
    offsetV = 2048 / 4096
}

--- 指定したサイズのくじを作成する。
local CreateLots = function (size)
    local lotsSize = math.floor(size)
    if lotsSize <= 0 then
        print('Error | INVALID PARAMETER: size = ' .. tostring(size))
        return nil
    end

    local remainSize = 0
    local lotsMap = {}
    local lastLot = -1

    return {
        --- `0` から `size - 1` のランダムな番号を返す。くじが空になるまで、同じ番号は出ない。空になったら、自動的にくじをシャッフルする。
        Draw = function ()
            if remainSize <= 0 then
                -- 空になったので作り直す
                for i = 0, lotsSize - 1 do
                    local r = math.random(0, lotsSize - 1)
                    if r < i and lotsMap[r] then
                        -- 存在する番号であったら、交換する
                        lotsMap[i] = lotsMap[r]
                        lotsMap[r] = i
                    else
                        -- 存在しなければ、番号をそのままセットする
                        lotsMap[i] = i
                    end
                end

                if lastLot == lotsMap[lotsSize - 1] then
                    -- 最後に引いた番号と同じであれば、先頭と入れ替える
                    local head = lotsMap[0]
                    lotsMap[0] = lotsMap[lotsSize - 1]
                    lotsMap[lotsSize - 1] = head
                end

                remainSize = lotsSize
            end

            lastLot = lotsMap[remainSize - 1]
            remainSize = remainSize - 1
            return lastLot
        end,

        --- くじのサイズを取得する。
        GetSize = function ()
            return lotsSize
        end,

        --- くじの残りのサイズを取得する。
        GetRemainSize = function ()
            return remainSize
        end
    }
end

local vciLoaded = false
local initialUpdateSkipped = false
local longPressTime = TimeSpan.FromSeconds(1)
local gripPressed = false
local gripStartTime = TimeSpan.Zero
local lots = CreateLots(conf.patternCount)
local lastImageIndex = 0

local ChangeImagePattern = function (index, sync)
    print('ChangeImagePattern: index = ' .. index)
    local vi = math.floor(index / conf.horizontalPatternCount)
    local ui = index - vi * conf.horizontalPatternCount
    local offset = Vector2.__new(conf.offsetU * ui, conf.offsetV * vi)
    if sync then
        vci.assets._ALL_SetMaterialTextureOffsetFromIndex(0, offset)
    else
        vci.assets.SetMaterialTextureOffsetFromIndex(0, offset)
    end
end

updateAll = function ()
    if not initialUpdateSkipped then
        initialUpdateSkipped = true
        return
    end

    if vciLoaded then
        if gripPressed and vci.me.UnscaledTime - longPressTime > gripStartTime then
            -- グリップ長押しで、ほかのユーザーに同じ画像を表示する
            gripStartTime = TimeSpan.MaxValue
            ChangeImagePattern(lastImageIndex, true)
        end
    else
        -- ロード完了
        vciLoaded = true
        lastImageIndex = lots.Draw()
        ChangeImagePattern(lastImageIndex)
    end
end

onUse = function (use)
    if not vciLoaded then
        return
    end

    gripPressed = true
    gripStartTime = vci.me.UnscaledTime

    lastImageIndex = lots.Draw()
    ChangeImagePattern(lastImageIndex)
-- print('remain size: ' .. lots.GetRemainSize())
end

onUnuse = function (use)
    if not vciLoaded then
        return
    end

    gripPressed = false
end
