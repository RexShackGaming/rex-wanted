local RSGCore = exports['rsg-core']:GetCoreObject()
local playerSpawnCooldowns = {} -- anti-spam
lib.locale()

---------------------------------
-- discord webhook functions
---------------------------------
local function SendDiscordLog(title, description, fields, color)
    if not Config.Discord.Enabled or not Config.Discord.WebhookURL or Config.Discord.WebhookURL == '' then
        return
    end
    
    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["color"] = color or Config.Discord.Color,
            ["fields"] = fields or {},
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S")
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
        }
    }
    
    PerformHttpRequest(Config.Discord.WebhookURL, function(err, text, headers) end, 'POST', json.encode({
        username = Config.Discord.BotName,
        avatar_url = Config.Discord.BotAvatar,
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

local function LogOutlawStatusChange(src, citizenid, outlawStatus, reason)
    if not Config.Discord.LogOutlawStatus then return end
    
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local playerName = GetPlayerName(src)
    local identifier = GetPlayerIdentifiers(src)[1] or 'Unknown'
    
    local fields = {
        { ["name"] = locale('discord_field_player'), ["value"] = playerName, ["inline"] = true },
        { ["name"] = locale('discord_field_citizenid'), ["value"] = citizenid, ["inline"] = true },
        { ["name"] = locale('discord_field_wanted_level'), ["value"] = tostring(outlawStatus), ["inline"] = true },
        { ["name"] = locale('discord_field_identifier'), ["value"] = identifier, ["inline"] = false },
    }
    
    if reason then
        table.insert(fields, { ["name"] = locale('discord_field_reason'), ["value"] = reason, ["inline"] = false })
    end
    
    local color = outlawStatus >= Config.OutlawTriggerAmount and 16711680 or 16776960 -- Red or Yellow
    
    SendDiscordLog(
        locale('discord_wanted_update_title'),
        locale('discord_wanted_update_desc'),
        fields,
        color
    )
end

local function LogStatusCleared(src, citizenid)
    if not Config.Discord.LogStatusCleared then return end
    
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local playerName = GetPlayerName(src)
    local identifier = GetPlayerIdentifiers(src)[1] or 'Unknown'
    
    local fields = {
        { ["name"] = locale('discord_field_player'), ["value"] = playerName, ["inline"] = true },
        { ["name"] = locale('discord_field_citizenid'), ["value"] = citizenid, ["inline"] = true },
        { ["name"] = locale('discord_field_identifier'), ["value"] = identifier, ["inline"] = false },
    }
    
    SendDiscordLog(
        locale('discord_status_cleared_title'),
        locale('discord_status_cleared_desc'),
        fields,
        65280 -- Green color
    )
end

---------------------------------
-- get outlaw status (cached)
---------------------------------
local statusCache = {}
local CACHE_DURATION = 5000 -- 5 seconds

RSGCore.Functions.CreateCallback('rex-wanted:server:getoutlawstatus', function(source, cb)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then
        cb(nil)
        return
    end
    
    local citizenid = Player.PlayerData.citizenid
    local now = GetGameTimer()
    
    -- Return cached value if fresh
    if statusCache[citizenid] and (now - statusCache[citizenid].time) < CACHE_DURATION then
        cb({{ outlawstatus = statusCache[citizenid].value }})
        return
    end
    
    -- Fetch from DB with validation
    MySQL.query('SELECT outlawstatus FROM players WHERE citizenid = ? LIMIT 1', {citizenid}, function(result)
        if result and result[1] and result[1].outlawstatus then
            local status = tonumber(result[1].outlawstatus) or 0
            statusCache[citizenid] = { value = status, time = now }
            cb({{ outlawstatus = status }})
        else
            cb({{ outlawstatus = 0 }})
        end
    end)
end)

---------------------------------
-- server-side NPC spawn validation
---------------------------------
RegisterNetEvent('rex-wanted:server:requestNpcSpawn', function(locationKey)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    -- Rate limiting
    local now = GetGameTimer()
    if playerSpawnCooldowns[src] and (now - playerSpawnCooldowns[src]) < 1000 then
        return -- too fast, ignore
    end
    
    playerSpawnCooldowns[src] = now
    
    -- Validate location exists
    if not locationKey or locationKey < 1 or locationKey > #Config.BanditLocations then
        return
    end
    
    -- Authorize spawn
    TriggerClientEvent('rex-wanted:client:spawnNpc', src, locationKey)
end)

---------------------------------
-- clear outlaw status on death
---------------------------------
RegisterNetEvent('rex-wanted:server:clearOutlawStatus', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    -- Clear in database
    MySQL.update('UPDATE players SET outlawstatus = ? WHERE citizenid = ?', {0, citizenid}, function(affectedRows)
        if affectedRows > 0 then
            -- Clear cache
            statusCache[citizenid] = { value = 0, time = GetGameTimer() }
            
            -- Log to Discord
            LogStatusCleared(src, citizenid)
            
            -- Notify player
            TriggerClientEvent('ox_lib:notify', src, {
                title = locale('notify_outlaw_cleared_title'),
                description = locale('notify_outlaw_cleared_desc'),
                type = 'success',
                duration = 5000
            })
        end
    end)
end)

---------------------------------
-- update outlaw status
---------------------------------
RegisterNetEvent('rex-wanted:server:updateOutlawStatus', function(newStatus, reason)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    newStatus = tonumber(newStatus) or 0
    
    -- Update database
    MySQL.update('UPDATE players SET outlawstatus = ? WHERE citizenid = ?', {newStatus, citizenid}, function(affectedRows)
        if affectedRows > 0 then
            -- Update cache
            statusCache[citizenid] = { value = newStatus, time = GetGameTimer() }
            
            -- Log to Discord
            LogOutlawStatusChange(src, citizenid, newStatus, reason)
            
            -- Notify player
            local statusText = newStatus >= Config.OutlawTriggerAmount and locale('notify_outlaw_wanted') or locale('notify_outlaw_updated')
            TriggerClientEvent('ox_lib:notify', src, {
                title = locale('notify_outlaw_status_title') .. ' ' .. statusText,
                description = locale('notify_outlaw_level', {level = newStatus}),
                type = newStatus >= Config.OutlawTriggerAmount and 'error' or 'warning',
                duration = 5000
            })
        end
    end)
end)

---------------------------------
-- cronjob: reduce outlaw status by 1 every minute (only online players)
---------------------------------
lib.cron.new('* * * * *', function()
    local Players = RSGCore.Functions.GetPlayers()
    for _, playerId in ipairs(Players) do
        local Player = RSGCore.Functions.GetPlayer(playerId)
        if Player then
            local citizenid = Player.PlayerData.citizenid
            -- fetch current outlaw status
            MySQL.query('SELECT outlawstatus FROM players WHERE citizenid = ? LIMIT 1', {citizenid}, function(result)
                if result and result[1] and result[1].outlawstatus and result[1].outlawstatus > 0 then
                    local newStatus = math.max(0, result[1].outlawstatus - 1)
                    MySQL.update('UPDATE players SET outlawstatus = ? WHERE citizenid = ?', {newStatus, citizenid}, function()
                        -- Update cache
                        statusCache[citizenid] = { value = newStatus, time = GetGameTimer() }
                    end)
                end
            end)
        end
    end
end)

-- Cleanup cache on player drop
AddEventHandler('playerDropped', function()
    local src = source
    playerSpawnCooldowns[src] = nil
    
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player then
        local citizenid = Player.PlayerData.citizenid
        statusCache[citizenid] = nil
    end
end)
