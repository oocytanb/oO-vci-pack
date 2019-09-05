--[[
MIT License

Copyright (c) 2019 oO (https://github.com/oocytanb)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

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

local vciLoaded = false
local initialUpdateSkipped = false

local lastLot = -1
local lotsMap = {}
local lotsMapSize = 0

local DrawLot = function ()
    if lotsMapSize <= 0 then
        -- 空になったので作り直す
        if conf.patternCount <= 0 then
            print('Error | INVALID patternCount: ' .. tostring(conf.patternCount))
            return -1
        end

        lotsMapSize = conf.patternCount
        for i = 0, lotsMapSize - 1 do
            local r = math.random(0, lotsMapSize - 1)
            if r < i and lotsMap[r] then
                -- 存在する番号であったら、交換する
                lotsMap[i] = lotsMap[r]
                lotsMap[r] = i
            else
                -- 存在しなければ、番号をそのままセットする
                lotsMap[i] = i
            end
        end

        if lastLot == lotsMap[lotsMapSize - 1] then
            -- 最後に引いた番号と同じであれば、先頭と入れ替える
            local head = lotsMap[0]
            lotsMap[0] = lotsMap[lotsMapSize - 1]
            lotsMap[lotsMapSize - 1] = head
        end

        -- print('shuffle lots')
        -- for i = 0, lotsMapSize - 1 do
        --     print('  lots[' .. i .. '] = ' .. lotsMap[i])
        -- end
    end

    lastLot = lotsMap[lotsMapSize - 1]
    lotsMapSize = lotsMapSize - 1
    return lastLot
end

local function ChangeImagePattern (index)
    print('ChangeImagePattern: index = ' .. index)
    local vi = math.floor(index / conf.horizontalPatternCount)
    local ui = index - vi * conf.horizontalPatternCount
    local offset = Vector2.__new(conf.offsetU * ui, conf.offsetV * vi)
    vci.assets.SetMaterialTextureOffsetFromIndex(0, offset)
end

function updateAll ()
    if not initialUpdateSkipped then
        initialUpdateSkipped = true
        return
    end

    if not vciLoaded then
        -- ロード完了
        vciLoaded = true
        math.randomseed(os.time()-os.clock()*10000)
        ChangeImagePattern(DrawLot())
    end
end

function onUse (use)
    if not vciLoaded then
        return
    end
    ChangeImagePattern(DrawLot())
end
