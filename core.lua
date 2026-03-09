local f = CreateFrame("Frame")
local lastPlayed = 0
local cooldown = 5

f:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
f:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")

f:SetScript("OnEvent", function()
    if arg1 and string.find(arg1, "Shout") then
        local now = GetTime()

        if now - lastPlayed >= cooldown then
            PlaySoundFile("assets\\faah.wav")
            lastPlayed = now
        end
    end
end)