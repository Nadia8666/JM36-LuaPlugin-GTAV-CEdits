print("Loading Custom Console")
-- Hardcode settings, custom .ini file from CustomConsoleSettings.ini used laterr
local ConsoleOpen = false
local ConsoleKeybinds = {57}
local Screen = {}
local KeyPress = IsControlJustPressed
local YieldMS = JM36.yield
local MaxLines = 10
local Lines = 0
local StringLines = {}


Screen.X, Screen.Y = GRAPHICS.GET_SCREEN_RESOLUTION(0, 0)

local function Rect(xMin, yMin, xMax, yMax, c1, c2, c3, c4)
    GRAPHICS.DRAW_RECT(xMin, yMin,xMax, yMax, c1, c2, c3, c4);
end

local function Text(Text, Size, Font, Scale, Scale2)
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


local CCLib_Functions = {
   
}
---adds a function to CCLib_Functions for the RunCMD function
---@param FuncName string
---@param Func function
---@param Aliases table
function CCLibAddFunction(FuncName, Func, Aliases)
    CCLib_Functions[FuncName] = Func
    for index, othername in pairs(Aliases) do
        CCLib_Functions[othername] = Func
    end
end


-- .045 , 0, .3, .3

local function NewKeyboardInput(ExampleText, MaxStringLength)
	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLength	-->	Maximum String Length

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

---adds new line to console reg
---@param NewText string
---@param TextParams table | nil
local function HandleNewLine(NewText, TextParams)

    -- Class: TextObject
    -- Contains:
    --          TextString : string
    --          Info : TextInfoTable | Info : {.045, 0, .3, .3}

    local TextObject = {
        TextString = NewText,
        Info = TextParams or nil,
    }
    
    -- Aliases
    TextObject[1] = TextObject.TextString
    TextObject[2] = TextObject.Info

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

    StringLines[#StringLines + 1] = TextObject
    Lines = Lines + 1
end

CCLibAddFunction("help", function ()
    local TXT = "Test... ".. tostring(math.random(1, 100000))
    HandleNewLine(TXT, {.5, 0, .3, .3})
end, {"help()","about()","info()"})

local function RunCMD(text)
    if CCLib_Functions[string.lower(text)] then
        CCLib_Functions[string.lower(text)]()
    else
        local cmd = assert(load(text, "chunk", "t"), "Invalid Lua")
        cmd()
    end
end

local function Render()
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
        if v[2] then -- custom text params
            local Size, Font, Scale, Scale2 = v[2][1], v[2][2], v[2][3], v[2][4] -- readability nightmare >:)
            Text(v[1], {Size, LineMaxSize[2] * i}, Font, Scale, Scale2)
        else
            Text(v[1], {.045, LineMaxSize[2] * i}, 0, .3, .3)
        end
    end
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
                    HandleNewLine("CMD > ".. Text, nil)
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

---CustomConsole Library: https://github.com/Nadia8666/JM36-LuaPlugin-GTAV-CEdits/blob/Script-Docs/Docs_CustomConsole.md
CustomConsole = {}

---Prints a line to CCLib' Visual Console
---@param Text string
---@param CustomSizing table | nil
function CustomConsole:PrintLine(Text, CustomSizing)
    HandleNewLine(Text, CustomSizing)
end

print("Custom Console: Finished Loading")
return{
    stop = function ()
        ConsoleOpen = false
    end
}