local DisableMigrator = false





local require = require



--[[ Compatability with existing legacy original LuaPlugin scripts ]]
Keys = require("0A_Compatability-Migrator-LuaPlugin_Legacy\\Keys");keys=Keys
do
	local package_loaded = package.loaded
	Libs = setmetatable({},{
		__mode	=	"kv",
		__index	=	function(Self,Key)
						local Value = package_loaded[Key] or require(Key)
						Self[Key] = Value
						return Value
					end,
	})
end



--[[ Migrate existing legacy original LuaPlugin scripts ]]
if not DisableMigrator then
	local os_remove, os_rename = os.remove, os.rename
	local ExemptA, ExemptB =
	{
		["."] = true,
		[".."] = true,
	},{
		["basemodule.lua"] = true,
		["exampleGUI.lua"] = true,
		["GUI.lua"] = true,
		--["keys.lua"] = true,
		--["utils.lua"] = true,
	}
	
	os_remove("scripts\\keys.lua")
	os_remove("scripts\\utils.lua")
	
	for FileName in lfs.dir("scripts\\addins\\") do
		if not ExemptA[FileName] then
			if not ExemptB[FileName] then
				if not os_rename("scripts\\addins\\"..FileName, Script_Modules..FileName) then
					os_remove("scripts\\addins\\"..FileName)
				end
			else
				os_remove("scripts\\addins\\"..FileName)
			end
		end
	end
	os_remove("scripts\\addins\\")
	
	for FileName in lfs.dir("scripts\\libs\\") do
		if not ExemptA[FileName] then
			if not ExemptB[FileName] then
				if not os_rename("scripts\\libs\\"..FileName, Script_Libs..FileName) then
					os_remove("scripts\\libs\\"..FileName)
				end
			else
				os_remove("scripts\\libs\\"..FileName)
			end
		end
	end
	os_remove("scripts\\libs\\")
end