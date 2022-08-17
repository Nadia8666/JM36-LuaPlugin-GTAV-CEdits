--[[

-- Modern Examples/Stuff


-- Creates a thread, prints "Hello World!" once, and then terminates thread
JM36.CreateThread(function()
	print("Hello World!")
end)


-- Creates a thread, prints "Hello World!" forever (for as long as that thread is running for)
JM36.CreateThread(function()
	while true do
		JM36.Wait(0)
	end
end)

]]



--[[

-- Legacy Examples/Stuff


return {
	init	=	nil or function()
					--Stuff that runs only once, on startup of the script
				end,
	loop	=	nil or function(Info)
					--Stuff that runs/loops every frame
				end,
	stop	=	nil or function()
					--Stuff that runs only once, on shutdown of the script
				end,
}

]]