local anchored = false
local boat = nil
local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = GetPlayerPed(-1)
        if IsPedInAnyBoat(ped) then
            boat = GetVehiclePedIsIn(ped, true)
        end
        local coords = GetEntityCoords(ped)
        local distanceToBoat = boat and GetDistanceBetweenCoords(coords, GetEntityCoords(boat), true) or 999
        if distanceToBoat < 3.0 and not IsPedInAnyVehicle(ped) then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour jeter/lâcher l'ancre.")
            if IsControlJustPressed(0, 47) and boat ~= nil then
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
        end
        if IsVehicleEngineOn(boat) then
            anchored = false
        end
    end
end)