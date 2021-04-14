ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local plakalar = {}

ESX.RegisterServerCallback('carlock:isVehicleOwner', function(source, cb, plate)
	local identifier = GetPlayerIdentifier(source, 0)

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			cb(result[1].owner == identifier)
		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('yatzzz_carlock:GetPlates', function(source, cb)
	local plakalar = {}
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles',{},function(AllCars)
--		local carCount = nil

		for a=1 , #AllCars,1 do 

			if xPlayer.identifier == AllCars[a].owner then
				table.insert(plakalar, AllCars[a].plate)
			end
		end
		cb(plakalar)
	end)
end)
