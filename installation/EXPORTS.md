# REX-WANTED EXPORTS

This document describes how to use the exports from the rex-wanted script in your own resources.

## Client-Side Exports

### GetOutlawStatus
Get the player's current outlaw status (from local cache).

```lua
local outlawStatus = exports['rex-wanted']:GetOutlawStatus()
print('Current outlaw status:', outlawStatus)
```

### IsHostile
Check if bounty hunters are currently hostile to the player.

```lua
local hostile = exports['rex-wanted']:IsHostile()
if hostile then
    print('Bounty hunters are attacking!')
end
```

### GetSpawnedPedCount
Get the number of bounty hunter NPCs currently spawned for this player.

```lua
local count = exports['rex-wanted']:GetSpawnedPedCount()
print('Active bounty hunters:', count)
```

### GetSpawnedPeds
Get a table of all spawned bounty hunter NPCs.

```lua
local peds = exports['rex-wanted']:GetSpawnedPeds()
for k, v in pairs(peds) do
    print('Bounty hunter ped:', v.spawnedPed)
end
```

---

## Server-Side Exports

### GetPlayerOutlawStatus
Get a player's outlaw status from the database.

```lua
local source = 1 -- player ID
local status = exports['rex-wanted']:GetPlayerOutlawStatus(source)
print('Player outlaw status:', status)
```

### SetPlayerOutlawStatus
Set a player's outlaw status to a specific value.

```lua
local source = 1 -- player ID
local newStatus = 50
local reason = 'Set via admin command'

exports['rex-wanted']:SetPlayerOutlawStatus(source, newStatus, reason)
```

### AddPlayerOutlawStatus
Add to a player's current outlaw status.

```lua
local source = 1 -- player ID
local amount = 10
local reason = 'Player committed crime'

exports['rex-wanted']:AddPlayerOutlawStatus(source, amount, reason)
```

**Example Usage:**
```lua
-- When player kills an NPC
RegisterServerEvent('myscript:npcKilled')
AddEventHandler('myscript:npcKilled', function()
    local src = source
    exports['rex-wanted']:AddPlayerOutlawStatus(src, 5, 'Killed NPC')
end)
```

### RemovePlayerOutlawStatus
Remove from a player's current outlaw status.

```lua
local source = 1 -- player ID
local amount = 5
local reason = 'Player paid fine'

exports['rex-wanted']:RemovePlayerOutlawStatus(source, amount, reason)
```

### ClearPlayerOutlawStatus
Clear a player's outlaw status completely (set to 0).

```lua
local source = 1 -- player ID
exports['rex-wanted']:ClearPlayerOutlawStatus(source)
```

---

## Integration Examples

### Crime System Integration
```lua
-- In your crime resource (server-side)
RegisterServerEvent('mycrime:playerRobbed')
AddEventHandler('mycrime:playerRobbed', function()
    local src = source
    local wantedLevel = 15
    
    exports['rex-wanted']:AddPlayerOutlawStatus(src, wantedLevel, 'Robbery')
end)
```

### Admin Command Integration
```lua
-- In your admin resource (server-side)
RegisterCommand('setwanted', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local wantedLevel = tonumber(args[2]) or 0
    
    if targetId and wantedLevel then
        exports['rex-wanted']:SetPlayerOutlawStatus(targetId, wantedLevel, 'Admin command')
        print('Set player ' .. targetId .. ' wanted level to ' .. wantedLevel)
    end
end, true) -- restricted to admins
```

### UI Display Integration
```lua
-- In your HUD resource (client-side)
CreateThread(function()
    while true do
        Wait(5000)
        
        local wantedLevel = exports['rex-wanted']:GetOutlawStatus()
        local isHostile = exports['rex-wanted']:IsHostile()
        
        -- Update your UI with wanted level and hostile status
        SendNUIMessage({
            type = 'updateWanted',
            level = wantedLevel,
            hostile = isHostile
        })
    end
end)
```

---

## Notes

- The `reason` parameter in server exports is optional and will be logged to Discord if webhook is configured.
- Client exports return cached values for performance.
- Server exports interact directly with the database.
- All server exports validate that the player exists before executing.
