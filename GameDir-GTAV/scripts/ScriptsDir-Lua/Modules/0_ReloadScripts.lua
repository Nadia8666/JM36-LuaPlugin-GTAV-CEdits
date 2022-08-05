if DebugMode then
	JM36.CreateThread(function()
		local Info = Info
		local yield = JM36.yield
		
		if ReloadScripts then
			yield(ReloadScripts - Info.Time)
			ReloadScripts = nil
		end
		
		local Scripts_Init, print, IsControlPressed, get_key_pressed
			= Scripts_Init, print, IsControlPressed, get_key_pressed
		
		while true do
			--[[If Tab Key Pressed and not Alt Key Pressed then]]
			if get_key_pressed(9) and not IsControlPressed(0, 19) then
				ReloadScripts = Info.Time + 2500
				print"Reloading Scripts"
				Scripts_Init()
			end
			yield()
		end
	end)
end