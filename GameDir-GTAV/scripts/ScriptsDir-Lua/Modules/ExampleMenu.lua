--[[
local Menu = require("GUI") -- create menu
local MenuIsOpened = false -- set menu open to false

local function ExampleFunction(ExampleParam)
    print("Hello World!", ExampleParam)
end

Menu.addButton("First Button", ExampleFunction, "ExampleParam1", 0.0, 0.2, 0.05, 0.05)
Menu.addButton("Second Button", ExampleFunction, "ExampleParam2", 0.0, 0.2, 0.05, 0.05)
Menu.addButton("Third Button", ExampleFunction, {}, 0.0, 0.2, 0.05, 0.05)
Menu.addButton("Fourth Button", ExampleFunction, nil, 0.0, 0.2, 0.05, 0.05)

JM36.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 20) then -- if DPAD_Down (Controller) or Z (QWERTY) was just pressed then
            MenuIsOpened = not MenuIsOpened -- Invert menu open/display state boolean
        end
        
        if MenuIsOpened then
            Menu.tick() -- Displays this particular menu lib's menu
        end
        JM36.Wait() -- Wait so we don't endless while true do loop crash ourselves (or well the game)
    end
end)

return{
    stop    =   function()
                    unrequire("GUI") -- destroy menu
                end,
}
]]