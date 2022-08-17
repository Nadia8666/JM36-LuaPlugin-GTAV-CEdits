local IsDisabledControlPressed = IsDisabledControlPressed
local function _IsDisabledControlReleased(...)
	return not IsDisabledControlPressed(...)
end
IsDisabledControlReleased = _IsDisabledControlReleased
return IsDisabledControlReleased