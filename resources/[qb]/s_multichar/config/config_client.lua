--- @param Modify the event to open the stash
RegisterNetEvent('s_multichar:client:stashopen', function(CurrentApartment)
	local other = {}
	other.maxweight = Config.StashWeight
	other.slots = Config.StashSlots
	TriggerServerEvent("inventory:server:OpenInventory", "stash", CurrentApartment, other)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
	TriggerEvent("inventory:client:SetCurrentStash", CurrentApartment)
end)

local IsNew = false

RegisterNetEvent('s_multichar:client:SetNewState', function(bool)
	IsNew = bool
end)

--- @param Modify the initial apartment
function CreateInitialApartment(spawn) 
	local objects = {}
    local POIOffsets = {}
	POIOffsets.exit = json.decode('{"z":1.2,"y":-4.59636328125,"x":-4.872736328125,"h":176.4}')
	POIOffsets.clothes = json.decode('{"z":1.2,"y":3.5555111328,"x":-2.8689604492,"h":2.2633972168}')
	POIOffsets.stash = json.decode('{"z":1.2,"y":-0.2440585937501,"x":-6.072736328125,"h":2.2633972168}')
	POIOffsets.logout = json.decode('{"z":1.8,"y":-0.2555111328,"x":4.5689604492,"h":2.2633972168}')
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end
	RequestModel(`modernhotel_shell`)
	while not HasModelLoaded(`modernhotel_shell`) do
	    Wait(3)
	end
	local house = CreateObject(`modernhotel_shell`, spawn.x, spawn.y, spawn.z, false, false, false)
    FreezeEntityPosition(house, true)
    objects[#objects+1] = house
	TeleportToInterior(spawn.x  + 4.872736328125, spawn.y + 4.32736328125, spawn.z + 1.2, POIOffsets.exit.h)
	if IsNew then
		SetTimeout(750, function()
			TriggerEvent('qb-clothes:client:CreateFirstCharacter')
			IsNew = false
		end)
	end
    return { objects, POIOffsets }
end


--- @param Modify if below the functions to send email if 'Config.UsePhoneEmail' is 'true'
RegisterNetEvent('s_multichar:client:MoveApp', function()
	TriggerServerEvent('qb-phone:server:sendNewMail', {
		sender = 'City',
		subject = 'Welcome',
		message = 'Welcome, you got your new apartment, you can stop renting or move to other apartment when you need!.',
		button = {}
	})
end)


RegisterNetEvent('s_multichar:client:RentEmail', function()
	TriggerServerEvent('qb-phone:server:sendNewMail', {
		sender = 'City',
		subject = 'Apartment Rent',
		message = 'A direct debit was made from your bank account for the rent for the apartment.',
		button = {}
	})
end)

RegisterNetEvent('s_multichar:client:StopRentRemail', function()
	TriggerServerEvent('qb-phone:server:sendNewMail', {
		sender = 'City',
		subject = 'Stop Renting',
		message = 'Why!!! Our apartments they are so nice, lets hope you come back soon, and I never see you sleeping under a bridge!',
		button = {}
	})
end)

RegisterNetEvent('s_multichar:client:LostApp', function()
	TriggerServerEvent('qb-phone:server:sendNewMail', {
		sender = 'City',
		subject = 'Dumped',
		message = 'We were unable to make a direct debit from your bank account for the rent on the apartment, you were evicted from the apartment, your percentages were sold at auction.',
		button = {}
	})
end)



