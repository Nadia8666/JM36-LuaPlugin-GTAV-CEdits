print("Loading Custom Console")
-- Hardcode settings, custom .ini file from CustomConsoleSettings.ini used laterr
local ConsoleOpen = false
local ConsoleKeybinds = {57}
local Screen = {}
local KeyPress = IsControlJustPressed
local YieldMS = JM36.yield


Screen.X, Screen.Y = GRAPHICS.GET_SCREEN_RESOLUTION(0, 0)

function Rect(xMin, yMin, xMax, yMax, c1, c2, c3, c4)
    GRAPHICS.DRAW_RECT(xMin, yMin,xMax, yMax, c1, c2, c3, c4);
end

function Text(Text, Size, Font, Scale, Scale2)
    UI.SET_TEXT_FONT(Font or 0)
	UI.SET_TEXT_SCALE(Scale or 0.0, Scale2 or 0.35)
	UI.SET_TEXT_COLOUR(255, 255, 255, 255)
	UI.SET_TEXT_CENTRE(true)
	UI.SET_TEXT_DROPSHADOW(0, 0, 0, 0, 0)
	UI.SET_TEXT_EDGE(0, 0, 0, 0, 0)
	UI._SET_TEXT_ENTRY("STRING")
	UI._ADD_TEXT_COMPONENT_STRING(Text)
	UI._DRAW_TEXT(Size[1], Size[2])
	UI._ADD_TEXT_COMPONENT_STRING(Text)
end

function RunCMD(text)
    local cmd = assert(load(text, "chunk", "t"), "Invalid Lua")
    cmd()
end

local MaxLines = 10
local Lines = 0
local StringLines = {}

function Render()
    -- Console Background
    GRAPHICS.DRAW_RECT(0, 0, 2, 1, 0, 0, 0, 200);
    -- Console Bar Background
    GRAPHICS.DRAW_RECT(0, .5175, 2, .035, 0, 0, 0, 220);

    -- BG Text
    Text("Custom Console", {.045, .01}, 2, .5, .5)

    -- Console Bar Text
    Text(" > Hit [F] to type command:", {.09, .5}, 0, .4, .4)

    local LineMaxSize = {2, .45/MaxLines}
    for i,v in ipairs(StringLines) do
       --print(i)
        Text(v, {.045, LineMaxSize[2] * i}, 0, .3, .3)
    end
end

local function NewKeyboardInput(ExampleText, MaxStringLength)

	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght

	--AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
	DisplayOnscreenKeyboard(true, "CELL_EMAIL_BOD", "", ExampleText, "", "", "", MaxStringLength) --Actually calls the Keyboard Input
	local blockinput = true --Blocks new input while typing if **blockinput** is used

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		JM36.yield()
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing

		JM36.yield(300) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		JM36.yield(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
end

function HandleNewLine(NewText)
    if Lines >= MaxLines then
        local NewSL = {}
        for i,v in ipairs(StringLines) do
           if i > 1 then
            NewSL[i-1] = v
           end
        end
        StringLines = NewSL
        Lines = Lines - 1
    end

    StringLines[#StringLines + 1] = NewText
    Lines = Lines + 1
end


JM36.CreateThread(function()
    while true do
        for Index, Keybind in pairs(ConsoleKeybinds) do
            if KeyPress(0, Keybind) then
                ConsoleOpen = not ConsoleOpen
            end
        end

        if ConsoleOpen == true then
            Render()
            if KeyPress(0, 23) then
                local Text = NewKeyboardInput("", 500)
                if Text then
                    HandleNewLine("CMD > ".. Text)
                    RunCMD(Text)
                end
            end
        end

        YieldMS()
    end
end)

local frames = 0
JM36.CreateThread(function() -- debug thread
    while true do
        frames = frames + 1
        HandleNewLine("Seconds: ".. tostring(frames))
        --print(frames)
        YieldMS(1000)
    end
end)

local UIFunctions = {
    PrintLine = function (Text)
        
    end
}

print("Custom Console: Finished Loading")
return{
    UIFunctions,
    stop = function ()
        ConsoleOpen = false
    end
}