if DebugMode and not _G2.ReloadScripts then _G2.ReloadScripts = true
	JM36.CreateThread_HighPriority(function()
		local Info = Info
		local yield = JM36.yield
		
		local Scripts_Init, print, IsControlPressed, get_key_pressed
			= Scripts_Init, print, IsControlPressed, get_key_pressed
		
		while true do
			--[[If Tab Key Pressed and not Alt Key Pressed then]]
			if get_key_pressed(9) and not IsControlPressed(0, 19) then
				print"Reloading Scripts"
				Scripts_Init()
				yield(2499)
			end
			yield()
		end
	end)
end