-- file used when working on code changes for -master branch--
local FunctionForOccurenceType = setmetatable({
	["nil"] = function(configFile, text --[[, occurence]])
		local RetVal
		for line in configFile:lines() do
			if line:find(text) then
				RetVal = line
			end
		end
		return RetVal
	end,
	["number"] = function(configFile, text, occurence)
		local RetVal
		local OccurenceCurrent = 0
		for line in configFile:lines() do
			if line:find(text) then
				RetVal = line
				OccurenceCurrent = OccurenceCurrent + 1
				if OccurenceCurrent == occurence then
					break
				end
			end
		end
		return RetVal, OccurenceCurrent ~= occurence and OccurenceCurrent -- Second return is truthy "failed"; second return will be "false" if we found and returned the requested occurence, otherwise will be the occurence number.
	end,
	["boolean"] = function(configFile, text --[[, occurence]])
		local RetVal = {}
		local OccurenceCurrent = 0
		for line in configFile:lines() do
			if line:find(text) then
				OccurenceCurrent = OccurenceCurrent + 1
				RetVal[OccurenceCurrent] = line
			end
		end
		return RetVal
	end},
    {
	__index = function(Self --[[, Key]])
		return Self["nil"]
	end,
})
function configFileFindLineFromText(file, text, occurence)
	local configFile = assert(io_open(Scripts_Path .. file, "r"), "Invalid File Path")
	local line, failed = FunctionForOccurenceType[type(occurence)](configFile, text, occurence)
	configFile:close()
	return line, failed
end