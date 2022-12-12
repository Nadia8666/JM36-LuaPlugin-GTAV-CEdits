local IsControlPressed = IsControlPressed
return function()
	--[[If Tab Key Pressed and not Alt Key Pressed then]]
	return IsControlPressed(0, 37) and not IsControlPressed(0, 19)
end