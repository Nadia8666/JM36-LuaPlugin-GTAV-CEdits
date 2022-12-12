local MConf = configFileRead("MainConfig.ini")
if not ScriptsReloadTriggerLoaded then ScriptsReloadTriggerLoaded = true
	JM36.CreateThread_HighPriority(function()
		local Scripts_Init, print = Scripts_Init, print
		
		local ShouldReload = require("0_ReloadScriptsTrigger")
		
		local yield = JM36.yield
		while true do
			if ShouldReload() and MConf.DebugMode == "true" then
				print"Reloading Scripts"
				Scripts_Init()
				yield(1000)
			end
			yield()
		end
	end)
	JM36.CreateThread_HighPriority(function()
		local yield = JM36.yield
		while true do
			MConf = configFileRead("MainConfig.ini")
			yield(3000)
		end
	end)
end
