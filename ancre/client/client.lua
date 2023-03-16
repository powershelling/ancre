local anchored = false
local boat = nil
Citizen.CreateThread(function()
	while true do

		Wait(0)
		local ped = GetPlayerPed(-1)
		if IsPedInAnyBoat(ped) then
		boat  = GetVehiclePedIsIn(ped, true)
		end
		if IsControlJustPressed(0, 47) and not IsPedInAnyVehicle(ped) and boat ~= nil then
			if not anchored then
				SetBoatAnchor(boat, true)
				TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Citizen.Wait(10000)
				ClearPedTasks(ped)
			else
				TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				Citizen.Wait(10000)
				SetBoatAnchor(boat, false)
				ClearPedTasks(ped)
			end
			anchored = not anchored
		end
				if IsVehicleEngineOn(boat) then
			anchored = false
		end
	end
end)