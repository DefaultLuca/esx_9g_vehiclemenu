ESX = nil
local windowstatus  = { [0] = false, [1] = false, [2] = false, [3] = false }
local indicatorstatus = { [0] = false, [1] = false }
local internallightstatus = false
local externallightstatus = false
local helisearchlightstatus = false
local helitarget = nil
local extrasstatus = { [1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false, [7] = false, [8] = false, [9] = false }

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ShowVehicleMenu()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehiclemenu',
    {
        title       = _U('vehiclemenu'),
        align       = 'bottom-right',
        elements    = {
            { label = _U('engine'), value = 'engine' },
            { label = _U('locksystem'), value = 'locksystem' },
            { label = _U('trunk'), value = 'trunk' },
            { label = _U('hood'), value = 'hood' },
            { label = _U('doors'), value = 'doors' },
            { label = _U('windows'), value = 'windows' },
            { label = _U('indicatorleft'), value = 'indicatorleft' },
            { label = _U('indicatorright'), value = 'indicatorright' },
            { label = _U('internallight'), value = 'internallight' },
            { label = _U('externallight'), value = 'externallight' },
            { label = _U('helisearchlight'), value = 'helisearchlight' },
            { label = _U('extras'), value = 'extras' }
        }
    }, 
    function(data, menu)
        if data.current.value then
            if data.current.value == 'engine' then
                TriggerEvent('9g_extratools:EngineToggle')
                menu.close()
            elseif data.current.value == 'locksystem' then
                TriggerEvent('ls:togglelock')
                menu.close()
            elseif data.current.value == 'trunk' then
                ToggleVehicleDoorsDriver(5)
            elseif data.current.value == 'hood' then
                ToggleVehicleDoorsDriver(4) 
            elseif data.current.value == 'doors' then

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'doorsmenu',
                {
                    title   = _U('doors'),
                    align   = 'bottom-right',
                    elements = {
                        { label = _U('doors')..' 1', value = 1 },
                        { label = _U('doors')..' 2', value = 2 },
                        { label = _U('doors')..' 3', value = 3 },
                        { label = _U('doors')..' 4', value = 4 },
                        { label = _U('doors')..' '.._('all'), value = 'all' }
                    }
                },
                function(data2, menu2)
                    if data2.current.value then
                        if data2.current.value == 1 then
                            ToggleVehicleDoors(0)
                        elseif data2.current.value == 2 then
                            ToggleVehicleDoors(1)
                        elseif data2.current.value == 3 then
                            ToggleVehicleDoors(2)
                        elseif data2.current.value == 4 then
                            ToggleVehicleDoors(3)
                        elseif data2.current.value == 'all' then
                            ToggleVehicleDoorsDriver(0)
                            ToggleVehicleDoorsDriver(1)
                            ToggleVehicleDoorsDriver(2)
                            ToggleVehicleDoorsDriver(3)
                        end
                    end
                end,
                function(data2, menu2)
                    menu2.close()
                end)

            elseif data.current.value == 'windows' then

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'windowsmenu',
                {
                    title   = _U('windows'),
                    align   = 'bottom-right',
                    elements = {
                        { label = _U('windows')..' 1', value = 1 },
                        { label = _U('windows')..' 2', value = 2 },
                        { label = _U('windows')..' 3', value = 3 },
                        { label = _U('windows')..' 4', value = 4 },
                        { label = _U('windows')..' '.._('all'), value = 'all' }
                    }
                },
                function(data2, menu2)
                    if data2.current.value then
                        if data2.current.value == 1 then
                            ToggleVehicleWindows(0)
                        elseif data2.current.value == 2 then
                            ToggleVehicleWindows(1)
                        elseif data2.current.value == 3 then
                            ToggleVehicleWindows(2)
                        elseif data2.current.value == 4 then
                            ToggleVehicleWindows(3)
                        elseif data2.current.value == 'all' then
                            ToggleVehicleWindowsDriver(0)
                            ToggleVehicleWindowsDriver(1)
                            ToggleVehicleWindowsDriver(2)
                            ToggleVehicleWindowsDriver(3)
                        end
                    end
                end,
                function(data2, menu2)
                    menu2.close()
                end)

            elseif data.current.value == 'indicatorleft' then
                ToggleVehicleIndicators(1)
            elseif data.current.value == 'indicatorright' then
                ToggleVehicleIndicators(0)
            elseif data.current.value == 'internallight' then
                ToggleVehicleInternalLight()
            elseif data.current.value == 'externallight' then
                ToggleVehicleExternalLight()
            elseif data.current.value == 'helisearchlight' then
                ToggleHeliSearchLight()
            elseif data.current.value == 'extras' then

                ESX.TriggerServerCallback('9g_vehiclemenu:getPlayerGroup', function(group)

                    if group == 'admin' or group == 'superadmin' then
                        local playerped = GetPlayerPed(-1)
                        if IsPedInAnyVehicle(playerped, false) then
                            local vehicle   = GetVehiclePedIsUsing(playerped)
                            local i = 1
                            local elements = {}
                            for i = 1, 9, 1 do
                                if DoesExtraExist(vehicle, i) then
                                    table.insert(elements, { label = _U('extras')..' '..i, value = i })
                                end
                            end
                            if #elements == 0 then
                                table.insert(elements, { label = _U('noextras') })
                            end
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extrasmenu',
                            {
                                title   = _U('extras'),
                                align   = 'bottom-right',
                                elements = elements
                            },
                            function(data2, menu2)
                                if data2.current.value then
                                    if extrasstatus[data2.current.value] == true then
                                        SetVehicleExtra(vehicle, data2.current.value, false)
                                    else
                                        SetVehicleExtra(vehicle, data2.current.value, true)
                                    end
                                    extrasstatus[data2.current.value] = not extrasstatus[data2.current.value]
                                else
                                    menu2.close()
                                end
                            end,
                            function(data2, menu2)
                                menu2.close()
                            end)
                        else
                            ESX.ShowNotification(_U('not_vehicle'))
                        end
                    else
                        ESX.ShowNotification(_U('no_permission'))
                    end

                end)

            end
        end
    end, 
    function(data, menu)
        menu.close()
    end)

