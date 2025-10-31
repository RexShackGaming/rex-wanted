local RSGCore = exports['rsg-core']:GetCoreObject()
local outlawstatus = 0
local hunterGroup = `BOUNTY_HUNTER`
local spawnedPeds = {}
local spawnedPedCount = 0
local lastNotifiedStatus = 0
local isHostile = false
lib.locale()

-- Initialize relationship group
CreateThread(function()
    Wait(1000)
    AddRelationshipGroup('BOUNTY_HUNTER')
    hunterGroup = GetHashKey('BOUNTY_HUNTER')
end)

-- Optimized: spatial filtering + spawn limit + validation
CreateThread(function()
    while true do
        Wait(Config.LocationCheckInterval)
        local playerCoords = GetEntityCoords(cache.ped)
        
        -- Pre-filter locations by nearby range
        local nearbyLocations = {}
        for k, v in pairs(Config.BanditLocations) do
            local roughDist = #(playerCoords - v.coords)
            if roughDist < Config.NearbyLocationRange then
                nearbyLocations[k] = v
            end
        end
        
        -- Process only nearby locations
        for k, v in pairs(nearbyLocations) do
            local distance = #(playerCoords - v.npccoords.xyz)

            -- Spawn with limit enforcement
            if distance < Config.DistanceSpawn and not spawnedPeds[k] then
                if spawnedPedCount < Config.MaxSpawnedPedsPerPlayer then
                    TriggerServerEvent('rex-wanted:server:requestNpcSpawn', k)
                end
            end
            
            -- Cleanup
            if distance >= Config.DistanceSpawn and spawnedPeds[k] then
                if DoesEntityExist(spawnedPeds[k].spawnedPed) then
                    DeletePed(spawnedPeds[k].spawnedPed)
                end
                spawnedPeds[k] = nil
                spawnedPedCount = math.max(0, spawnedPedCount - 1)
            end
        end
        
        -- Cleanup orphaned entries
        for k, v in pairs(spawnedPeds) do
            if not DoesEntityExist(v.spawnedPed) then
                spawnedPeds[k] = nil
                spawnedPedCount = math.max(0, spawnedPedCount - 1)
            end
        end
    end
end)

-- Server-authorized spawn handler
RegisterNetEvent('rex-wanted:client:spawnNpc', function(locationKey, npcData)
    if spawnedPeds[locationKey] then return end
    if spawnedPedCount >= Config.MaxSpawnedPedsPerPlayer then return end
    
    local location = Config.BanditLocations[locationKey]
    if not location then return end
    
    local spawnedPed = NearPed(location.npcmodel, location.npccoords, location.npcweapon, location.npcwander)
    if spawnedPed then
        spawnedPeds[locationKey] = { spawnedPed = spawnedPed }
        spawnedPedCount = spawnedPedCount + 1
    end
end)

