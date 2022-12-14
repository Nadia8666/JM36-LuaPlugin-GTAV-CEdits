-- burnout boost script
local BurnoutBoostVersion = "1.0.0"
local function clamp(value, min, max)
    if value > max then
        value = max
    elseif value < min then
        value = min
    end
    return value
end
JM36.CreateThread(function()
    while true do

        if IsControlPressed(0, 32) and IsControlPressed(0, 33) then
           if Info.Player.Vehicle.IsIn then
                local HeldFrames = 0
                CustomConsole:PrintLine("StartedBurnout")
                while IsControlPressed(0, 32) and IsControlPressed(0, 33) do
                    JM36.yield()
                    HeldFrames = HeldFrames + 20
                end
                local Config = configFileRead("Configs\\BurnoutBoostConfig.ini")
                CustomConsole:PrintLine("BurnoutEnded")
                if Info.Player.Vehicle.IsIn then
                    local Coords = GetEntityCoords(Info.Player.Vehicle.Id, false)
                    CustomConsole:PrintLine(tostring(HeldFrames))
                    local TMulti = tonumber(Config.BoostDivider or 1000)
                    HeldFrames = clamp(HeldFrames, 5, tonumber(Config.MaximumBoostValue or 1000))
                    if HeldFrames >= (tonumber(Config.BoostFrameMinimum) or 500) then -- held for at least 2 seconds
                        ApplyForceToEntityCenterOfMass(
                        Info.Player.Vehicle.Id, 
                        1, 
                        0, 
                        Coords.y * (clamp(HeldFrames / TMulti, 5, 5000000)), 
                        0, 
                        .001, 
                        true, 
                        true, 
                        true
                    )
                end
            end
           end
        end

        JM36.yield()
    end
end)