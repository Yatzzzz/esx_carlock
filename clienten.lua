ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

local plakalar = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	Citizen.Wait(1000)
	ESX.TriggerServerCallback('yatzzz_carlock:GetPlates', function(plaka)
		plakalar = plaka
	end)
end)

Citizen.CreateThread(function()
	local dict = "anim@mp_player_intmenu@key_fob@"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end
  	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 303) then
			local kordinat = GetEntityCoords(PlayerPedId())
			local arac, mesafe = ESX.Game.GetClosestVehicle(kordinat)
			if mesafe <= 5.0 then
				local plaka = ESX.Math.Trim(GetVehicleNumberPlateText(arac))
				local BulunanArac = arac
					for i = 1, #plakalar, 1 do
						if plaka == plakalar[i].plate then
							--print("araac bulundu " .. Plakalar[i].plate .. ' ' .. BulunanArac)
							local lock = GetVehicleDoorLockStatus(BulunanArac)
							if lock == 1 or lock == 0 then
								SetVehicleDoorShut(BulunanArac, 0, false)
								SetVehicleDoorShut(BulunanArac, 1, false)
								SetVehicleDoorShut(BulunanArac, 2, false)
								SetVehicleDoorShut(BulunanArac, 3, false)
								SetVehicleDoorsLocked(BulunanArac, 2)
								SetVehicleDoorsLockedForAllPlayers(BulunanArac, true)
								--PlayVehicleDoorCloseSound(BulunanArac, 1)
								exports['mythic_notify']:DoHudText('error', 'Aracın kapıları kilitlendi.')
								TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lock', 0.3)
								if not IsPedInAnyVehicle(PlayerPedId(), true) then
									TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)

									SetVehicleLights(BulunanArac, 2)

									SetVehicleBrakeLights(BulunanArac, true)
									SetVehicleInteriorlight(BulunanArac, true)
									SetVehicleIndicatorLights(BulunanArac, 0, true)
									SetVehicleIndicatorLights(BulunanArac, 1, true)
									Citizen.Wait(450)
									SetVehicleIndicatorLights(BulunanArac, 0, false)
									SetVehicleIndicatorLights(BulunanArac, 1, false)
									Citizen.Wait(450)									
									SetVehicleInteriorlight(BulunanArac, true)
									SetVehicleIndicatorLights(BulunanArac, 0, true)
									SetVehicleIndicatorLights(BulunanArac, 1, true)
									Citizen.Wait(450)	
									SetVehicleLights(BulunanArac, 0)
									SetVehicleBrakeLights(BulunanArac, false)
									SetVehicleInteriorlight(BulunanArac, false)
									SetVehicleIndicatorLights(BulunanArac, 0, false)
									SetVehicleIndicatorLights(BulunanArac, 1, false)

								
								end
							elseif lock == 2 then
								SetVehicleDoorsLocked(BulunanArac, 1)
								SetVehicleDoorsLockedForAllPlayers(BulunanArac, false)
								--PlayVehicleDoorOpenSound(BulunanArac, 0)
								exports['mythic_notify']:DoHudText('success', 'Aracın kapıları açıldı.')
								if not IsPedInAnyVehicle(PlayerPedId(), true) then
									TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'unlock', 0.1)
									TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
									SetVehicleLights(BulunanArac, 2)
									SetVehicleFullbeam(BulunanArac, true)
									SetVehicleBrakeLights(BulunanArac, true)
									SetVehicleInteriorlight(BulunanArac, true)
									SetVehicleIndicatorLights(BulunanArac, 0, true)
									SetVehicleIndicatorLights(BulunanArac, 1, true)
									Citizen.Wait(450)
									SetVehicleIndicatorLights(BulunanArac, 0, false)
									SetVehicleIndicatorLights(BulunanArac, 1, false)
									Citizen.Wait(450)
									SetVehicleInteriorlight(BulunanArac, true)
									SetVehicleIndicatorLights(BulunanArac, 0, true)
									SetVehicleIndicatorLights(BulunanArac, 1, true)
									Citizen.Wait(450)
									SetVehicleLights(BulunanArac, 0)
									SetVehicleFullbeam(BulunanArac, false)
									SetVehicleBrakeLights(BulunanArac, false)
									SetVehicleInteriorlight(BulunanArac, false)
									SetVehicleIndicatorLights(BulunanArac, 0, false)
									SetVehicleIndicatorLights(BulunanArac, 1, false)
								end
							end
							break
						end
					end
			end
		end
  	end
end)


RegisterNetEvent('esx_carlock:addPlate')
AddEventHandler('esx_carlock:addPlate', function(yeniplaka)
    if yeniplaka ~= nil then
        table.insert(plakalar, {
            plate = yeniplaka
        })
    else
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local plaka = GetVehicleNumberPlateText(vehicle)
        table.insert(plakalar, {
            plate = plaka
        })
    end
end)

