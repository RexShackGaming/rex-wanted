local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

---------------------------------
-- get outlaw status
---------------------------------
RSGCore.Functions.CreateCallback('rex-wanted:server:getoutlawstatus', function(source, cb)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player ~= nil then
        MySQL.query('SELECT outlawstatus FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
            if result[1] then
                cb(result)
            else
                cb(nil)
            end
        end)
    end
end)
