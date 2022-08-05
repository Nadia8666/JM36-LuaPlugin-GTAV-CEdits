local IsControlPressed, get_key_pressed = IsControlPressed, get_key_pressed
return function()
	--[[If Tab Key Pressed and not Alt Key Pressed then]]
	return get_key_pressed(9) and not IsControlPressed(0, 19)
end