end

-- dev -- Target heli search light to the closest vehicle
function TargetHeliSearchLight()
    local playerped = GetPlayerPed(-1)

    --NetworkOverrideClockTime(00, 00, 00) -- set midnight for testing
    
    if IsPedInAnyVehicle(playerped, false) then
        local vehicle   = GetVehiclePedIsUsing(playerped)
        local coords = GetEntityCoords(playerped)
        --local helitarget = ESX.Game.GetClosestVehicle(playercoords)
        local helitarget = GetClosestVehicle(coords.x, coords.y, coords.z-5, 50.0, 0, 71)

        --print(vehicle, helitarget)

        SetMountedWeaponTarget(vehicle, 0, helitarget, 0.0, 0.0, 0.0) -- should work, otherwise DRAWSPOTLIGHT solution
        --     shootingPed --[[ Ped ]], 
        --     targetPed --[[ Ped ]], 
        --     targetVehicle --[[ Vehicle ]], 
        --     x --[[ number ]], 
        --     y --[[ number ]], 
        --     z --[[ number ]]

    else
        ESX.ShowNotification(_U('not_vehicle'))
    end

end


-- Toggle heli search light only if in the driver seat
function ToggleHeliSearchLight()
    local playerped = GetPlayerPed(-1)

  if IsPedInAnyVehicle(playerped, false) then  
        local vehicle   = GetVehiclePedIsUsing(playerped)
        if GetPedInVehicleSeat(vehicle, -1) == playerped then
            if helisearchlightstatus == true then
                SetVehicleSearchlight(vehicle, false, false)
            else
                SetVehicleSearchlight(vehicle, true, false)
            end
            helisearchlightstatus = not helisearchlightstatus
        else
            ESX.ShowNotification(_U('not_driverseat'))
        end
    else
        ESX.ShowNotification(_U('not_vehicle'))
    end
end

