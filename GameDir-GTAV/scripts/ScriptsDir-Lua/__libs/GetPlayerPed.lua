local _PlayerPedId, _GetPlayerPedScriptIndex = PlayerPedId, GetPlayerPedScriptIndex
local _GetPlayerPed = function(PlayerId)
	return PlayerId ~= -1 and _GetPlayerPedScriptIndex(PlayerId) or _PlayerPedId()
end
GetPlayerPed, GetPlayerPedScriptIndex = _GetPlayerPed, _GetPlayerPed