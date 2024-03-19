local anchored = false
local boat = nil
local ESX = nil
local ped = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while true do
        Citizen.Wait(0)
        ped = GetPlayerPed(-1)

        if IsPedInAnyBoat(ped) then
            boat = GetVehiclePedIsIn(ped, true)
        elseif boat ~= nil then
            if GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(boat), true) > 3.0 or not DoesEntityExist(boat) then
                boat = nil
            end
        end

        if boat ~= nil and not IsPedInAnyVehicle(ped) then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour jeter/lâcher l'ancre.")
            if IsControlJustPressed(0, 47) then
                TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                Citizen.Wait(1000)

                if not anchored then
                    SetBoatAnchor(boat, true)
                else
                    SetBoatAnchor(boat, false)
                end

                anchored = not anchored
                Citizen.Wait(9000)
                ClearPedTasks(ped)
            end
        end

        if IsVehicleEngineOn(boat) then
            anchored = false
        end
    end
end)