-- Toggle external light only if in the driver seat
function ToggleVehicleExternalLight()
    local playerped = GetPlayerPed(-1)

    if IsPedInAnyVehicle(playerped, false) then
        local vehicle   = GetVehiclePedIsUsing(playerped)
        if GetPedInVehicleSeat(vehicle, -1) == playerped then
            if externallightstatus == true then
                SetVehicleLights(vehicle, 1)
                print("emm?", externallightstatus)
            else
                SetVehicleLights(vehicle, 2)
            end
            externallightstatus = not externallightstatus

        else
            ESX.ShowNotification(_U('not_driverseat'))
        end
    else
        ESX.ShowNotification(_U('not_vehicle'))
    end
end

-- Toggle internal light only if in the driver seat
function ToggleVehicleInternalLight()
    local playerped = GetPlayerPed(-1)

    if IsPedInAnyVehicle(playerped, false) then
        local vehicle   = GetVehiclePedIsUsing(playerped)
        if GetPedInVehicleSeat(vehicle, -1) == playerped then
            if internallightstatus == true then
                SetVehicleInteriorlight(vehicle, false)
                SetVehicleSearchlight(vehicle, false, false) --search light only for heli, only night time
            else
                SetVehicleInteriorlight(vehicle, true)
                SetVehicleSearchlight(vehicle, true, false)
            end
            internallightstatus = not internallightstatus
        else
            ESX.ShowNotification(_U('not_driverseat'))
        end
    else
        ESX.ShowNotification(_U('not_vehicle'))
    end
end

-- Toggle indicators only if in the driver seat
function ToggleVehicleIndicators(indicator)
    local playerped = GetPlayerPed(-1)
    local indicator      = indicator

    if IsPedInAnyVehicle(playerped, false) then
        local vehicle   = GetVehiclePedIsUsing(playerped)
        if GetPedInVehicleSeat(vehicle, -1) == playerped then
            if indicatorstatus[indicator] == true then
                SetVehicleIndicatorLights(vehicle, indicator, false)
            else
                SetVehicleIndicatorLights(vehicle, indicator, true)
                PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
            end
            indicatorstatus[indicator] = not indicatorstatus[indicator]
        else
            ESX.ShowNotification(_U('not_driverseat'))
        end
    else
        ESX.ShowNotification(_U('not_vehicle'))
    end
end

-- Toggle windows only if in the relative seat or driver seat
function ToggleVehicleWindows(window)
    local playerped = GetPlayerPed(-1)
    local window    = window
    
    if IsPedInAnyVehicle(playerped, false) then
        local vehicle   = GetVehiclePedIsUsing(playerped)
        if GetVehicleDoorLockStatus(vehicle) == 1 then
            if GetPedInVehicleSeat(vehicle, -1) == playerped or GetPedInVehicleSeat(vehicle, window-1) == playerped then
                if windowstatus[window] == true then
                    RollUpWindow(vehicle, window)
                else
                    RollDownWindow(vehicle, window)
                end
                windowstatus[window] = not windowstatus[window]
            else
                ESX.ShowNotification(_U('not_relativeseat'))
            end
        else
            ESX.ShowNotification(_U('vehicle_locked'))
        end            
    else
        ESX.ShowNotification(_U('not_vehicle'))
    end
end

-- Toggle windows only if in the driver seat
function ToggleVehicleWindowsDriver(window)
    local playerped = GetPlayerPed(-1)
    local window    = window

    if IsPedInAnyVehicle(playerped, false) then
        local vehicle   = GetVehiclePedIsUsing(playerped)
        if GetVehicleDoorLockStatus(vehicle) == 1 then
            if GetPedInVehicleSeat(vehicle, -1) == playerped then
                if windowstatus[window] == true then
                    RollUpWindow(vehicle, window)
                else
                    RollDownWindow(vehicle, window)
                end
                windowstatus[window] = not windowstatus[window]
            else
                ESX.ShowNotification(_U('not_driverseat'))
            end
        else
            ESX.ShowNotification(_U('vehicle_locked'))
        end
    else
        ESX.ShowNotification(_U('not_vehicle'))
    end
end

