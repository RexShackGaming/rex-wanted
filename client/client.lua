local RSGCore = exports['rsg-core']:GetCoreObject()
local outlawstatus = 0
local hunterGroup
local spawnedPeds = {}
lib.locale()

CreateThread(function()
    while true do
        Wait(500)
        for k,v in pairs(Config.BanditLocations) do
            local playerCoords = GetEntityCoords(cache.ped)
            local distance = #(playerCoords - v.npccoords.xyz)

            if distance < Config.DistanceSpawn and not spawnedPeds[k] then
                local spawnedPed = NearPed(v.npcmodel, v.npccoords, v.npcweapon)
                spawnedPeds[k] = { spawnedPed = spawnedPed }
            end
            
            if distance >= Config.DistanceSpawn and spawnedPeds[k] then
                if Config.FadeIn then
                    for i = 255, 0, -51 do
                        Wait(50)
                        SetEntityAlpha(spawnedPeds[k].spawnedPed, i, false)
                    end
                end
                DeletePed(spawnedPeds[k].spawnedPed)
                spawnedPeds[k] = nil
            end

        end
    end
end)

function NearPed(npcmodel, npccoords, npcweapon)
    RequestModel(npcmodel)
    while not HasModelLoaded(npcmodel) do
        Wait(50)
    end
    spawnedPed = CreatePed(npcmodel, npccoords.x, npccoords.y, npccoords.z - 1.0, npccoords.w, false, false, 0, 0)
    SetEntityAlpha(spawnedPed, 0, false)
    SetPedKeepTask(spawnedPed)
    SetRandomOutfitVariation(spawnedPed, true)
    SetPedCombatAbility(spawnedPed, 3)
    SetPedCombatMovement(spawnedPed, 3)
    SetPedCombatRange(spawnedPed, 3)
    SetPedCombatAttributes(spawnedPed, 46)
    SetPedCombatAttributes(spawnedPed, 5)
    SetPedCombatAttributes(spawnedPed, 0)
    SetPedFleeAttributes(spawnedPed, 0, false)
    SetPedSeeingRange(spawnedPed, 500.0)
    SetPedHearingRange(spawnedPed, 500.0)
    GiveWeaponToPed(spawnedPed, npcweapon, 999, false, true)
    TaskWanderInArea(spawnedPed, npccoords.x, npccoords.y, npccoords.z, 50.0)
    if Config.FadeIn then
        for i = 0, 255, 51 do
            Wait(50)
            SetEntityAlpha(spawnedPed, i, false)
        end
    end
    -- set relationship
    hunterGroup = GetPedRelationshipGroupHash(spawnedPed)
    return spawnedPed
end

----------------------------
-- make hunters hostile
----------------------------
CreateThread(function()
    while true do
        local sleep = 0
        if LocalPlayer.state.isLoggedIn and Config.WantedSystemActive then
            sleep = (5000)
            RSGCore.Functions.TriggerCallback('rex-wanted:server:getoutlawstatus', function(result)
                outlawstatus = result[1].outlawstatus
                local playerPed = PlayerPedId()
                local playerGroup = GetPedRelationshipGroupHash(playerPed)
                if outlawstatus ~= nil and outlawstatus > Config.OutlawTriggerAmount and not LocalPlayer.state['isDead'] then
                    SetRelationshipBetweenGroups(6, hunterGroup, playerGroup)
                else
                    SetRelationshipBetweenGroups(0, hunterGroup, playerGroup)
                end
            end)
        end
        Wait(sleep)
    end
end)

-- cleanup
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for k,v in pairs(spawnedPeds) do
        DeletePed(spawnedPeds[k].spawnedPed)
        spawnedPeds[k] = nil
    end
end)
