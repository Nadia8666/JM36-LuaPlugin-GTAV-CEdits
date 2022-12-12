if DebugMode and not ScriptsReloadTriggerLoaded then ScriptsReloadTriggerLoaded = true
	JM36.CreateThread_HighPriority(function()
		local Scripts_Init, print = Scripts_Init, print
		
		local ShouldReload = require"0_ReloadScriptsTrigger"
		
		local yield = JM36.yield
		while true do
			if ShouldReload() then
				print"Reloading Scripts"
				Scripts_Init()
				yield(2499)
			end
			yield()
		end
	end)
end
