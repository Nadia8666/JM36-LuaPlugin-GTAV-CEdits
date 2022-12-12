local GUI = {}
GUI.GUI = {}
GUI.buttonCount = 0
GUI.loaded = false
GUI.selection = 0
GUI.time = 0
GUI.hidden = false

---comment
---@param name string
---@param func any
---@param args any
---@param xmin number
---@param xmax number
---@param ymin number
---@param ymax number
function GUI.addButton(name, func,args, xmin, xmax, ymin, ymax, CustomColor, CustomSelectionColor)
	print("Added Button : "..name )
	GUI.GUI[GUI.buttonCount +1] = {}
	GUI.GUI[GUI.buttonCount +1]["name"] = name
	GUI.GUI[GUI.buttonCount+1]["func"] = func
	GUI.GUI[GUI.buttonCount+1]["args"] = args
	GUI.GUI[GUI.buttonCount+1]["active"] = false
	GUI.GUI[GUI.buttonCount+1]["xmin"] = xmin
	GUI.GUI[GUI.buttonCount+1]["ymin"] = ymin * (GUI.buttonCount + 0.01) +0.02
	GUI.GUI[GUI.buttonCount+1]["xmax"] = xmax 
	GUI.GUI[GUI.buttonCount+1]["ymax"] = ymax 
	GUI.buttonCount = GUI.buttonCount+1
end

--/ edit button text
function GUI.CSEditButtonName(oldname, newname)
	--/ go through all buttons
	for id, settings in ipairs(GUI.GUI) do
		--/ if the button's name is correct name
		if settings["name"] == oldname then
			-- / edit button's name
			GUI.GUI[id]["name"] = newname
		end
	end
end

function GUI.unload()
end
function GUI.init()

	GUI.loaded = true
end
function GUI.tick()
	if(not GUI.hidden)then
		if( GUI.time == 0) then
			GUI.time = GAMEPLAY.GET_GAME_TIMER()
		end
		if((GAMEPLAY.GET_GAME_TIMER() - GUI.time)> 100) then
			GUI.updateSelection()
		end	
		GUI.renderGUI()	
		if(not GUI.loaded ) then
			GUI.init()	 
		end
	end
end

local updb = false
local downdb = false


function GUI.updateSelection() 
	--print(updb, downdb)
	if(IsControlJustPressed(0,187)) then 
		if downdb == false then
			downdb = true
			if(GUI.selection < GUI.buttonCount -1  )then
				GUI.selection = GUI.selection +1
				GUI.time = 0
			end
			JM36.CreateThread(function ()
				JM36.yield()
				downdb = false
			end)
		end
	elseif (IsControlJustPressed(0,188) )then
		if updb == false then
			updb = true
			if(GUI.selection > 0)then
				GUI.selection = GUI.selection -1
				GUI.time = 0
			end
			JM36.CreateThread(function ()
				JM36.yield()
				updb = false
			end)
		end
	elseif (IsControlJustPressed(0, 176)) then
		if(type(GUI.GUI[GUI.selection +1]["func"]) == "function") then
			GUI.GUI[GUI.selection +1]["func"](GUI.GUI[GUI.selection +1]["args"])
		else
			print(type(GUI.GUI[GUI.selection]["func"]))
		end
		GUI.time = 0
	end
	local iterator = 0
	for id, settings in ipairs(GUI.GUI) do
		GUI.GUI[id]["active"] = false
		if(iterator == GUI.selection ) then
			GUI.GUI[iterator +1]["active"] = true
		end
		iterator = iterator +1
	end
end

function GUI.renderGUI()
	 GUI.renderButtons()
end
function GUI.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	GRAPHICS.DRAW_RECT(xMin, yMin,xMax, yMax, color1, color2, color3, color4);
end

function GUI.renderButtons()
	
	for id, settings in pairs(GUI.GUI) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GRAPHICS.GET_SCREEN_RESOLUTION(0, 0)
		boxColor = {255,255,255,100}
		if settings["CustomColor"] then
			boxColor = settings["CustomColor"]
			if settings["active"] then
				boxColor = settings["CustomColorActive"]
			end
		else
			if(settings["active"]) then
				boxColor = {0,242,216,100}
			end
		end
		UI.SET_TEXT_FONT(0)
		UI.SET_TEXT_SCALE(0.0, 0.35)
		UI.SET_TEXT_COLOUR(255, 255, 255, 255)
		UI.SET_TEXT_CENTRE(true)
		UI.SET_TEXT_DROPSHADOW(0, 0, 0, 0, 0)
		UI.SET_TEXT_EDGE(0, 0, 0, 0, 0)
		UI._SET_TEXT_ENTRY("STRING")
		UI._ADD_TEXT_COMPONENT_STRING(settings["name"])
		UI._DRAW_TEXT(settings["xmin"]+ 0.05, (settings["ymin"] - 0.0125 ))
		UI._ADD_TEXT_COMPONENT_STRING(settings["name"])
		GUI.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"], settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
	 end     
end
return GUI