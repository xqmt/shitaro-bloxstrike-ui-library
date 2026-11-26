local cloneref = cloneref or function(instance)
    return instance
end

local getgenv = getgenv or getfenv
local gethui = gethui or get_hidden_gui or function()
    return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local request = request or http_request or (syn and syn.request) or (http and http.request)
local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function encode64(value)
    local result = {}
    for offset = 1, #value, 3 do
        local a, b, c = string.byte(value, offset, offset + 2)
        local number = a * 65536 + (b or 0) * 256 + (c or 0)
        local first = math.floor(number / 262144) % 64
        local second = math.floor(number / 4096) % 64
        local third = math.floor(number / 64) % 64
        local fourth = number % 64
        result[#result + 1] = alphabet:sub(first + 1, first + 1)
        result[#result + 1] = alphabet:sub(second + 1, second + 1)
        result[#result + 1] = b and alphabet:sub(third + 1, third + 1) or "="
        result[#result + 1] = c and alphabet:sub(fourth + 1, fourth + 1) or "="
    end
    return table.concat(result)
end

local function decode64(value)
    local result, number, bits = {}, 0, 0
    for offset = 1, #value do
        local char = value:sub(offset, offset)
        if char == "=" then
            break
        end
        local index = alphabet:find(char, 1, true)
        if index then
            number = number * 64 + index - 1
            bits += 6
            if bits >= 8 then
                bits -= 8
                result[#result + 1] = string.char(math.floor(number / 2 ^ bits) % 256)
                number %= 2 ^ bits
            end
        end
    end
    return table.concat(result)
end

local base64encode = base64encode or encode64
local base64decode = base64decode or decode64

local m = {
    [59] = table.pack,
    rH = function(self, dest, offset, ...)
        local h = table.pack(...)
        table.move(h, 1, h.n, offset + 1, dest)
    end,
    qH = function(self, dest, offset, pack)
        for h = 1, pack.n, 1 do
            dest[offset + h] = pack[h]
        end
        dest.n = offset + pack.n
    end
}

local createLibrary = function()
    local j = {}
    j[1] = function(h)
        return cloneref(game:GetService(h))
    end
    j[8] = {}
    j[9] = (j[1]("Players"))
    m:rH(j[8], 0, j[9])
    m:qH(j[8], 1, m[59](j[1]("RunService")))
    j[2], j[3] = j[8][1], j[8][2]
    j[10] = {}
    m:qH(j[10], 0, m[59](j[1]("UserInputService")))
    j[4] = j[10][1]
    j[11] = {}
    m:qH(j[11], 0, m[59](j[1]("TweenService")))
    j[5] = j[11][1]
    j[12] = {}
    m:qH(j[12], 0, m[59](j[1]("HttpService")))
    j[6] = j[12][1]
    j[13] = {}
    m:qH(j[13], 0, m[59](j[1]("GuiService")))
    j[7] = j[13][1]
    local h = j[1]("ReplicatedStorage")
    local b = j[1]("Lighting")
    local K = j[1]("Stats")
    local S, o, t, G, i, Y, O, T, x = j[2].LocalPlayer, j[3], j[4], j[5], j[6], j[7], h, b, K
    local h = S
    local b = Color3.fromRGB
    local K = Color3.fromHSV
    local S = Color3.new
    local p = UDim2.new
    local A = UDim2.fromOffset
    local M = UDim2.fromScale
    local a = UDim.new
    local B = Vector2.new
    local N = ColorSequence.new
    local I = ColorSequenceKeypoint.new
    local R = NumberSequence.new
    local n = NumberSequenceKeypoint.new
    local E = math.clamp
    local d = math.floor
    local w = math.max
    local P = math.min
    local r = math.abs
    local L = string.format
    local Z = string.sub
    local X = string.upper
    local q = string.lower
    local U = string.gsub
    local z = string.match
    local J = string.find
    local y = table.find
    local f = table.remove
    local k = table.clear
    local g = table.concat
    local Q = table.sort
    local c = table.clone
    local H = task.spawn
    local _ = task.delay
    local s = task.defer
    local F = Enum.TextXAlignment
    local v = Enum.AutomaticSize.X
    local u = Enum.AutomaticSize.Y
    local V = Enum.AutomaticSize.XY
    local e = Enum.AutomaticSize.None
    local l = Enum.HorizontalAlignment
    local C = Enum.VerticalAlignment
    local W = Enum.TextTruncate.AtEnd
    local mF = Enum.UserInputType.MouseButton1
    local DF = Enum.UserInputType.MouseButton2
    local jF = Enum.UserInputType.MouseButton3
    local hF = Enum.UserInputType.MouseMovement
    local bF = Enum.UserInputType.Touch
    local KF = Enum.UserInputState.End
    local SF = Enum.KeyCode.Unknown
    local oF = Enum.PlaybackState.Completed
    local tF = Enum.EasingStyle.Quint
    local GF = Enum.EasingStyle.Quad
    local iF = Enum.EasingStyle.Sine
    local YF = S(1, 1, 1)
    local OF = S(0, 0, 0)
    local TF, xF, pF, AF = getgenv(), base64encode, base64decode, {}
    AF.__index = AF
    AF.new = function()
        return setmetatable({}, AF)
    end
    AF.add = function(MF, aF)
        MF[#MF + 1] = aF
        return aF
    end
    AF.clean = function(MF)
        for aF = #MF, 1, -1 do
            local BF = MF[aF]
            MF[aF] = nil
            aF = typeof(BF)
            if aF == "RBXScriptConnection" then
                BF:Disconnect()
            elseif aF == "Instance" then
                BF:Destroy()
            elseif aF == "function" then
                pcall(BF)
            elseif aF == "thread" then
                pcall(task.cancel, BF)
            elseif aF == "table" then
                if type(BF.destroy) == "function" then
                    BF:destroy()
                elseif type(BF.clean) == "function" then
                    BF:clean()
                end
            end
        end
    end

    local function MF(aF, BF, NF)
        local IF = aF:Connect(BF)
        if NF then
            NF[#NF + 1] = IF
        end
        return IF
    end

    local function aF(BF)
        local NF, IF = pcall(i.JSONEncode, i, BF)
        return NF and IF or nil
    end

    local function BF(NF)
        if type(NF) ~= "string" then
            return nil
        elseif NF == "" then
            return nil
        end
        local IF, RF = pcall(i.JSONDecode, i, NF)
        if IF then
            if type(RF) == "table" then
                return RF
            end
        end
        return nil
    end

    local NF = {
        dir = function(IF)
            local RF, nF = pcall(isfolder, IF)
            if RF then
                if not (nF) then
                    pcall(makefolder, IF)
                end
            end
        end,
        has = function(IF)
            local RF, nF = pcall(isfile, IF)
            return RF and nF == true
        end,
    }
    NF.read = function(IF)
        if NF.has(IF) then
            local RF, nF = pcall(readfile, IF)
            if RF then
                return nF
            end
        end
        return nil
    end
    NF.write = function(IF, RF)
        return (pcall(writefile, IF, RF))
    end
    NF.del = function(IF)
        if NF.has(IF) then
            pcall(delfile, IF)
        end
    end
    NF.list = function(IF)
        local RF, nF = pcall(isfolder, IF)
        if RF then
            if nF then
                local RF, nF = pcall(listfiles, IF)
                if RF then
                    if type(nF) == "table" then
                        return nF
                    end
                end
            end
        end
        return {}
    end

    local IF, RF
    do
        local function nF(EF)
            local dF, wF = pcall(request, { Url = EF, Method = "GET" })
            if dF then
                if type(wF) == "table" then
                    if wF.StatusCode == 200 then
                        if type(wF.Body) == "string" then
                            return wF.Body
                        end
                    end
                end
            end
            return nil
        end
        IF = function(EF)
            local dF, wF = pcall(getcustomasset, EF)
            if dF then
                if type(wF) == "string" then
                    return wF
                end
            end
            return nil
        end
        local function EF(dF, wF, PF)
            if not (NF.has(dF)) then
                local rF = nF(wF)
                if rF then
                    if #rF < (PF or 1) then
                        return nil
                    elseif not (NF.write(dF, rF)) then
                        return nil
                    end
                else
                    return nil
                end
            end
            return IF(dF)
        end
        RF = EF
    end

    local nF, EF = {}
    do
        local dF = bit32.band
        local wF = bit32.bxor
        local PF = bit32.rshift
        local rF = buffer.create
        local LF = buffer.writeu8
        local ZF = buffer.readu8
        local XF = buffer.copy
        local qF = buffer.tostring
        local UF = math.exp
        local zF = math.sqrt
        local JF, yF = string.byte, {}
        for fF = 0, 255, 1 do
            j[1] = fF
            for kF = 1, 8, 1 do
                j[1] = if dF(j[1], 1) == 1 then wF(3988292384, PF(j[1], 1)) else PF(j[1], 1)
                yF[fF] = j[1]
            end
            local function fF(kF, gF, QF)
                local cF = 4294967295
                for HF = gF, gF + QF - 1, 1 do
                    cF = wF(yF[dF(wF(cF, ZF(kF, HF)), 255)], PF(cF, 8))
                end
                return wF(cF, 4294967295)
            end
            local function yF(kF, gF, QF)
                LF(kF, gF, dF(PF(QF, 24), 255))
                LF(kF, gF + 1, dF(PF(QF, 16), 255))
                LF(kF, gF + 2, dF(PF(QF, 8), 255))
                LF(kF, gF + 3, dF(QF, 255))
            end
            local kF = { 137, 80, 78, 71, 13, 10, 26, 10 }
            local function gF(QF, cF, HF)
                local _F = QF * 4 + 1
                local sF = _F * cF
                local FF = rF(sF)
                for vF = 0, cF - 1, 1 do
                    local uF = vF * _F
                    LF(FF, uF, 0)
                    for _F = 0, QF - 1, 1 do
                        local VF, eF, lF, CF = HF(_F, vF)
                        local vF = uF + 1 + _F * 4
                        LF(FF, vF, VF)
                        LF(FF, vF + 1, eF)
                        LF(FF, vF + 2, lF)
                        LF(FF, vF + 3, CF)
                    end
                end
                local _F = math.ceil(sF / 65535)
                HF = 2 + sF + _F * 5 + 4
                local vF = rF(45 + HF + 12)
                for rF = 1, 8, 1 do
                    LF(vF, rF - 1, kF[rF])
                end
                local rF = 8
                local function kF(uF, VF, eF)
                    yF(vF, rF, VF)
                    for lF = 1, 4, 1 do
                        LF(vF, rF + 3 + lF, JF(uF, lF))
                    end
                    eF(rF + 8)
                    yF(vF, rF + 8 + VF, fF(vF, rF + 4, VF + 4))
                    eF = rF
                    rF = eF + (12 + VF)
                end
                kF("IHDR", 13, function(rF)
                    yF(vF, rF, QF)
                    yF(vF, rF + 4, cF)
                    LF(vF, rF + 8, 8)
                    LF(vF, rF + 9, 6)
                    LF(vF, rF + 10, 0)
                    LF(vF, rF + 11, 0)
                    LF(vF, rF + 12, 0)
                end)
                kF("IDAT", HF, function(rF)
                    LF(vF, rF, 120)
                    LF(vF, rF + 1, 1)
                    local JF, fF, QF = rF + 2, 1, 0
                    for cF = 0, _F - 1, 1 do
                        rF = cF * 65535
                        local HF = P(65535, sF - rF)
                        local sF = wF(HF, 65535)
                        LF(vF, JF, cF == _F - 1 and 1 or 0)
                        LF(vF, JF + 1, dF(HF, 255))
                        LF(vF, JF + 2, PF(HF, 8))
                        LF(vF, JF + 3, dF(sF, 255))
                        LF(vF, JF + 4, PF(sF, 8))
                        XF(vF, JF + 5, FF, rF, HF)
                        for dF = rF, rF + HF - 1, 1 do
                            fF = (fF + ZF(FF, dF)) % 65521
                            QF = (QF + fF) % 65521
                        end
                        JF = JF + (5 + HF)
                    end
                    yF(vF, JF, QF * 65536 + fF)
                end)
                kF("IEND", 0, function() end)
                return qF(vF)
            end
            local function dF(wF, PF, rF, LF, ZF)
                local XF, qF = r(wF) - rF + ZF, r(PF) - LF + ZF
                LF, wF = w(XF, 0), w(qF, 0)
                return zF(LF * LF + wF * wF) + P(w(XF, qF), 0) - ZF
            end
            local function wF(PF, rF, LF, ZF, XF, qF, zF)
                return {
                    w = PF,
                    h = rF,
                    v = 2,
                    px = function(JF, yF)
                        local fF = dF(JF + 0.5 - PF / 2, yF + 0.5 - rF / 2, LF, ZF, XF)
                        if fF <= -1.25 then
                            return 0, 0, 0, 0
                        elseif fF >= qF then
                            return 0, 0, 0, 0
                        end
                        yF, JF = 1 - w(fF, 0) / qF, fF < 0 and (fF + 1.25) / 1.25 or 1
                        return 0, 0, 0, d(255 * zF * yF * yF * JF + 0.5)
                    end,
                }
            end
            local PF = {}
            PF.pshadow = wF(63, 61, 17.5, 16.5, 16.5, 14, 0.42)
            PF.bshadow = wF(52, 52, 12, 12, 10, 14, 0.42)
            PF.shadow = {
                w = 96,
                h = 96,
                px = function(wF, rF)
                    local LF = dF(wF + 0.5 - 48, rF + 0.5 - 48, 20, 20, 12)
                    if LF <= 0 then
                        return 0, 0, 0, 0
                    end
                    return 0, 0, 0, d(127.5 * UF(-3.4 * LF / 28) + 0.5)
                end,
            }
            PF.checker = {
                w = 2,
                h = 2,
                px = function(dF, wF)
                    local rF = (dF + wF) % 2 == 0 and 206 or 146
                    return rF, rF, rF, 255
                end,
            }
            local function dF(wF)
                for rF, LF in next, PF, nil do
                    local PF = wF .. "/" .. rF .. "_v" .. (LF.v or 1) .. ".png"
                    if not (NF.has(PF)) then
                        local wF, ZF = pcall(gF, LF.w, LF.h, LF.px)
                        if wF then
                            NF.write(PF, ZF)
                        end
                    end
                    nF[rF] = IF(PF)
                end
            end
            EF = dF
        end
    end

    local function dF(wF, PF)
        local rF = L("#%02x%02x%02x", d(wF.R * 255 + 0.5), d(wF.G * 255 + 0.5), d(wF.B * 255 + 0.5))
        return if PF then rF .. L("%02x", d(PF * 255 + 0.5)) else rF
    end

    local function wF(PF)
        if type(PF) ~= "string" then
            return nil
        end
        PF = U(PF, "[^%x]", "")
        local rF = #PF
        if rF ~= 6 then
            if rF ~= 8 then
                return nil
            end
        end
        return b(tonumber(Z(PF, 1, 2), 16), tonumber(Z(PF, 3, 4), 16), (tonumber(Z(PF, 5, 6), 16))), rF == 8 and tonumber(Z(PF, 7, 8), 16) / 255 or 1
    end

    local PF, rF
    do
        local function LF(ZF)
            return (U(U(U(tostring(ZF), "&", "&amp;"), "<", "&lt;"), ">", "&gt;"))
        end
        local function ZF(XF, qF)
            return (U(LF(XF), "{(.-)}", function(LF)
                return L('<font color="%s">%s</font>', dF(qF), LF)
            end))
        end
        local LF = {
            Insert = "INS",
            Delete = "DEL",
            Home = "HOME",
            End = "END",
            PageUp = "PGUP",
            PageDown = "PGDN",
            LeftShift = "LSHIFT",
            RightShift = "RSHIFT",
            LeftControl = "LCTRL",
            RightControl = "RCTRL",
            LeftAlt = "LALT",
            RightAlt = "RALT",
            LeftSuper = "LWIN",
            RightSuper = "RWIN",
            CapsLock = "CAPS",
            Backspace = "BKSP",
            Return = "ENTER",
            Space = "SPACE",
            Tab = "TAB",
            Escape = "ESC",
            MouseButton1 = "M1",
            MouseButton2 = "M2",
            MouseButton3 = "M3",
            Zero = "0",
            One = "1",
            Two = "2",
            Three = "3",
            Four = "4",
            Five = "5",
            Six = "6",
            Seven = "7",
            Eight = "8",
            Nine = "9",
            Backquote = "`",
            Minus = "-",
            Equals = "=",
            LeftBracket = "[",
            RightBracket = "]",
            BackSlash = "\\",
            Semicolon = ";",
            Quote = "'",
            Comma = ",",
            Period = ".",
            Slash = "/",
            Up = "UP",
            Down = "DOWN",
            Left = "LEFT",
            Right = "RIGHT",
        }
        local function XF(qF)
            if not (qF) then
                return nil
            end
            local UF = LF[qF]
            if UF then
                return UF
            end
            UF = z(qF, "^Keypad(.+)$")
            if UF then
                return "NUM" .. (LF[UF] or X(UF))
            end
            return X(qF)
        end
        PF, rF = ZF, XF
    end

    local function X(LF)
        if LF.KeyCode ~= SF then
            return LF.KeyCode.Name
        end
        local SF = LF.UserInputType
        if SF == mF then
            return SF.Name
        elseif SF == DF then
            return SF.Name
        elseif SF == jF then
            return SF.Name
        end
        return nil
    end

    local SF = {}
    SF.win = b(12, 12, 14)
    SF.bg = b(7, 7, 9)
    SF.pop = b(19, 19, 23)
    SF.hud = b(12, 12, 15)
    SF.txt = b(230, 230, 236)
    SF.sub = b(170, 170, 178)
    SF.dim = b(112, 112, 122)
    SF.faint = b(68, 68, 76)
    SF.knob = b(146, 146, 154)
    SF.acc = b(200, 148, 232)
    SF.ink = b(22, 14, 28)
    SF.ok = b(128, 214, 156)
    SF.bad = b(255, 112, 118)
    SF.warn = b(255, 198, 96)

    local LF, ZF, XF = {
        card = 0.958,
        edge = 0.935,
        sep = 0.955,
        hov = 0.972,
        ctl = 0.952,
        ctle = 0.925,
        ctlh = 0.932,
        trk = 0.885,
        line = 0.94,
        tab = 0.925,
        sel = 0.952,
        phov = 0.962,
        psel = 0.945,
        pfil = 0.955,
    }
    do
        local qF = Enum.FontWeight
        ZF = {}
        ZF.r = Font.new("rbxasset://fonts/families/BuilderSans.json", qF.Regular)
        ZF.m = Font.new("rbxasset://fonts/families/BuilderSans.json", qF.Medium)
        ZF.s = Font.new("rbxasset://fonts/families/BuilderSans.json", qF.SemiBold)
        ZF.b = Font.new("rbxasset://fonts/families/BuilderSans.json", qF.Bold)
        ZF.h = Font.new("rbxasset://fonts/families/Montserrat.json", qF.Bold)
        local UF, zF = {
            geist = {
                "geist/v5/gyBhhwUxId8gMGYQMKR3pzfaWI_RnOM4nQ.ttf",
                "geist/v5/gyBhhwUxId8gMGYQMKR3pzfaWI_RruM4nQ.ttf",
                "geist/v5/gyBhhwUxId8gMGYQMKR3pzfaWI_RQuQ4nQ.ttf",
                "geist/v5/gyBhhwUxId8gMGYQMKR3pzfaWI_Re-Q4nQ.ttf",
            },
            onest = {
                "onest/v11/gNMZW3F-SZuj7zOT0IfSjTS16cPh9R-Zsg.ttf",
                "onest/v11/gNMZW3F-SZuj7zOT0IfSjTS16cPhxx-Zsg.ttf",
                "onest/v11/gNMZW3F-SZuj7zOT0IfSjTS16cPhKxiZsg.ttf",
                "onest/v11/gNMZW3F-SZuj7zOT0IfSjTS16cPhEhiZsg.ttf",
            },
            inter = {
                "inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuLyfMZg.ttf",
                "inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuI6fMZg.ttf",
                "inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuGKYMZg.ttf",
                "inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuFuYMZg.ttf",
            },
        }, { { 400, "Regular" }, { 500, "Medium" }, { 600, "SemiBold" }, { 700, "Bold" } }
        local function JF(yF, fF)
            fF = UF[fF] and fF or "geist"
            local kF, gF = UF[fF], table.create(4)
            for UF = 1, 4, 1 do
                local QF = zF[UF]
                local zF = RF(yF .. "/" .. fF .. "-" .. QF[1] .. ".ttf", "https://fonts.gstatic.com/s/" .. kF[UF], 20000)
                if not (zF) then
                    return false
                end
                gF[UF] = { name = QF[2], weight = QF[1], style = "normal", assetId = zF }
            end
            local UF, zF = yF .. "/" .. fF .. ".json", aF({ name = fF, faces = gF })
            if zF then
                if not (NF.write(UF, zF)) then
                    return false
                end
            else
                return false
            end
            gF = IF(UF)
            if not gF then
                return false
            end
            ZF.r, ZF.m, ZF.s, ZF.b = Font.new(gF, qF.Regular), Font.new(gF, qF.Medium), Font.new(gF, qF.SemiBold), Font.new(gF, qF.Bold)
            return true
        end
        XF = JF
    end

    local IF = {
        logo = 106124864132557,
        code = 106124864132557,
        aim = 80648116191645,
        crosshair = 83752373575368,
        target = 121091323240554,
        dot = 122878673716704,
        trigger = 81854854241463,
        zap = 109718589733073,
        eye = 127234874352422,
        view = 127234874352422,
        players = 119713822992150,
        users = 85332511060401,
        user = 114567720540659,
        chams = 132705178126217,
        world = 75025349205767,
        globe = 125685532120024,
        move = 80792036653047,
        misc = 133109875194066,
        skins = 127369887384101,
        spray = 97652569554326,
        bug = 75649814233484,
        map = 131325044235094,
        configs = 97828544806816,
        folder = 77937190465422,
        settings = 106205298246017,
        cog = 123222732420633,
        sliders = 125396339381135,
        gear = 109485777305919,
        save = 122894934359450,
        chevron = 71457658246709,
        right = 101007429951147,
        dots = 95127553964880,
        check = 86817768619372,
        x = 116396312853810,
        keyboard = 121978468376124,
        plus = 101123124881873,
        pencil = 113132794872298,
        trash = 126010725826757,
        refresh = 106497040962250,
        load = 109698732019071,
        copy = 116378866141355,
        import = 87776530532335,
        clock = 136533241128438,
        wifi = 104941258142372,
        layers = 114499998778667,
        grip = 128492050787735,
        bomb = 85112456002145,
        shield = 106509993556171,
        sparkles = 105634041692696,
        sun = 139232691165198,
        bell = 84691420588185,
        gamepad = 99293705721130,
        flag = 121835250831612,
        feather = 103991922506350,
        ram = 82464660673318,
        cpu = 105237370909681,
        skull = 101060850237115,
        camera = 114084146151777,
        volume = 129861259578431,
        message = 86432989388834,
        power = 89331085993646,
        tap = 98931495397575,
        scale = 101030566996452,
        round = 99439828273252,
        text = 70694319369829,
        toggle = 129483325318573,
    }

    local function qF(UF)
        if UF == nil then
            return ""
        end
        local zF = IF[UF]
        if zF then
            return "rbxassetid://" .. zF
        end
        if type(UF) == "number" then
            return "rbxassetid://" .. UF
        end
        return tostring(UF)
    end

    local function buildGradientSeq(spec, fallbackA, fallbackB)
        if typeof(spec) == "ColorSequence" then
            return spec
        end
        if type(spec) == "table" and #spec > 0 then
            local kps = {}
            for idx = 1, #spec do
                local item = spec[idx]
                if typeof(item) == "ColorSequenceKeypoint" then
                    kps[#kps + 1] = item
                elseif typeof(item) == "Color3" then
                    local tPos = #spec == 1 and 0 or (idx - 1) / (#spec - 1)
                    kps[#kps + 1] = I(tPos, item)
                elseif type(item) == "table" then
                    local cVal = item.color or item[2] or fallbackA or SF.acc
                    if type(cVal) == "string" then
                        cVal = wF(cVal) or SF.acc
                    end
                    local tPos = tonumber(item.time or item[1]) or ((idx - 1) / math.max(#spec - 1, 1))
                    kps[#kps + 1] = I(E(tPos, 0, 1), cVal)
                end
            end
            if #kps >= 2 then
                return N(kps)
            elseif #kps == 1 then
                return N(kps[1].Value)
            end
        end
        local c1 = fallbackA or SF.acc
        local c2 = fallbackB or K((select(1, c1:ToHSV()) + 0.14) % 1, 0.85, 1)
        if type(c1) == "string" then
            c1 = wF(c1) or SF.acc
        end
        if type(c2) == "string" then
            c2 = wF(c2) or SF.acc
        end
        return N({ I(0, c1), I(1, c2) })
    end

    local UF
    do
        local zF = {
            Frame = { BorderSizePixel = 0, BackgroundTransparency = 1 },
            CanvasGroup = { BorderSizePixel = 0, BackgroundTransparency = 1 },
        }
        zF.ScrollingFrame = {
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            ScrollBarImageColor3 = YF,
            ScrollBarImageTransparency = 1,
            CanvasSize = p(0, 0, 0, 0),
            AutomaticCanvasSize = u,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ElasticBehavior = Enum.ElasticBehavior.Never,
        }
        zF.TextLabel = { BorderSizePixel = 0, BackgroundTransparency = 1, TextXAlignment = F.Left, TextSize = 14, Text = "", AutoLocalize = false }
        zF.TextButton = { BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false, Text = "", TextSize = 14, AutoLocalize = false }
        zF.TextBox = { BorderSizePixel = 0, BackgroundTransparency = 1, ClearTextOnFocus = false, TextXAlignment = F.Left, TextSize = 14, Text = "", AutoLocalize = false }
        zF.ImageLabel = { BorderSizePixel = 0, BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit }
        zF.ImageButton = { BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false, ScaleType = Enum.ScaleType.Fit }
        local JF = { TextLabel = true, TextButton = true, TextBox = true }
        local function yF(fF, kF, gF)
            local QF, cF = Instance.new(fF), zF[fF]
            if cF then
                for zF, HF in next, cF, nil do
                    QF[zF] = HF
                end
            end
            if JF[fF] then
                QF.FontFace = ZF.s
                QF.TextColor3 = SF.txt
            end
            fF = nil
            if kF then
                for zF, JF in next, kF, nil do
                    if zF == "Parent" then
                        fF = JF
                    else
                        QF[zF] = JF
                    end
                end
            end
            if gF then
                for zF, JF in next, gF, nil do
                    QF[zF] = SF[JF]
                    QF:SetAttribute("t_" .. zF, JF)
                end
            end
            if fF then
                QF.Parent = fF
            end
            return QF
        end
        UF = yF
    end

    local function zF(JF, yF)
        return UF("UICorner", { CornerRadius = a(0, yF or 6), Parent = JF })
    end
    local function JF(yF)
        return UF("UICorner", { CornerRadius = a(1, 0), Parent = yF })
    end
    local yF, fF
    do
        j[2] = setmetatable
        j[1] = { __mode = "k" }
        local kF, gF = j[2]({}, j[1]), 1
        local function QF(cF, HF, _F)
            local sF = UF("UIStroke", {
                Color = _F or YF,
                Transparency = HF or LF.edge,
                Thickness = gF,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Parent = cF,
            })
            kF[sF] = true
            return sF
        end
        local function cF(HF, _F)
            gF = HF < 1 and 1 / HF or 1
            for HF in next, kF, nil do
                if HF.Parent then
                    HF.Thickness = _F and HF:IsDescendantOf(_F) and gF or 1
                else
                    kF[HF] = nil
                end
            end
        end
        yF, fF = QF, cF
    end

    local function kF(gF, QF, cF, HF, _F)
        return UF("UIPadding", {
            PaddingLeft = a(0, QF or 0),
            PaddingRight = a(0, cF or 0),
            PaddingTop = a(0, HF or 0),
            PaddingBottom = a(0, _F or 0),
            Parent = gF,
        })
    end
    local function gF(QF, cF, HF)
        return UF("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = a(0, cF or 0), HorizontalAlignment = HF or l.Left, Parent = QF })
    end
    local function QF(cF, HF, _F)
        return UF("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = a(0, HF or 0),
            HorizontalAlignment = _F or l.Left,
            VerticalAlignment = C.Center,
            Parent = cF,
        })
    end

    local C
    do
        local cF = {}
        local function HF(_F, sF, FF, vF, uF)
            FF, vF, uF = FF or 0.16, vF or tF, uF or 0
            local tF = vF.Name .. FF .. ":" .. uF
            local VF = cF[tF]
            if not VF then
                VF = TweenInfo.new(FF, vF, Enum.EasingDirection.Out, 0, false, uF)
                cF[tF] = VF
            end
            tF = G:Create(_F, VF, sF)
            tF:Play()
            return tF
        end
        C = HF
    end

    local function tF(cF, HF)
        local _F, sF = cF.AbsolutePosition, cF.AbsoluteSize
        return HF.X >= _F.X and HF.Y >= _F.Y and HF.X <= _F.X + sF.X and HF.Y <= _F.Y + sF.Y
    end

    local cF, HF = { flags = {}, els = {}, fl = {}, profs = {}, dir = "polar", thm = SF, fnt = ZF, ico = IF, ver = "1.0.0" }, {}
    HF.md = AF.new()
    HF.pops = {}
    HF.bmap = {}
    HF.drag = {}
    HF.open = false
    HF.dead = false
    HF.live = false
    HF.fn = 0
    HF.unl = {}
    HF.bgt = 0.08
    HF.blur = true
    j[2] = setmetatable
    j[1] = { __mode = "k" }
    j[14] = (j[2]({}, j[1]))
    HF.hbg = j[14]

    local function IF()
        local _F = HF.us
        return _F and _F.Scale or 1
    end
    local function _F()
        local sF = HF.tp
        if sF then
            return sF
        end
        local sF, FF = t:GetMouseLocation(), HF.probe
        if FF then
            return sF + FF.AbsolutePosition
        end
        return sF
    end
    local function sF(FF)
        local vF = FF.Position
        return B(vF.X, vF.Y)
    end
    local function FF(vF)
        return vF == mF or vF == bF
    end

    local vF, uF, VF, eF, lF, CF, WF
    local function m7(D7, j7, h7, b7)
        local K7 = HF.drag
        K7.mv = D7
        K7.up = j7
        K7.own = h7
        K7.ti = b7 and b7.UserInputType == bF and b7 or nil
    end
    local function D7(j7)
        local h7 = HF.drag
        local b7 = h7.up
        h7.mv = nil
        h7.up = nil
        h7.own = nil
        h7.ti = nil
        if b7 then
            b7(j7)
        end
    end

    j[1] = setmetatable
    j[2] = { __mode = "k" }
    local j7 = j[1]({}, j[2])
    local h7, b7
    do
        local function K7(S7, o7)
            local t7 = HF.pops
            local G7 = S7 and y(t7, S7) or 0
            for S7 = #t7, G7 + 1, -1 do
                if tF(t7[S7].frame, o7) then
                    return true
                end
            end
            return false
        end
        local function S7(o7, t7)
            local G7, i7 = o7.o, o7.p
            if G7.Parent == nil then
                o7.i = false
                j7[o7] = nil
            end
            local Y7 = o7.i and HF.open and (i7 == nil or i7.isopen == true) and tF(G7, t7) and not K7(i7, t7)
            if Y7 ~= o7.s then
                o7.s = Y7
                if Y7 then
                    o7.on()
                else
                    o7.off()
                end
            end
        end
        local function K7()
            if next(j7) == nil then
                return
            end
            local o7 = _F()
            for t7 in next, j7, nil do
                S7(t7, o7)
            end
        end
        local function o7(t7, G7, i7, Y7)
            local O7 = { o = t7, p = G7, on = i7, off = Y7, i = false, s = false }
            MF(t7.MouseEnter, function()
                O7.i = true
                j7[O7] = true
                S7(O7, _F())
            end)
            MF(t7.MouseLeave, function()
                O7.i = false
                j7[O7] = nil
                S7(O7, _F())
            end)
            return O7
        end
        h7, b7 = K7, o7
    end

    local function K7(S7, o7, t7, G7, i7, Y7)
        return b7(S7, o7, function()
            C(S7, { [t7] = i7 }, Y7 or 0.12)
        end, function()
            C(S7, { [t7] = G7 }, Y7 or 0.12)
        end)
    end

    local function S7(o7, t7)
        local G7 = 0
        MF(o7.InputBegan, function(i7)
            local Y7 = i7.UserInputType
            local O7 = Y7 == mF and HF.ph
            if Y7 ~= bF then
                if not O7 then
                    return
                end
            end
            G7 += 1
            local Y7 = G7
            local T7 = O7 and _F() or sF(i7)
            _(0.5, function()
                if Y7 ~= G7 then
                    return
                elseif HF.dead then
                    return
                elseif i7.UserInputState == KF then
                    return
                end
                if O7 then
                    if t:IsMouseButtonPressed(mF) then
                        if (_F() - T7).Magnitude < 10 then
                            t7(i7)
                        end
                    end
                elseif (sF(i7) - T7).Magnitude < 10 then
                    t7(i7)
                end
            end)
        end)
        MF(o7.InputEnded, function(KF)
            if FF(KF.UserInputType) then
                G7 += 1
            end
        end)
    end

    local function KF(o7)
        return UF("TextButton", { Size = M(1, 1), ZIndex = 0, Parent = o7 })
    end

    local function o7(t7, G7, i7)
        if not (nF.shadow) then
            return nil
        end
        local Y7 = (G7 or 12) / 12
        G7 = d(28 * Y7 + 0.5)
        return UF("ImageLabel", {
            Image = nF.shadow,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(40, 40, 56, 56),
            SliceScale = Y7,
            ImageTransparency = i7 or 0,
            Position = A(-G7, -G7),
            Size = p(1, G7 * 2, 1, G7 * 2),
            ZIndex = 0,
            Parent = t7,
        })
    end

    local function t7()
        return HF.live == true and HF.open and HF.ft == nil and not HF.dead
    end

    j[2] = setmetatable
    j[1] = { __mode = "k" }
    local G7 = j[2]({}, j[1])
    local i7
    do
        local Y7 = Enum.EasingStyle.Cubic
        local function O7(T7, x7, p7, A7, M7, a7)
            local B7, N7 = G7[T7]
            if B7 then
                N7 = B7
            else
                if M7 and HF.live and not HF.dead or t7() then
                    if not (T7.Parent) then
                        T7.Visible = x7
                        if a7 then
                            a7()
                        end
                        return
                    end
                else
                    T7.Visible = x7
                    if a7 then
                        a7()
                    end
                    return
                end
                if not x7 and not T7.Visible then
                    if a7 then
                        a7()
                    end
                    return
                end
                local I7, R7 = T7.AutomaticSize, T7.Size
                local n7, E7, d7, w7 = I7 == v or I7 == V, I7 == u or I7 == V, M7 and 20 or 0, T7.AnchorPoint
                B7 = {}
                B7.p = T7.Parent
                B7.pos = T7.Position
                B7.ap = w7
                B7.sz = R7
                B7.n = 0
                B7.m = d7
                B7.d = A(d7 * (2 * w7.X - 1), d7 * (2 * w7.Y - 1))
                B7.g = UF("CanvasGroup", {
                    Position = B7.pos + B7.d,
                    AnchorPoint = w7,
                    Size = R7 + A(d7 * 2, d7 * 2),
                    AutomaticSize = I7,
                    LayoutOrder = T7.LayoutOrder,
                    ZIndex = T7.ZIndex,
                    GroupTransparency = x7 and 1 or 0,
                    Parent = B7.p,
                })
                if d7 > 0 then
                    kF(B7.g, d7, d7, d7, d7)
                end
                G7[T7] = B7
                T7.Parent = B7.g
                T7.AnchorPoint = B(0, 0)
                T7.Position = A(0, 0)
                T7.Size = p(n7 and 0 or 1, n7 and R7.X.Offset or 0, E7 and 0 or 1, E7 and R7.Y.Offset or 0)
                N7 = B7
            end
            N7.n = N7.n + 1
            local M7 = N7.n
            if x7 then
                T7.Visible = true
            end
            N7.g.Interactable = x7
            local B7, I7, R7, n7, E7 = N7.g, { GroupTransparency = x7 and 0 or 1 }, p7 or 0.2, x7 and GF or Y7, function(Y7)
                if Y7 ~= oF then
                    return
                elseif N7.n ~= M7 then
                    return
                elseif G7[T7] ~= N7 then
                    return
                end
                G7[T7] = nil
                if not (x7) then
                    T7.Visible = false
                end
                pcall(function()
                    T7.Parent = N7.p
                    T7.Position, T7.AnchorPoint, T7.Size = N7.pos, N7.ap, N7.sz
                end)
                N7.g:Destroy()
                if a7 then
                    a7()
                end
            end
            C(B7, I7, R7, n7, x7 and A7 or nil).Completed:Once(E7)
        end
        i7 = O7
    end

    local function Y7(O7)
        local T7 = G7[O7]
        if T7 then
            G7[O7] = nil
            T7.g:Destroy()
        end
        O7:Destroy()
    end
    local function O7(T7)
        local x7 = G7[T7]
        return x7 and x7.pos or T7.Position
    end
    local function T7(x7, p7)
        local A7 = G7[x7]
        if A7 then
            A7.pos = p7
            A7.g.Position = p7 + A7.d
        else
            x7.Position = p7
        end
    end
    local function x7(p7, A7)
        local M7 = G7[p7]
        if M7 then
            M7.sz = A7
            M7.g.Size = A7 + A(M7.m * 2, M7.m * 2)
        else
            p7.Size = A7
        end
    end

    j[1] = setmetatable
    j[2] = { __mode = "k" }
    local p7 = j[1]({}, j[2])
    local function A7(M7, a7, B7)
        if p7[M7] == a7 then
            return
        end
        p7[M7] = a7
        i7(M7, a7, B7 or 0.2, nil, true)
    end

    local M7, a7
    do
        local B7 = {}
        B7.__index = B7
        local function N7(I7, R7, n7)
            local E7 = HF.mt
            if not E7 or not E7.Parent then
                E7 = UF("TextLabel", { Size = A(0, 0), TextTransparency = 1, Parent = HF.gui })
                HF.mt = E7
            end
            E7.FontFace = R7 or ZF.s
            E7.TextSize = n7 or 13
            E7.Text = q(tostring(I7 or ""))
            return E7.TextBounds.X
        end
        j[2] = setmetatable
        j[1] = { __mode = "k" }
        local I7 = j[2]({}, j[1])
        local function j(R7)
            MF(R7.DescendantAdded, function(R7)
                if I7[R7] then
                    return
                end
                local n7 = R7:IsA("TextBox") and "PlaceholderText" or (R7:IsA("TextLabel") or R7:IsA("TextButton")) and "Text"
                if not n7 then
                    return
                end
                I7[R7] = true
                local function I7()
                    local E7 = R7[n7]
                    local d7 = q(E7)
                    if E7 ~= d7 then
                        R7[n7] = d7
                    end
                end
                I7()
                MF(R7:GetPropertyChangedSignal(n7), I7)
            end)
        end
        local function I7(R7)
            local n7 = setmetatable({ w = R7.w or 180, aw = R7.w == nil and not R7.raw, keep = R7.keep, par = R7.par, anchor = R7.anchor, md = AF.new(), isopen = false, px = 0, py = 0, an = 0 }, B7)
            n7.box = UF("Frame", { Size = A(n7.w, 0), Visible = false, Parent = HF.pl })
            local E7, d7 = R7.rad or 10, UF("Frame", { Size = M(1, 1), BackgroundTransparency = 0, Parent = n7.box }, { BackgroundColor3 = "pop" })
            n7.frame = d7
            zF(d7, E7)
            UF("UIGradient", { Rotation = 90, Color = N(YF, S(0.84, 0.84, 0.86)), Parent = d7 })
            UF("UIGradient", { Rotation = 90, Transparency = R(0.1, 0.75), Parent = yF(d7, 0.88) })
            o7(d7, E7, 0)
            KF(d7)
            local S = UF("Frame", { Size = p(1, 0, 0, 46), BackgroundColor3 = YF, BackgroundTransparency = 0, ZIndex = 1, Parent = d7 })
            zF(S, E7)
            UF("UIGradient", { Rotation = 90, Transparency = R({ n(0, 0.962), n(0.7, 0.99), n(1, 1) }), Parent = S })
            S = UF("Frame", { Size = p(1, 0, 0, 0), AutomaticSize = u, ZIndex = 2, Parent = d7 })
            n7.body = S
            MF(S:GetPropertyChangedSignal("AbsoluteSize"), function()
                n7:fit()
            end)
            if not (R7.raw) then
                kF(S, 6, 6, R7.title and 0 or 6, 6)
                gF(S, 6)
                if R7.title then
                    n7:head(R7.title)
                end
                n7.c = VF(S, R7.tab, n7)
                n7.c.tmp = R7.tmp
            end
            return n7
        end
        B7.head = function(S, R7)
            local n7 = UF("Frame", { Size = p(1, 0, 0, 38), LayoutOrder = -1, Parent = S.body })
            S.ttl = q(tostring(R7 or ""))
            UF("TextLabel", { Position = A(12, 1), Size = p(1, -48, 1, 0), Text = S.ttl, FontFace = ZF.h, TextSize = 14, TextTruncate = W, Parent = n7 }, { TextColor3 = "txt" })
            R7 = UF("Frame", { AnchorPoint = B(1, 0.5), Position = p(1, -2, 0.5, 1), Size = A(0, 24), AutomaticSize = v, Parent = n7 })
            QF(R7, 2, l.Right)
            S.hd = n7
            S.hr = R7
            return n7
        end
        B7.fitw = function(S)
            local R7 = IF()
            local n7, E7 = if S.ttl then w(172, 12 + N7(S.ttl, ZF.h, 14) + 16 + S.hr.AbsoluteSize.X / R7 + 14) else 172, S.rws
            if E7 then
                for d7 = #E7, 1, -1 do
                    local w7 = E7[d7]
                    if w7.r.Parent then
                        n7 = if w7.r.Visible then w(n7, w7.x + (w7.n and N7(q(w7.n)) + 8 or 0) + w7.af.AbsoluteSize.X / R7 + 26) else n7
                    else
                        f(E7, d7)
                    end
                end
            end
            S.w = d(P(n7, 340) + 0.5)
        end
        B7.hbtn = function(S, N7, R7, n7)
            local E7 = UF("ImageButton", { Size = A(24, 24), BackgroundColor3 = YF, BackgroundTransparency = 1, Parent = S.hr })
            zF(E7, 7)
            local d7 = UF("ImageLabel", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(13, 13), Image = qF(N7), Parent = E7 }, { ImageColor3 = "dim" })
            b7(E7, S, function()
                C(E7, { BackgroundTransparency = LF.pfil }, 0.12, GF)
                C(d7, { ImageColor3 = SF[R7 or "txt"] }, 0.12, GF)
            end, function()
                C(E7, { BackgroundTransparency = 1 }, 0.12, GF)
                C(d7, { ImageColor3 = SF.dim }, 0.12, GF)
            end)
            MF(E7.MouseButton1Click, n7)
            return E7, d7
        end
        B7.fit = function(S)
            local N7 = S.body.AbsoluteSize.Y / IF()
            S.box.Size = A(S.w, d(N7 + 0.5))
        end
        B7.clampit = function(S)
            local N7 = S.box
            if not (N7.Parent and HF.pl) then
                return
            end
            local R7, n7, E7, d7, w7 = IF(), HF.pl.AbsolutePosition, HF.probe.AbsolutePosition, HF.gui.AbsoluteSize, S.frame.AbsoluteSize
            local P7, r7 = E(n7.X + S.px * R7, E7.X + 6, w(E7.X + 6, E7.X + d7.X - w7.X - 6)), E(n7.Y + S.py * R7, E7.Y + 6, w(E7.Y + 6, E7.Y + d7.Y - w7.Y - 6))
            N7.Position = A(d((P7 - n7.X) / R7 + 0.5), d((r7 - n7.Y) / R7 + 0.5))
        end
        B7.place = function(S, N7, R7)
            local n7, E7 = IF(), HF.pl.AbsolutePosition
            S.px, S.py = (N7 - E7.X) / n7, (R7 - E7.Y) / n7
            S.box.Position = A(S.px, S.py)
            S:clampit()
            E7, N7, R7 = S.md, S.frame, function()
                S:clampit()
            end
            E7:add(N7:GetPropertyChangedSignal("AbsoluteSize"):Connect(R7))
        end
        local function S(N7)
            local R7 = N7.cg
            if R7 then
                N7.cg = nil
                if N7.frame.Parent == R7 then
                    N7.frame.Parent = N7.box
                end
                R7:Destroy()
            end
        end
        B7.settle = function(N7)
            N7.an = N7.an + 1
            S(N7)
        end
        B7.anim = function(N7, R7, n7)
            N7.an = N7.an + 1
            local E7 = N7.an
            local d7 = N7.cg
            if not d7 then
                d7 = UF("CanvasGroup", { Position = A(-24, -24), Size = p(1, 48, 1, 48), GroupTransparency = R7 and 1 or 0, Parent = N7.box })
                kF(d7, 24, 24, 24, 24)
                N7.cg = d7
                N7.frame.Parent = d7
            end
            d7.Interactable = R7
            local w7, P7, r7 = { GroupTransparency = R7 and 0 or 1 }, R7 and 0.2 or 0.18, R7 and GF
            local R7, L7 = C(d7, w7, P7, r7 or iF), function(iF)
                if iF ~= oF or N7.an ~= E7 then
                    return
                end
                S(N7)
                if n7 then
                    n7()
                end
            end
            R7.Completed:Once(L7)
        end
        B7.hide = function(S, iF)
            if not (S.isopen) then
                return
            end
            S.isopen = false
            S.md:clean()
            if HF.drag.own == S then
                D7()
            end
            local B7 = HF.listen
            if B7 and B7.c and B7.c.pop == S then
                HF.listen = nil
                B7.lst = false
                B7:draw()
            end
            B7 = S.onclose
            if B7 then
                S.onclose = nil
                B7()
            end
            local B7, N7 = S.box
            if S.keep then
                N7 = function()
                    B7.Visible = false
                end
            else
                S.dead = true
                N7 = function()
                    B7:Destroy()
                end
            end
            if iF or not t7() then
                S:settle()
                N7()
            else
                S:anim(false, N7)
            end
        end
        M7, a7 = j, I7
    end

    local function j(S, iF)
        local B7 = HF.pops
        local N7 = #B7
        for I7 = N7, w(S, 1), -1 do
            local R7 = B7[I7]
            B7[I7] = nil
            R7:hide(iF)
        end
        if N7 >= w(S, 1) then
            h7()
        end
    end
    local function S(iF)
        j(1, iF)
    end
    local function iF(B7)
        local N7 = y(HF.pops, B7)
        if N7 then
            j(N7)
        end
    end
    local function B7(N7, I7, R7)
        local n7 = HF.pops
        j((N7.par and y(n7, N7.par) or 0) + 1)
        n7[#n7 + 1] = N7
        N7.isopen = true
        N7.box.ZIndex = 10 + #n7
        N7.box.Visible = true
        if N7.aw then
            N7:fitw()
        end
        N7:fit()
        N7:place(I7, R7)
        if t7() then
            N7:anim(true)
        else
            N7:settle()
        end
        h7()
    end
    local function t7(N7)
        local I7 = HF.pops
        for R7 = #I7, 1, -1 do
            local n7 = I7[R7]
            if tF(n7.frame, N7) then
                j(R7 + 1)
                return
            elseif n7.anchor and n7.anchor.Parent and tF(n7.anchor, N7) then
                j(R7 + 1)
                return
            end
        end
        S()
    end

    local function N7(I7, R7)
        local n7 = HF.bmap[R7]
        if not n7 then
            n7 = {}
            HF.bmap[R7] = n7
        end
        if not (y(n7, I7)) then
            n7[#n7 + 1] = I7
        end
    end
    local function I7(R7, n7)
        local E7 = HF.bmap[n7]
        if not (E7) then
            return
        end
        local d7 = y(E7, R7)
        if d7 then
            f(E7, d7)
        end
        if #E7 == 0 then
            HF.bmap[n7] = nil
        end
    end

    local R7 = { MouseButton1 = true, MouseButton2 = true, MouseButton3 = true }
    local function n7(E7)
        if not (E7 and HF.open and HF.root) then
            return false
        end
        if tF(HF.root, E7) then
            return true
        end
        local d7 = HF.pops
        for w7 = 1, #d7, 1 do
            if tF(d7[w7].frame, E7) then
                return true
            end
        end
        return false
    end

    local function tF(E7)
        if HF.dead then
            return
        end
        local d7, w7 = E7.UserInputType
        if d7 == bF then
            w7 = sF(E7)
            HF.tp = w7
        elseif d7 == mF or d7 == DF or d7 == jF then
            HF.tp = nil
            w7 = (_F())
        end
        local DF = HF.listen
        if DF then
            local P7 = X(E7)
            if P7 then
                HF.listen = nil
                DF.lst = false
                if P7 == "Escape" or P7 == "Backspace" then
                    DF:setkey(nil)
                elseif R7[P7] and DF.o.nomouse or P7 == "MouseButton1" and n7(w7) then
                    DF:draw()
                else
                    if R7[P7] then
                        HF.eat = DF
                        _(0.35, function()
                            if HF.eat == DF then
                                HF.eat = nil
                            end
                        end)
                    end
                    DF:setkey(P7)
                end
                return
            end
        end
        if w7 and d7 ~= jF and #HF.pops > 0 then
            t7(w7)
        end
        if d7 == bF then
            return
        end
        d7 = X(E7)
        if not d7 or t:GetFocusedTextBox() or n7(w7) then
            return
        end
        if d7 == "Escape" and HF.open and #HF.pops > 0 then
            iF(HF.pops[#HF.pops])
            return
        end
        E7 = HF.bmap[d7]
        if E7 then
            for DF = #E7, 1, -1 do
                d7 = E7[DF]
                if d7 then
                    d7:bdown()
                end
            end
        end
    end

    local function DF(jF)
        if HF.dead then
            return
        end
        local t7, n7, E7 = jF.UserInputType, HF.drag, HF.tg
        if E7 and (t7 == bF and E7.i == jF or t7 == mF and E7.m) then
            HF.tg = nil
            E7.tap(E7.m and _F() or sF(jF))
        end
        if n7.mv then
            if t7 == mF and not n7.ti then
                D7(true)
            elseif t7 == bF and n7.ti == jF then
                D7(true)
            end
        end
        t7 = X(jF)
        if not t7 then
            return
        end
        E7 = HF.bmap[t7]
        if E7 then
            for X = #E7, 1, -1 do
                n7 = E7[X]
                if n7 then
                    n7:bup()
                end
            end
        end
    end

    local function X(jF, t7)
        local n7, E7 = r(t7.X - jF.p0.X), r(t7.Y - jF.p0.Y)
        if n7 > 6 then
            if n7 >= E7 then
                HF.tg = nil
                jF.drag(t7)
            elseif E7 > 6 then
                HF.tg = nil
            end
        elseif E7 > 6 then
            HF.tg = nil
        end
    end

    local function jF(t7)
        if HF.dead then
            return
        end
        local n7, E7 = t7.UserInputType, HF.drag
        if n7 == hF then
            HF.tp = nil
            local d7 = HF.tg
            if d7 and d7.m then
                X(d7, _F())
            end
            if E7.mv and not (E7.ti) then
                E7.mv(_F())
            end
            h7()
        elseif n7 == bF then
            local n7 = sF(t7)
            HF.tp = n7
            local d7 = HF.tg
            if d7 and d7.i == t7 then
                X(d7, n7)
            end
            if E7.mv and E7.ti == t7 then
                E7.mv(n7)
            end
        end
    end

    local function X()
        for t7, n7 in next, HF.bmap, nil do
            for E7 = #n7, 1, -1 do
                t7 = n7[E7]
                if t7 then
                    t7:bup()
                end
            end
        end
    end

    local function t7(n7)
        local E7 = n7 and y(HF.pops, n7)
        j(E7 and E7 + 1 or 1)
    end

    do
        local j = {}
        j.__index = j
        local n7, E7, d7 = 0, setmetatable, { __mode = "k" }
        local w7 = E7({}, d7)
        local function E7(d7, P7, r7, L7)
            n7 += 1
            local Z7, X7 = setmetatable, { id = n7, kind = L7, c = P7, o = r7, name = r7.name or r7.text or "", flag = r7.flag, cb = r7.cb or r7.callback, dis = false, an = 0, tmp = r7.tmp or P7 and P7.tmp or false }
            return Z7(X7, d7)
        end
        local function n7(d7)
            local P7 = d7.h == true or (d7.o or 0) > 0
            if d7.l == P7 then
                return
            end
            d7.l = P7
            local r7, L7, Z7 = d7.hl, {}, P7 and (d7.b.soft and LF.phov or LF.hov)
            L7.BackgroundTransparency = Z7 or 1
            C(r7, L7, 0.12, GF)
        end
        local function d7(P7, r7)
            local L7 = P7 and w7[P7]
            if not (L7 and L7.hl) then
                return
            end
            L7.o = w(0, (L7.o or 0) + (r7 and 1 or -1))
            n7(L7)
        end
        local P7 = {}
        P7.__index = P7
        local function r7(L7, Z7, X7, q7)
            local U7 = UF("Frame", { Size = p(1, 0, 0, 0), AutomaticSize = u, BackgroundColor3 = YF, BackgroundTransparency = X7 and LF.card or 1, LayoutOrder = Z7, Parent = L7 })
            if X7 then
                zF(U7, 7)
                yF(U7, LF.edge)
            end
            gF(U7, 0)
            return setmetatable({ f = U7, rows = {}, n = 0, rad = X7 and 7 or 0, pop = q7, soft = not X7 }, P7)
        end
        P7.fix = function(L7)
            local Z7, X7, q7 = L7.rows
            for U7 = 1, #Z7, 1 do
                local z7 = Z7[U7]
                if z7.r.Visible then
                    X7, q7 = X7 or z7, z7
                end
            end
            local U7 = L7.rad
            for z7 = 1, #Z7, 1 do
                local J7 = Z7[z7]
                if J7.sp then
                    J7.sp.Visible = J7 ~= X7
                end
                z7 = J7.hc and J7.hl
                if z7 then
                    local Z7, y7 = U7 > 0 and J7 == X7, U7 > 0 and J7 == q7
                    J7.hc.CornerRadius = a(0, (Z7 or y7) and U7 or 0)
                    if Z7 and not y7 then
                        z7.Position, z7.Size = A(0, 0), p(1, 0, 1, U7)
                    elseif y7 and not Z7 then
                        z7.Position, z7.Size = A(0, -U7), p(1, 0, 1, U7)
                    else
                        z7.Position, z7.Size = A(0, 0), M(1, 1)
                    end
                end
            end
            L7.f.Visible = X7 ~= nil
        end
        P7.add = function(L7, Z7, X7)
            L7.n = L7.n + 1
            local q7 = UF("Frame", { Size = p(1, 0, 0, Z7), LayoutOrder = L7.n, Parent = L7.f })
            local U7 = { r = q7, b = L7 }
            if not (L7.soft) then
                U7.sp = UF("Frame", { Size = p(1, 0, 0, 1), BackgroundColor3 = YF, BackgroundTransparency = LF.sep, ZIndex = 3, Parent = q7 })
            end
            if (X7 and not X7) or L7.soft then
                U7.hl = UF("Frame", { Size = M(1, 1), BackgroundColor3 = YF, BackgroundTransparency = 1, ZIndex = 0, Parent = q7 })
                zF(U7.hl, 7)
                b7(q7, L7.pop, function()
                    U7.h = true
                    n7(U7)
                end, function()
                    U7.h = false
                    n7(U7)
                end)
            elseif not X7 then
                Z7 = UF("Frame", { Size = M(1, 1), ClipsDescendants = true, ZIndex = 0, Parent = q7 })
                U7.hl = UF("Frame", { Size = M(1, 1), BackgroundColor3 = YF, BackgroundTransparency = 1, ZIndex = 0, Parent = Z7 })
                U7.hc = zF(U7.hl, 0)
                b7(q7, L7.pop, function()
                    U7.h = true
                    n7(U7)
                end, function()
                    U7.h = false
                    n7(U7)
                end)
            end
            w7[q7] = U7
            X7 = L7.rows
            X7[#X7 + 1] = U7
            L7:fix()
            return q7, U7
        end
        P7.del = function(n7, L7)
            local Z7 = w7[L7]
            if not (Z7) then
                return
            end
            w7[L7] = nil
            local X7 = n7.rows
            local q7 = y(X7, Z7)
            if q7 then
                f(X7, q7)
            end
            L7:Destroy()
            n7:fix()
        end
        P7.clear = function(n7)
            local P7 = n7.rows
            for L7 = #P7, 1, -1 do
                local Z7 = P7[L7]
                w7[Z7.r] = nil
                Z7.r:Destroy()
                P7[L7] = nil
            end
            n7.n = 0
            n7:fix()
        end

        j.get = function(n7)
            return n7.val
        end
        j.eff = function(n7)
            return n7.val
        end
        j.ser = function(n7)
            return n7.val
        end
        j.unser = function(n7, n7)
            return n7
        end
        j.load = function(n7) end
        j.draw = function(n7) end
        j.rw = function(n7)
            return n7.row or n7.host and n7.host.row
        end
        j.nexta = function(n7)
            n7.an = n7.an + 1
            return n7.an * 2
        end
        j.hostof = function(n7)
            if n7.accf then
                return n7
            end
            return n7.host
        end

        local function n7(P7, L7)
            local Z7 = P7.accs
            if not Z7 then
                Z7 = {}
                P7.accs = Z7
            end
            Z7[#Z7 + 1] = L7
            L7.host = P7
            if L7.name == "" then
                L7.name = P7.name
            end
        end

        j.kbdraw = function(P7)
            local L7 = P7.bnd
            if not (L7) then
                return
            end
            if P7.pv then
                CF(P7)
            end
            local Z7, X7 = L7.key, P7.kt
            if Z7 and not X7 then
                local q7 = P7:hostof()
                if not (q7) then
                    return
                end
                local U7 = UF("TextButton", {
                    Size = A(0, 18),
                    AutomaticSize = v,
                    TextSize = 11,
                    BackgroundColor3 = YF,
                    BackgroundTransparency = LF.ctl,
                    LayoutOrder = (P7.lo or 1000000) - 1,
                    Parent = q7.accf,
                }, { TextColor3 = "dim" })
                zF(U7, 4)
                yF(U7, LF.ctle)
                kF(U7, 6, 6, 0, 0)
                MF(U7.MouseButton1Click, function()
                    uF(P7)
                end)
                P7.kt = U7
                X7 = U7
            end
            if X7 then
                X7.Visible = Z7 ~= nil
                if Z7 then
                    X7.Text = rF(Z7)
                    C(X7, { TextColor3 = L7.act and SF.acc or SF.dim }, 0.12, GF)
                end
            end
        end

        j.bdown = function(P7)
            local L7 = P7.bnd
            if not (L7 and not P7.dis and not P7.dead) then
                return
            end
            if L7.mode == "hold" then
                if not (L7.act) then
                    L7.act = true
                    P7:draw()
                    P7:fire()
                end
            elseif P7.kind == "tgl" or P7.kind == "gtgl" then
                P7:set(not P7.val)
            else
                L7.act = not L7.act
                P7:draw()
                P7:fire()
            end
        end

        j.bup = function(P7)
            local L7 = P7.bnd
            if L7 and L7.mode == "hold" and L7.act then
                L7.act = false
                P7:draw()
                P7:fire()
            end
        end

        j.onchange = function(P7, L7)
            local Z7 = P7.ucb
            if not Z7 then
                Z7 = {}
                P7.ucb = Z7
            end
            Z7[#Z7 + 1] = L7
            return P7
        end

        j.fire = function(P7, L7)
            local Z7 = P7:eff()
            if P7.flag and not (P7.tmp) then
                cF.flags[P7.flag] = Z7
                if P7.a ~= nil then
                    cF.flags[P7.flag .. "_a"] = P7.a
                end
            end
            local X7 = P7.prof
            if X7 and not (X7.ld) then
                X7.dirty = true
                if tostring(X7.cur) == X7.g then
                    X7:spread(P7)
                end
            end
            if not (L7) then
                if P7.cb then
                    H(P7.cb, Z7, P7.a)
                end
                X7 = P7.ucb
                if X7 then
                    for L7 = 1, #X7, 1 do
                        H(X7[L7], Z7, P7.a)
                    end
                end
            end
            Z7 = P7.dnt
            if Z7 then
                for L7 = 1, #Z7, 1 do
                    Z7[L7]:chkdep()
                end
            end
            if P7.ind and not (P7.tmp) then
                vF()
            end
        end

        j.dep = function(P7, L7, Z7)
            local X7 = P7.deps
            if not X7 then
                X7 = {}
                P7.deps = X7
            end
            X7[#X7 + 1] = { src = L7, want = Z7 }
            Z7 = L7.dnt
            if not Z7 then
                Z7 = {}
                L7.dnt = Z7
            end
            if not (y(Z7, P7)) then
                Z7[#Z7 + 1] = P7
            end
            P7:chkdep()
            return P7
        end

        j.chkdep = function(P7)
            local L7, Z7 = true, P7.deps
            if Z7 then
                for X7 = 1, #Z7, 1 do
                    local q7 = Z7[X7]
                    local Z7, U7 = q7.src, q7.want
                    X7 = Z7:eff()
                    q7 = if type(U7) == "function" then U7(X7) else (if U7 == nil then X7 == true else (if type(X7) == "table" then y(X7, U7) ~= nil else X7 == U7))
                    if not q7 or Z7.dis then
                        L7 = false
                        break
                    end
                end
            end
            P7:setdis(not L7)
        end

        j.setdis = function(P7, L7)
            L7 = L7 == true
            if P7.dis == L7 then
                return P7
            end
            P7.dis = L7
            P7:draw()
            if P7.ind and not (P7.tmp) then
                vF()
            end
            local Z7 = P7.accs
            if Z7 then
                for X7 = 1, #Z7, 1 do
                    Z7[X7]:setdis(L7)
                end
            end
            Z7 = P7.dnt
            if Z7 then
                for L7 = 1, #Z7, 1 do
                    Z7[L7]:chkdep()
                end
            end
            return P7
        end

        j.vis = function(P7, L7)
            local Z7 = P7.row
            if Z7 then
                Z7.Visible = L7 ~= false
                local L7 = w7[Z7]
                if L7 then
                    L7.b:fix()
                end
            end
            return P7
        end

        j.setbind = function(P7, L7, Z7)
            local X7 = P7.bnd
            if not (X7) then
                return P7
            end
            if X7.key then
                I7(P7, X7.key)
            end
            X7.act = false
            X7.key = L7
            if Z7 then
                X7.mode = Z7
            end
            if L7 then
                N7(P7, L7)
            end
            P7:kbdraw()
            P7:draw()
            P7:fire()
            return P7
        end

        local function P7(L7)
            if L7 then
                iF(L7)
                L7.md:clean()
                L7.box:Destroy()
            end
        end

        j.destroy = function(L7)
            if L7.dead then
                return
            end
            L7.dead = true
            local Z7 = L7.bnd
            if Z7 and Z7.key then
                I7(L7, Z7.key)
            end
            if L7.kind == "kbd" and L7.val then
                I7(L7, L7.val)
            end
            if HF.listen == L7 then
                HF.listen = nil
            end
            Z7 = y(cF.els, L7)
            if Z7 then
                f(cF.els, Z7)
            end
            Z7 = L7.prof
            if Z7 then
                local X7 = y(Z7.els, L7)
                if X7 then
                    f(Z7.els, X7)
                end
            end
            if L7.flag and cF.fl[L7.flag] == L7 then
                cF.fl[L7.flag] = nil
                cF.flags[L7.flag] = nil
            end
            Z7 = L7.accs
            if Z7 then
                for X7 = #Z7, 1, -1 do
                    Z7[X7]:destroy()
                end
            end
            Z7 = L7.host
            if Z7 and Z7.accs then
                local X7 = y(Z7.accs, L7)
                if X7 then
                    f(Z7.accs, X7)
                end
            end
            P7(L7.lp)
            P7(L7.pp)
            P7(L7.sp)
            Z7 = L7.row
            if Z7 then
                local P7 = w7[Z7]
                if P7 then
                    P7.b:del(Z7)
                elseif Z7.Parent then
                    Z7:Destroy()
                end
            elseif L7.ctl then
                L7.ctl:Destroy()
            end
            if L7.kt then
                L7.kt:Destroy()
            end
            WF(L7)
            vF()
        end

        j.padset = function(w7, P7, L7)
            local Z7 = w7.pd
            if not (Z7) then
                return w7
            end
            L7 = if P7 == "on" then L7 == true else (if P7 == "nm" then Z(tostring(L7 or ""), 1, 24) else (if P7 == "sz" then E(tonumber(L7) or 100, 70, 150) else E(tonumber(L7) or 100, 0, 100)))
            if Z7[P7] == L7 then
                return w7
            end
            Z7[P7] = L7
            lF(w7)
            eF()
            return w7
        end

        local function w7(P7)
            if P7.tmp then
                return
            end
            local L7 = cF.els
            L7[#L7 + 1] = P7
            L7 = P7:ser()
            P7.def = if type(L7) == "table" then c(L7) else L7
            if P7.flag then
                cF.fl[P7.flag] = P7
                cF.flags[P7.flag] = P7:eff()
                if P7.a ~= nil then
                    cF.flags[P7.flag .. "_a"] = P7.a
                end
                L7 = P7.c and P7.c.tab
                local Z7 = L7 and L7.prof
                if Z7 and not (P7.o.noprof) then
                    P7.prof = Z7
                    Z7.els[#Z7.els + 1] = P7
                end
            end
            if P7.ind and (P7.ind.on or P7.bnd and P7.bnd.key) then
                vF()
            end
            L7 = P7.pd
            if L7 then
                local Z7 = P7.flag and HF.pads and HF.pads[P7.flag]
                if type(Z7) == "table" then
                    L7.on = Z7.o == true
                    L7.sz = E(tonumber(Z7.s) or 100, 70, 150)
                    L7.rd = E(tonumber(Z7.r) or 100, 0, 100)
                    L7.nm = type(Z7.n) == "string" and Z(Z7.n, 1, 24) or ""
                    local X7 = Z7.p
                    L7.pos = type(X7) == "table" and #X7 == 4 and X7 or nil
                end
                lF(P7)
            end
        end

        local P7 = {}
        P7.__index = P7
        VF = function(L7, Z7, X7)
            return setmetatable({ frame = L7, tab = Z7, pop = X7, n = 0 }, P7)
        end
        P7.blk = function(L7)
            local Z7 = L7.cb
            if not Z7 then
                L7.n = L7.n + 1
                Z7 = r7(L7.frame, L7.n, true, L7.pop)
                L7.cb = Z7
            end
            return Z7
        end
        P7.brk = function(r7)
            r7.cb = nil
        end
        P7.row = function(r7, L7, Z7)
            return r7:blk():add(L7 or 30, Z7)
        end
        P7.free = function(r7, L7)
            r7.cb = nil
            r7.n = r7.n + 1
            return UF("Frame", { Size = p(1, 0, 0, L7 or 0), AutomaticSize = L7 and e or u, LayoutOrder = r7.n, Parent = r7.frame })
        end
        P7.head = function(r7, L7)
            local Z7 = r7:row(32, true)
            UF("TextLabel", { Position = A(12, 0), Size = p(1, -24, 1, 0), Text = tostring(L7 or ""), FontFace = ZF.b, TextSize = 13, TextTruncate = W, Parent = Z7 })
            return Z7
        end
        P7.space = function(r7, L7)
            return r7:free(L7 or 6)
        end
        P7.div = function(r7)
            local L7 = r7:free(1)
            UF("Frame", { Position = A(6, 0), Size = p(1, -12, 0, 1), BackgroundColor3 = YF, BackgroundTransparency = 0.955, Parent = L7 })
            return L7
        end

        local function r7(L7, Z7)
            local X7 = Z7.pop
            local q7 = Z7:row(X7 and 28 or 30)
            local U7, z7 = UF("TextButton", { Size = M(1, 1), ZIndex = 1, Parent = q7 }), UF("Frame", { AnchorPoint = B(1, 0.5), Position = p(1, -10, 0.5, 0), Size = A(0, 22), AutomaticSize = v, ZIndex = 2, Parent = q7 })
            QF(z7, 8, l.Right)
            local J7, y7, f7, k7 = 12
            if L7.o.icon then
                y7, J7 = UF("ImageLabel", { AnchorPoint = B(0, 0.5), Position = p(0, 12, 0.5, 0), Size = A(13, 13), Image = qF(L7.o.icon), ZIndex = 2, Parent = q7 }, { ImageColor3 = "txt" }), 32
                f7, k7 = J7, y7
            else
                f7, k7 = J7, y7
            end
            local J7, y7
            if L7.name ~= "" then
                y7 = UF("TextLabel", { Position = A(f7, 0), Size = p(1, -(f7 + 12), 1, 0), Text = L7.name, TextSize = 13, TextTruncate = W, ZIndex = 2, Parent = q7 }, { TextColor3 = "txt" })
                MF(z7:GetPropertyChangedSignal("AbsoluteSize"), function()
                    y7.Size = p(1, -(f7 + 18 + z7.AbsoluteSize.X / IF()), 1, 0)
                end)
                if k7 then
                    MF(y7:GetPropertyChangedSignal("TextColor3"), function()
                        k7.ImageColor3 = y7.TextColor3
                    end)
                end
            else
                y7 = J7
            end
            if X7 then
                Z7 = X7.rws
                if not Z7 then
                    Z7 = {}
                    X7.rws = Z7
                end
                local X7, J7 = #Z7 + 1, { r = q7 }
                J7.n, J7.af, J7.x, Z7[X7] = y7 and L7.name, z7, f7, J7
            end
            L7.row = q7
            L7.hit = U7
            L7.accf = z7
            L7.lbl = y7
            return q7, U7, z7
        end

        local L7 = setmetatable({}, j)
        L7.__index = L7
        P7.toggle = function(Z7, X7)
            X7 = X7 or {}
            local q7 = E7(L7, Z7, X7, "tgl")
            q7.val = X7.default == true
            q7.lo = 1000000
            local U7, U7, z7 = r7(q7, Z7)
            Z7 = UF("Frame", { Size = A(26, 14), BackgroundColor3 = YF, BackgroundTransparency = LF.trk, LayoutOrder = q7.lo, Parent = z7 })
            JF(Z7)
            z7 = UF("Frame", { AnchorPoint = B(0, 0.5), Position = p(0, 2, 0.5, 0), Size = A(10, 10), BackgroundTransparency = 0, Parent = Z7 }, { BackgroundColor3 = "knob" })
            JF(z7)
            q7.trk = Z7
            q7.kn = z7
            q7.bnd = { key = nil, mode = X7.mode or "toggle", act = false }
            q7.ind = { on = X7.ind ~= nil and X7.ind ~= false, name = type(X7.ind) == "string" and X7.ind or "" }
            q7.pd = { on = false, sz = 100, rd = 100, nm = "" }
            MF(U7.InputBegan, function(Z7)
                if FF(Z7.UserInputType) then
                    q7.lpd = false
                end
            end)
            MF(U7.MouseButton1Click, function()
                if q7.lpd then
                    q7.lpd = false
                    return
                end
                if not (q7.dis) then
                    q7:set(not q7.val)
                end
            end)
            MF(U7.MouseButton2Click, function()
                uF(q7)
            end)
            S7(U7, function()
                q7.lpd = true
                uF(q7)
            end)
            if X7.bind then
                q7.bnd.key = X7.bind
                N7(q7, X7.bind)
            end
            q7:draw(true)
            w7(q7)
            return q7
        end
        L7.eff = function(Z7)
            local X7 = Z7.bnd
            if X7.act and X7.mode == "hold" then
                return not Z7.val
            end
            return Z7.val
        end
        L7.set = function(Z7, X7, q7)
            X7 = X7 == true
            if Z7.val == X7 then
                return Z7
            end
            Z7.val = X7
            Z7:draw()
            Z7:fire(q7)
            return Z7
        end
        L7.load = function(Z7, X7)
            if type(X7) == "boolean" then
                Z7:set(X7)
            end
        end
        L7.draw = function(L7, Z7)
            local X7, q7 = L7:eff(), L7.dis
            local U7, z7, J7, y7, f7, k7, g7 = q7 and SF.faint or (X7 and L7.o.risky and SF.bad or SF.txt), X7 and SF.acc or YF, X7 and (q7 and 0.6 or 0) or LF.trk, X7 and YF or SF.knob, p(0, X7 and 14 or 2, 0.5, 0), q7 and 0.55 or 0, L7.lbl
            if Z7 then
                if g7 then
                    g7.TextColor3 = U7
                end
                L7.trk.BackgroundColor3, L7.trk.BackgroundTransparency = z7, J7
                L7.kn.Position, L7.kn.BackgroundColor3, L7.kn.BackgroundTransparency = f7, y7, k7
            else
                if g7 then
                    C(g7, { TextColor3 = U7 }, 0.14, GF)
                end
                C(L7.trk, { BackgroundColor3 = z7, BackgroundTransparency = J7 }, 0.16, GF)
                C(L7.kn, { Position = f7, BackgroundColor3 = y7, BackgroundTransparency = k7 }, 0.2)
            end
            L7:kbdraw()
        end

        -- Gradient Toggle
        local GT = setmetatable({}, j)
        GT.__index = GT
        P7.gradient_toggle = function(Z7, X7)
            X7 = X7 or {}
            local q7 = E7(GT, Z7, X7, "gtgl")
            q7.val = X7.default == true
            q7.rot = tonumber(X7.rotation) or 0
            q7.grad_spec = X7.colors or X7.gradient
            q7.c_from = X7.from
            q7.c_to = X7.to
            q7.lo = 1000000
            local U7, U7, z7 = r7(q7, Z7)
            local trk = UF("Frame", { Size = A(28, 14), BackgroundColor3 = YF, BackgroundTransparency = LF.trk, LayoutOrder = q7.lo, Parent = z7 })
            JF(trk)
            local grad = UF("UIGradient", { Rotation = q7.rot, Enabled = false, Color = buildGradientSeq(q7.grad_spec, q7.c_from, q7.c_to), Parent = trk })
            local kn = UF("Frame", { AnchorPoint = B(0, 0.5), Position = p(0, 2, 0.5, 0), Size = A(10, 10), BackgroundTransparency = 0, ZIndex = 2, Parent = trk }, { BackgroundColor3 = "knob" })
            JF(kn)
            q7.trk = trk
            q7.grad = grad
            q7.kn = kn
            q7.bnd = { key = nil, mode = X7.mode or "toggle", act = false }
            q7.ind = { on = X7.ind ~= nil and X7.ind ~= false, name = type(X7.ind) == "string" and X7.ind or "" }
            q7.pd = { on = false, sz = 100, rd = 100, nm = "" }
            MF(U7.InputBegan, function(ev)
                if FF(ev.UserInputType) then
                    q7.lpd = false
                end
            end)
            MF(U7.MouseButton1Click, function()
                if q7.lpd then
                    q7.lpd = false
                    return
                end
                if not (q7.dis) then
                    q7:set(not q7.val)
                end
            end)
            MF(U7.MouseButton2Click, function()
                uF(q7)
            end)
            S7(U7, function()
                q7.lpd = true
                uF(q7)
            end)
            if X7.bind then
                q7.bnd.key = X7.bind
                N7(q7, X7.bind)
            end
            q7:setgradient(q7.grad_spec, q7.c_from, q7.c_to, q7.rot)
            q7:draw(true)
            w7(q7)
            return q7
        end
        GT.setgradient = function(self, spec, fromCol, toCol, rot)
            self.grad_spec = spec or self.grad_spec
            self.c_from = fromCol or self.c_from
            self.c_to = toCol or self.c_to
            if rot ~= nil then
                self.rot = tonumber(rot) or 0
            end
            if self.grad then
                self.grad.Rotation = self.rot
                self.grad.Color = buildGradientSeq(self.grad_spec, self.c_from, self.c_to)
            end
            return self
        end
        GT.eff = function(Z7)
            local X7 = Z7.bnd
            if X7.act and X7.mode == "hold" then
                return not Z7.val
            end
            return Z7.val
        end
        GT.set = function(Z7, X7, q7)
            X7 = X7 == true
            if Z7.val == X7 then
                return Z7
            end
            Z7.val = X7
            Z7:draw()
            Z7:fire(q7)
            return Z7
        end
        GT.load = function(Z7, X7)
            if type(X7) == "boolean" then
                Z7:set(X7)
            end
        end
        GT.draw = function(self, instant)
            local active, dis = self:eff(), self.dis
            local lblCol = dis and SF.faint or (active and self.o.risky and SF.bad or SF.txt)
            local trkCol = active and YF or YF
            local trkTrans = active and (dis and 0.6 or 0) or LF.trk
            local knPos = p(0, active and 16 or 2, 0.5, 0)
            local knCol = active and YF or SF.knob
            local knTrans = dis and 0.55 or 0
            if self.grad then
                self.grad.Enabled = active
                self.grad.Rotation = self.rot
                if not self.grad_spec and not self.c_from and not self.c_to then
                    self.grad.Color = buildGradientSeq(nil, SF.acc, K(((select(1, SF.acc:ToHSV())) + 0.12) % 1, 0.85, 1))
                end
            end
            if instant then
                if self.lbl then
                    self.lbl.TextColor3 = lblCol
                end
                self.trk.BackgroundColor3, self.trk.BackgroundTransparency = trkCol, trkTrans
                self.kn.Position, self.kn.BackgroundColor3, self.kn.BackgroundTransparency = knPos, knCol, knTrans
            else
                if self.lbl then
                    C(self.lbl, { TextColor3 = lblCol }, 0.14, GF)
                end
                C(self.trk, { BackgroundColor3 = trkCol, BackgroundTransparency = trkTrans }, 0.16, GF)
                C(self.kn, { Position = knPos, BackgroundColor3 = knCol, BackgroundTransparency = knTrans }, 0.2)
            end
            self:kbdraw()
        end

        j.settings = function(L7, Z7)
            Z7 = Z7 or {}
            local X7 = L7:hostof()
            if not X7 then
                return nil
            end
            local q7, U7 = L7.c, UF("ImageButton", { Size = A(14, 14), Image = qF("dots"), LayoutOrder = -1, Parent = X7.accf }, { ImageColor3 = "dim" })
            K7(U7, q7.pop, "ImageColor3", SF.dim, SF.txt)
            local z7 = a7({ w = Z7.w, keep = true, anchor = U7, par = q7.pop, tab = q7.tab, tmp = L7.tmp, title = Z7.title or L7.name })
            z7.owner = L7
            z7.c.page, z7.c.sec = q7.page, q7.sec
            MF(U7.MouseButton1Click, function()
                if X7.dis then
                    return
                end
                if z7.isopen then
                    iF(z7)
                    return
                end
                local Z7 = X7.row
                d7(Z7, true)
                function z7.onclose()
                    d7(Z7, false)
                end
                local Z7, X7 = U7.AbsolutePosition, U7.AbsoluteSize
                B7(z7, Z7.X + X7.X + 12, Z7.Y - 8)
            end)
            L7.sp = z7
            return z7.c
        end

        j.color = function(L7, Z7)
            local X7 = L7:hostof()
            return X7 and L7.c:colorpicker(Z7 or {}, X7)
        end
        j.colorpicker = j.color
        j.dropdown = function(L7, Z7)
            local X7 = L7:hostof()
            return X7 and L7.c:dropdown(Z7 or {}, X7)
        end
        j.slider = function(L7, Z7)
            local X7 = L7:hostof()
            return X7 and L7.c:slider(Z7 or {}, X7)
        end
        j.gradient_toggle = function(L7, Z7)
            local X7 = L7:hostof()
            return X7 and L7.c:gradient_toggle(Z7 or {}, X7)
        end
        j.gradient_slider = function(L7, Z7)
            local X7 = L7:hostof()
            return X7 and L7.c:gradient_slider(Z7 or {}, X7)
        end

        local L7 = setmetatable({}, j)
        L7.__index = L7
        local function Z7(X7, q7, U7)
            local z7 = UF("Frame", { Size = A(0, 22), AutomaticSize = v, LayoutOrder = X7.lo, Parent = q7 })
            QF(z7, 8)
            local J7 = UF("TextBox", { Size = A(0, 18), AutomaticSize = v, BackgroundColor3 = YF, BackgroundTransparency = LF.ctl, TextSize = 11, TextXAlignment = F.Center, LayoutOrder = 1, Parent = z7 })
            zF(J7, 4)
            yF(J7, LF.ctle)
            kF(J7, 7, 7, 0, 0)
            UF("UISizeConstraint", { MinSize = B(40, 18), Parent = J7 })
            q7 = UF("TextButton", { Size = A(X7.o.sw or 72, 18), LayoutOrder = 2, Parent = z7 })
            local y7 = UF("Frame", { AnchorPoint = B(0, 0.5), Position = M(0, 0.5), Size = p(1, 0, 0, 4), BackgroundColor3 = YF, BackgroundTransparency = LF.trk, Parent = q7 })
            JF(y7)
            local f7 = UF("Frame", { Size = M(0, 1), BackgroundTransparency = 0, Parent = y7 }, { BackgroundColor3 = "acc" })
            JF(f7)
            local k7 = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0, 0.5), Size = A(10, 10), BackgroundColor3 = YF, BackgroundTransparency = 0, ZIndex = 3, Parent = y7 })
            JF(k7)
            X7.ctl = z7
            X7.vl = J7
            X7.trk = q7
            X7.bar = y7
            X7.fil = f7
            X7.kn = k7
            X7.mv = function(z7)
                local f7, g7 = y7.AbsolutePosition.X, y7.AbsoluteSize.X
                if g7 <= 0 then
                    return
                end
                local y7 = X7.min + E((z7.X - f7) / g7, 0, 1) * (X7.max - X7.min)
                if X7.bnd.act then
                    X7:setbv(y7)
                else
                    X7:set(y7)
                end
            end
            X7.mu = function()
                X7.drg = false
                local z7 = X7.hov and 12 or 10
                C(k7, { Size = A(z7, z7) }, 0.14)
                if X7.pend then
                    X7.pend = false
                    X7:fire()
                end
            end
            local function z7(y7)
                X7.drg = true
                C(k7, { Size = A(12, 12) }, 0.14)
                m7(X7.mv, X7.mu, U7, y7)
            end
            MF(q7.InputBegan, function(y7)
                if X7.dis then
                    return
                end
                local f7 = y7.UserInputType
                local g7 = f7 == mF and HF.ph
                if f7 == mF and not g7 then
                    X7.mv(_F())
                    z7(y7)
                elseif f7 == bF or g7 then
                    local f7 = { i = y7 }
                    f7.p0 = g7 and _F() or sF(y7)
                    f7.m = g7
                    f7.drag = function(g7)
                        X7.mv(g7)
                        z7(y7)
                    end
                    f7.tap = function(z7)
                        X7.mv(z7)
                        X7.mu()
                    end
                    HF.tg = f7
                    _(0.5, function()
                        if HF.tg == f7 then
                            HF.tg = nil
                            uF(X7)
                        end
                    end)
                end
            end)
            MF(q7.MouseButton2Click, function()
                uF(X7)
            end)
            b7(q7, U7, function()
                X7.hov = true
                if not (X7.drg) then
                    C(k7, { Size = A(12, 12) }, 0.14)
                end
            end, function()
                X7.hov = false
                if not (X7.drg) then
                    C(k7, { Size = A(10, 10) }, 0.14)
                end
            end)
            MF(J7.Focused, function()
                if X7.dis then
                    J7:ReleaseFocus()
                    return
                end
                X7.foc = true
                J7.Text = tostring(X7:eff())
                J7.TextColor3 = SF.acc
                d7(X7:rw(), true)
            end)
            MF(J7.FocusLost, function()
                if X7.foc then
                    X7.foc = false
                    d7(X7:rw(), false)
                end
                local q7 = tonumber((U(J7.Text, "[^%d%.%-]", "")))
                if q7 then
                    if X7.bnd.act then
                        X7:setbv(q7)
                    else
                        X7:set(q7)
                    end
                end
                X7:draw()
            end)
        end

        P7.slider = function(X7, q7, U7)
            q7 = q7 or {}
            local z7 = E7(L7, X7, q7, "sld")
            z7.min, z7.max = q7.min or 0, q7.max or 100
            z7.dec = q7.dec or q7.decimals or 0
            z7.step = q7.step or 10 ^ (-z7.dec)
            z7.pat = "%." .. z7.dec .. "f"
            z7.suf = q7.suffix or ""
            z7.zero = q7.zero
            z7.val = z7:rnd(q7.default or z7.min)
            z7.bnd = { key = nil, mode = q7.mode or "hold", act = false, v = z7.val }
            z7.ind = { on = q7.ind ~= nil and q7.ind ~= false, name = type(q7.ind) == "string" and q7.ind or "" }
            z7.pd = { on = false, sz = 100, rd = 100, nm = "" }
            if q7.bindvalue ~= nil then
                z7.bnd.v = z7:rnd(q7.bindvalue)
            end
            if U7 then
                n7(U7, z7)
                z7.lo = U7:nexta()
                Z7(z7, U7.accf, X7.pop)
            else
                z7.lo = 1000000
                local U7, U7 = r7(z7, X7)
                Z7(z7, z7.accf, X7.pop)
                MF(U7.MouseButton2Click, function()
                    uF(z7)
                end)
                S7(U7, function()
                    uF(z7)
                end)
            end
            if q7.bind then
                z7.bnd.key = q7.bind
                N7(z7, q7.bind)
            end
            z7:draw()
            w7(z7)
            return z7
        end

        L7.rnd = function(S7, Z7)
            local X7, q7 = S7.min, S7.max
            Z7 = E(tonumber(Z7) or X7, X7, q7)
            local U7 = S7.step
            Z7 = if U7 > 0 then X7 + d((Z7 - X7) / U7 + 0.5) * U7 else Z7
            return tonumber(L(S7.pat, E(Z7, X7, q7)))
        end
        L7.eff = function(S7)
            local Z7 = S7.bnd
            if Z7 and Z7.act then
                return Z7.v
            end
            return S7.val
        end
        L7.set = function(S7, Z7, X7)
            Z7 = S7:rnd(Z7)
            if Z7 == S7.val then
                return S7
            end
            S7.val = Z7
            S7:draw()
            if S7.bnd.act then
                return S7
            end
            if S7.drg and S7.o.release then
                S7.pend = true
                return S7
            end
            S7:fire(X7)
            return S7
        end
        L7.setbv = function(S7, Z7)
            Z7 = S7:rnd(Z7)
            local X7 = S7.bnd
            if X7.v == Z7 then
                return S7
            end
            X7.v = Z7
            if X7.act then
                S7:draw()
                S7:fire()
            end
            return S7
        end
        L7.load = function(S7, Z7)
            if type(Z7) == "number" then
                S7:set(Z7)
            end
        end
        L7.fmtv = function(S7, Z7)
            local X7 = S7.o.fmt
            if X7 then
                return X7(Z7)
            end
            if S7.zero and Z7 <= S7.min then
                return S7.zero
            end
            return L(S7.pat, Z7) .. S7.suf
        end
        L7.draw = function(L)
            local S7, L7, Z7, X7 = L:eff(), L.dis, L.bnd, L.max - L.min
            local q7 = X7 > 0 and (S7 - L.min) / X7 or 0
            if L.drawn then
                C(L.fil, { Size = M(q7, 1) }, 0.12)
                C(L.kn, { Position = M(q7, 0.5) }, 0.12)
            else
                L.drawn = true
                L.fil.Size = M(q7, 1)
                L.kn.Position = M(q7, 0.5)
            end
            L.fil.BackgroundTransparency = L7 and 0.6 or 0
            L.kn.BackgroundTransparency = L7 and 0.6 or 0
            if L.lbl then
                L.lbl.TextColor3 = L7 and SF.faint or SF.txt
            end
            if not (L.vl:IsFocused()) then
                L.vl.Text = L:fmtv(S7)
                q7, X7 = L.vl, L7 and SF.faint or (Z7.act and SF.acc or SF.txt)
                q7.TextColor3 = X7
            end
            L.vl.TextEditable = not L7
            L:kbdraw()
        end

        -- Gradient Slider
        local GS = setmetatable({}, L7)
        GS.__index = GS
        local function attachGradientSliderCtl(X7, q7, U7)
            local z7 = UF("Frame", { Size = A(0, 22), AutomaticSize = v, LayoutOrder = X7.lo, Parent = q7 })
            QF(z7, 8)
            local J7 = UF("TextBox", { Size = A(0, 18), AutomaticSize = v, BackgroundColor3 = YF, BackgroundTransparency = LF.ctl, TextSize = 11, TextXAlignment = F.Center, LayoutOrder = 1, Parent = z7 })
            zF(J7, 4)
            yF(J7, LF.ctle)
            kF(J7, 7, 7, 0, 0)
            UF("UISizeConstraint", { MinSize = B(40, 18), Parent = J7 })
            local trkBtn = UF("TextButton", { Size = A(X7.o.sw or 76, 18), LayoutOrder = 2, Parent = z7 })
            local bar = UF("Frame", { AnchorPoint = B(0, 0.5), Position = M(0, 0.5), Size = p(1, 0, 0, 5), BackgroundColor3 = YF, BackgroundTransparency = LF.trk, Parent = trkBtn })
            JF(bar)
            local fil = UF("Frame", { Size = M(0, 1), BackgroundColor3 = YF, BackgroundTransparency = 0, ClipsDescendants = true, Parent = bar })
            JF(fil)
            local grad = UF("UIGradient", { Rotation = X7.rot, Color = buildGradientSeq(X7.grad_spec, X7.c_from, X7.c_to), Parent = fil })
            local kn = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0, 0.5), Size = A(10, 10), BackgroundColor3 = YF, BackgroundTransparency = 0, ZIndex = 3, Parent = bar })
            JF(kn)
            local knStroke = yF(kn, 0.35, OF)

            X7.ctl = z7
            X7.vl = J7
            X7.trk = trkBtn
            X7.bar = bar
            X7.fil = fil
            X7.grad = grad
            X7.kn = kn
            X7.knStroke = knStroke

            X7.mv = function(pos)
                local f7, g7 = bar.AbsolutePosition.X, bar.AbsoluteSize.X
                if g7 <= 0 then
                    return
                end
                local val = X7.min + E((pos.X - f7) / g7, 0, 1) * (X7.max - X7.min)
                if X7.bnd.act then
                    X7:setbv(val)
                else
                    X7:set(val)
                end
            end
            X7.mu = function()
                X7.drg = false
                local sz = X7.hov and 12 or 10
                C(kn, { Size = A(sz, sz) }, 0.14)
                if X7.pend then
                    X7.pend = false
                    X7:fire()
                end
            end
            local function startDrag(ev)
                X7.drg = true
                C(kn, { Size = A(12, 12) }, 0.14)
                m7(X7.mv, X7.mu, U7, ev)
            end
            MF(trkBtn.InputBegan, function(ev)
                if X7.dis then
                    return
                end
                local f7 = ev.UserInputType
                local g7 = f7 == mF and HF.ph
                if f7 == mF and not g7 then
                    X7.mv(_F())
                    startDrag(ev)
                elseif f7 == bF or g7 then
                    local tg = { i = ev }
                    tg.p0 = g7 and _F() or sF(ev)
                    tg.m = g7
                    tg.drag = function(pt)
                        X7.mv(pt)
                        startDrag(ev)
                    end
                    tg.tap = function(pt)
                        X7.mv(pt)
                        X7.mu()
                    end
                    HF.tg = tg
                    _(0.5, function()
                        if HF.tg == tg then
                            HF.tg = nil
                            uF(X7)
                        end
                    end)
                end
            end)
            MF(trkBtn.MouseButton2Click, function()
                uF(X7)
            end)
            b7(trkBtn, U7, function()
                X7.hov = true
                if not (X7.drg) then
                    C(kn, { Size = A(12, 12) }, 0.14)
                end
            end, function()
                X7.hov = false
                if not (X7.drg) then
                    C(kn, { Size = A(10, 10) }, 0.14)
                end
            end)
            MF(J7.Focused, function()
                if X7.dis then
                    J7:ReleaseFocus()
                    return
                end
                X7.foc = true
                J7.Text = tostring(X7:eff())
                J7.TextColor3 = SF.acc
                d7(X7:rw(), true)
            end)
            MF(J7.FocusLost, function()
                if X7.foc then
                    X7.foc = false
                    d7(X7:rw(), false)
                end
                local num = tonumber((U(J7.Text, "[^%d%.%-]", "")))
                if num then
                    if X7.bnd.act then
                        X7:setbv(num)
                    else
                        X7:set(num)
                    end
                end
                X7:draw()
            end)
        end

        P7.gradient_slider = function(X7, q7, U7)
            q7 = q7 or {}
            local z7 = E7(GS, X7, q7, "gsld")
            z7.min, z7.max = q7.min or 0, q7.max or 100
            z7.dec = q7.dec or q7.decimals or 0
            z7.step = q7.step or 10 ^ (-z7.dec)
            z7.pat = "%." .. z7.dec .. "f"
            z7.suf = q7.suffix or ""
            z7.zero = q7.zero
            z7.rot = tonumber(q7.rotation) or 0
            z7.grad_spec = q7.colors or q7.gradient
            z7.c_from = q7.from
            z7.c_to = q7.to
            z7.val = z7:rnd(q7.default or z7.min)
            z7.bnd = { key = nil, mode = q7.mode or "hold", act = false, v = z7.val }
            z7.ind = { on = q7.ind ~= nil and q7.ind ~= false, name = type(q7.ind) == "string" and q7.ind or "" }
            z7.pd = { on = false, sz = 100, rd = 100, nm = "" }
            if q7.bindvalue ~= nil then
                z7.bnd.v = z7:rnd(q7.bindvalue)
            end
            if U7 then
                n7(U7, z7)
                z7.lo = U7:nexta()
                attachGradientSliderCtl(z7, U7.accf, X7.pop)
            else
                z7.lo = 1000000
                local rowBtn, _ = r7(z7, X7)
                attachGradientSliderCtl(z7, z7.accf, X7.pop)
                MF(rowBtn.MouseButton2Click, function()
                    uF(z7)
                end)
                S7(rowBtn, function()
                    uF(z7)
                end)
            end
            if q7.bind then
                z7.bnd.key = q7.bind
                N7(z7, q7.bind)
            end
            z7:setgradient(z7.grad_spec, z7.c_from, z7.c_to, z7.rot)
            z7:draw()
            w7(z7)
            return z7
        end

        GS.setgradient = function(self, spec, fromCol, toCol, rot)
            self.grad_spec = spec or self.grad_spec
            self.c_from = fromCol or self.c_from
            self.c_to = toCol or self.c_to
            if rot ~= nil then
                self.rot = tonumber(rot) or 0
            end
            if self.grad then
                self.grad.Rotation = self.rot
                self.grad.Color = buildGradientSeq(self.grad_spec, self.c_from, self.c_to)
            end
            return self
        end

        GS.draw = function(self)
            local effVal, dis, bnd, span = self:eff(), self.dis, self.bnd, self.max - self.min
            local alpha = span > 0 and E((effVal - self.min) / span, 0, 1) or 0
            if self.grad and not self.grad_spec and not self.c_from and not self.c_to then
                self.grad.Color = buildGradientSeq(nil, SF.acc, K(((select(1, SF.acc:ToHSV())) + 0.14) % 1, 0.85, 1))
            end
            if self.drawn then
                C(self.fil, { Size = M(alpha, 1) }, 0.12)
                C(self.kn, { Position = M(alpha, 0.5) }, 0.12)
            else
                self.drawn = true
                self.fil.Size = M(alpha, 1)
                self.kn.Position = M(alpha, 0.5)
            end
            self.fil.BackgroundTransparency = dis and 0.6 or 0
            self.kn.BackgroundTransparency = dis and 0.6 or 0
            if self.lbl then
                self.lbl.TextColor3 = dis and SF.faint or SF.txt
            end
            if not (self.vl:IsFocused()) then
                self.vl.Text = self:fmtv(effVal)
                self.vl.TextColor3 = dis and SF.faint or (bnd.act and SF.acc or SF.txt)
            end
            self.vl.TextEditable = not dis
            self:kbdraw()
        end

        local L = setmetatable({}, j)
        L.__index = L
        local function S7(L7, Z7, X7, q7)
            if X7 then
                for X7, U7 in next, Z7, nil do
                    L7[X7] = U7
                end
            else
                C(L7, Z7, q7 or 0.12, GF)
            end
        end

        local function L7(Z7)
            local X7 = UF("UIGradient", { Enabled = false, Parent = Z7 })
            local function q7()
                local U7 = Z7.AbsoluteSize.X
                local z7 = U7 > 1 and Z7.TextBounds.X > U7 + 1.5
                X7.Enabled = z7
                if z7 then
                    local z7 = E(1 - 18 * IF() / U7, 0.05, 0.95)
                    X7.Transparency = R({ n(0, 0), n(z7, 0), n(1, 1) })
                end
            end
            MF(Z7:GetPropertyChangedSignal("TextBounds"), q7)
            MF(Z7:GetPropertyChangedSignal("AbsoluteSize"), q7)
            q7()
        end

        local function n(Z7, X7, q7, U7, z7)
            z7 = z7 or 22
            local J7 = UF("TextButton", { Size = A(U7 and 0 or X7, z7), AutomaticSize = U7 and v or e, BackgroundColor3 = YF, BackgroundTransparency = LF.ctl, LayoutOrder = q7 or 0, Parent = Z7 })
            zF(J7, 6)
            X7 = yF(J7, LF.ctle)
            kF(J7, 9, 8, 0, 0)
            QF(J7, U7 and 2 or 6)
            Z7 = UF("TextLabel", { Size = U7 and A(0, z7) or p(1, -16, 1, 0), AutomaticSize = U7 and v or e, TextSize = 12, ClipsDescendants = true, LayoutOrder = 1, Parent = J7 }, { TextColor3 = "sub" })
            if U7 then
                kF(Z7, 0, 4, 0, 0)
                UF("UISizeConstraint", { MaxSize = B(154, z7), Parent = Z7 })
            end
            L7(Z7)
            return J7, Z7, UF("ImageLabel", { Size = A(10, 10), Image = qF("chevron"), LayoutOrder = 2, Parent = J7 }, { ImageColor3 = "dim" }), X7
        end

        local function Z7(X7, q7)
            local U7 = UF("TextButton", { Size = A(0, 22), AutomaticSize = v, LayoutOrder = q7 or 0, Parent = X7 })
            QF(U7, 1)
            X7 = UF("TextLabel", { Size = A(0, 22), AutomaticSize = v, TextSize = 13, ClipsDescendants = true, LayoutOrder = 1, Parent = U7 }, { TextColor3 = "sub" })
            kF(X7, 0, 4, 0, 0)
            UF("UISizeConstraint", { MaxSize = B(122, 22), Parent = X7 })
            L7(X7)
            return U7, X7, (UF("ImageLabel", { Size = A(12, 12), Image = qF("right"), LayoutOrder = 2, Parent = U7 }, { ImageColor3 = "dim" }))
        end

        P7.dropdown = function(L7, X7, q7)
            X7 = X7 or {}
            local U7 = E7(L, L7, X7, "drp")
            U7.multi = X7.multi == true
            U7.values = X7.values or X7.options or {}
            if U7.multi then
                U7.val = {}
                local z7 = X7.default
                if type(z7) == "table" then
                    for J7 = 1, #z7, 1 do
                        U7.val[J7] = z7[J7]
                    end
                elseif z7 ~= nil then
                    U7.val[1] = z7
                end
            else
                U7.val = X7.default
                if U7.val == nil and not (X7.none) then
                    U7.val = U7.values[1]
                end
            end
            U7.srt = function(z7, J7)
                return (y(U7.values, z7) or 0) < (y(U7.values, J7) or 0)
            end
            U7.ind = { on = X7.ind ~= nil and X7.ind ~= false, name = type(X7.ind) == "string" and X7.ind or "" }
            local z7 = L7.pop
            U7.fly = z7 ~= nil and X7.par == nil and X7.box ~= true
            local J7, y7, f7 = X7.par, X7.w or 112, X7.lo
            if q7 then
                n7(q7, U7)
                U7.lo = q7:nexta()
                J7, y7, f7 = q7.accf, X7.w or 96, U7.lo
            elseif not J7 then
                U7.lo = 1000000
                local q7, k7 = r7(U7, L7)
                J7, f7 = U7.accf, U7.lo
                MF(k7.MouseButton1Click, function()
                    U7:flip()
                end)
                MF(k7.MouseButton2Click, function()
                    uF(U7)
                end)
                if U7.fly then
                    b7(q7, z7, function()
                        U7.rh = true
                        U7:draw()
                    end, function()
                        U7.rh = false
                        U7:draw()
                    end)
                end
            end
            if U7.fly then
                U7.btn, U7.t, U7.ch = Z7(J7, f7)
            else
                U7.btn, U7.t, U7.ch, U7.sk = n(J7, y7, f7, X7.auto, X7.h)
            end
            U7.ctl = U7.btn
            b7(U7.btn, z7, function()
                U7.bh = true
                U7:draw()
            end, function()
                U7.bh = false
                U7:draw()
            end)
            MF(U7.btn.MouseButton1Click, function()
                U7:flip()
            end)
            U7:draw(true)
            w7(U7)
            return U7
        end

        L.flip = function(n)
            if n.dis then
                return
            end
            if n.lp and n.lp.isopen then
                iF(n.lp)
            else
                n:openlist()
            end
        end
        L.has = function(n, L7)
            if n.multi then
                return y(n.val, L7) ~= nil
            end
            return n.val == L7
        end
        L.none = function(n)
            if n.multi then
                return #n.val == 0
            end
            return n.val == nil
        end
        L.text = function(n)
            if n:none() then
                return n.o.empty or (n.multi and not n.fly and "None" or "Select")
            end
            if n.multi then
                local L7 = #n.val
                local Z7 = table.create(L7)
                for X7 = 1, L7, 1 do
                    Z7[X7] = tostring(n.val[X7])
                end
                return g(Z7, ", ")
            end
            return tostring(n.val)
        end
        L.draw = function(n, L7)
            local Z7 = n.dis
            if Z7 and n.lp then
                iF(n.lp)
                return
            end
            local X7, q7, U7 = n.lp ~= nil, if Z7 then not Z7 else n.bh or n.rh, n:none()
            n.t.Text = n:text()
            local z7, J7 = if Z7 then SF.faint, SF.faint else ((X7 or q7) and SF.txt or (U7 and SF.dim or SF.sub)), (X7 and SF.txt or (q7 and SF.sub or SF.dim))
            S7(n.t, { TextColor3 = z7 }, L7)
            U7 = n.sk
            if U7 then
                local z7, y7 = n.btn, {}
                y7.BackgroundTransparency = (X7 or q7) and LF.ctlh or LF.ctl
                S7(z7, y7, L7)
                S7(U7, { Transparency = X7 and 0.88 or LF.ctle }, L7)
                y7, z7 = n.ch, { ImageColor3 = J7 }
                z7.Rotation = X7 and 180 or 0
                S7(y7, z7, L7, 0.16)
            else
                S7(n.ch, { ImageColor3 = J7 }, L7)
            end
            if n.lbl then
                n.lbl.TextColor3 = Z7 and SF.faint or SF.txt
            end
            q7 = n.items
            if q7 then
                Z7, X7, U7 = n.hv, n.multi
                for z7 = 1, #q7, 1 do
                    local J7 = q7[z7]
                    local q7, y7 = n:has(J7.v), Z7 == J7
                    U7 = U7 or (q7 and not X7 and z7 or nil)
                    local z7, f7 = J7.t, {}
                    f7.TextColor3 = (q7 or y7) and SF.txt or SF.sub
                    S7(z7, f7, L7, 0.1)
                    if X7 then
                        S7(J7.m, { BackgroundColor3 = q7 and SF.acc or YF, BackgroundTransparency = q7 and 0 or LF.trk }, L7, 0.14)
                        S7(J7.k, { Position = p(0, q7 and 12 or 2, 0.5, 0), BackgroundColor3 = q7 and YF or SF.knob }, L7, 0.18)
                    end
                end
                if n.cap then
                    n.cap(Z7 and Z7.i, U7, L7)
                end
            end
        end

        L.set = function(n, L7, Z7)
            if n.multi then
                local X7 = n.val
                L7 = if L7 == X7 then (c(L7)) else L7
                k(X7)
                if type(L7) == "table" then
                    for q7 = 1, #L7, 1 do
                        local U7 = L7[q7]
                        if y(n.values, U7) and not (y(X7, U7)) then
                            X7[#X7 + 1] = U7
                        end
                    end
                elseif L7 ~= nil and y(n.values, L7) then
                    X7[1] = L7
                end
                Q(X7, n.srt)
            else
                if L7 ~= nil and not (y(n.values, L7)) then
                    return n
                end
                if n.val == L7 then
                    return n
                end
                n.val = L7
            end
            n:draw()
            n:fire(Z7)
            return n
        end

        L.pick = function(n, L7)
            local Z7 = n.val
            local X7 = y(Z7, L7)
            if X7 then
                if n.o.min1 and #Z7 == 1 then
                    return
                end
                f(Z7, X7)
            else
                Z7[#Z7 + 1] = L7
                Q(Z7, n.srt)
            end
            n:draw()
            n:fire()
        end

        L.setvalues = function(n, L7)
            n.values = L7 or {}
            if n.multi then
                L7 = n.val
                for Z7 = #L7, 1, -1 do
                    if not (y(n.values, L7[Z7])) then
                        f(L7, Z7)
                    end
                end
            elseif n.val ~= nil and not (y(n.values, n.val)) then
                n.val = n.values[1]
            end
            if n.lp and n.lp.isopen then
                iF(n.lp)
            end
            n:draw()
            n:fire()
            return n
        end

        L.ser = function(n)
            if n.multi then
                return c(n.val)
            end
            return n.val
        end
        L.load = function(n, c)
            if n.multi then
                if type(c) == "table" then
                    n:set(c)
                end
            elseif c ~= nil then
                n:set(c)
            end
        end

        L.openlist = function(n)
            local L, c, L7, Z7 = n.btn, n.fly, n.c and n.c.pop, n:rw()
            local X7, q7 = IF(), n.values
            local U7, z7, J7, y7, f7, k7 = #q7, n.multi, 28, 2, 8, 5
            local g7 = w(1, P(U7, f7))
            local Q7, c7 = g7 * J7 + (g7 - 1) * y7 + 10, a7({ w = 140, raw = true, rad = 8, anchor = Z7 or L, par = L7 })
            local H7 = w(U7, 1) * J7 + w(U7 - 1, 0) * y7 + 10
            local _7 = UF("ScrollingFrame", { Size = p(1, 0, 0, Q7), CanvasSize = p(0, 0, 0, H7), AutomaticCanvasSize = e, ZIndex = 2, Parent = c7.body })
            local s7 = UF("Frame", { Position = A(k7, k7), Size = p(1, -10, 0, J7), BackgroundColor3 = YF, BackgroundTransparency = 1, ZIndex = 2, Parent = _7 })
            zF(s7, 6)
            local F7 = yF(s7, 1)
            H7 = UF("Frame", { Position = A(k7, k7), Size = p(1, -10, 0, 0), AutomaticSize = u, ZIndex = 3, Parent = _7 })
            gF(H7, y7)
            if U7 == 0 then
                UF("TextLabel", { Size = p(1, 0, 0, J7), Text = "Nothing here", TextSize = 13, TextXAlignment = F.Center, ZIndex = 3, Parent = H7 }, { TextColor3 = "dim" })
            end
            local v7
            local u7 = 0
            local function V7(e7, l7)
                local C7 = e7 ~= nil
                if C7 then
                    local W7 = A(k7, k7 + (e7 - 1) * (J7 + y7))
                    if l7 or v7 == nil then
                        s7.Position = W7
                    elseif v7 ~= e7 then
                        C(s7, { Position = W7 }, 0.22)
                    end
                end
                v7 = e7
                S7(s7, { BackgroundTransparency = C7 and 0.955 or 1 }, l7, 0.14)
                S7(F7, { Transparency = C7 and 0.93 or 1 }, l7, 0.14)
            end
            local function S7(y7, k7, s7)
                u7 += 1
                if y7 or s7 then
                    V7(y7 or k7, s7)
                    return
                end
                local y7 = u7
                _(0.08, function()
                    if u7 == y7 and n.cap == S7 then
                        V7(k7)
                    end
                end)
            end
            n.cap = S7
            local y7, k7, s7 = table.create(U7), z7 and 40 or 10
            local F7 = 0
            for v7 = 1, U7, 1 do
                local u7 = q7[v7]
                local V7 = n:has(u7)
                s7 = s7 or (V7 and v7 or nil)
                local e7 = UF("TextButton", { Size = p(1, 0, 0, J7), LayoutOrder = v7, ZIndex = 3, Parent = H7 })
                local J7 = UF("TextLabel", { Position = A(10, 0), Size = p(1, -(10 + k7), 1, 0), Text = tostring(u7), TextSize = 13, TextColor3 = V7 and SF.txt or SF.sub, TextTruncate = W, ZIndex = 3, Parent = e7 })
                local l7, C7
                if z7 then
                    l7 = UF("Frame", { AnchorPoint = B(1, 0.5), Position = p(1, -9, 0.5, 0), Size = A(22, 12), BackgroundColor3 = V7 and SF.acc or YF, BackgroundTransparency = V7 and 0 or LF.trk, ZIndex = 3, Parent = e7 })
                    JF(l7)
                    C7 = UF("Frame", { AnchorPoint = B(0, 0.5), Position = p(0, V7 and 12 or 2, 0.5, 0), Size = A(8, 8), BackgroundColor3 = V7 and YF or SF.knob, BackgroundTransparency = 0, ZIndex = 3, Parent = l7 })
                    JF(C7)
                end
                F7 = w(F7, J7.TextBounds.X)
                local V7 = { b = e7, t = J7, m = l7, k = C7, v = u7, i = v7 }
                b7(e7, c7, function()
                    n.hv = V7
                    n:draw()
                end, function()
                    if n.hv == V7 then
                        n.hv = nil
                        n:draw()
                    end
                end)
                MF(e7.MouseButton1Click, function()
                    if n.multi then
                        n:pick(u7)
                    else
                        iF(c7)
                        n:set(u7)
                    end
                end)
                y7[v7] = V7
            end
            H7 = c and 0 or L.AbsoluteSize.X / X7
            c7.w = d(E(w(F7 + 10 + k7 + 10 + 4, n.o.lw or 0, 132), H7, w(H7, 280)) + 0.5)
            n.items = y7
            n.lp = c7
            d7(Z7, true)
            c7.onclose = function()
                n.items = nil
                n.hv = nil
                n.lp = nil
                n.cap = nil
                d7(Z7, false)
                n:draw()
            end
            if s7 and U7 > f7 then
                _7.CanvasPosition = B(0, w(0, (s7 - 1) * 30 - d((g7 - 1) / 2) * 30))
            end
            k7, f7, y7, q7, H7, U7 = HF.probe.AbsolutePosition, HF.gui.AbsoluteSize, c7.w * X7, Q7 * X7
            if c and L7 then
                _7, Q7, g7 = L7.frame.AbsolutePosition, L7.frame.AbsoluteSize, Z7 or L
                H7 = _7.X + Q7.X + 6 * X7
                H7, U7 = if H7 + y7 > k7.X + f7.X - 6 then _7.X - 6 * X7 - y7 else H7, g7.AbsolutePosition.Y + (g7.AbsoluteSize.Y - q7) / 2
            else
                local c, L7 = L.AbsolutePosition, L.AbsoluteSize
                H7, U7 = n.o.par and c.X or c.X + L7.X - y7, c.Y + L7.Y + 4 * X7
                if U7 + q7 > k7.Y + f7.Y - 6 and c.Y - 4 * X7 - q7 >= k7.Y + 6 then
                    U7 = c.Y - 4 * X7 - q7
                end
            end
            S7(nil, (if z7 then not z7 else s7) or nil, true)
            B7(c7, H7, U7)
            n:draw()
        end

        local n = setmetatable({}, j)
        n.__index = n
        local function L(c, S7, L7)
            if not (nF.checker) then
                return nil
            end
            local Z7 = UF("ImageLabel", { Size = M(1, 1), Image = nF.checker, ScaleType = Enum.ScaleType.Tile, TileSize = A(S7 or 8, S7 or 8), ResampleMode = Enum.ResamplerMode.Pixelated, Parent = c })
            if L7 == true then
                JF(Z7)
            elseif L7 then
                zF(Z7, L7)
            end
            return Z7
        end
        local function c(S7, L7, Z7, X7)
            local q7 = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0, 0.5), Size = A(L7, Z7), BackgroundTransparency = 0, ZIndex = 5, Parent = S7 })
            zF(q7, X7)
            UF("UIStroke", { Color = YF, Thickness = 2, Parent = q7 })
            S7 = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(L7 + 5, Z7 + 5), ZIndex = 4, Parent = q7 })
            zF(S7, X7 + 2)
            UF("UIStroke", { Color = OF, Transparency = 0.72, Thickness = 1, Parent = S7 })
            return q7
        end
        local S7 = { "RGB", "HEX", "HSV" }
        P7.colorpicker = function(L7, Z7, X7)
            Z7 = Z7 or {}
            local q7 = E7(n, L7, Z7, "cpk")
            local U7 = Z7.default or Z7.color or YF
            q7.val = U7
            q7.a = Z7.alpha or 1
            q7.h, q7.s, q7.v = U7:ToHSV()
            U7 = nil
            if X7 then
                n7(X7, q7)
                q7.lo = X7:nexta()
                U7 = X7.accf
            else
                q7.lo = 1000000
                local n7, n7 = r7(q7, L7)
                U7 = q7.accf
                MF(n7.MouseButton1Click, function()
                    q7:flip()
                end)
            end
            X7 = UF("TextButton", { Size = A(16, 16), LayoutOrder = q7.lo, Parent = U7 })
            zF(X7, 5)
            L(X7, 4, 5)
            q7.swc = UF("Frame", { Size = M(1, 1), BackgroundTransparency = 0, ZIndex = 2, Parent = X7 })
            zF(q7.swc, 5)
            yF(X7, 0.86)
            q7.sw = X7
            q7.ctl = X7
            MF(X7.MouseButton1Click, function()
                q7:flip()
            end)
            q7:draw()
            w7(q7)
            return q7
        end

        n.flip = function(n7)
            if n7.dis then
                return
            end
            if n7.pp and n7.pp.isopen then
                iF(n7.pp)
            else
                n7:openpick()
            end
        end
        n.ser = function(n7)
            return dF(n7.val, n7.a)
        end
        n.unser = function(n7, n7)
            return wF(n7) or n7
        end
        n.load = function(n7, L7)
            local Z7, X7 = wF(L7)
            if Z7 then
                n7:set(Z7, X7)
            end
        end
        n.set = function(n7, L7, Z7, X7)
            if typeof(L7) ~= "Color3" then
                return n7
            end
            Z7 = Z7 or n7.a
            if L7 == n7.val and Z7 == n7.a then
                return n7
            end
            n7.val = L7
            n7.a = Z7
            local Z7, q7, U7 = L7:ToHSV()
            if q7 > 0 and U7 > 0 then
                n7.h = Z7
            end
            n7.s = q7
            n7.v = U7
            n7:draw()
            n7:fire(X7)
            return n7
        end
        n.sethsv = function(n7, L7, Z7, X7, q7)
            n7.h = L7
            n7.s = Z7
            n7.v = X7
            if q7 then
                n7.a = q7
            end
            n7.val = K(L7, Z7, X7)
            n7:draw()
            n7:fire()
        end
        n.draw = function(n7)
            n7.swc.BackgroundColor3 = n7.val
            n7.swc.BackgroundTransparency = n7.dis and P(1, 1.55 - n7.a) or 1 - n7.a
            if n7.lbl then
                n7.lbl.TextColor3 = n7.dis and SF.faint or SF.txt
            end
            local L7 = n7.pu
            if L7 then
                L7()
            end
        end

        n.openpick = function(n)
            local n7, L7, Z7, X7 = n, 196, 6, 184
            local q7 = a7({ w = L7, raw = true, rad = 8, anchor = n.row or n.sw, par = n.c and n.c.pop })
            n7.pp = q7
            local U7 = UF("Frame", { Size = A(L7, 170), ZIndex = 2, Parent = q7.body })
            local z7 = UF("TextButton", { Position = A(Z7, Z7), Size = A(X7, 100), BackgroundTransparency = 0, Parent = U7 })
            zF(z7, 5)
            L7 = UF("Frame", { Size = M(1, 1), BackgroundColor3 = YF, BackgroundTransparency = 0, Parent = z7 })
            zF(L7, 5)
            UF("UIGradient", { Transparency = R(0, 1), Parent = L7 })
            L7 = UF("Frame", { Size = M(1, 1), BackgroundColor3 = OF, BackgroundTransparency = 0, Parent = z7 })
            zF(L7, 5)
            UF("UIGradient", { Rotation = 90, Transparency = R(1, 0), Parent = L7 })
            L7 = UF("Frame", { Size = M(1, 1), ZIndex = 3, Parent = z7 })
            zF(L7, 5)
            yF(L7, 0.92)
            local J7 = UF("Frame", { AnchorPoint = B(0.5, 0.5), Size = A(9, 9), ZIndex = 5, Parent = z7 })
            JF(J7)
            UF("UIStroke", { Color = YF, Thickness = 2, Parent = J7 })
            L7 = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(14, 14), ZIndex = 4, Parent = J7 })
            JF(L7)
            UF("UIStroke", { Color = OF, Transparency = 0.72, Thickness = 1, Parent = L7 })
            local function y7(f7)
                local k7 = UF("TextButton", { Position = A(Z7, f7 - 8), Size = A(X7, 16), Parent = U7 })
                f7 = UF("Frame", { AnchorPoint = B(0, 0.5), Position = M(0, 0.5), Size = p(1, 0, 0, 8), BackgroundColor3 = YF, BackgroundTransparency = 1, Parent = k7 })
                zF(f7, 3)
                return k7, f7, c(f7, 6, 12, 2)
            end
            local c, f7, k7 = y7(117)
            f7.BackgroundTransparency = 0
            L7 = table.create(7)
            for g7 = 0, 6, 1 do
                L7[g7 + 1] = I(g7 / 6, K(g7 / 6 % 1, 1, 1))
            end
            UF("UIGradient", { Color = N(L7), Parent = f7 })
            local N, I, g7 = y7(133)
            L(I, 4, 3)
            local L = UF("Frame", { Size = M(1, 1), BackgroundTransparency = 0, ZIndex = 2, Parent = I })
            zF(L, 3)
            UF("UIGradient", { Transparency = R(1, 0), Parent = L })
            local R = UF("Frame", { Position = A(Z7, 144), Size = A(X7, 20), Parent = U7 })
            QF(R, 4)
            y7 = UF("TextButton", { Size = A(36, 20), LayoutOrder = 1, Parent = R })
            local Z7 = UF("ImageLabel", { AnchorPoint = B(0, 0.5), Position = p(0, 1, 0.5, 0), Size = A(9, 9), Image = qF("chevron"), Parent = y7 }, { ImageColor3 = "dim" })
            local X7 = UF("TextLabel", { Position = A(13, 0), Size = p(1, -13, 1, 0), TextSize = 11, Parent = y7 }, { TextColor3 = "sub" })
            b7(y7, q7, function()
                C(X7, { TextColor3 = SF.txt }, 0.12, GF)
                C(Z7, { ImageColor3 = SF.sub }, 0.12, GF)
            end, function()
                C(X7, { TextColor3 = SF.sub }, 0.12, GF)
                C(Z7, { ImageColor3 = SF.dim }, 0.12, GF)
            end)
            local function Z7(U7, Q7)
                local c7 = UF("TextBox", { Size = A(Q7 or 27, 20), BackgroundColor3 = YF, BackgroundTransparency = LF.ctl, TextSize = 11, TextXAlignment = F.Center, ClipsDescendants = true, LayoutOrder = U7, Parent = R })
                zF(c7, 4)
                local U7 = yF(c7, LF.ctle)
                MF(c7.Focused, function()
                    C(U7, { Color = SF.acc, Transparency = 0.5 }, 0.14, GF)
                end)
                MF(c7.FocusLost, function()
                    C(U7, { Color = YF, Transparency = LF.ctle }, 0.14, GF)
                end)
                return c7
            end
            local U7 = {}
            m:rH(U7, 0, Z7(2), Z7(3), (Z7(4)))
            local Q7 = Z7(5, 89)
            local c7 = Z7(6)
            local H7 = UF("ImageButton", { Size = A(20, 20), BackgroundColor3 = YF, BackgroundTransparency = LF.ctl, LayoutOrder = 7, Parent = R })
            zF(H7, 4)
            yF(H7, LF.ctle)
            local R = UF("ImageLabel", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(11, 11), Image = qF("copy"), Parent = H7 }, { ImageColor3 = "dim" })
            b7(H7, q7, function()
                C(H7, { BackgroundTransparency = LF.ctlh }, 0.12, GF)
                C(R, { ImageColor3 = SF.txt }, 0.12, GF)
            end, function()
                C(H7, { BackgroundTransparency = LF.ctl }, 0.12, GF)
                C(R, { ImageColor3 = SF.dim }, 0.12, GF)
            end)
            local function R()
                local _7 = n7.cm or "RGB"
                X7.Text = _7
                local X7 = _7 == "HEX"
                for s7 = 1, 3, 1 do
                    U7[s7].Visible = not X7
                end
                Q7.Visible = X7
                return _7
            end
            n7.pu = function()
                local X7, _7 = K(n7.h, 1, 1), n7.val
                z7.BackgroundColor3 = X7
                J7.Position = M(n7.s, 1 - n7.v)
                k7.Position = M(n7.h, 0.5)
                k7.BackgroundColor3 = X7
                L.BackgroundColor3 = _7
                g7.Position = M(n7.a, 0.5)
                g7.BackgroundColor3 = _7
                X7 = if (n7.cm or "RGB") == "HSV" then { d(n7.h * 360 + 0.5), d(n7.s * 100 + 0.5), d(n7.v * 100 + 0.5) } else { d(_7.R * 255 + 0.5), d(_7.G * 255 + 0.5), d(_7.B * 255 + 0.5) }
                for K = 1, 3, 1 do
                    if not (U7[K]:IsFocused()) then
                        U7[K].Text = tostring(X7[K])
                    end
                end
                if not (Q7:IsFocused()) then
                    Q7.Text = dF(_7)
                end
                if not (c7:IsFocused()) then
                    c7.Text = tostring(d(n7.a * 255 + 0.5))
                end
            end
            R()
            MF(y7.MouseButton1Click, function()
                n7.cm = S7[(y(S7, n7.cm or "RGB") or 0) % #S7 + 1]
                R()
                n7.pu()
            end)
            for K = 1, 3, 1 do
                local R = U7[K]
                MF(R.FocusLost, function()
                    local L = tonumber((U(R.Text, "[^%d%.]", "")))
                    if L then
                        if (n7.cm or "RGB") == "HSV" then
                            local R, S7, X7 = n7.h, n7.s, n7.v
                            if K == 1 then
                                R = E(L, 0, 359.9) / 360
                            elseif K == 2 then
                                S7 = E(L, 0, 100) / 100
                            else
                                X7 = E(L, 0, 100) / 100
                            end
                            n7:sethsv(R, S7, X7)
                        else
                            local R = n7.val
                            local S7 = { R.R * 255, R.G * 255, R.B * 255, [K] = E(L, 0, 255) }
                            n7:set(b(S7[1], S7[2], S7[3]))
                        end
                    end
                    if n7.pu then
                        n7.pu()
                    end
                end)
            end
            MF(Q7.FocusLost, function()
                local K = Q7.Text
                local R, L = wF(K)
                if R then
                    n7:set(R, #U(K, "[^%x]", "") == 8 and L or n7.a)
                end
                if n7.pu then
                    n7.pu()
                end
            end)
            MF(c7.FocusLost, function()
                local K = tonumber((U(c7.Text, "[^%d%.]", "")))
                if K then
                    n7:sethsv(n7.h, n7.s, n7.v, E(K, 0, 255) / 255)
                end
                if n7.pu then
                    n7.pu()
                end
            end)
            MF(H7.MouseButton1Click, function()
                local K = dF(n7.val, n7.a)
                if pcall(setclipboard, K) then
                    cF:notify("Copied {" .. K .. "}")
                end
            end)
            local function K(R, L)
                MF(R.InputBegan, function(R)
                    local S7 = R.UserInputType
                    if FF(S7) then
                        L(S7 == bF and sF(R) or _F())
                        m7(L, nil, q7, R)
                    end
                end)
            end
            K(z7, function(R)
                local L, S7 = z7.AbsolutePosition, z7.AbsoluteSize
                n7:sethsv(n7.h, E((R.X - L.X) / S7.X, 0, 1), 1 - E((R.Y - L.Y) / S7.Y, 0, 1))
            end)
            K(c, function(R)
                local L, c = f7.AbsolutePosition, f7.AbsoluteSize
                n7:sethsv(E((R.X - L.X) / c.X, 0, 0.9999), n7.s, n7.v)
            end)
            K(N, function(K)
                local N, R = I.AbsolutePosition, I.AbsoluteSize
                n7:sethsv(n7.h, n7.s, n7.v, E((K.X - N.X) / R.X, 0, 1))
            end)
            local K = n7:rw()
            d7(K, true)
            q7.onclose = function()
                n7.pu = nil
                n7.pp = nil
                d7(K, false)
            end
            n7.pu()
            L7, Z7 = n.sw.AbsolutePosition, n.sw.AbsoluteSize
            B7(q7, L7.X + Z7.X + 10, L7.Y - 8)
        end

        local K = setmetatable({}, j)
        K.__index = K
        P7.keybind = function(N, I)
            local R = I or {}
            local I = E7(K, N, R, "kbd")
            local n = R.default
            n = if typeof(n) == "EnumItem" then n.Name else n
            n = if n == "None" then nil else n
            I.val = n
            I.lo = 1000000
            local L, L, c = r7(I, N)
            local S7 = UF("TextButton", { Size = A(0, 20), AutomaticSize = v, TextSize = 11, BackgroundColor3 = YF, BackgroundTransparency = LF.ctl, LayoutOrder = I.lo, Parent = c })
            zF(S7, 5)
            kF(S7, 8, 8, 0, 0)
            UF("UISizeConstraint", { MinSize = B(44, 20), Parent = S7 })
            I.ks = yF(S7, LF.ctle)
            I.b = S7
            I.ctl = S7
            K7(S7, N.pop, "BackgroundTransparency", LF.ctl, LF.ctlh)
            local function N()
                if HF.eat ~= I and not (I.dis) then
                    I:listen()
                end
            end
            MF(S7.MouseButton1Click, N)
            MF(L.MouseButton1Click, N)
            MF(S7.MouseButton2Click, function()
                if HF.eat ~= I and not (I.dis) and not (R.nonone) then
                    I:setkey(nil)
                end
            end)
            if n and not (I.tmp) then
                N7(I, n)
            end
            I:draw()
            w7(I)
            return I
        end

        K.listen = function(N)
            local I = HF.listen
            if I and I ~= N then
                I.lst = false
                I:draw()
            end
            HF.listen = N
            N.lst = true
            N:draw()
        end
        K.setkey = function(N, I, R)
            N.lst = false
            if HF.listen == N then
                HF.listen = nil
            end
            if I == nil and N.o.nonone then
                N:draw()
                return N
            end
            if I == N.val then
                N:draw()
                return N
            end
            if N.val and not (N.tmp) then
                I7(N, N.val)
            end
            N.val = I
            if I and not (N.tmp) then
                N7(N, I)
            end
            N:draw()
            N:fire(R)
            return N
        end
        K.set = function(N, I)
            return N:setkey(I)
        end
        K.ser = function(N)
            return N.val or "None"
        end
        K.unser = function(N, N)
            if N == "None" then
                return nil
            end
            return N
        end
        K.load = function(N, I)
            if I == nil or I == "None" then
                N:setkey(nil)
            elseif type(I) == "string" then
                N:setkey(I)
            end
        end
        K.bdown = function(N)
            local I = N.o.onpress
            if I and not (N.dis) then
                H(I, N.val)
            end
        end
        K.bup = function(N)
            local I = N.o.onrelease
            if I and not (N.dis) then
                H(I, N.val)
            end
        end
        K.down = function(N)
            local I = N.val
            if not I then
                return false
            end
            if R7[I] then
                N = Enum.UserInputType[I]
                return t:IsMouseButtonPressed(N)
            end
            local N, R = pcall(function()
                return Enum.KeyCode[I]
            end)
            return N and t:IsKeyDown(R) or false
        end
        K.draw = function(K)
            local N, I = K.b, K.lst == true
            N.Text = I and "..." or (rF(K.val) or "none")
            C(N, { TextColor3 = K.dis and SF.faint or (I and SF.acc or (K.val and SF.txt or SF.dim)) }, 0.12, GF)
            C(K.ks, { Color = I and SF.acc or YF, Transparency = I and 0.5 or LF.ctle }, 0.14, GF)
            if K.lbl then
                K.lbl.TextColor3 = K.dis and SF.faint or SF.txt
            end
            if K.lsh ~= I then
                K.lsh = I
                d7(K.row, I)
            end
        end

        local K = setmetatable({}, j)
        K.__index = K
        P7.input = function(N, I)
            local R = I or {}
            local I = E7(K, N, R, "inp")
            I.val = tostring(R.default or "")
            local n
            if I.name ~= "" then
                I.lo = 1000000
                local L, L, c = r7(I, N)
                n = UF("TextBox", { Size = A(R.w or 140, 22), BackgroundColor3 = YF, BackgroundTransparency = LF.ctl, Text = I.val, TextSize = 13, PlaceholderText = R.placeholder or "", TextTruncate = W, ClipsDescendants = true, LayoutOrder = I.lo, Parent = c }, { PlaceholderColor3 = "dim" })
                zF(n, 5)
                kF(n, 8, 8, 0, 0)
                I.sk = yF(n, LF.ctle)
                MF(L.MouseButton1Click, function()
                    if not (I.dis) then
                        n:CaptureFocus()
                    end
                end)
            else
                local L = N:row(30)
                I.row = L
                local N = UF("TextBox", { Position = A(12, 0), Size = p(1, -24, 1, 0), Text = I.val, TextSize = 13, PlaceholderText = R.placeholder or "", TextTruncate = W, ClipsDescendants = true, ZIndex = 2, Parent = L }, { PlaceholderColor3 = "dim" })
                n = N
            end
            I.b = n
            I.ctl = n
            MF(n.Focused, function()
                I.foc = true
                d7(I.row, true)
                if I.sk then
                    C(I.sk, { Color = SF.acc, Transparency = 0.5 }, 0.14, GF)
                end
            end)
            MF(n.FocusLost, function(N)
                if I.foc then
                    I.foc = false
                    d7(I.row, false)
                end
                if I.sk then
                    C(I.sk, { Color = YF, Transparency = LF.ctle }, 0.14, GF)
                end
                I:set(n.Text)
                if N and R.onenter then
                    H(R.onenter, I.val)
                end
            end)
            if R.live then
                MF(n:GetPropertyChangedSignal("Text"), function()
                    if n:IsFocused() and n.Text ~= I.val then
                        I.val = n.Text
                        I:fire()
                    end
                end)
            end
            I:draw()
            w7(I)
            return I
        end

        K.set = function(N, I, R)
            I = tostring(I or "")
            local n = N.o.max
            I = if n then (Z(I, 1, n)) else I
            if N.b.Text ~= I then
                N.b.Text = I
            end
            if I == N.val then
                return N
            end
            N.val = I
            N:fire(R)
            return N
        end
        K.load = function(N, I)
            if type(I) == "string" then
                N:set(I)
            end
        end
        K.draw = function(N)
            N.b.TextColor3 = N.dis and SF.faint or SF.txt
            N.b.TextEditable = not N.dis
            if N.lbl then
                N.lbl.TextColor3 = N.dis and SF.faint or SF.txt
            end
        end
        K.focus = function(K)
            K.b:CaptureFocus()
            return K
        end

        local K = setmetatable({}, j)
        K.__index = K
        local N = { ghost = { tc = "txt", ic = "sub" }, primary = { tc = "acc", ic = "acc" }, danger = { tc = "bad", ic = "bad" } }
        P7.button = function(I, R)
            R = R or {}
            local n = E7(K, I, R, "btn")
            local L, c = N[R.style or "ghost"] or N.ghost, I:free()
            n.row = c
            local N = LF.card
            local rF = UF("TextButton", { Size = p(1, 0, 0, R.h or (I.pop and 28 or 30)), BackgroundColor3 = YF, BackgroundTransparency = N, Parent = c })
            zF(rF, 7)
            yF(rF, LF.edge)
            c = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(0, 20), AutomaticSize = v, Parent = rF })
            QF(c, 7)
            if R.icon then
                n.ic = UF("ImageLabel", { Size = A(12, 12), Image = qF(R.icon), LayoutOrder = 1, Parent = c }, { ImageColor3 = L.ic })
            end
            n.t = UF("TextLabel", { Size = A(0, 20), AutomaticSize = v, Text = n.name, TextSize = 13, LayoutOrder = 2, Parent = c }, { TextColor3 = L.tc })
            n.b = rF
            n.vr = L
            K7(rF, I.pop, "BackgroundTransparency", N, 0.94)
            MF(rF.MouseButton1Click, function()
                if not (n.dis) and n.cb then
                    H(n.cb)
                end
            end)
            n:draw()
            return n
        end
        K.draw = function(N)
            N.t.TextTransparency = N.dis and 0.55 or 0
            if N.ic then
                N.ic.ImageTransparency = N.dis and 0.55 or 0
            end
        end
        K.press = function(N)
            if N.cb then
                H(N.cb)
            end
        end
        K.settext = function(K, N)
            K.name = tostring(N or "")
            K.t.Text = K.name
            return K
        end

        local K = setmetatable({}, j)
        K.__index = K
        P7.label = function(N, I)
            I = (if type(I) == "string" then { text = I } else I) or {}
            local R, n = E7(K, N, I, "lbl"), N:row(I.h or 30, true)
            n.AutomaticSize = u
            R.row = n
            N = UF("Frame", { Size = p(1, 0, 0, 0), AutomaticSize = u, Parent = n })
            kF(N, 12, 12, 8, 8)
            R.l = UF("TextLabel", { Size = p(1, 0, 0, 14), AutomaticSize = u, TextWrapped = true, RichText = I.rich == true, TextSize = 13, TextXAlignment = I.center and F.Center or F.Left, Text = R.name, Parent = N }, { TextColor3 = I.bright and "sub" or "dim" })
            return R
        end
        K.settext = function(K, N)
            K.name = tostring(N or "")
            K.l.Text = K.name
            return K
        end

        local K = setmetatable({}, j)
        K.__index = K
        local function N(I)
            if type(I) == "table" then
                local R = I.value
                R = if R == nil then I.name else R
                return R, tostring(I.name or R), I.image, I.crop == true
            end
            return I, tostring(I), nil, false
        end
        local function I(R, n)
            local L = UF("TextButton", { Size = A(100, 100), BackgroundColor3 = YF, BackgroundTransparency = LF.card, LayoutOrder = n, Parent = R.gr })
            zF(L, 7)
            local n = {
                b = L,
                sk = yF(L, LF.edge),
                im = UF("ImageLabel", { AnchorPoint = B(0.5, 0), Position = p(0.5, 0, 0, 7), Size = p(1, -14, 1, -34), Parent = L }),
                tl = UF("TextLabel", { AnchorPoint = B(0, 1), Position = p(0, 8, 1, -7), Size = p(1, -16, 0, 16), FontFace = ZF.m, TextSize = 12, TextXAlignment = F.Center, TextTruncate = W, TextColor3 = SF.sub, Parent = L }),
                h = false,
            }
            b7(L, R.c.pop, function()
                n.h = true
                R:paint(n, true)
            end, function()
                n.h = false
                R:paint(n, true)
            end)
            MF(L.MouseButton1Click, function()
                if not (R.dis) and n.v ~= nil then
                    R:set(n.v)
                end
            end)
            return n
        end
        P7.cards = function(R, n)
            n = n or {}
            local L = E7(K, R, n, "crd")
            L.cols = E(d(tonumber(n.cols) or 3), 1, 6)
            L.gap = 6
            L.ratio = tonumber(n.ratio) or 0.75
            L.pool = {}
            L.items = {}
            L.idx = {}
            L.val = n.default
            local c = R:free()
            L.row = c
            R = UF("Frame", { Size = p(1, 0, 0, 0), AutomaticSize = u, Parent = c })
            L.gr = R
            L.grid = UF("UIGridLayout", { CellPadding = A(L.gap, L.gap), CellSize = A(100, 100), FillDirectionMaxCells = L.cols, SortOrder = Enum.SortOrder.LayoutOrder, Parent = R })
            MF(R:GetPropertyChangedSignal("AbsoluteSize"), function()
                L:fit()
            end)
            L:setvalues(n.values, true)
            if L.val == nil and L.items[1] then
                L.val = L.items[1].v
            end
            L:fit()
            L:draw()
            w7(L)
            return L
        end
        K.fit = function(R)
            local n = R.gr.AbsoluteSize.X / IF()
            if n <= 0 then
                return
            end
            local L = R.cols
            local c = d((n - R.gap * (L - 1)) / L)
            L = d((c - 14) * R.ratio + 34 + 0.5)
            if R.cw ~= c or R.ch ~= L then
                R.cw = c
                R.ch = L
                R.grid.CellSize = A(c, L)
            end
        end
        K.paint = function(R, n, L)
            local c, rF = n.v ~= nil and n.v == R.val, R.dis
            local R, S7, R7, n7, w7, L7 = c and SF.acc or YF, c and 0.9 or (n.h and not rF and LF.ctlh or LF.card), c and SF.acc or YF, c and 0.35 or LF.edge, rF and SF.faint or (c and SF.txt or (n.h and SF.txt or SF.sub)), rF and 0.55 or 0
            if L then
                C(n.b, { BackgroundColor3 = R, BackgroundTransparency = S7 }, 0.14, GF)
                C(n.sk, { Color = R7, Transparency = n7 }, 0.14, GF)
                C(n.tl, { TextColor3 = w7 }, 0.14, GF)
                C(n.im, { ImageTransparency = L7 }, 0.14, GF)
            else
                n.b.BackgroundColor3, n.b.BackgroundTransparency = R, S7
                n.sk.Color, n.sk.Transparency = R7, n7
                n.tl.TextColor3 = w7
                n.im.ImageTransparency = L7
            end
        end
        K.draw = function(R)
            local n = R.pool
            for L = 1, #n, 1 do
                local c = n[L]
                if c.v ~= nil then
                    R:paint(c, true)
                end
            end
        end
        K.setvalues = function(R, n, L)
            local c, rF, S7 = {}, {}, R.pool
            if type(n) == "table" then
                for R7 = 1, #n, 1 do
                    local n7, w7, L7, Z7 = N(n[R7])
                    if n7 ~= nil and rF[n7] == nil then
                        R7 = #c + 1
                        c[R7] = { v = n7, t = w7, img = L7, crop = Z7 }
                        rF[n7] = R7
                    end
                end
            end
            R.items = c
            R.idx = rF
            for N = 1, #c, 1 do
                n = S7[N]
                if not n then
                    n = I(R, N)
                    S7[N] = n
                end
                local I = c[N]
                n.v = I.v
                if n.t ~= I.t then
                    n.t = I.t
                    n.tl.Text = I.t
                end
                N = I.img or ""
                if n.img ~= N then
                    n.img = N
                    n.im.Image = N
                end
                N = I.crop and Enum.ScaleType.Crop or Enum.ScaleType.Fit
                if n.im.ScaleType ~= N then
                    n.im.ScaleType = N
                end
                n.b.Visible = true
                R:paint(n, false)
            end
            for N = #c + 1, #S7, 1 do
                local I = S7[N]
                I.v = nil
                I.h = false
                I.b.Visible = false
            end
            if not (L) and R.val ~= nil and rF[R.val] == nil then
                S7 = c[1]
                R.val = S7 and S7.v or nil
                R:draw()
                R:fire()
            end
            return R
        end
        K.set = function(N, I, R)
            if I ~= nil and N.idx[I] == nil then
                return N
            end
            if N.val == I then
                return N
            end
            N.val = I
            N:draw()
            N:fire(R)
            return N
        end
        K.load = function(K, N)
            if N ~= nil then
                K:set(N)
            end
        end

        local K = setmetatable({}, j)
        K.__index = K
        P7.submenu = function(j, N)
            N = (if type(N) == "string" then { name = N } else N) or {}
            local I = E7(K, j, N, "sub")
            I.lo = 1000000
            local R, n, L = r7(I, j)
            I.ch = UF("ImageLabel", { Size = A(12, 12), Image = qF("right"), LayoutOrder = I.lo, Parent = L }, { ImageColor3 = "dim" })
            local L = a7({ w = N.w, keep = true, anchor = R, par = j.pop, tab = j.tab, tmp = j.tmp, title = N.title })
            L.owner = I
            L.c.page, L.c.sec = j.page, j.sec
            I.sp = L
            MF(n.MouseButton1Click, function()
                if I.dis then
                    return
                end
                if L.isopen then
                    iF(L)
                    return
                end
                d7(R, true)
                C(I.ch, { ImageColor3 = SF.txt }, 0.12, GF)
                function L.onclose()
                    d7(R, false)
                    C(I.ch, { ImageColor3 = SF.dim }, 0.12, GF)
                end
                if L.aw then
                    L:fitw()
                end
                local N, n, c, iF, rF = IF(), R.AbsolutePosition, R.AbsoluteSize, HF.probe.AbsolutePosition, HF.gui.AbsoluteSize
                local R, S7, R7 = L.w * N, n.X, n.X + c.X
                if j.pop then
                    c = j.pop.frame
                    S7, R7 = c.AbsolutePosition.X, c.AbsolutePosition.X + c.AbsoluteSize.X
                end
                c = R7 + 8 * N
                B7(L, if c + R > iF.X + rF.X - 6 then S7 - 8 * N - R else c, n.Y - 6 * N)
            end)
            I:draw()
            return L.c, I
        end
        P7.menu = P7.submenu
        K.draw = function(j)
            if j.lbl then
                j.lbl.TextColor3 = j.dis and SF.faint or SF.txt
            end
        end

        local j = {}
        j.__index = j
        local function K(N, I, R, n, L)
            local c = #I
            local iF = setmetatable({ i = R or 1, b = {}, cb = n, n = c }, j)
            R = L ~= nil
            n = UF("Frame", { Size = p(1, 0, 0, 30), BackgroundColor3 = YF, BackgroundTransparency = R and LF.pfil or LF.card, Parent = N })
            zF(n, R and 8 or 7)
            if not R then
                yF(n, LF.edge)
            end
            kF(n, 3, 3, 3, 3)
            iF.hl = UF("Frame", { Size = p(1 / c, 0, 1, 0), BackgroundColor3 = YF, BackgroundTransparency = R and 0.935 or LF.tab, Parent = n })
            zF(iF.hl, R and 6 or 5)
            R = UF("Frame", { Size = M(1, 1), ZIndex = 2, Parent = n })
            QF(R, 0)
            iF.f = n
            for N = 1, c, 1 do
                local n = UF("TextButton", { Size = p(1 / c, 0, 1, 0), Text = I[N], TextSize = 13, LayoutOrder = N, ZIndex = 2, Parent = R }, { TextColor3 = "dim" })
                iF.b[N] = n
                MF(n.MouseButton1Click, function()
                    iF:set(N, true)
                end)
                b7(n, L, function()
                    if iF.i ~= N then
                        C(n, { TextColor3 = SF.sub }, 0.1, GF)
                    end
                end, function()
                    if iF.i ~= N then
                        C(n, { TextColor3 = SF.dim }, 0.1, GF)
                    end
                end)
            end
            iF:paint(false)
            iF:place(false)
            return iF
        end
        j.place = function(N, I)
            local R = M((N.i - 1) / N.n, 0)
            if I then
                C(N.hl, { Position = R }, 0.22)
            else
                N.hl.Position = R
            end
        end
        j.paint = function(N, I)
            for R = 1, #N.b, 1 do
                local n, L = R == N.i, N.b[R]
                L.FontFace = n and ZF.b or ZF.s
                R = n and SF.txt or SF.dim
                if I then
                    C(L, { TextColor3 = R }, 0.14, GF)
                else
                    L.TextColor3 = R
                end
            end
        end
        j.set = function(j, N, I)
            if N == j.i or not (j.b[N]) then
                return
            end
            j.i = N
            j:paint(true)
            j:place(true)
            if j.cb then
                j.cb(N, I)
            end
        end

        P7.subtabs = function(j, N, I)
            local R = I or {}
            local I, n = j:free(), table.create(#N)
            local L = K(I, N, R.default or 1, function(K, c)
                t7(j.pop)
                for iF = 1, #n, 1 do
                    if iF ~= K then
                        n[iF].frame.Visible = false
                    end
                end
                i7(n[K].frame, true, 0.2)
                if c and R.cb then
                    H(R.cb, K, N[K])
                end
            end, j.pop)
            for K = 1, #N, 1 do
                j.n = j.n + 1
                I = UF("Frame", { Size = p(1, 0, 0, 0), AutomaticSize = u, LayoutOrder = j.n, Visible = K == L.i, Parent = j.frame })
                gF(I, 6)
                local N = VF(I, j.tab, j.pop)
                N.tmp, N.page, N.sec = j.tmp, j.page, j.sec
                N.sub = { s = L, i = K, up = j.sub }
                n[K] = N
            end
            j.cb = nil
            return n
        end

        uF = function(j)
            if j.tmp or j.dead or HF.dead or HF.eat then
                return
            end
            local K = j.ind
            local N = j.bnd
            local I = j.pd
            if not K and not N then
                return
            end
            local R = a7({ tmp = true, par = j.c and j.c.pop, title = j.name })
            local n, L, c, iF, rF, uF, S7, t7, a7, R7, n7, E7, w7, P7 = R.c, HF.ph and I ~= nil
            if L then
                S7 = n:toggle({
                    name = "Button",
                    icon = "tap",
                    default = I.on,
                    cb = function(r7)
                        if r7 and rF and N.v == j.val then
                            j:setbv(j.val >= j.max and j.min or j.max)
                            rF:set(N.v, true)
                        end
                        j:padset("on", r7)
                    end,
                })
                t7 = n:slider({ name = "Size", icon = "scale", min = 70, max = 150, step = 5, suffix = "%", sw = 56, default = I.sz, cb = function(r7)
                    j:padset("sz", r7)
                end }):dep(S7)
                a7 = n:slider({ name = "Rounding", icon = "round", min = 0, max = 100, step = 5, suffix = "%", sw = 56, default = I.rd, cb = function(r7)
                    j:padset("rd", r7)
                end }):dep(S7)
                R7 = n:input({ name = "Name", icon = "text", placeholder = j.name, default = I.nm, max = 24, live = true, w = 104, cb = function(I)
                    j:padset("nm", I)
                end }):dep(S7)
                n:brk()
                n7, E7, w7, P7 = S7, t7, a7, R7
            end
            local I
            if N then
                if not L then
                    uF = n:keybind({
                        name = "Key",
                        icon = "keyboard",
                        default = N.key,
                        cb = function(S7)
                            if S7 and not (N.key) then
                                if rF and N.v == j.val then
                                    j:setbv(j.val >= j.max and j.min or j.max)
                                    rF:set(N.v, true)
                                end
                                if K and not (K.on) then
                                    K.on = true
                                    if c then
                                        c:set(true, true)
                                    end
                                end
                            end
                            j:setbind(S7)
                        end,
                    })
                end
                n:dropdown({
                    name = "Mode",
                    icon = "refresh",
                    values = { "Hold", "Toggle" },
                    default = N.mode == "hold" and "Hold" or "Toggle",
                    w = 96,
                    cb = function(S7)
                        j:setbind(N.key, S7 == "Hold" and "hold" or "toggle")
                    end,
                })
                if j.kind == "sld" or j.kind == "gsld" then
                    rF = n:slider({
                        name = "Value",
                        icon = "sliders",
                        min = j.min,
                        max = j.max,
                        dec = j.dec,
                        step = j.step,
                        suffix = j.suf,
                        zero = j.zero,
                        fmt = j.o.fmt,
                        sw = 56,
                        default = N.v,
                        cb = function(rF)
                            j:setbv(rF)
                        end,
                    })
                end
                I = uF
            end
            local rF
            if K then
                n:brk()
                c = n:toggle({ name = "Show in list", icon = "eye", default = K.on, cb = function(uF)
                    K.on = uF
                    vF()
                end })
                iF = n:input({ name = "List name", icon = "pencil", placeholder = j.name, default = K.name, w = 104, cb = function(uF)
                    K.name = uF
                    vF()
                end })
                rF = iF
            end
            R:hbtn("trash", "bad", function()
                if N then
                    j:setbind(nil)
                    if I then
                        I:setkey(nil, true)
                    end
                end
                if K then
                    K.on = false
                    K.name = ""
                    if c then
                        c:set(false, true)
                    end
                    if rF then
                        rF:set("", true)
                    end
                end
                if L then
                    j:padset("on", false):padset("sz", 100):padset("rd", 100):padset("nm", "")
                    n7:set(false, true)
                    E7:set(100, true)
                    w7:set(100, true)
                    P7:set("", true)
                end
                vF()
            end)
            local K = j:rw()
            d7(K, true)
            R.onclose = function()
                d7(K, false)
            end
            n = _F()
            B7(R, n.X + 4, n.Y + 4)
        end
    end

    local j
    local K, N, I, R, n, L, c, iF, rF, uF, S7 = { "User", "FPS", "Ping", "CPU", "RAM", "Time" }
    do
        local t7 = Font.new("rbxasset://fonts/families/SourceSansPro.json")
        local a7, B7 = b(12, 20, 25), 0.686274528503418
        local R7 = b(210, 220, 230)
        local n7 = b(20, 20, 20)
        local function b(E7)
            return (U(U(U(U(E7, "<[^>]->", ""), "&lt;", "<"), "&gt;", ">"), "&amp;", "&"))
        end
        local function E7(d7, w7)
            local P7 = UF("TextLabel", { Position = A(1, 1), Size = M(1, 1), Text = d7.RichText and b(d7.Text) or d7.Text, FontFace = d7.FontFace, TextSize = d7.TextSize, TextXAlignment = d7.TextXAlignment, TextColor3 = OF, TextTransparency = w7 or 0.2, ZIndex = d7.ZIndex, Parent = d7 })
            local w7 = UF("TextLabel", { Size = M(1, 1), Text = d7.Text, RichText = d7.RichText, FontFace = d7.FontFace, TextSize = d7.TextSize, TextXAlignment = d7.TextXAlignment, TextColor3 = d7.TextColor3, ZIndex = d7.ZIndex + 1, Parent = d7 })
            d7.TextTransparency = 1
            MF(d7:GetPropertyChangedSignal("Text"), function()
                w7.Text = d7.Text
                P7.Text = d7.RichText and b(d7.Text) or d7.Text
            end)
            MF(d7:GetPropertyChangedSignal("TextColor3"), function()
                w7.TextColor3 = d7.TextColor3
            end)
            return d7, w7, P7
        end
        local function b(d7, w7)
            d7.FontFace = t7
            d7.TextSize = 16
            if d7.AutomaticSize == nil then
                d7.AutomaticSize = V
            end
            if d7.TextColor3 == nil and not (w7) then
                d7.TextColor3 = YF
            end
            return E7(UF("TextLabel", d7, w7), 0.15)
        end
        local function t7(E7, d7)
            local w7 = UF("Frame", { Size = A(25, 14), LayoutOrder = d7, Parent = E7 })
            UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(1, 14), BackgroundColor3 = YF, BackgroundTransparency = 0.392, Parent = w7 })
            return w7
        end
        local function E7(d7, w7, P7, r7, L7, Z7)
            return UF("ImageLabel", { Size = A(L7, L7), Image = qF(w7), ImageTransparency = Z7, LayoutOrder = P7, Parent = d7 }, r7 and { ImageColor3 = r7 } or nil)
        end
        local function d7(w7, P7, r7)
            return UF("Frame", { Size = A(P7, 1), LayoutOrder = r7, Parent = w7 })
        end
        local function w7(P7, r7, L7)
            local Z7 = UF("ImageLabel", { Size = A(18, 18), Image = "rbxthumb://type=AvatarHeadShot&id=" .. r7 .. "&w=48&h=48", ScaleType = Enum.ScaleType.Crop, BackgroundColor3 = n7, BackgroundTransparency = 0, LayoutOrder = L7, Parent = P7 })
            JF(Z7)
            return Z7
        end
        local function n7(P7, r7, L7)
            local Z7, X7 = pcall(Instance.new, "UIShadow")
            if Z7 and X7 then
                X7.BlurRadius = a(0, 8)
                X7.Spread = A(2, 2)
                X7.Transparency = 0.5
                X7.Parent = r7
                return
            end
            Z7 = L7 and nF.pshadow or nF.bshadow
            if Z7 then
                UF("ImageLabel", { Image = Z7, ScaleType = Enum.ScaleType.Slice, SliceCenter = L7 and Rect.new(31, 0, 32, 61) or Rect.new(24, 24, 28, 28), Position = A(-14, -14), Size = L7 and p(1, 28, 0, 62) or p(1, 28, 1, 28), ZIndex = 0, Parent = P7 })
            end
        end
        local function nF(P7, r7, L7, Z7)
            local X7 = UF("Frame", { Size = A(0, 34), LayoutOrder = L7 or 0, Parent = P7 })
            L7 = UF("Frame", { Size = M(1, 1), BackgroundColor3 = a7, BackgroundTransparency = B7, ZIndex = 1, Parent = X7 })
            if r7 then
                JF(L7)
            else
                zF(L7, 17)
            end
            n7(X7, L7, r7)
            local P7 = UF("Frame", { AnchorPoint = B(0, r7 and 0.5 or 0), Position = M(0, r7 and 0.5 or 0), Size = Z7 and p(1, 0, 0, 0) or A(0, 0), AutomaticSize = Z7 and u or V, ZIndex = 2, Parent = X7 })
            kF(P7, 12, 12, 8, 8)
            local function L7()
                local q7 = P7.AbsoluteSize
                x7(X7, Z7 and p(1, 0, 0, q7.Y) or A(q7.X, r7 and w(q7.Y, 34) or q7.Y))
            end
            MF(P7:GetPropertyChangedSignal("AbsoluteSize"), L7)
            L7()
            return X7, P7, L7
        end
        local function P7(r7, L7, Z7)
            local X7 = UF("Frame", { Size = p(1, 0, 0, 20), LayoutOrder = 0, Parent = r7 })
            QF(X7, 0)
            E7(X7, L7, 1, "acc", 18, 0.392)
            d7(X7, 8, 2)
            b({ Text = Z7, LayoutOrder = 3, Parent = X7 })
            X7 = UF("Frame", { Size = p(1, 0, 0, 10), LayoutOrder = 1, Parent = r7 })
            UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = p(1, 0, 0, 1), BackgroundColor3 = YF, BackgroundTransparency = 0.75, Parent = X7 })
            L7 = UF("Frame", { Size = p(1, 0, 0, 0), AutomaticSize = u, LayoutOrder = 2, Parent = r7 })
            gF(L7, 4)
            return L7
        end
        N = { on = true, rows = {}, q = false }
        local function r7(L7)
            local Z7 = L7.kind
            if Z7 == "tgl" or Z7 == "gtgl" then
                local X7 = L7:eff()
                return X7 and "ON" or "OFF", X7 and SF.acc or R7
            elseif Z7 == "sld" or Z7 == "gsld" then
                return L7:fmtv(L7:eff()), L7.bnd.act and SF.acc or R7
            elseif Z7 == "drp" then
                return L7:text(), R7
            end
            return "", R7
        end
        local function L7()
            local Z7 = N.f
            if not (Z7 and not HF.dead) then
                return
            end
            local X7, q7, U7, z7, J7 = N.rows, {}, cF.els, 0, 0
            for y7 = 1, #U7, 1 do
                local f7 = U7[y7]
                y7 = f7.ind
                if y7 and not f7.dead and not f7.dis and (y7.on or f7.bnd and f7.bnd.key) then
                    z7 += 1
                    q7[f7] = true
                    local U7 = X7[f7]
                    if not U7 then
                        local k7 = UF("Frame", { Size = p(1, 0, 0, 20), Parent = Z7 })
                        local Z7, g7, Q7 = b({ Size = A(0, 20), AutomaticSize = v, TextColor3 = R7, Parent = k7 })
                        local c7, H7, _7 = b({ AnchorPoint = B(1, 0), Position = M(1, 0), Size = A(0, 20), AutomaticSize = v, TextXAlignment = F.Right, TextColor3 = R7, Parent = k7 })
                        U7 = { f = k7, n = Z7, v = c7 }
                        X7[f7] = U7
                        g7.TextTransparency = 1
                        Q7.TextTransparency = 1
                        H7.TextTransparency = 1
                        _7.TextTransparency = 1
                        C(g7, { TextTransparency = 0 }, 0.22, GF)
                        C(H7, { TextTransparency = 0 }, 0.22, GF)
                        C(Q7, { TextTransparency = 0.15 }, 0.22, GF)
                        C(_7, { TextTransparency = 0.15 }, 0.22, GF)
                        MF(U7.n:GetPropertyChangedSignal("AbsoluteSize"), vF)
                        MF(U7.v:GetPropertyChangedSignal("AbsoluteSize"), vF)
                    end
                    U7.f.LayoutOrder = 10 + z7
                    U7.n.Text = y7.name ~= "" and y7.name or f7.name
                    local Z7, y7 = r7(f7)
                    U7.v.Text = Z7
                    C(U7.v, { TextColor3 = y7 }, 0.14, GF)
                    J7 = w(J7, U7.n.AbsoluteSize.X + w(U7.v.AbsoluteSize.X, 26) + 2)
                end
            end
            for r7, Z7 in next, X7, nil do
                if not (q7[r7]) then
                    X7[r7] = nil
                    Z7.f:Destroy()
                end
            end
            X7 = N.g
            x7(X7, A(24 + w(132, d(J7 + 0.5)), 0))
            A7(X7, N.on and (HF.open or z7 > 0))
        end
        vF = function()
            if N.q or not (N.f and not HF.dead) then
                return
            end
            N.q = true
            s(function()
                N.q = false
                L7()
            end)
        end
        local function r7(L7, Z7)
            local X7 = UF("Frame", { Position = Z7, Size = A(156, 0), AutomaticSize = u, Visible = false, Parent = L7 })
            Z7, L7 = nF(X7, false, 0, true)
            gF(L7, 0)
            N.g, N.f = X7, P7(L7, "code", "Keybinds")
            N.hh = UF("TextButton", { Size = M(1, 1), ZIndex = 5, Visible = false, Parent = X7 })
            return X7
        end
        local function L7(Z7)
            local X7, q7 = Z7.pv, Z7.pd
            X7.us.Scale = q7.sz / 100
            X7.cr.CornerRadius = a(0, d(17 * q7.rd / 100 + 0.5))
            X7.nl.Text = q7.nm ~= "" and q7.nm or Z7.name
            X7.fit()
        end
        CF = function(a, Z7)
            local X7 = a.pv
            if not (X7) then
                return
            end
            local q7 = a.bnd
            local U7 = if a.kind == "tgl" or a.kind == "gtgl" then a:eff() == true else q7 ~= nil and q7.act == true
            local q7, z7 = a.dis and SF.faint or (U7 and SF.acc or YF), U7 and 0 or 0.392
            if Z7 then
                X7.nl.TextColor3 = q7
                X7.ic.ImageColor3, X7.ic.ImageTransparency = q7, z7
            else
                C(X7.nl, { TextColor3 = q7 }, 0.14, GF)
                C(X7.ic, { ImageColor3 = q7, ImageTransparency = z7 }, 0.14, GF)
            end
        end
        local function a(Z7)
            local X7 = Z7.pd
            local q7 = X7.pos
            if not q7 then
                local U7, z7 = cF.els, 0.3
                for J7 = 0, 5, 1 do
                    z7 = 0.3 + J7 * 0.07
                    J7 = false
                    for y7 = 1, #U7, 1 do
                        local f7 = U7[y7]
                        y7 = f7 ~= Z7 and f7.pv and f7.pd.pos
                        if y7 and r(y7[1] - 0.82) < 0.03 and r(y7[3] - z7) < 0.035 then
                            J7 = true
                            break
                        end
                    end
                    if not J7 then
                        break
                    end
                end
                q7 = { 0.82, 0, z7, 0 }
            end
            local r = HF.gui.AbsoluteSize
            local U7, z7 = (tonumber(q7[1]) or 0.5) + (r.X > 0 and (tonumber(q7[2]) or 0) / r.X or 0), (tonumber(q7[3]) or 0.5) + (r.Y > 0 and (tonumber(q7[4]) or 0) / r.Y or 0)
            U7, z7 = E(U7, 0, 1), E(z7, 0, 1)
            X7.pos = { U7, 0, z7, 0 }
            r = AF.new()
            HF.md:add(r)
            local AF = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(U7, z7), Size = A(0, 34), Visible = false, ZIndex = 25, Parent = HF.gui })
            local q7 = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(0, 34), ZIndex = 1, Parent = AF })
            local U7 = UF("UIScale", { Parent = q7 })
            local z7 = UF("Frame", { Size = M(1, 1), BackgroundColor3 = a7, BackgroundTransparency = B7, ZIndex = 1, Parent = q7 })
            local a7 = zF(z7, 17)
            n7(q7, z7, true)
            local n7 = UF("Frame", { Size = A(0, 34), ZIndex = 2, Parent = q7 })
            kF(n7, 12, 12, 0, 0)
            QF(n7, 0)
            local J7 = E7(n7, Z7.o.icon or ((Z7.kind == "sld" or Z7.kind == "gsld") and "sliders" or "toggle"), 1, nil, 18, 0.392)
            d7(n7, 8, 2)
            local y7 = b({ AutomaticSize = e, Size = A(0, 18), LayoutOrder = 3, Parent = n7 })
            local e = UF("TextButton", { Size = M(1, 1), ZIndex = 5, Parent = AF })
            local f7, k7, g7, Q7
            local c7 = B(0, 34)
            local function H7()
                local _7 = HF.gui.AbsoluteSize
                if f7 or _7.X <= 0 or _7.Y <= 0 then
                    return
                end
                local s7, F7 = X7.pos, c7 * 0.5
                local v7, u7 = E(s7[1] * _7.X, F7.X, w(F7.X, _7.X - F7.X)), E(s7[3] * _7.Y, F7.Y, w(F7.Y, _7.Y - F7.Y))
                T7(AF, M(v7 / _7.X, u7 / _7.Y))
            end
            local function _7()
                local s7 = U7.Scale
                if s7 <= 0 then
                    return
                end
                local F7 = y7.TextBounds
                local v7 = d(F7.X / s7 + 0.5) + 2
                y7.Size = A(v7, d(F7.Y / s7 + 0.5) + 2)
                F7 = 50 + v7
                n7.Size = A(F7, 34)
                q7.Size = A(F7, 34)
                c7 = B(d(F7 * s7 + 0.5), d(34 * s7 + 0.5))
                x7(AF, A(c7.X, c7.Y))
                H7()
            end
            r:add(y7:GetPropertyChangedSignal("TextBounds"):Connect(_7))
            r:add(HF.gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(H7))
            local n7 = { g = AF, us = U7, cr = a7, ic = J7, nl = y7, md = r, fit = _7 }
            Z7.pv = n7
            local function a7(q7)
                if q7.UserInputType == bF then
                    return sF(q7)
                end
                return _F()
            end
            local function q7()
                return Z7.bnd and Z7.bnd.mode == "hold"
            end
            local function U7(J7)
                f7 = nil
                C(z7, { BackgroundTransparency = B7 }, 0.14, GF)
                if Q7 then
                    local y7 = O7(AF)
                    X7.pos = { y7.X.Scale, 0, y7.Y.Scale, 0 }
                    eF()
                elseif q7() then
                    Z7:bup()
                elseif J7 then
                    Z7:bdown()
                end
            end
            r:add(e.InputBegan:Connect(function(e)
                if f7 or HF.dead or not (FF(e.UserInputType)) then
                    return
                end
                local X7, J7, y7, H7 = O7(AF), HF.gui.AbsoluteSize
                y7, H7, f7 = a7(e), B(X7.X.Scale * J7.X + X7.X.Offset, X7.Y.Scale * J7.Y + X7.Y.Offset), e
                k7, g7, Q7 = y7, H7, false
                C(z7, { BackgroundTransparency = B7 - 0.2 }, 0.08, GF)
                if q7() then
                    Z7:bdown()
                end
            end))
            r:add(t.InputChanged:Connect(function(e)
                if not (f7) then
                    return
                end
                if f7.UserInputType == bF then
                    if e ~= f7 then
                        return
                    end
                elseif e.UserInputType ~= hF then
                    return
                end
                local hF = a7(e)
                local a7, B7 = hF.X - k7.X, hF.Y - k7.Y
                if not (Q7) then
                    if a7 * a7 + B7 * B7 < 64 then
                        return
                    end
                    Q7 = true
                    if q7() then
                        Z7:bup()
                    end
                end
                hF = HF.gui.AbsoluteSize
                if hF.X <= 0 or hF.Y <= 0 then
                    return
                end
                e = c7 * 0.5
                local Z7, X7 = E(g7.X + a7, e.X, w(e.X, hF.X - e.X)), E(g7.Y + B7, e.Y, w(e.Y, hF.Y - e.Y))
                T7(AF, M(Z7 / hF.X, X7 / hF.Y))
            end))
            r:add(t.InputEnded:Connect(function(e)
                if f7 and (e == f7 or f7.UserInputType == mF and e.UserInputType == mF) then
                    U7(true)
                end
            end))
            r:add(t.WindowFocusReleased:Connect(function()
                if f7 then
                    U7(false)
                end
            end))
            return n7
        end
        lF = function(r)
            local e = r.pd
            if not (e and not r.tmp and not HF.dead and HF.gui) then
                return
            end
            local mF, hF = HF.ph == true and e.on and not r.dead, r.pv
            if not hF then
                if not (mF) then
                    return
                end
                hF = (a(r))
            end
            L7(r)
            CF(r, true)
            A7(hF.g, mF)
        end
        WF = function(r)
            local e = r.pv
            if e then
                r.pv = nil
                e.md:clean()
                Y7(e.g)
            end
        end

        I = { on = true, use = false, rows = {}, list = {}, q = false }
        local function r()
            local e = I.f
            if not (e and not HF.dead) then
                return
            end
            local mF, hF, AF, lF, CF = I.rows, {}, I.list, 0, 0
            for WF = 1, #AF, 1 do
                local a7 = AF[WF]
                WF = a7.id
                if not hF[WF] then
                    lF += 1
                    hF[WF] = true
                    local B7 = mF[WF]
                    if not B7 then
                        local n7 = UF("Frame", { Size = p(1, 0, 0, 20), Parent = e })
                        QF(n7, 0)
                        local L7 = w7(n7, WF, 1)
                        d7(n7, 8, 2)
                        local Z7, X7, q7 = b({ Size = A(0, 20), AutomaticSize = v, TextColor3 = R7, LayoutOrder = 3, Parent = n7 })
                        B7 = { f = n7, n = Z7 }
                        mF[WF] = B7
                        L7.ImageTransparency = 1
                        L7.BackgroundTransparency = 1
                        X7.TextTransparency = 1
                        q7.TextTransparency = 1
                        C(X7, { TextTransparency = 0 }, 0.22, GF)
                        C(q7, { TextTransparency = 0.15 }, 0.22, GF)
                        C(L7, { ImageTransparency = 0, BackgroundTransparency = 0 }, 0.22, GF)
                        MF(Z7:GetPropertyChangedSignal("AbsoluteSize"), j)
                    end
                    B7.f.LayoutOrder = 10 + lF
                    B7.n.Text = a7.name
                    CF = w(CF, B7.n.AbsoluteSize.X + 26)
                end
            end
            for WF, a7 in next, mF, nil do
                if not (hF[WF]) then
                    mF[WF] = nil
                    a7.f:Destroy()
                end
            end
            x7(I.g, A(24 + w(132, d(CF + 0.5)), 0))
            AF, e = I.g, I.use and I.on and (HF.open or lF > 0)
            A7(AF, e)
        end
        j = function()
            if I.q or not (I.f and not HF.dead) then
                return
            end
            I.q = true
            s(function()
                I.q = false
                r()
            end)
        end
        local function r(e, mF)
            local hF = UF("Frame", { AnchorPoint = B(1, 0), Position = mF, Size = A(156, 0), AutomaticSize = u, Visible = false, Parent = e })
            mF, e = nF(hF, false, 0, true)
            gF(e, 0)
            I.g, I.f = hF, P7(e, "eye", "Spectators")
            I.hh = UF("TextButton", { Size = M(1, 1), ZIndex = 5, Visible = false, Parent = hF })
            return hF
        end
        cF.spectators = function(e, mF)
            e = I.list
            k(e)
            if type(mF) == "table" then
                for hF = 1, #mF, 1 do
                    local AF, lF, CF = mF[hF]
                    if typeof(AF) == "Instance" and AF:IsA("Player") then
                        lF, CF = AF.UserId, AF.DisplayName
                    elseif type(AF) == "table" then
                        lF, CF = (tonumber(AF.id)), AF.name
                    end
                    if lF and CF ~= nil then
                        hF, AF = #e + 1, { id = lF }
                        AF.name, e[hF] = tostring(CF), AF
                    end
                end
            end
            j()
        end

        R = { on = true, show = { "User", "FPS", "Ping", "RAM", "Time" }, title = "polar", v = {}, n = 0 }
        local e = { FPS = "layers", Ping = "wifi", CPU = "cpu", RAM = "ram", Time = "clock" }
        local function mF()
            local hF, AF = pcall(function()
                return x.PerformanceStats.CPU:GetValue()
            end)
            if (if hF then type(AF) ~= "number" else not hF) or AF <= 0 then
                hF, AF = pcall(function()
                    return x.RenderCPUFrameTime * 1000
                end)
            end
            if not (hF and type(AF) == "number" and AF > 0) then
                return nil
            end
            return E(d(AF * w(HF.fps or 60, 1) / 10 + 0.5), 0, 100)
        end
        n = function()
            local hF = R.nl
            if not (hF) then
                return
            end
            hF.Text = R.title
            hF = R.v
            if hF.User then
                hF.User.Text = h.Name
            end
            if hF.FPS then
                hF.FPS.Text = tostring(HF.fps or 0)
            end
            if hF.Ping then
                local AF, lF = pcall(h.GetNetworkPing, h)
                hF.Ping.Text = d((AF and lF or 0) * 1000 + 0.5) .. "ms"
            end
            if hF.CPU then
                local AF = mF()
                hF.CPU.Text = AF and AF .. "%" or "-"
            end
            if hF.RAM then
                local mF, AF = pcall(x.GetTotalMemoryUsageMb, x)
                hF.RAM.Text = (mF and d(AF + 0.5) or 0) .. "mb"
            end
            if hF.Time then
                hF.Time.Text = os.date("%H:%M")
            end
        end
        L = function()
            local x = R.f
            if not (x) then
                return
            end
            local mF = x:GetChildren()
            for hF = 1, #mF, 1 do
                if mF[hF]:IsA("GuiObject") then
                    mF[hF]:Destroy()
                end
            end
            mF = {}
            R.v = mF
            local hF = 0
            for AF = 1, #K, 1 do
                local lF = K[AF]
                if y(R.show, lF) then
                    hF += 1
                    if hF > 1 then
                        t7(x, AF * 2 - 1)
                    end
                    local CF = UF("Frame", { Size = A(0, 0), AutomaticSize = V, LayoutOrder = AF * 2, Parent = x })
                    QF(CF, 0)
                    if lF == "User" then
                        w7(CF, h.UserId, 1)
                    else
                        E7(CF, e[lF], 1, nil, 14, 0.392)
                    end
                    d7(CF, 8, 2)
                    mF[lF] = b({ LayoutOrder = 3, Parent = CF })
                end
            end
            R.n = hF
            R.p2.Visible = hF > 0
            n()
        end
        local function h(x, e)
            local mF = UF("Frame", { AnchorPoint = B(1, 0), Position = e, Size = A(0, 0), AutomaticSize = V, Visible = false, Parent = x })
            e = UF("Frame", { Size = A(0, 0), AutomaticSize = V, Parent = mF })
            QF(e, 10, l.Right)
            local hF, hF = nF(e, true, 1)
            QF(hF, 0)
            E7(hF, "code", 1, nil, 18, 0.392)
            d7(hF, 8, 2)
            R.nl = b({ LayoutOrder = 3, Parent = hF })
            x, hF = nF(e, true, 2)
            QF(hF, 0)
            R.g, R.p2, R.f = mF, x, hF
            R.hh = UF("TextButton", { Size = M(1, 1), ZIndex = 10, Visible = false, Parent = mF })
            L()
            return mF
        end

        c = { on = true, n = 0, l = {} }
        local x = { ok = "ok", bad = "bad", warn = "warn" }
        local function e(mF)
            local hF = y(c.l, mF)
            if hF then
                f(c.l, hF)
            end
            Y7(mF)
        end
        cF.notify = function(f, mF, hF, AF)
            f = c.f
            if not (f and not HF.dead and c.on) then
                return
            end
            c.n = c.n + 1
            local lF, CF = x[hF] or "acc", UF("Frame", { Size = A(0, 34), LayoutOrder = c.n, Parent = f })
            local x, f, hF = nF(CF, true)
            x.Visible = false
            QF(f, 0)
            E7(f, "code", 1, lF, 18, 0.15)
            d7(f, 8, 2)
            b({ Text = HF.brand or "polar", LayoutOrder = 3, Parent = f }, { TextColor3 = lF })
            t7(f, 4)
            b({ Text = PF(tostring(mF), SF.acc), RichText = true, LayoutOrder = 5, Parent = f })
            hF()
            CF.Size = A(f.AbsoluteSize.X, 34)
            MF(x:GetPropertyChangedSignal("AbsoluteSize"), function()
                CF.Size = A(x.AbsoluteSize.X, 34)
            end)
            f = c.l
            f[#f + 1] = CF
            while #f > 6 do
                e(f[1])
            end
            i7(x, true, 0.24, nil, true)
            _(AF or 4, function()
                if CF.Parent and not (HF.dead) then
                    i7(x, false, 0.3, nil, true, function()
                        e(CF)
                    end)
                end
            end)
        end
        cF.log = function(b, x, f, e)
            return b:notify(x, f, e)
        end
        iF, rF, uF, S7 = a, r7, h, r
    end

    local h = {}
    h.__index = h
    local function b(x, a, r, f)
        local e = UF("Frame", { Size = M(1, 1), Visible = false, Parent = x.frame })
        kF(e, 10, 10, 0, 0)
        return setmetatable({ tab = x, name = a, i = r, frame = e, sn = 0, cols = {}, nc = E(d(tonumber(f and f.cols) or 2), 1, 4) }, h)
    end
    h.col = function(x, a)
        local r = x.cols
        a = E(d(tonumber(a) or 1), 1, 4)
        if a > x.nc then
            x.nc = a
        end
        local f = x.nc
        if #r < f then
            for e = #r + 1, f, 1 do
                local mF = UF("ScrollingFrame", { ScrollBarThickness = 0, Parent = x.frame })
                kF(mF, 2, 2, 10, 12)
                gF(mF, 8)
                r[e] = mF
            end
            for x = 1, f, 1 do
                r[x].Position = p((x - 1) / f, (x - 1) * 8 / f, 0, 0)
                r[x].Size = p(1 / f, -(f - 1) * 8 / f, 1, 0)
            end
        end
        return r[a]
    end
    h.section = function(x, a)
        a = (if type(a) == "string" then { name = a } else a) or {}
        local r = a.side
        local f = x:col(tonumber(if r == "left" then 1 else (if r == "right" then (x.nc > 2 and x.nc or 2) else (if r == "center" or r == "middle" then 2 else r))) or 1)
        x.sn = x.sn + 1
        local r = UF("Frame", { Size = p(1, 0, 0, 0), AutomaticSize = u, LayoutOrder = x.sn, Parent = f })
        gF(r, 6)
        f = VF(r, x.tab)
        f.page = x
        f.sec = { name = a.name or "", page = x, frame = r }
        if a.name and a.name ~= "" then
            f.n = f.n + 1
            x = UF("Frame", { Size = p(1, 0, 0, 14), LayoutOrder = f.n, Parent = r })
            UF("TextLabel", { Position = A(10, 0), Size = p(1, -10, 1, 0), Text = a.name, FontFace = ZF.s, TextSize = 12, TextTruncate = W, Parent = x }, { TextColor3 = "dim" })
        end
        return f
    end

    local x = {}
    x.__index = x
    x.pgdraw = function(a)
        local r = a.pages
        local f = #r > 1
        for u = 1, #r, 1 do
            local e = r[u]
            local r, u = e == a.pg, e.btn
            u.Visible = f
            u.FontFace = r and ZF.b or ZF.s
            C(u, { TextColor3 = r and SF.txt or (e.hov and SF.sub or SF.dim) }, 0.14, GF)
        end
    end
    x.page = function(a, r, f)
        if type(r) == "table" then
            r, f = r.name, r
        end
        local u = a.pages
        local e = b(a, r or "Main", #u + 1, f)
        u[#u + 1] = e
        u = UF("TextButton", { Size = A(0, 40), AutomaticSize = v, Text = e.name, TextSize = 13, LayoutOrder = e.i, Parent = a.tr }, { TextColor3 = "dim" })
        e.btn = u
        b7(u, nil, function()
            e.hov = true
            a:pgdraw()
        end, function()
            e.hov = false
            a:pgdraw()
        end)
        MF(u.MouseButton1Click, function()
            a:show(e.i)
        end)
        if not (a.pg) then
            a.pg = e
            e.frame.Visible = true
        end
        a:pgdraw()
        return e
    end
    x.show = function(b, a)
        local r = b.pages[a]
        if not (r and r ~= b.pg) then
            return
        end
        S()
        i7(b.pg.frame, false, 0.12)
        b.pg = r
        i7(r.frame, true, 0.2, 0.07)
        b:pgdraw()
    end
    x.section = function(b, a)
        return (b.pages[1] or b:page("Main")):section(a)
    end
    x.navdraw = function(b)
        local a = b.win.cur == b
        local r = b.hov and not a
        b.nl.FontFace = a and ZF.b or ZF.s
        local f, u, e = b.ni, {}, a and SF.acc or (r and SF.sub or SF.dim)
        u.ImageColor3 = e
        C(f, u, 0.14, GF)
        u, e, f = b.nl, {}, a and SF.txt or (r and SF.sub or SF.dim)
        e.TextColor3 = f
        C(u, e, 0.14, GF)
    end
    x.hc = function(b)
        local a = b.hcc
        if not a then
            a = VF(b.tl, b, nil)
            b.hcc = a
        end
        return a
    end
    x.tbdrop = function(b, a)
        a = a or {}
        a.noprof = true
        b.tn = b.tn + 1
        a.par = b.tl
        a.lo = b.tn
        a.auto = true
        a.h = a.h or 24
        return b:hc():dropdown(a)
    end

    local b = {}
    b.__index = b
    x.profile = function(a, r)
        r = r or {}
        local f = r.global or "Global"
        local u, e = { f }, r.items or {}
        for mF = 1, #e, 1 do
            if e[mF] ~= f then
                u[#u + 1] = e[mF]
            end
        end
        local e = setmetatable({ tab = a, items = u, g = f, data = {}, els = {}, id = r.id or r.flag or a.name }, b)
        e.cur = y(u, r.default) and r.default or f
        a.prof = e
        e.idd = a:tbdrop({ values = u, default = e.cur, cb = function(a)
            e:select(a)
        end })
        cF.profs[#cF.profs + 1] = e
        return e
    end
    b.store = function(a)
        local r = tostring(a.cur)
        local f = a.data[r]
        if not f then
            if not (a.dirty) and r ~= a.g then
                return
            end
            f = {}
            a.data[r] = f
        end
        r = a.els
        for u = 1, #r, 1 do
            a = r[u]
            f[a.flag] = a:ser()
        end
    end
    b.apply = function(a)
        local r = tostring(a.cur)
        local f = a.data[r]
        f = if f == nil and r ~= a.g then a.data[a.g] else f
        a.ld = true
        r = a.els
        for u = 1, #r, 1 do
            local e = r[u]
            u = f and f[e.flag]
            e:load(if u == nil then e.def else u)
        end
        a.ld = false
        a.dirty = false
        if a.cb then
            H(a.cb, a.cur)
        end
    end
    b.select = function(a, r)
        if r == a.cur or not (y(a.items, r)) then
            return
        end
        a:store()
        a.cur = r
        if a.idd.val ~= r then
            a.idd:set(r, true)
        end
        a:apply()
    end
    b.spread = function(a, r)
        local f = r.flag
        for u, e in next, a.data, nil do
            if u ~= a.g then
                e[f] = r:ser()
            end
        end
    end
    b.get = function(a, r, f)
        local u = tostring(a.cur)
        f = f ~= nil and tostring(f) or u
        f = if u == a.g then a.g else (if y(a.items, f) then f else a.g)
        if f == u then
            return cF.flags[r]
        end
        u = a.data[f]
        if u == nil and f ~= a.g then
            return a:get(r, a.g)
        end
        local a, f = cF.fl[r], u and u[r]
        f = if f == nil then a and a.def else f
        return if a then (a:unser(f)) else f
    end
    b.ser = function(a)
        a:store()
        return { cur = a.cur, data = a.data }
    end
    b.load = function(b, a)
        if type(a) ~= "table" then
            return
        end
        b.data = type(a.data) == "table" and a.data or {}
        if a.cur ~= nil and y(b.items, a.cur) then
            b.cur = a.cur
            b.idd:set(a.cur, true)
        end
        b:apply()
    end

    local b = {}
    b.__index = b
    b.group = function(a)
        return a
    end
    b.barhl = function(a, r)
        local f = a.cur
        if not (f) then
            return
        end
        local u = f.nb
        if u.AbsoluteSize.X <= 0 then
            return
        end
        f = IF()
        local e, mF = (u.AbsolutePosition - a.bls.AbsolutePosition) / f, u.AbsoluteSize / f
        f, u = A(e.X, e.Y), A(mF.X, mF.Y)
        if r then
            C(a.bhl, { Position = f, Size = u }, 0.24)
        else
            a.bhl.Position, a.bhl.Size = f, u
        end
    end
    b.tab = function(a, r)
        r = (if type(r) == "string" then { name = r } else r) or {}
        a.nn = a.nn + 1
        local f = setmetatable({ win = a, o = r, name = r.name or "Tab", pages = {}, tn = 0 }, x)
        local u = UF("TextButton", { Size = A(0, 26), AutomaticSize = v, LayoutOrder = a.nn, ZIndex = 4, Parent = a.bls })
        kF(u, 10, 12, 0, 0)
        QF(u, 6)
        f.ni = UF("ImageLabel", { Size = A(13, 13), Image = qF(r.icon or "misc"), LayoutOrder = 1, ZIndex = 4, Parent = u }, { ImageColor3 = "dim" })
        f.nl = UF("TextLabel", { Size = A(0, 26), AutomaticSize = v, Text = f.name, TextSize = 13, LayoutOrder = 2, ZIndex = 4, Parent = u }, { TextColor3 = "dim" })
        f.nb = u
        f.frame = UF("Frame", { Size = M(1, 1), Visible = false, Parent = a.body })
        f.tl = UF("Frame", { Size = A(0, 40), AutomaticSize = v, Visible = false, LayoutOrder = 10 + a.nn, Parent = a.tl })
        QF(f.tl, 8)
        f.tr = UF("Frame", { Size = A(0, 40), AutomaticSize = v, Visible = false, Parent = a.tr })
        QF(f.tr, 16, l.Right)
        b7(u, nil, function()
            f.hov = true
            f:navdraw()
        end, function()
            f.hov = false
            f:navdraw()
        end)
        MF(u.MouseButton1Click, function()
            a:select(f)
        end)
        MF(u:GetPropertyChangedSignal("AbsoluteSize"), function()
            if a.cur == f then
                a:barhl(true)
            end
        end)
        u = a.tabs
        u[#u + 1] = f
        if a.cur then
            f:navdraw()
        else
            a:select(f)
        end
        return f
    end
    b.select = function(a, r)
        local f = a.cur
        if f == r then
            return
        end
        S()
        a.cur = r
        if f then
            i7(f.frame, false, 0.12)
            f.tl.Visible = false
            f.tr.Visible = false
            f:navdraw()
        end
        i7(r.tl, true, 0.2)
        i7(r.tr, true, 0.2)
        i7(r.frame, true, 0.2, f and 0.07 or nil)
        r:navdraw()
        a:barhl(f ~= nil)
        s(function()
            if a.cur == r then
                a:barhl(f ~= nil)
            end
        end)
    end
    b.toggle = function(a, r)
        cF:toggle(r)
        return a
    end

    local function a() end
    local r, f
    do
        r = function()
            return cF.dir .. "/configs"
        end
        local function u(e)
            return r() .. "/" .. e .. ".json"
        end
        local function e(mF)
            return Z(z(U(tostring(mF or ""), '[\\/:%*%?"<>|]', ""), "^%s*(.-)%s*$") or "", 1, 40)
        end
        cF.configs = function(mF)
            local hF = NF.list(r())
            local AF, lF = {}, {}
            for CF = 1, #hF, 1 do
                local WF = hF[CF]
                if not (NF.has(WF)) then
                    local a7 = z(WF, "[/\\]([^/\\]+)$") or WF
                    a7 = z(a7, "^(.+)%.json$")
                    if a7 and a7 ~= "" and not (lF[a7]) then
                        lF[a7] = true
                        AF[#AF + 1] = a7
                    end
                end
            end
            Q(AF)
            return AF
        end
        cF.saveconfig = function(mF, hF)
            mF = e(hF)
            if mF == "" then
                return false, "Invalid name"
            end
            NF.dir(cF.dir)
            NF.dir(r())
            hF = { v = 1, flags = {}, profs = {} }
            local AF = cF.els
            for lF = 1, #AF, 1 do
                local CF = AF[lF]
                if CF.flag and not (CF.tmp or CF.prof) then
                    hF.flags[CF.flag] = CF:ser()
                end
            end
            AF = cF.profs
            for lF = 1, #AF, 1 do
                local CF = AF[lF]
                if CF.id then
                    hF.profs[CF.id] = CF:ser()
                end
            end
            AF = aF(hF)
            if not AF then
                return false, "Encode failed"
            end
            if not (NF.write(u(mF), AF)) then
                return false, "Write failed"
            end
            return true, mF
        end
        cF.loadconfig = function(mF, hF)
            mF = e(hF)
            if mF == "" then
                return false, "Invalid name"
            end
            local AF = NF.read(u(mF))
            if not AF then
                return false, "Not found"
            end
            AF = BF(AF)
            if type(AF) ~= "table" then
                return false, "Corrupt config"
            end
            local lF, CF = type(AF.flags) == "table" and AF.flags or {}, {}
            local WF = cF.els
            for a7 = 1, #WF, 1 do
                local B7 = WF[a7]
                if B7.flag and not (B7.tmp or B7.prof) then
                    local n7 = lF[B7.flag]
                    if n7 ~= nil then
                        B7:load(n7)
                        CF[B7.flag] = true
                    end
                end
            end
            WF = cF.profs
            for a7 = 1, #WF, 1 do
                local B7 = WF[a7]
                local n7 = B7.id and type(AF.profs) == "table" and AF.profs[B7.id]
                if n7 ~= nil then
                    B7:load(n7)
                end
            end
            for a7, B7 in next, lF, nil do
                if not (CF[a7]) then
                    cF.flags[a7] = B7
                    local n7 = cF.fl[a7]
                    if n7 then
                        n7:load(B7)
                    end
                end
            end
            return true, mF
        end
        cF.deleteconfig = function(mF, hF)
            mF = e(hF)
            if mF == "" then
                return false, "Invalid name"
            end
            local AF = u(mF)
            if not (NF.has(AF)) then
                return false, "Not found"
            end
            NF.del(AF)
            return true, mF
        end
        f = e
    end

    local u
    do
        local function e(mF)
            local hF = {}
            for AF, lF in next, mF, nil do
                if typeof(lF) == "Color3" then
                    hF[AF] = dF(lF)
                end
            end
            return hF
        end
        local function mF(hF)
            local AF = {}
            if type(hF) ~= "table" then
                return AF
            end
            for lF, CF in next, hF, nil do
                local WF = wF(CF)
                if WF then
                    AF[lF] = WF
                end
            end
            return AF
        end
        local function hF()
            return cF.dir .. "/themes"
        end
        local function AF(lF)
            return hF() .. "/" .. lF .. ".json"
        end
        cF.themes = function()
            local lF = NF.list(hF())
            local CF, WF = {}, {}
            for a7 = 1, #lF, 1 do
                local B7 = lF[a7]
                if not (NF.has(B7)) then
                    local n7 = z(B7, "[/\\]([^/\\]+)$") or B7
                    n7 = z(n7, "^(.+)%.json$")
                    if n7 and n7 ~= "" and not (WF[n7]) then
                        WF[n7] = true
                        CF[#CF + 1] = n7
                    end
                end
            end
            Q(CF)
            return CF
        end
        cF.savetheme = function(lF, CF)
            lF = f(CF)
            if lF == "" then
                return false, "Invalid name"
            end
            NF.dir(cF.dir)
            NF.dir(hF())
            CF = aF({ v = 1, colors = e(SF) })
            if not CF then
                return false, "Encode failed"
            end
            if not (NF.write(AF(lF), CF)) then
                return false, "Write failed"
            end
            return true, lF
        end
        cF.loadtheme = function(lF, CF)
            lF = f(CF)
            if lF == "" then
                return false, "Invalid name"
            end
            local WF = NF.read(AF(lF))
            if not WF then
                return false, "Not found"
            end
            WF = BF(WF)
            if type(WF) ~= "table" then
                return false, "Corrupt theme"
            end
            WF = mF(WF.colors)
            if next(WF) == nil then
                return false, "No valid colors"
            end
            cF:theme(WF)
            return true, lF
        end
        cF.deletetheme = function(lF, CF)
            lF = f(CF)
            if lF == "" then
                return false, "Invalid name"
            end
            local WF = AF(lF)
            if not (NF.has(WF)) then
                return false, "Not found"
            end
            NF.del(WF)
            return true, lF
        end
        u = mF
    end

    local function mF(e)
        local hF = cF.dir .. "/settings.json"
        if e then
            NF.dir(cF.dir)
            local AF = { v = 1, bg = HF.bgt, blur = HF.blur, font = cF.fontName, pads = {} }
            local lF = cF.els
            for CF = 1, #lF, 1 do
                local WF = lF[CF]
                local a7 = WF.flag and WF.pd
                if a7 then
                    local B7 = WF.pv and O7(WF.pv.g)
                    AF.pads[WF.flag] = {
                        o = a7.on == true,
                        s = a7.sz or 100,
                        r = a7.rd or 100,
                        n = a7.nm or "",
                        p = B7 and { B7.X.Scale, B7.X.Offset, B7.Y.Scale, B7.Y.Offset } or a7.pos,
                    }
                end
            end
            e = aF(AF)
            if e then
                NF.write(hF, e)
            end
            return
        end
        hF = BF(NF.read(hF))
        if type(hF) ~= "table" then
            return
        end
        if type(hF.bg) == "number" then
            HF.bgt = E(hF.bg, 0, 1)
        end
        if type(hF.blur) == "boolean" then
            HF.blur = hF.blur
        end
        if type(hF.font) == "string" then
            cF.fontName = hF.font
        end
        if type(hF.pads) == "table" then
            HF.pads = hF.pads
        end
    end
    eF = mF

    local function hF(e)
        local mF = HF.gui
        if not mF then
            return
        end
        local hF = mF:GetDescendants()
        for AF = 1, #hF, 1 do
            local lF = hF[AF]
            local CF = lF:GetAttribute("t_BackgroundColor3")
            if CF then
                local WF = SF[CF]
                if WF then
                    if e then
                        C(lF, { BackgroundColor3 = WF }, 0.18, GF)
                    else
                        lF.BackgroundColor3 = WF
                    end
                end
            end
            CF = lF:GetAttribute("t_TextColor3")
            if CF then
                local WF = SF[CF]
                if WF then
                    if e then
                        C(lF, { TextColor3 = WF }, 0.18, GF)
                    else
                        lF.TextColor3 = WF
                    end
                end
            end
            CF = lF:GetAttribute("t_ImageColor3")
            if CF then
                local WF = SF[CF]
                if WF then
                    if e then
                        C(lF, { ImageColor3 = WF }, 0.18, GF)
                    else
                        lF.ImageColor3 = WF
                    end
                end
            end
        end
        hF = cF.els
        for AF = 1, #hF, 1 do
            local lF = hF[AF]
            if not (lF.dead) then
                if lF.kind == "gtgl" or lF.kind == "gsld" then
                    if lF.grad and not lF.grad_spec and not lF.c_from and not lF.c_to then
                        lF.grad.Color = buildGradientSeq(nil, SF.acc, K(((select(1, SF.acc:ToHSV())) + 0.14) % 1, 0.85, 1))
                    end
                end
                lF:draw(true)
            end
        end
        if R.n then
            L()
        end
        vF()
        S7()
    end

    cF.theme = function(e, mF)
        if type(mF) ~= "table" then
            return SF
        end
        for AF, lF in next, mF, nil do
            if SF[AF] ~= nil then
                local CF = if typeof(lF) == "Color3" then lF else wF(lF)
                if CF then
                    SF[AF] = CF
                end
            end
        end
        hF(true)
        return SF
    end

    cF.setfont = function(e, mF)
        mF = q(tostring(mF or ""))
        if mF == "" or mF == "builder" or mF == "buildersans" then
            mF = "builder"
        elseif mF ~= "geist" and mF ~= "onest" and mF ~= "inter" then
            return false
        end
        cF.fontName = mF
        if mF == "builder" then
            local hF = Enum.FontWeight
            ZF.r = Font.new("rbxasset://fonts/families/BuilderSans.json", hF.Regular)
            ZF.m = Font.new("rbxasset://fonts/families/BuilderSans.json", hF.Medium)
            ZF.s = Font.new("rbxasset://fonts/families/BuilderSans.json", hF.SemiBold)
            ZF.b = Font.new("rbxasset://fonts/families/BuilderSans.json", hF.Bold)
        elseif not (XF(cF.dir .. "/fonts", mF)) then
            return false
        end
        local hF = HF.gui
        if hF then
            local AF = hF:GetDescendants()
            for lF = 1, #AF, 1 do
                local CF = AF[lF]
                if CF:IsA("TextLabel") or CF:IsA("TextButton") or CF:IsA("TextBox") then
                    CF.FontFace = ZF.s
                end
            end
        end
        hF = HF.win
        if hF then
            local AF = hF.tabs
            for lF = 1, #AF, 1 do
                local CF = AF[lF]
                CF.nl.FontFace = hF.cur == CF and ZF.b or ZF.s
                CF:pgdraw()
            end
        end
        return true
    end

    cF.setbg = function(e, mF)
        mF = E(tonumber(mF) or 0.08, 0, 1)
        HF.bgt = mF
        if HF.bg then
            C(HF.bg, { BackgroundTransparency = mF }, 0.25, GF)
        end
        eF()
    end

    cF.setblur = function(e, mF)
        mF = mF == true
        HF.blur = mF
        if HF.bo then
            HF.bo.Enabled = mF and HF.open
        end
        eF()
    end

    cF.open = function(e)
        if HF.dead or HF.open then
            return
        end
        HF.open = true
        if HF.bo then
            HF.bo.Enabled = HF.blur
        end
        if HF.bg then
            C(HF.bg, { BackgroundTransparency = HF.bgt }, 0.25, GF)
        end
        i7(HF.root, true, 0.24, nil, true)
        vF()
        S7()
        h7()
        if e and e.onopen then
            H(e.onopen)
        end
    end

    cF.close = function(e)
        if HF.dead or not (HF.open) then
            return
        end
        HF.open = false
        S()
        if HF.bo then
            HF.bo.Enabled = false
        end
        if HF.bg then
            C(HF.bg, { BackgroundTransparency = 1 }, 0.2, GF)
        end
        i7(HF.root, false, 0.18, nil, true)
        vF()
        S7()
        if e and e.onclose then
            H(e.onclose)
        end
    end

    cF.toggle = function(e, mF)
        if mF == nil then
            mF = not HF.open
        end
        if mF then
            cF:open()
        else
            cF:close()
        end
    end

    cF.isopen = function()
        return HF.open and not HF.dead
    end

    cF.unload = function()
        if HF.dead then
            return
        end
        HF.dead = true
        HF.open = false
        S()
        local e = cF.els
        for mF = #e, 1, -1 do
            local hF = e[mF]
            if hF and not (hF.dead) then
                hF:destroy()
            end
        end
        HF.md:clean()
        if HF.bo then
            pcall(function()
                HF.bo:Destroy()
            end)
        end
        if HF.gui then
            HF.gui:Destroy()
        end
        local e = HF.unl
        for mF = 1, #e, 1 do
            pcall(e[mF])
        end
        k(e)
        if TF[cF.dir] == cF then
            TF[cF.dir] = nil
        end
    end

    cF.onunload = function(e, mF)
        if type(mF) == "function" then
            HF.unl[#HF.unl + 1] = mF
        end
    end

    cF.window = function(e, mF)
        mF = mF or {}
        if HF.win then
            return HF.win
        end
        local hF = q(tostring(mF.folder or mF.name or "polar"))
        hF = U(hF, "[^%w_%-]", "")
        cF.dir = hF ~= "" and hF or "polar"
        cF.brand = mF.brand or mF.name or "polar"
        HF.brand = cF.brand
        R.title = mF.hud or cF.brand
        mF()
        NF.dir(cF.dir)
        EF(cF.dir)
        local AF = mF.theme
        if type(AF) == "string" then
            AF = u(BF(NF.read(cF.dir .. "/themes/" .. f(AF) .. ".json")))
        end
        if type(AF) == "table" then
            for lF, CF in next, AF, nil do
                if SF[lF] ~= nil and typeof(CF) == "Color3" then
                    SF[lF] = CF
                end
            end
        end
        local lF = UF("ScreenGui", { Name = cF.dir, ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 900, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
        pcall(function()
            lF.OnTopOfCoreBlur = true
        end)
        HF.gui = lF
        local CF = UF("Frame", { Size = M(1, 1), Parent = lF })
        HF.probe = CF
        local WF = UF("UIScale", { Parent = lF })
        HF.us = WF
        local a7 = function()
            local B7 = CF.AbsoluteSize
            if B7.X <= 0 or B7.Y <= 0 then
                return
            end
            local n7 = P(B7.X / 860, B7.Y / 560)
            WF.Scale = n7 < 1 and w(0.65, n7) or 1
            fF(WF.Scale, HF.root)
            for n7 = 1, #HF.pops, 1 do
                HF.pops[n7]:clampit()
            end
        end
        MF(CF:GetPropertyChangedSignal("AbsoluteSize"), a7)
        a7()
        local B7 = UF("Frame", { Size = M(1, 1), BackgroundColor3 = OF, BackgroundTransparency = 1, ZIndex = 1, Parent = lF })
        HF.bg = B7
        local n7 = UF("Frame", { Size = M(1, 1), Visible = false, ZIndex = 2, Parent = lF })
        HF.root = n7
        local L7 = UF("Frame", { Size = M(1, 1), ZIndex = 50, Parent = n7 })
        HF.pl = L7
        local Z7 = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0), Size = A(740, 480), BackgroundColor3 = YF, BackgroundTransparency = 0, ZIndex = 1, Parent = n7 }, { BackgroundColor3 = "win" })
        zF(Z7, 12)
        UF("UIGradient", { Rotation = 90, Color = N(YF, S(0.86, 0.86, 0.88)), Parent = Z7 })
        UF("UIGradient", { Rotation = 90, Transparency = R(0.15, 0.8), Parent = yF(Z7, 0.86) })
        o7(Z7, 12, 0.15)
        KF(Z7)
        local X7 = UF("Frame", { Size = p(1, 0, 0, 56), BackgroundColor3 = YF, BackgroundTransparency = 0, ZIndex = 1, Parent = Z7 })
        zF(X7, 12)
        UF("UIGradient", { Rotation = 90, Transparency = R({ n(0, 0.96), n(0.7, 0.99), n(1, 1) }), Parent = X7 })
        local q7 = UF("Frame", { Size = p(1, 0, 0, 44), ZIndex = 3, Parent = Z7 })
        local U7 = UF("Frame", { Position = A(14, 0), Size = A(0, 44), AutomaticSize = v, Parent = q7 })
        QF(U7, 8)
        local z7 = mF.logo or "logo"
        local J7 = UF("ImageLabel", { Size = A(18, 18), Image = qF(z7), LayoutOrder = 1, Parent = U7 }, { ImageColor3 = "acc" })
        local y7 = UF("TextLabel", { Size = A(0, 20), AutomaticSize = v, Text = cF.brand, FontFace = ZF.h, TextSize = 15, LayoutOrder = 2, Parent = U7 }, { TextColor3 = "txt" })
        local f7 = mF.sub or mF.subtitle
        if f7 and f7 ~= "" then
            UF("Frame", { Size = A(1, 12), BackgroundColor3 = YF, BackgroundTransparency = LF.sep, LayoutOrder = 3, Parent = U7 })
            UF("TextLabel", { Size = A(0, 20), AutomaticSize = v, Text = q(tostring(f7)), TextSize = 12, LayoutOrder = 4, Parent = U7 }, { TextColor3 = "dim" })
        end
        local k7 = UF("Frame", { Position = A(0, 44), Size = p(1, 0, 1, -44), Parent = Z7 })
        local g7 = UF("Frame", { Size = p(1, 0, 0, 40), ZIndex = 4, Parent = k7 })
        local Q7 = UF("Frame", { Position = A(14, 7), Size = A(0, 26), AutomaticSize = v, Parent = g7 })
        QF(Q7, 2)
        local c7 = UF("Frame", { Size = A(0, 26), BackgroundColor3 = YF, BackgroundTransparency = LF.tab, ZIndex = 2, Parent = Q7 })
        zF(c7, 7)
        local H7 = UF("Frame", { AnchorPoint = B(0, 1), Position = p(0, 0, 1, 0), Size = p(1, 0, 0, 1), BackgroundColor3 = YF, BackgroundTransparency = LF.sep, ZIndex = 5, Parent = g7 })
        local _7 = UF("Frame", { AnchorPoint = B(1, 0), Position = p(1, -14, 0, 0), Size = A(0, 40), AutomaticSize = v, ZIndex = 4, Parent = g7 })
        QF(_7, 0, l.Right)
        local s7 = UF("Frame", { Position = A(0, 40), Size = p(1, 0, 1, -40), Parent = k7 })
        local F7 = UF("Frame", { Size = p(1, 0, 0, 44), ZIndex = 3, Parent = q7 })
        QF(F7, 6, l.Right)
        kF(F7, 0, 12, 0, 0)
        local v7 = UF("Frame", { Size = p(1, 0, 0, 1), BackgroundColor3 = YF, BackgroundTransparency = LF.sep, ZIndex = 4, Parent = k7 })
        local u7
        do
            local V7 = UF("Frame", { Size = A(24, 24), Parent = F7 })
            local e7 = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(16, 16), BackgroundColor3 = YF, BackgroundTransparency = 1, Parent = V7 })
            zF(e7, 5)
            local l7 = UF("ImageLabel", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(12, 12), Image = qF("x"), Parent = e7 }, { ImageColor3 = "dim" })
            b7(e7, nil, function()
                C(e7, { BackgroundTransparency = LF.ctlh }, 0.12, GF)
                C(l7, { ImageColor3 = SF.bad }, 0.12, GF)
            end, function()
                C(e7, { BackgroundTransparency = 1 }, 0.12, GF)
                C(l7, { ImageColor3 = SF.dim }, 0.12, GF)
            end)
            MF(e7.MouseButton1Click, function()
                cF:close()
            end)
            u7 = V7
        end
        local V7, e7
        do
            local l7 = UF("Frame", { Size = A(24, 24), Parent = F7 })
            local C7 = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(16, 16), BackgroundColor3 = YF, BackgroundTransparency = 1, Parent = l7 })
            zF(C7, 5)
            local W7 = UF("ImageLabel", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(12, 12), Image = qF("sliders"), Parent = C7 }, { ImageColor3 = "dim" })
            local D7 = false
            b7(l7, nil, function()
                C(C7, { BackgroundTransparency = LF.ctlh }, 0.12, GF)
                C(W7, { ImageColor3 = D7 and SF.acc or SF.txt }, 0.12, GF)
            end, function()
                C(C7, { BackgroundTransparency = 1 }, 0.12, GF)
                C(W7, { ImageColor3 = D7 and SF.acc or SF.dim }, 0.12, GF)
            end)
            local function j7()
                D7 = not D7
                C(W7, { ImageColor3 = D7 and SF.acc or SF.dim }, 0.14, GF)
                local h7 = cF.els
                for b7 = 1, #h7, 1 do
                    local K7 = h7[b7]
                    if K7.pd and not (K7.dead or K7.tmp) then
                        K7.pd.on = D7
                        lF(K7)
                    end
                end
                eF()
            end
            MF(C7.InputBegan, function(h7)
                if FF(h7.UserInputType) then
                    j7()
                end
            end)
            V7, e7 = l7, j7
        end
        local l7, C7
        do
            local W7 = UF("Frame", { Size = A(24, 24), Parent = F7 })
            local D7 = UF("Frame", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(16, 16), BackgroundColor3 = YF, BackgroundTransparency = 1, Parent = W7 })
            zF(D7, 5)
            local j7 = UF("ImageLabel", { AnchorPoint = B(0.5, 0.5), Position = M(0.5, 0.5), Size = A(12, 12), Image = qF("settings"), Parent = D7 }, { ImageColor3 = "dim" })
            b7(D7, nil, function()
                C(D7, { BackgroundTransparency = LF.ctlh }, 0.12, GF)
                C(j7, { ImageColor3 = SF.txt }, 0.12, GF)
            end, function()
                C(D7, { BackgroundTransparency = 1 }, 0.12, GF)
                C(j7, { ImageColor3 = SF.dim }, 0.12, GF)
            end)
            local h7
            MF(D7.InputBegan, function(b7)
                if not (FF(b7.UserInputType)) then
                    return
                end
                if h7 and h7.isopen then
                    iF(h7)
                    return
                end
                local K7 = a7({ w = 220, keep = true, anchor = D7, title = "Settings" })
                h7 = K7
                local S7 = K7.c
                S7:slider({ name = "Background", min = 0, max = 100, step = 1, suffix = "%", sw = 60, default = d(HF.bgt * 100 + 0.5), cb = function(t7)
                    cF:setbg(t7 / 100)
                end })
                S7:toggle({ name = "Blur", default = HF.blur, cb = function(t7)
                    cF:setblur(t7)
                end })
                S7:dropdown({
                    name = "Font",
                    values = { "Builder", "Geist", "Onest", "Inter" },
                    default = (if cF.fontName == "geist" then "Geist" elseif cF.fontName == "onest" then "Onest" elseif cF.fontName == "inter" then "Inter" else "Builder"),
                    w = 88,
                    cb = function(t7)
                        cF:setfont(t7)
                    end,
                })
                K7:fit()
                local t7, G7 = D7.AbsolutePosition, D7.AbsoluteSize
                B7(K7, t7.X + G7.X - K7.w * IF(), t7.Y + G7.Y + 4 * IF())
            end)
            l7, C7 = W7, h7
        end
        local W7 = UF("Frame", { Size = p(1, -260, 1, 0), Parent = F7 })
        QF(W7, 6, l.Right)
        local D7 = setmetatable({ frame = Z7, body = s7, bls = Q7, bhl = c7, tl = _7, tr = F7, tabs = {}, nn = 0 }, b)
        HF.win = D7
        M7(lF)
        do
            local j7, h7
            local b7 = function(K7)
                local S7 = IF()
                local t7 = HF.gui.AbsoluteSize
                local G7 = Z7.AbsoluteSize
                local i7 = E(K7.X - j7.X, 6, w(6, t7.X - G7.X - 6))
                K7 = E(K7.Y - j7.Y, 6, w(6, t7.Y - G7.Y - 6))
                Z7.Position = A(d((i7 - t7.X * 0.5 + G7.X * 0.5) / S7 + 0.5), d((K7 - t7.Y * 0.5 + G7.Y * 0.5) / S7 + 0.5))
            end
            MF(q7.InputBegan, function(K7)
                local S7 = K7.UserInputType
                if not (FF(S7)) or tF(W7, sF(K7)) then
                    return
                end
                local t7 = IF()
                local G7 = Z7.AbsolutePosition
                j7 = (if S7 == bF then sF(K7) else _F()) - G7
                h7 = K7
                m7(b7, nil, nil, K7)
            end)
            MF(q7.InputEnded, function(K7)
                if K7 == h7 or h7 and h7.UserInputType == mF and K7.UserInputType == mF then
                    h7 = nil
                    D7(true)
                end
            end)
        end
        local j7 = UF("Frame", { Size = M(1, 1), ZIndex = 60, Parent = lF })
        local h7 = UF("Frame", { AnchorPoint = B(1, 0), Position = p(1, -18, 0, 18), Size = A(0, 0), AutomaticSize = u, Parent = j7 })
        gF(h7, 8, l.Right)
        c.f = h7
        local b7 = UF("Frame", { Position = A(18, 18), Size = A(0, 0), AutomaticSize = u, Parent = j7 })
        gF(b7, 8)
        uF(b7, A(0, 0))
        iF(b7, A(0, 132))
        rF(b7, A(0, 132))
        local K7 = false
        local S7 = function()
            local t7 = not (HF.dead) and (HF.open or N.g.Visible or I.g.Visible or R.g.Visible)
            j7.Visible = t7
            if not (t7) then
                return
            end
            local G7 = HF.open and not K7
            N.hh.Visible = G7
            I.hh.Visible = G7
            R.hh.Visible = G7
        end
        local t7 = function(G7, i7, Y7)
            local O7, T7, x7 = false
            local p7 = function()
                if not (HF.open) or K7 then
                    return
                end
                O7 = false
                i7.Visible = true
                C(G7, { BackgroundTransparency = 0.45 }, 0.12, GF)
            end
            local A7 = function()
                O7 = false
                i7.Visible = false
                C(G7, { BackgroundTransparency = 1 }, 0.12, GF)
            end
            MF(i7.InputBegan, function(M7)
                if not (HF.open) or K7 or not (FF(M7.UserInputType)) then
                    return
                end
                O7 = true
                T7 = if M7.UserInputType == bF then sF(M7) else _F()
                x7 = M7
                m7(function(a7)
                    if O7 and (a7 - T7).Magnitude > 6 then
                        O7 = false
                    end
                    if not (O7) then
                        Y7(a7)
                    end
                end, function()
                    O7 = false
                end, nil, M7)
            end)
            MF(i7.InputEnded, function(M7)
                if M7 == x7 or x7 and x7.UserInputType == mF and M7.UserInputType == mF then
                    x7 = nil
                    D7(true)
                end
            end)
        end
        t7(N.g:FindFirstChildWhichIsA("Frame"), N.hh, function(G7)
            local i7 = IF()
            local Y7 = HF.gui.AbsoluteSize
            local O7 = N.g.AbsoluteSize
            N.g.Position = A(d(E(G7.X - O7.X * 0.5, 6, w(6, Y7.X - O7.X - 6)) / i7 + 0.5), d(E(G7.Y - 17, 6, w(6, Y7.Y - O7.Y - 6)) / i7 + 0.5))
        end)
        t7(I.g:FindFirstChildWhichIsA("Frame"), I.hh, function(G7)
            local i7 = IF()
            local Y7 = HF.gui.AbsoluteSize
            local O7 = I.g.AbsoluteSize
            I.g.Position = M(E((G7.X + O7.X * 0.5) / Y7.X, O7.X / Y7.X, 1), E((G7.Y - 17) / Y7.Y, 0, w(0, 1 - O7.Y / Y7.Y)))
        end)
        t7(R.g:FindFirstChildWhichIsA("Frame"), R.hh, function(G7)
            local i7 = IF()
            local Y7 = HF.gui.AbsoluteSize
            local O7 = R.g.AbsoluteSize
            R.g.Position = M(E((G7.X + O7.X * 0.5) / Y7.X, O7.X / Y7.X, 1), E((G7.Y - 17) / Y7.Y, 0, w(0, 1 - O7.Y / Y7.Y)))
        end)
        local G7
        if HF.blur then
            local i7, Y7 = pcall(function()
                local O7 = Instance.new("BlurEffect")
                O7.Name = cF.dir .. "_Blur"
                O7.Size = 14
                O7.Enabled = false
                O7.Parent = T
                return O7
            end)
            if i7 then
                G7 = Y7
                HF.bo = G7
            end
        end
        local i7, Y7 = 0, 0
        MF(o.RenderStepped, function(O7)
            if HF.dead then
                return
            end
            i7 += 1
            Y7 += O7
            if Y7 >= 0.25 then
                HF.fps = d(i7 / Y7 + 0.5)
                i7 = 0
                Y7 = 0
                if R.n > 0 then
                    n()
                end
            end
            local T7 = HF.hbg
            for x7 in next, T7, nil do
                if x7.Parent then
                    local p7 = x7:GetAttribute("b_rot") or 0
                    local A7 = x7:GetAttribute("b_spd") or 0
                    if A7 ~= 0 then
                        x7.Rotation = (p7 + tick() * A7) % 360
                    end
                else
                    T7[x7] = nil
                end
            end
        end)
        MF(t.InputBegan, tF)
        MF(t.InputEnded, DF)
        MF(t.InputChanged, jF)
        MF(t.WindowFocusReleased, X)
        local O7 = gethui()
        lF.Parent = O7
        if lF.Parent == nil then
            lF.Parent = h:WaitForChild("PlayerGui")
        end
        _(0.05, function()
            if not (HF.dead) then
                HF.live = true
            end
        end)
        cF:open(mF)
        return D7
    end

    cF.init = cF.window
    return cF
end

return createLibrary()