-- Toggle doors only if in the relative seat or driver seat
function ToggleVehicleDoors(door)
    local playerped = GetPlayerPed(-1)
    local door      = door

    if IsPedInAnyVehicle(playerped, false) then
        local vehicle   = GetVehiclePedIsUsing(playerped)
        if GetVehicleDoorLockStatus(vehicle) == 1 then
            if GetPedInVehicleSeat(vehicle, -1) == playerped or GetPedInVehicleSeat(vehicle, door-1) == playerped then
                if GetVehicleDoorAngleRatio(vehicle, door) > 0 then
                    SetVehicleDoorShut(vehicle, door, false)
                else
                    SetVehicleDoorOpen(vehicle, door, false, false)
                end
            else
                ESX.ShowNotification(_U('not_relativeseat'))
            end
        else
            ESX.ShowNotification(_U('vehicle_locked'))
        end            
    else
        ESX.ShowNotification(_U('not_vehicle'))
    end
end

-- Toggle doors only if in the driver seat
function ToggleVehicleDoorsDriver(door)
    local playerped = GetPlayerPed(-1)
    local door      = door

    if IsPedInAnyVehicle(playerped, false) then
        local vehicle   = GetVehiclePedIsUsing(playerped)
        if GetVehicleDoorLockStatus(vehicle) == 1 then
            if GetPedInVehicleSeat(vehicle, -1) == playerped then
                if GetVehicleDoorAngleRatio(vehicle, door) > 0 then
                    SetVehicleDoorShut(vehicle, door, false)
                else
                    SetVehicleDoorOpen(vehicle, door, false, false)
                end
            else
                ESX.ShowNotification(_U('not_driverseat'))
            end
        else
            ESX.ShowNotification(_U('vehicle_locked'))
        end
    else
        ESX.ShowNotification(_U('not_vehicle'))
    end
end

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, Config.Key) and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'vehiclemenu') then
			ShowVehicleMenu()
		end
	end
end)


-- -- Documentation Fivem Native

-- doorIndex:  
-- 0 = Front Left Door  
-- 1 = Front Right Door  
-- 2 = Back Left Door  
-- 3 = Back Right Door  
-- 4 = Hood  
-- 5 = Trunk  
-- 6 = Trunk2 

-- windowIndex:  
-- 0 = Front Right Window  
-- 1 = Front Left Window  
-- 2 = Back Right Window  
-- 3 = Back Left Window  


-- SetVehicleDoorShut(
-- 	vehicle --[[ Vehicle ]], 
-- 	doorIndex --[[ integer ]], 
-- 	closeInstantly --[[ boolean ]]
-- )

-- SetVehicleDoorOpen(
-- 	vehicle --[[ Vehicle ]], 
-- 	doorIndex --[[ integer ]], 
-- 	loose --[[ boolean ]], 
-- 	openInstantly --[[ boolean ]]
-- )

-- GetPedInVehicleSeat(
--     vehicle --[[ Vehicle ]], 
--     index --[[ integer ]]
-- )
-- -1 (driver) <= index < GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle)  

-- 	GetVehicleDoorLockStatus(
-- 		vehicle --[[ Vehicle ]]
-- 	)
-- return VehicleLockStatus = {
--     None = 0,
--     Unlocked = 1,
--     Locked = 2,
--     LockedForPlayer = 3,
--     StickPlayerInside = 4, -- Doesn't allow players to exit the vehicle with the exit vehicle key.
--     CanBeBrokenInto = 7, -- Can be broken into the car. If the glass is broken, the value will be set to 1
--     CanBeBrokenIntoPersist = 8,
--     CannotBeTriedToEnter = 10
-- }

-- RollDownWindow(
--     vehicle --[[ Vehicle ]], 
--     windowIndex --[[ integer ]]
-- )

-- SetVehicleLights(
-- 	vehicle --[[ Vehicle ]], 
-- 	state --[[ integer ]]
-- )
-- set's if the vehicle has lights or not.  
-- not an on off toggle.  
-- p1 = 0 ;vehicle normal lights, off then lowbeams, then highbeams  
-- p1 = 1 ;vehicle doesn't have lights, always off  
-- p1 = 2 ;vehicle has always on lights  
-- p1 = 3 ;or even larger like 4,5,... normal lights like =1  
-- note1: when using =2 on day it's lowbeam,highbeam  
-- but at night it's lowbeam,lowbeam,highbeam  
-- note2: when using =0 it's affected by day or night for highbeams don't exist in daytime.

