--[[
-- used to debug the config system
JM36.CreateThread(function ()
    local originalconfigtext = "findme=yes"

    local file = io:write("testconfig.ini", "findme=yes")

    local ali = {"e", "f", "nig"}
    local ali2 = {
        [1] = "hi",
        [2] = "yo",
    }
    print(#ali, #ali2)
    print("starting debug")
    print(configFileFindLineFromText)
    local Line = configFileFindLineFromText("testconfig.ini", "findme")
    if Line then
        configFileWriteLine("testconfig.ini", Line, "findme=yes")
    end
    print("Done", Line )
end)]]