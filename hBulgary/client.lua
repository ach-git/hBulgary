ESX = nil

Citizen.CreateThread(function()
    TriggerEvent("esx:getSharedObject", function(obj)   ESX = obj   end)

    RequestModel(GetHashKey("g_m_m_armlieut_01"))
    while not HasModelLoaded(GetHashKey("g_m_m_armlieut_01")) do
        Wait(1)
    end
    ped = CreatePed(4, 0xE7714013, 884.46, -953.00, 38.2133, 3374176, false, true)
    SetEntityHeading(ped, 270.0)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GUARD_STAND", 0, true)
    SetBlockingOfNonTemporaryEvents(ped, true)


    while true do
        local interval = 1000
        local playerPos = GetEntityCoords(PlayerPedId())
        if not currentSteal then
            for k,v in pairs(Config.stealzone) do
                local zoneCenter = v.Enter
                local dst = #(playerPos-zoneCenter)
                if not v.cooldownentry then 
                    if dst <= 25.0 then
                        interval = 0
                        DrawMarker(2, zoneCenter, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.30, 0.30, 0.30, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                        if dst <= 1.0 then
                            Visual.Subtitle("Appuyez sur ~g~E~s~ pour voler", 1)
                            if IsControlJustPressed(0, 51) then
                                StealStart(zoneCenter, v.Exit, v)
                            end
                        end
                    end
                end
            end

            local vendorZone = Config.vendor.position
            local dst = #(playerPos-vendorZone)
            if dst <= 30.0 then
                interval = 25
                if not isMenuActive then
                    if dst <= 1.5 then
                        interval = 0
                        Visual.Subtitle("Appuyez sur ~g~E~s~ pour vendre vos objet", 1)
                        if IsControlJustPressed(0, 51) then
                            OpenMenuSell()
                        end
                    end
                end
            end
        end
        Wait(interval)
    end

end)

function StealStart(enter, target, house)
    local inventory = ESX.GetPlayerData().inventory
    local lockpick = nil
    for i=1, #inventory, 1 do                          
        if inventory[i].name == 'lockpick' then
            lockpick = inventory[i].count
        end
    end
    if lockpick > 0 then
        local playerPed = PlayerPedId()
        FreezeEntityPosition(playerPed, true)
        SetEntityCoords(playerPed, enter.x, enter.y, enter.z-0.98)
        SetEntityHeading(playerPed, house.hEnter)
        AnimJoueur("mini@safe_cracking", "idle_base")
        Wait(house.time * 1000)
        SetEntityCoords(playerPed, target.x, target.y, target.z-0.98)
        SetEntityHeading(playerPed, house.hExit+180)
        FreezeEntityPosition(playerPed, false)
        ClearPedTasksImmediately(playerPed)
        currentSteal = true
        Visual.Subtitle("Vous avez ~g~réussi~s~ le crochetage.", 1)
        TriggerServerEvent("hburglary:sellItem", "lockpick", 1)
        Citizen.SetTimeout(house.MaxStealTime*1000,function()
            if currentSteal then
                currentSteal = false
                ESX.ShowNotification("Vous etes ~r~sorite~s~ de "..house.name.." car vous etes trops long")
                DoScreenFadeOut(1500)
                Wait(3000)
                DoScreenFadeIn(1500)
                SetEntityCoords(playerPed, enter.x, enter.y, enter.z-0.98)
                SetEntityHeading(playerPed, house.hEnter+180)
            end
        end)
        local timestartrandom = ESX.Math.Round(house.time/4)
        local randomtime = math.random(timestartrandom , house.time)
        Citizen.SetTimeout(randomtime*1000, function()
            if currentSteal then
                TriggerServerEvent('hbulgary:server:policeAlert', enter)
                Wait(5000)
                ESX.ShowNotification("~r~La police a été prevenue du vole!")
            end
        end)
        while currentSteal do 
            house.cooldownentry = true
            local playerPos = GetEntityCoords(PlayerPedId())
            local dstexit = #(playerPos-target)
            DrawMarker(2, target, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.30, 0.30, 0.30, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
            if dstexit <= 1.5 then
                Visual.Subtitle("Appuyez sur ~g~E~s~ pour sortir", 1)
                if IsControlJustPressed(0, 51) then
                    FreezeEntityPosition(playerPed, true)
                    SetEntityHeading(playerPed, house.hExit)
                    SetEntityCoords(playerPed, house.Exit.x, house.Exit.y, house.Exit.z-0.98)
                    TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
                    DoScreenFadeOut(1000)
                    Wait(2000)
                    DoScreenFadeIn(1000)
                    currentSteal = false
                    SetEntityCoords(playerPed, enter.x, enter.y, enter.z-0.98)
                    SetEntityHeading(playerPed, house.hEnter+180)
                    FreezeEntityPosition(playerPed, false)
                    ESX.ShowNotification("Vous etes ~r~sorite~s~ de "..house.name)

                    Citizen.SetTimeout(180000,function()
                        house.cooldownentry = false
                    end)
                end
            end
            for k,v in pairs(house.Objects) do
                local posobj = v.pos
                local dstobj = #(playerPos-posobj)
                if not v.cooldown then 
                    DrawMarker(2, posobj, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.30, 0.30, 0.30, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                    if dstobj <= 1.0 then
                        Visual.Subtitle("Appuyez sur ~g~E~s~ pour voler un(e) "..v.name, 1)
                        if IsControlJustPressed(0, 51) then
                            FreezeEntityPosition(playerPed, true)
                            SetEntityHeading(playerPed, v.hObj)
                            SetEntityCoords(playerPed, v.pos.x, v.pos.y, v.pos.z-0.98)
                            TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
                            Wait(v.time * 1000)
                            if currentSteal then
                                FreezeEntityPosition(playerPed, false)
                                ClearPedTasksImmediately(playerPed)
                                ESX.ShowNotification("Vous avez ~g~réussi~s~ à voler un(e) "..v.name)
                                TriggerServerEvent("hburglary:buy", v.Item)
                                v.cooldown = true
                                Citizen.SetTimeout(80000,function()
                                    v.cooldown = false
                                end)
                            else
                                FreezeEntityPosition(playerPed, false)
                                ClearPedTasksImmediately(playerPed)
                            end
                        end
                    end
                end
            end
            Wait(0)
        end
    else
        ESX.ShowNotification("~r~Vous ne pouvez pas volez vous n'avez pas de lockpick!")
    end
end

function OpenMenuSell()
    local playerPed = PlayerPedId()

    MenuSellMain = RageUI.CreateMenu("Contrebandier", "Contrebandier")
    MenuSellMain.Closed = function()
        SetPlayerControl(PlayerId(), true, 12)
        FreezeEntityPosition(playerPed, false)
        isMenuActive = false
    end

    isMenuActive = true

    RageUI.Visible(MenuSellMain, true)
    Citizen.CreateThread(function()
        FreezeEntityPosition(playerPed, true)
        while isMenuActive do

            RageUI.IsVisible(MenuSellMain, function()

                for k, v in pairs(ESX.GetPlayerData().inventory) do
                    local price = Config.SellPrice[v.name]

                    if price and v.count > 0 then 
                        RageUI.Button("Vendre "..v.label, "Vous vendez votre "..v.label.." au contrbandier pour ~g~"..price.."$", {RightLabel = "~g~"..price.."$"}, true, {
                            onSelected = function()
                                ESX.ShowNotification("Vous avez vendu "..v.label.." pour ~g~"..price.."$")
                                TriggerServerEvent("hburglary:sellItem", v.name, 1)
                            end
                        })
                    end
                end

            end, function()
            end, 1)
            Wait(0)
        end
    end)
end

function AnimJoueur(dict,annim)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(1000)
    end
    TaskPlayAnim(PlayerPedId(), dict, annim,8.0, -8.0, -1, 0, 0, false, false, false )
end

RegisterNetEvent('hbulgary:client:policeAlert')
AddEventHandler('hbulgary:client:policeAlert', function(targetCoords)
	local rueHash = GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z)
	local rue = GetStreetNameFromHashKey(rueHash)
    ESX.ShowNotification("Un vole a été signalé à ~g~"..rue.."~s~")

    local alpha = 250
    local policeBlip = AddBlipForRadius(targetCoords.x, targetCoords.y, targetCoords.z, 50.0)

    SetBlipHighDetail(policeBlip, true)
    SetBlipColour(policeBlip, 1)
    SetBlipAlpha(policeBlip, alpha)
    SetBlipAsShortRange(policeBlip, true)

    while alpha ~= 0 do
        Citizen.Wait(135)
        alpha = alpha - 1
        SetBlipAlpha(policeBlip, alpha)

        if alpha == 0 then
            RemoveBlip(policeBlip)
            return
        end
    end
end)