function NearPed(npcmodel, npccoords, npcweapon, npcwander)
    RequestModel(npcmodel)
    local timeout = 0
    while not HasModelLoaded(npcmodel) and timeout < 100 do
        Wait(50)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(npcmodel) then
        return nil
    end
    
    local spawnedPed = CreatePed(npcmodel, npccoords.x, npccoords.y, npccoords.z - 1.0, npccoords.w, false, false, 0, 0)
    
    if not DoesEntityExist(spawnedPed) then
        return nil
    end
    
    -- Mark as owned by this script for cleanup (DO NOT use SetEntityAsNoLongerNeeded)
    SetEntityAsMissionEntity(spawnedPed, true, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    SetPedKeepTask(spawnedPed, true)
    SetRandomOutfitVariation(spawnedPed, true)
    
    -- Assign to bounty hunter relationship group
    SetPedRelationshipGroupHash(spawnedPed, hunterGroup)
    
    -- Combat settings
    SetPedCombatAbility(spawnedPed, 2)
    SetPedCombatMovement(spawnedPed, 2)
    SetPedCombatRange(spawnedPed, 2)
    SetPedCombatAttributes(spawnedPed, 46, true)
    SetPedCombatAttributes(spawnedPed, 5, true)
    SetPedCombatAttributes(spawnedPed, 0, true)
    SetPedFleeAttributes(spawnedPed, 0, false)
    SetPedSeeingRange(spawnedPed, 100.0)
    SetPedHearingRange(spawnedPed, 100.0)
    SetPedConfigFlag(spawnedPed, 208, true) -- Disable melee
    SetPedConfigFlag(spawnedPed, 281, true) -- No writhe
    
    -- Weapon setup
    GiveWeaponToPed(spawnedPed, npcweapon, 999, false, true)
    SetCurrentPedWeapon(spawnedPed, npcweapon, true)
    SetPedInfiniteAmmo(spawnedPed, true, npcweapon)
    
    -- If already hostile, attack player immediately
    if isHostile then
        local playerPed = PlayerPedId()
        TaskCombatPed(spawnedPed, playerPed, 0, 16)
    else
        TaskWanderInArea(spawnedPed, npccoords.x, npccoords.y, npccoords.z, npcwander, 0, 0)
    end
    
    return spawnedPed
end

----------------------------
-- make hunters hostile
----------------------------
CreateThread(function()
    while true do
        Wait(Config.StatusCheckInterval)
        
        if LocalPlayer.state.isLoggedIn and Config.WantedSystemActive then
            RSGCore.Functions.TriggerCallback('rex-wanted:server:getoutlawstatus', function(result)
                if not result or not result[1] then return end
                
                local newStatus = result[1].outlawstatus or 0
                outlawstatus = newStatus
                
                local playerPed = PlayerPedId()
                local playerGroup = GetPedRelationshipGroupHash(playerPed)
                
                if outlawstatus > Config.OutlawTriggerAmount and not LocalPlayer.state['isDead'] then
                    if not isHostile then
                        isHostile = true
                        
                        -- Make bounty hunters hostile to player
                        SetRelationshipBetweenGroups(5, hunterGroup, playerGroup)
                        SetRelationshipBetweenGroups(5, playerGroup, hunterGroup)
                        
                        -- Force existing NPCs to attack
                        for k, v in pairs(spawnedPeds) do
                            if v.spawnedPed and DoesEntityExist(v.spawnedPed) then
                                ClearPedTasks(v.spawnedPed)
                                TaskCombatPed(v.spawnedPed, playerPed, 0, 16)
                            end
                        end
                        
                        lib.notify({
                            title = 'Wanted',
                            description = 'Bounty hunters are now hostile!',
                            type = 'error',
                            duration = 5000
                        })
                    end
                else
                    if isHostile then
                        isHostile = false
                        
                        -- Make bounty hunters neutral
                        SetRelationshipBetweenGroups(1, hunterGroup, playerGroup)
                        SetRelationshipBetweenGroups(1, playerGroup, hunterGroup)
                        
                        -- Stop existing NPCs from attacking
                        for k, v in pairs(spawnedPeds) do
                            if v.spawnedPed and DoesEntityExist(v.spawnedPed) then
                                ClearPedTasks(v.spawnedPed)
                                local coords = GetEntityCoords(v.spawnedPed)
                                TaskWanderInArea(v.spawnedPed, coords.x, coords.y, coords.z, 50.0, 0, 0)
                            end
                        end
                        
                        lib.notify({
                            title = 'Wanted Cleared',
                            description = 'Bounty hunters are no longer hostile',
                            type = 'success',
                            duration = 5000
                        })
                    end
                end
                
                lastNotifiedStatus = outlawstatus
            end)
        end
    end
end)

-- Clear wanted status on death
CreateThread(function()
    local wasDead = false
    while true do
        Wait(1000)
        
        if Config.ClearWantedOnDeath and LocalPlayer.state.isLoggedIn then
            local isDead = LocalPlayer.state.isDead
            
            -- Detect death transition
            if isDead and not wasDead then
                if outlawstatus > 0 then
                    TriggerServerEvent('rex-wanted:server:clearOutlawStatus')
                    outlawstatus = 0
                end
            end
            
            wasDead = isDead
        end
    end
end)

-- cleanup on resource stop
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Cleanup tracked peds
    for k, v in pairs(spawnedPeds) do
        if v.spawnedPed and DoesEntityExist(v.spawnedPed) then
            SetEntityAsMissionEntity(v.spawnedPed, false, true)
            DeletePed(v.spawnedPed)
            DeleteEntity(v.spawnedPed)
        end
    end
    
    -- Brute force cleanup: find all peds in bounty hunter group
    local allPeds = GetGamePool('CPed')
    for _, ped in ipairs(allPeds) do
        if DoesEntityExist(ped) and GetPedRelationshipGroupHash(ped) == hunterGroup then
            SetEntityAsMissionEntity(ped, false, true)
            DeletePed(ped)
            DeleteEntity(ped)
        end
    end
    
    spawnedPeds = {}
    spawnedPedCount = 0
end)