-- SetVehicleExtra(
-- 	vehicle --[[ Vehicle ]], 
-- 	extraId --[[ integer ]], 
-- 	disable --[[ boolean ]]
-- )
-- Note: only some vehicle have extras  
-- extra ids are from 1 - 9 depending on the vehicle  
-- -------------------------------------------------  
-- ^ not sure if outdated or simply wrong. Max extra ID for b944 is 14  
-- -------------------------------------------------  
-- p2 is not a on/off toggle. mostly 0 means on and 1 means off.  
-- not sure if it really should be a BOOL.  
-- -------------------------------------------------  
-- Confirmed p2 does not work as a bool. Changed to int. [0=on, 1=off]  

-- SetVehicleSearchlight(
-- 	heli --[[ Vehicle ]], 
-- 	toggle --[[ boolean ]], 
-- 	canBeUsedByAI --[[ boolean ]]
-- )
-- Only works during nighttime.  
-- And only if there is a driver in heli. 

-- SetMountedWeaponTarget(
-- 	shootingPed --[[ Ped ]], 
-- 	targetPed --[[ Ped ]], 
-- 	targetVehicle --[[ Vehicle ]], 
-- 	x --[[ number ]], 
-- 	y --[[ number ]], 
-- 	z --[[ number ]]
-- )
-- Note: Look in decompiled scripts and the times that p1 and p2 aren't 0. They are filled with vars. If you look through out that script what other natives those vars are used in, you can tell p1 is a ped and p2 is a vehicle. Which most likely means if you want the mounted weapon to target a ped set targetVehicle to 0 or vice-versa.  

-- GetClosestVehicle(
--     x --[[ number ]], 
--     y --[[ number ]], 
--     z --[[ number ]], 
--     radius --[[ number ]], 
--     modelHash --[[ Hash ]], 
--     flags --[[ integer ]]
-- )
-- Example usage  
-- VEHICLE::GET_CLOSEST_VEHICLE(x, y, z, radius, hash, unknown leave at 70)   
-- x, y, z: Position to get closest vehicle to.  
-- radius: Max radius to get a vehicle.  
-- modelHash: Limit to vehicles with this model. 0 for any.  
-- flags: The bitwise flags altering the function's behaviour.  
-- Does not return police cars or helicopters.  
-- It seems to return police cars for me, does not seem to return helicopters, planes or boats for some reason  
-- Only returns non police cars and motorbikes with the flag set to 70 and modelHash to 0. ModelHash seems to always be 0 when not a modelHash in the scripts, as stated above.   
-- These flags were found in the b617d scripts: 0,2,4,6,7,23,127,260,2146,2175,12294,16384,16386,20503,32768,67590,67711,98309,100359.  
-- Converted to binary, each bit probably represents a flag as explained regarding another native here: gtaforums.com/topic/822314-guide-driving-styles  
-- Conversion of found flags to binary: pastebin.com/kghNFkRi  
-- At exactly 16384 which is 0100000000000000 in binary and 4000 in hexadecimal only planes are returned.   
-- It's probably more convenient to use worldGetAllVehicles(int *arr, int arrSize) and check the shortest distance yourself and sort if you want by checking the vehicle type with for example VEHICLE::IS_THIS_MODEL_A_BOAT  
-- -------------------------------------------------------------------------  
-- Conclusion: This native is not worth trying to use. Use something like this instead: pastebin.com/xiFdXa7h 






-- Disable shuffle seat (for testing)
-- Original Code: https://forum.fivem.net/t/stop-vehicle-seat-shuffling/36087/10
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
-- 			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
-- 				if GetIsTaskActive(GetPlayerPed(-1), 165) then
-- 					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
-- 				end
-- 			end
-- 		end
-- 	end
-- end)