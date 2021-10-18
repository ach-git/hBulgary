ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)   ESX = obj   end)

RegisterServerEvent("hburglary:sellItem")
AddEventHandler("hburglary:sellItem", function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.SellPrice[itemName]
	local Item = xPlayer.getInventoryItem(itemName)

	if not price then
		if Item.name == "lockpick" then 
			xPlayer.removeInventoryItem(Item.name, 1)
			return
		else
			DropPlayer(source, "Exploit")
			return
		end
	end

	price = ESX.Math.Round(price * amount)

	xPlayer.addAccountMoney('black_money', price)

	xPlayer.removeInventoryItem(Item.name, amount)
end)

RegisterNetEvent('hburglary:buy')
AddEventHandler('hburglary:buy', function(itemName) 
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addInventoryItem(itemName, 1)
end)

RegisterNetEvent('hbulgary:server:policeAlert')
AddEventHandler('hbulgary:server:policeAlert', function(coords)
    local players = ESX.GetPlayers()
    
    for i = 1, #players do
        local player = ESX.GetPlayerFromId(players[i])
        if player['job']['name'] == 'police' then
            TriggerClientEvent('hbulgary:client:policeAlert', players[i], coords)
        end
    end
end)