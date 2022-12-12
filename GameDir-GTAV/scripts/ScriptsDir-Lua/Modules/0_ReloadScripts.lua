if not ScriptsReloadTriggerLoaded then ScriptsReloadTriggerLoaded = true
	JM36.CreateThread_HighPriority(function()
		local Scripts_Init, print = Scripts_Init, print
		
		local ShouldReload = require"0_ReloadScriptsTrigger"
		local MConf = require("MainConfig.lua")
		
		local yield = JM36.yield
		while true do
			if ShouldReload() and MConf.DebugMode == false then
				print"Reloading Scripts"
				Scripts_Init()
				yield(2499)
			end
			unrequire("MainConfig.lua")
			yield()
		end
	end)
end
