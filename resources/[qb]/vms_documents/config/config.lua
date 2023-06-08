Config = {}

Config.CoreExport = function()
    return exports['qb-core']:GetCoreObject()
end

Config.Notification = function(title, msg, time, icon, type)
    if type == "success" then
        --exports["vms_notify"]:Notification(title, msg, time, "#4ceb34", icon)
        QBCore.Functions.Notify(msg, "success", 5000)
    elseif type == "error" then
        --exports["vms_notify"]:Notification(title, msg, time, "#eb3446", icon)
        QBCore.Functions.Notify(msg, "error", 5000)
    end
end

Config.Interact = {
    Enabled = true,
    Open = function(key, msg)
        --exports["interact"]:Open(key, msg)
        exports['qb-core']:DrawText(msg, 'left')
    end,
    Close = function()
        --exports["interact"]:Close()
        exports['qb-core']:HideText()
    end
}

Config.MustMakePhoto = FALSE
Config.PhotoPrice = 250

Config.UseMarker = true
if Config.UseMarker then
    Config.Marker = {
        markerId = 1,
        coords = vector3(-531.16, -219.22, 37.65),--vector3(-544.94, -198.48, 37.23),
        size = vec(1.0, 1.0, 1.0),
        color = {60, 120, 250, 121},
        rotate = false
    }
end

Config.DisplayTexts = {
    ["drive_bike"] = {
        have = "A",
        notHave = "A"
    },
    ["drive"] = {
        have = "B",
        notHave = "B",
    },
    ["drive_truck"] = {
        have = "C",
        notHave = "C",
    },
    ["drive_boat"] = {
        have = "YES",
        notHave = "NO",
    },
    ["flying_helicopter"] = {
        have = "Helicopter",
        notHave = "Helicopter",
    },
    ["flying_plane"] = {
        have = "Plane",
        notHave = "Plane",
    },
    ["weapon"] = {
        have = "YES",
        notHave = "NO",
    }
}

Config.Documents = {
    ["id_card"] = {
        item = "id_card", -- nil if you want to use e.g. via trigger, if you want to use as an item set "itemname"
        color = "#f5e942",
        animation = {"random@atmrobberygen", "a_atm_mugging"},
        animationTimeout = 2500,
        header = "CARTÃO CIDADÃO",
        icon = "person", -- https://fonts.google.com/icons
        notifyText = "You showed the id card.",
    },
    ["id_drive"] = {
        item = "driver_license",
        color = "#34eb71",
        animation = {"random@atmrobberygen", "a_atm_mugging"},
        animationTimeout = 2500,
        header = "CARTA CONDUÇÃO",
        icon = "directions_car",
        notifyText = "You showed the driving license.",
    },
    ["id_fly"] = {
        item = nil,
        color = "#c2ddff",
        animation = {"random@atmrobberygen", "a_atm_mugging"},
        animationTimeout = 2500,
        header = "FLY LICENSE",
        icon = "flight",
        notifyText = "You showed the fly license.",
    },
    ["id_boat"] = {
        item = nil,
        color = "#267fed",
        animation = {"random@atmrobberygen", "a_atm_mugging"},
        animationTimeout = 2500,
        header = "BOAT LICENSE",
        icon = "directions_boat",
        notifyText = "You showed the boat license.",
    },
    ["id_weapon"] = {
        item = "weaponlicense",
        color = "#d92b2b",
        animation = {"random@atmrobberygen", "a_atm_mugging"},
        animationTimeout = 2500,
        header = "PORTE ARMA",
        icon = "crisis_alert",
        notifyText = "You showed the weapon license.",
    },
}

Config.Texts = {
    ["notify_title"] = "DOCUMENTS",
    ["notify_title_photo"] = "PHOTO",
    ["no_have_photo"] = "You do not have an picture to the document. You have to make them first.",
    ["you_paid_for_photo"] = "You paid %s$ to take a photo for documents",
    ["document_pay_reason"] = "Photos for documents",
    ["you_do_photo"] = "You took a picture for your documents.",
    ["not_have_money"] = "You don't have enough money to take a picture.",
    ['interact_paid_photo'] = "TAKE A PHOTO ($"..Config.PhotoPrice..")",
    ['interact_free_photo'] = "TAKE A PHOTO",
    ["male"] = 'Male',
    ["female"] = 'Female',
}