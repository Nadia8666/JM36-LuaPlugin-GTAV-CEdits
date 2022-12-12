local GetEntityCoords, GetEntitySpeedVector
	= GetEntityCoords, GetEntitySpeedVector
local math_abs = math.abs

local Info = Info
local Player = Info.Player
local Vehicle = Player.Vehicle
local yield = JM36.yield

local TrackDistance, TrackWidth, CruiseControlSpeed, _CruiseControlSpeed

JM36.CreateThread(function()
	local GetOffsetFromEntityInWorldCoords, GetEntityVelocity, StartShapeTestSweptSphere, GetShapeTestResult, DoesEntityExist, GetDistanceBetweenCoords
		= GetOffsetFromEntityInWorldCoords, GetEntityVelocity, StartShapeTestSweptSphere, GetShapeTestResult, DoesEntityExist, GetDistanceBetweenCoords
	
	local DummyV3 = GetEntityCoords(0,false)
	local LastCollidedEntityHandle = 0
	local PlayerCoords_x, PlayerCoords_y, PlayerCoords_z, EndCoords_x, EndCoords_y, EndCoords_z
	while true do
		if CruiseControlSpeed then
			local Vehicle_Id = Vehicle.Id
			do
				local PlayerCoords = Player.Coords
				PlayerCoords_x, PlayerCoords_y, PlayerCoords_z = PlayerCoords.x, PlayerCoords.y, PlayerCoords.z
			end
			do
				local EndCoords = GetOffsetFromEntityInWorldCoords(Vehicle_Id, 0.0, TrackDistance, 0.0)
				local VehicleVelocity = GetEntityVelocity(Vehicle_Id)
				EndCoords_x, EndCoords_y, EndCoords_z = EndCoords.x + VehicleVelocity.x, EndCoords.y + VehicleVelocity.y, EndCoords.z + VehicleVelocity.z
			end
			
			local ShapeTestHandle = StartShapeTestSweptSphere(PlayerCoords_x, PlayerCoords_y, PlayerCoords_z, EndCoords_x, EndCoords_y, EndCoords_z, TrackWidth, 2, Vehicle_Id, 0)
			
			--DrawLine(PlayerCoords_x, PlayerCoords_y, PlayerCoords_z, EndCoords_x, EndCoords_y, EndCoords_z, 255, 255, 255, 255)
			
			local Status, Collided, EntityHandle = GetShapeTestResult(ShapeTestHandle, 0,DummyV3,DummyV3,0)
			while Status == 1 or not Status do
				yield()
				Status, Collided, EntityHandle = GetShapeTestResult(ShapeTestHandle, 0,DummyV3,DummyV3,0)
			end
			if Status == 2 then
				if Collided == 1 then
					LastCollidedEntityHandle = EntityHandle
					_CruiseControlSpeed = GetEntitySpeedVector(EntityHandle, true).y
					_CruiseControlSpeed = math_abs(_CruiseControlSpeed) > 1.5 and _CruiseControlSpeed or 0.0
				else
					if not DoesEntityExist(LastCollidedEntityHandle) then
						_CruiseControlSpeed = false
					else
						local LastCollidedEntityCoords = GetEntityCoords(LastCollidedEntityHandle,false)
						if GetDistanceBetweenCoords(PlayerCoords_x, PlayerCoords_y, PlayerCoords_z, LastCollidedEntityCoords.x, LastCollidedEntityCoords.y, LastCollidedEntityCoords.z, false) > TrackDistance*1.5 then
							_CruiseControlSpeed = false
							LastCollidedEntityHandle = 0
						else
							_CruiseControlSpeed = GetEntitySpeedVector(EntityHandle, true).y
							_CruiseControlSpeed = math_abs(_CruiseControlSpeed) > 1.5 and _CruiseControlSpeed or 0.0
						end
					end
				end
			end
		end
		yield()
	end
end)

JM36.CreateThread(function()
	local SetControlNormal, math_min
		= SetControlNormal, math.min
	
	local ControlJustPressed = coroutine.wrap(function()
		local IsUsingKeyboard, IsControlJustPressed, IsControlPressed
			= IsUsingKeyboard, IsControlJustPressed, IsControlPressed
		
		local ToggleKey = tonumber(configFileRead("Vehicle_CruiseControl_Traditional.ini").ToggleKey or 305) or 305
		local NotUsingDefault = ToggleKey ~= 73
		local coroutine_yield = coroutine.yield
		while true do
			if not IsUsingKeyboard(2) then
				coroutine_yield(IsControlJustPressed(2, ToggleKey) and not (NotUsingDefault or IsControlPressed(27, 68)))
			else
				coroutine_yield(IsControlJustPressed(2, ToggleKey))
			end
		end
	end)
	
	local VehicleEligible, LastVehicle
	while true do
		if Vehicle.IsIn then
			if Vehicle.Id ~= LastVehicle and Vehicle.IsOp then
				LastVehicle = Vehicle.Id
				do
					local dMin, dMax = GetEntityCoords(0,false), GetEntityCoords(0,false)
					GetModelDimensions(Vehicle.Model, dMin, dMax)
					TrackDistance = (dMax.y - dMin.y)*0.75
					TrackWidth = (dMax.x - dMin.x)*0.75
				end
				local Vehicle_Type = Vehicle.Type
				VehicleEligible = not (Vehicle_Type.Heli or Vehicle_Type.Plane)
			end
			
			if VehicleEligible and Vehicle.IsOp then
				if ControlJustPressed() then
					CruiseControlSpeed = not CruiseControlSpeed and GetEntitySpeedVector(LastVehicle, true).y
				end
				if CruiseControlSpeed then
					local __CruiseControlSpeed = _CruiseControlSpeed or CruiseControlSpeed
					local CurrentSpeed = GetEntitySpeedVector(LastVehicle, true).y
					local SpeedDifference = math_abs(__CruiseControlSpeed-CurrentSpeed)
					if SpeedDifference > 1.5 then
						SetControlNormal
						(
							27,
							CurrentSpeed > __CruiseControlSpeed and 72 or 71,
							math_min(SpeedDifference/4, 1.0)
						)
					end
				end
			end
		elseif CruiseControlSpeed then
			CruiseControlSpeed = false
		end
		yield()
	end
end)