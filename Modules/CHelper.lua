print("CHelper : Init")
--[[/ 
// you can do stuff like:
// local print = print
// to fast-load functions for performance improvements if required
]]

--[[
useful links
https://pastebin.com/K9adDsu4
https://docs.fivem.net/natives/?_0x2AFE52F782F25775
https://docs.fivem.net/docs/game-references/controls/
]]

local Abbs = {
    ConfFile = {
        Write = configFileWrite,
        WriteLine = configFileWriteLine,
        Read = configFileRead,
        GetLine = configFileFindLineFromText,
    },
}

-- / customize depending on location
local task = {}

function task.spawn(func)
    local corot = coroutine.create(func)
    return coroutine.resume(corot)
end

--/ use JM36.yield() to wait for next frame
--/ JM36.CreateThread is a required function to start code, also async threads are cool
local Framecount = 0

local Menu = require("GUI")
local GenPlate = require("GenPlate")
local MenuOpen = false

local function KeyboardInput(TextEntry, ExampleText, MaxStringLength, CallbackFunction, CustomMessage)

	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght

	--AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", ExampleText, "", "", "", MaxStringLength) --Actually calls the Keyboard Input
	local blockinput = true --Blocks new input while typing if **blockinput** is used

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		JM36.yield()
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing


        if CustomMessage then
            task.spawn(function ()
                if CallbackFunction then
                    CallbackFunction(result)
                end
            end)
            local handle = RegisterPedheadshot(Info.Player.Ped)
            while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
                JM36.yield()
            end
            local txd = GetPedheadshotTxdString(handle)
        
            -- Add the notification text
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName(CustomMessage.String)
            --[[
            Title = "Saving Data",
            Subtitle = "*CHelper*",
            String = "",
            ]]
            -- Set the notification icon, title and subtitle.
            local title = CustomMessage.Title
            local subtitle = CustomMessage.Subtitle
            local iconType = 0
            local flash = false -- Flash doesn't seem to work no matter what.
            EndTextCommandThefeedPostMessagetext(txd, txd, flash, iconType, title, subtitle)
        
            -- Draw the notification
            local showInBrief = true
            local blink = false -- blink doesn't work when using icon notifications.
            EndTextCommandThefeedPostTicker(blink, showInBrief)
            
            -- Cleanup after yourself!
            UnregisterPedheadshot(handle)
            BeginTextCommandThefeedPost("")
            AddTextComponentSubstringPlayerName(CustomMessage.String)
            EndTextCommandThefeedPostTicker(true, true)
        end

		JM36.yield(3500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		JM36.yield(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
end


---comment
---@param WindowArguments table WindowType, WindowCallback
function OpenNewWindow(WindowArguments)
    local Wtype = WindowArguments.WindowType
    local WTable = {
        ["TextPrompt"] = function ()
            local Text = KeyboardInput(WindowArguments.TextStats.WindowName, WindowArguments.TextStats.DefaultText, WindowArguments.TextStats.MaxLength, WindowArguments.WindowCallback, WindowArguments.CustomMessage)
        end,
    }
    if WTable[Wtype] then  WTable[Wtype]() end
end

Menu.addButton("Change Plate Text", OpenNewWindow, 
{
    WindowType = "TextPrompt",
    WindowCallback = function (SaveData)
        task.spawn(function ()
           --/ Get old config
           local CurrentConfig = "LicenseText=".. SaveData
           --/ save new plate info
           local SaveLine = Abbs.ConfFile.GetLine("Configs\\CHelper.ini", "LicenseText=")
   
           if SaveLine then Abbs.ConfFile.WriteLine("Configs\\CHelper.ini", SaveLine, CurrentConfig) end
        end)
    end,
    TextStats = {
        WindowName = "New License Plate Text",
        DefaultText = "",
        MaxLength = 8,
    },
    CustomMessage = {
        Title = "Saving Data",
        Subtitle = "*CHelper*",
        String = "Saving license plate data...",
    },
},
.01, .23, 0.03, 0.03)

local Config = Abbs.ConfFile.Read("Configs\\CHelper.ini")
local AutoChagnerEnabled = Config.AutoChangeLicense 
local TitleString = "err"
if AutoChagnerEnabled == "0" then
    TitleString = "Enable LAC"
elseif AutoChagnerEnabled == "1" then
    TitleString = "Disable LAC"
end

local LACDB = false
local function ChangeLac()
    if LACDB then return end
    JM36.CreateThread(function ()
        print("Running Instance", LACDB)
        if LACDB == true then return end
        LACDB = true
       
        local Config = Abbs.ConfFile.Read("Configs\\CHelper.ini")
        print(Config.AutoChangeLicense)
        local LicenseLine = Abbs.ConfFile.GetLine("Configs\\CHelper.ini", "AutoChangeLicense=")
        if Config.AutoChangeLicense == "1" then
            if LicenseLine then
                Abbs.ConfFile.WriteLine("Configs\\CHelper.ini", LicenseLine, "AutoChangeLicense=0")
                SetVehicleNumberPlateText(Info.Player.Vehicle.Id, GenPlate.GenerateRandomPlate(8, 4))
            end
        elseif Config.AutoChangeLicense == "0" then
            if LicenseLine then
                Abbs.ConfFile.WriteLine("Configs\\CHelper.ini", LicenseLine, "AutoChangeLicense=1")
            end
        end
        JM36.yield(20)
        LACDB = false
    end)
end

Menu.addButton(TitleString, ChangeLac, {"TextPrompt", nil}, .01, .23, 0.03, 0.03)
Menu.addButton("fix car", function()
    --SetVehicleDamage(Info.Player.Vehicle.Id, 0 --[[ number ]], 0 --[[ number ]], 0 --[[ number ]], 0 --[[ number ]], 20 --[[ number ]], true --[[ boolean ]])
    SetVehicleFixed(Info.Player.Vehicle.Id)
    SetVehicleEngineHealth(Info.Player.Vehicle.Id, 1000)
end,
 {"TextPrompt", nil}, .01, .23, 0.03, 0.03)



local PedConversionInfo = {
    [689418] = 0, -- Micheal
    [71180] = 2, -- Franklin
    [2] = 1, -- Trevor
}



JM36.CreateThread(function ()
    --StartNewScript("cellphone_controller", 31000)
    --/ Split up ui stepping and game stepping for easier code management
    local function SteppedUI()
        local Config = Abbs.ConfFile.Read("Configs\\CHelper.ini")
        
        if MenuOpen then
            if Config.AutoChangeLicense == "0" then
                Menu.CSEditButtonName("Disable LAC", "Enable LAC")
            elseif Config.AutoChangeLicense == "1" then
                Menu.CSEditButtonName("Enable LAC", "Disable LAC")
            end
            DisableControlAction(0, 27, true)
        end

        if IsControlJustPressed(0, 289) then -- if DPAD_Down (Controller) or Z (QWERTY) was just pressed then
            if IsPedRunningMobilePhoneTask(Info.Player.Ped) then -- is phone open
                
            else -- phone closed
                MenuOpen = not MenuOpen -- Invert menu open/display state boolean
                if MenuOpen == false then
                    
                    --while not HasScriptLoaded("cellphone_controller") or not HasScriptLoaded("cellphone_flashhand")  do
                        --RequestScript("cellphone_flashhand")
                        --RequestScript("cellphone_controller")
                      --  JM36.yield()
                    --end
                    --StartNewScript("cellphone_flashhand", 1424)
                    --StartNewScript("cellphone_controller", 31000) -- start new phone script when menu closes, idk what the stack size should be lol
                   -- EnableControlAction(0, 173, true)
                else
                    --TerminateAllScriptsWithThisName("cellphone_flashhand") -- kill phone script
                end
            end
        end
        if MenuOpen  and Config.UIEnabled == "1" then
            Menu.tick()
            Menu.updateSelection()
        end
    end

    local function Stepped()
        --local value = GetMobilePhoneRenderId()
        --IsPedRunningMobilePhoneTask(Info.Player.Ped)
        
        --print(CanPhoneBeSeenOnScreen())
        Framecount = Framecount + 1
       
        --print("Ped: ", Info.Player.Ped)

        local Config = Abbs.ConfFile.Read("Configs\\CHelper.ini")
        local Cartext = Config.LicenseText or "TESTDEB"

        if Config.DebugFrames == "1" then
            print("frame loaded: ".. tostring(Framecount))
        end
        if Config.DebugINI == "1" then
            for i,v in pairs(Config) do
                print(i, " : ", v)
            end
        end

        local isbike = Info.Player.Vehicle.Type.Bike
        local iscar = Info.Player.Vehicle.Type.Car
        local isplane = Info.Player.Vehicle.Type.Plane
        local isheli = Info.Player.Vehicle.Type.Heli

        function ChangePlate()
            local CurrentVehicle = Info.Player.Vehicle.Id
            SetVehicleNumberPlateText(CurrentVehicle, Cartext)
        end

        if Info.Player.Vehicle.IsIn then
            if Config.AutoChangeLicense == "1" then
                if Config.BikeSupport == "1" and isbike then
                    ChangePlate()
                end
                if Config.CarSupport == "1" and iscar then
                    ChangePlate()
                end
                if Config.CountPlaneAndHelicopterAsOne == "1" then
                    if (Config.PlaneSupport == "1" or Config.HeliSupport == "1") and (isheli or isplane) then
                        ChangePlate()
                    end
                else
                    if Config.PlaneSupport == "1" and isplane then
                        ChangePlate()
                    end
                    if Config.HeliSupport == "1" and isheli then
                        ChangePlate()
                    end
                end
            end
        end
    end

    while true do
        if MenuOpen then
            CellCamActivateSelfieMode(false)
        end

        Stepped()
        SteppedUI()
        JM36.yield()
    end
end)

return {
    stop = function ()
        unrequire("GUI")
        unrequire("GenPlate")
    end
}