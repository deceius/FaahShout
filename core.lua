if faah_IsEnabled == nil then faah_IsEnabled = true end
local lastShout, SHOUT_COOLDOWN, SOUND = 0, 3, "Interface\\AddOns\\FaahShout\\assets\\faah.wav"
local pending

SLASH_FAAH1 = "/faah"
SlashCmdList["FAAH"] = function()
    faah_IsEnabled = not faah_IsEnabled
    local status = faah_IsEnabled and "|cff00ff00Enabled|r" or "|cffff0000Disabled|r"
    DEFAULT_CHAT_FRAME:AddMessage("|cff0000ff[FAAAAH!!]|r: " .. status)
end

local function OnEvent()
    if event == "SPELLCAST_STOP" and pending and faah_IsEnabled then
        local now = GetTime()
        if (now - lastShout) >= SHOUT_COOLDOWN then
            -- DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[FAAAAH!!]|r: " .. pending)
            PlaySoundFile(SOUND)
            lastShout = now
        end
    end
    pending = nil
end

local function Track(name)
    if name and string.find(string.lower(name), "shout") then pending = name end
end

local _CSBN = CastSpellByName
CastSpellByName = function(n, s) Track(n) _CSBN(n, s) end

local _CS = CastSpell
CastSpell = function(i, b) Track(GetSpellName(i, b)) _CS(i, b) end

local _UA = UseAction
UseAction = function(s, c, self)
    if HasAction(s) then
        GameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
        GameTooltip:SetAction(s)
        Track(GameTooltipTextLeft1:GetText())
        GameTooltip:Hide()
    end
    _UA(s, c, self)
end

local f = CreateFrame("Frame")
f:RegisterEvent("SPELLCAST_STOP")
f:RegisterEvent("SPELLCAST_FAILED")
f:RegisterEvent("SPELLCAST_INTERRUPTED")
f:SetScript("OnEvent", OnEvent)