----------------------------
-- REX-WANTED EXPORTS
----------------------------

-- Client Exports (if called from client)
if IsDuplicityVersion() == 0 then
    
    -- Get current outlaw status (from local cache)
    exports('GetOutlawStatus', function()
        return outlawstatus or 0
    end)
    
    -- Check if player is currently hostile
    exports('IsHostile', function()
        return isHostile or false
    end)
    
    -- Get count of spawned bounty hunter NPCs
    exports('GetSpawnedPedCount', function()
        return spawnedPedCount or 0
    end)
    
    -- Get all spawned bounty hunter NPCs
    exports('GetSpawnedPeds', function()
        return spawnedPeds or {}
    end)

-- Server Exports (if called from server)
else
    
    -- Get player's outlaw status from database
    exports('GetPlayerOutlawStatus', function(source)
        local Player = RSGCore.Functions.GetPlayer(source)
        if not Player then return 0 end
        
        local citizenid = Player.PlayerData.citizenid
        local result = MySQL.query.await('SELECT outlawstatus FROM players WHERE citizenid = ? LIMIT 1', {citizenid})
        
        if result and result[1] and result[1].outlawstatus then
            return tonumber(result[1].outlawstatus) or 0
        end
        
        return 0
    end)
    
    -- Set player's outlaw status
    exports('SetPlayerOutlawStatus', function(source, newStatus, reason)
        reason = reason or 'Manual update via export'
        TriggerEvent('rex-wanted:server:updateOutlawStatus', source, newStatus, reason)
    end)
    
    -- Add to player's outlaw status
    exports('AddPlayerOutlawStatus', function(source, amount, reason)
        local Player = RSGCore.Functions.GetPlayer(source)
        if not Player then return end
        
        local citizenid = Player.PlayerData.citizenid
        local result = MySQL.query.await('SELECT outlawstatus FROM players WHERE citizenid = ? LIMIT 1', {citizenid})
        
        local currentStatus = 0
        if result and result[1] and result[1].outlawstatus then
            currentStatus = tonumber(result[1].outlawstatus) or 0
        end
        
        local newStatus = currentStatus + (tonumber(amount) or 0)
        reason = reason or 'Added via export'
        TriggerEvent('rex-wanted:server:updateOutlawStatus', source, newStatus, reason)
    end)
    
    -- Remove from player's outlaw status
    exports('RemovePlayerOutlawStatus', function(source, amount, reason)
        local Player = RSGCore.Functions.GetPlayer(source)
        if not Player then return end
        
        local citizenid = Player.PlayerData.citizenid
        local result = MySQL.query.await('SELECT outlawstatus FROM players WHERE citizenid = ? LIMIT 1', {citizenid})
        
        local currentStatus = 0
        if result and result[1] and result[1].outlawstatus then
            currentStatus = tonumber(result[1].outlawstatus) or 0
        end
        
        local newStatus = math.max(0, currentStatus - (tonumber(amount) or 0))
        reason = reason or 'Removed via export'
        TriggerEvent('rex-wanted:server:updateOutlawStatus', source, newStatus, reason)
    end)
    
    -- Clear player's outlaw status completely
    exports('ClearPlayerOutlawStatus', function(source)
        TriggerServerEvent('rex-wanted:server:clearOutlawStatus', source)
    end)

end
