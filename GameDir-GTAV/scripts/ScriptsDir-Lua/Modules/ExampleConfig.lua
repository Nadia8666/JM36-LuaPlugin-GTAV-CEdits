--[[

-- Modern Examples/Stuff
local config
JM36.CreateThread(function()
	config = configFileRead("SomeConfig.ini")
	while true do
		JM36.Wait(0)
	end
end)
return{
	stop	=	function()
					configFileWrite("SomeConfig.ini", config)
				end,
}

]]



--[[

-- Legacy Examples/Stuff
local config
return {
	init	=	function()
					config = configFileRead("SomeConfig.ini")
				end,
	stop	=	function()
					configFileWrite("SomeConfig.ini", config)
				end,
}

]]