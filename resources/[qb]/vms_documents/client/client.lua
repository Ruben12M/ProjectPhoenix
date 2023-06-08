QBCore = Config.CoreExport()
local isDocumentOpened = false

Citizen.CreateThread(function()
    local inRange = false
    local isShowed = false
    while Config.UseMarker and Config.MustMakePhoto do
        sleep = 1500
        inRange = false
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local distance = #(Config.Marker.coords - myCoords)
        if distance < 10.0 then
            sleep = 1
            DrawMarker(Config.Marker.markerId, Config.Marker.coords, 0, 0, 0, 0, 0, 0, Config.Marker.size, Config.Marker.color[1], Config.Marker.color[2], Config.Marker.color[3], Config.Marker.color[4], false, false, false, Config.Marker.rotate, false, false, false)
        end
        if distance < 1.25 then
            if Config.Interact.Enabled then
                inRange = true
            end
            if IsControlJustPressed(0, 38) then
                inRange = false
                TriggerEvent("vms_documents:doPhoto")
            end
        end
        if inRange and not isShowed then
            if Config.PhotoPrice > 0 then
                Config.Interact.Open("E", Config.Texts["interact_paid_photo"])
            else
                Config.Interact.Open("E", Config.Texts["interact_free_photo"])
            end
            isShowed = true
        elseif not inRange and isShowed then
            Config.Interact.Close()
            isShowed = false
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent("vms_documents:doPhoto")
AddEventHandler("vms_documents:doPhoto", function()
    local mugshotBase = exports.MugShotBase64:GetMugShotBase64(PlayerPedId(), false)
    TriggerServerEvent("vms_document:saveMugshot", mugshotBase)
end)

RegisterNetEvent("vms_document:showMyDocument")
AddEventHandler("vms_document:showMyDocument", function(type)
    QBCore.Functions.TriggerCallback("vms_document:getImage", function(url)
        if url then
            TriggerServerEvent("vms_document:show", type, url)
        else
            if Config.MustMakePhoto then
                Config.Notification(Config.Texts["notify_title"], Config.Texts["no_have_photo"], 2500, "fa fa-address-card", "error")
            else
                local mugshotBase = exports.MugShotBase64:GetMugShotBase64(PlayerPedId(), false)
                TriggerServerEvent("vms_document:saveMugshot", mugshotBase)
                while mugshotBase do
                    QBCore.Functions.TriggerCallback("vms_document:getImage", function(url)
                        if url then
                            TriggerServerEvent("vms_document:show", type, url)
                        end
                    end)
                    break
                end
            end
        end
    end)
end)


RegisterNetEvent("vms_document:client:send")
AddEventHandler("vms_document:client:send", function(type, documentInfos, imageUrl)
    if not isDocumentOpened then
        isDocumentOpened = true
        SendNUIMessage({
            action = 'open',
            documentInfos = documentInfos,
            documentOptions = Config.Documents[type],
            type = type,
            playerImage = imageUrl,
        })
        while isDocumentOpened do
            Citizen.Wait(1)
            if IsControlJustPressed(0, 177) then
                isDocumentOpened = false
                SendNUIMessage({action = 'close'})
            end
        end
    end
end)

RegisterNetEvent("vms_document:client:notify")
AddEventHandler("vms_document:client:notify", function(title, msg, time, icon, type)
    Config.Notification(title, msg, time, icon, type)
end)

RegisterNetEvent('vms_document:client:animation', function(anim, timeout)
    local ped = PlayerPedId()
    loadAnimDict(anim[1])
    TaskPlayAnim(ped, anim[1], anim[2], 3.0, -1, timeout, 50, 0, false, false, false)
    RemoveAnimDict(anim[1])
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end