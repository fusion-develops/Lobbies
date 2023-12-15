local Lobbies = {}
local SetPlayerRoutingBucket = SetPlayerRoutingBucket
local GetPlayerName = GetPlayerName


RegisterNetEvent('Lobbies', function(data)
    if data.type == 'New Lobby' then 
        local index = #Lobbies+1
        local name = GetPlayerName(source)

        if data.Password then 
            Lobbies[index] = {
                Players = {name},
                CachedPlayers = {source},
                index = index,
                Password = data.Password,
                Name = data.Name,
                source = source,
                Creator = name,
                Settings = data.Settings
            }
        else
            Lobbies[index] = {
                Players = {name},
                index = index,
                CachedPlayers = {source},
                Name = data.Name,
                Creator = name,
                Settings = data.Settings
            }
        end
        SetPlayerRoutingBucket(source, index)
    elseif data.type == 'Leave' then 
        SetPlayerRoutingBucket(source, 0)
        for i = 1, #Lobbies do 
            local Lobby = Lobbies[i]
            if Lobby.Creator == source then 
                for j = 1, #Lobby.CachedPlayers do 
                    local Player = Lobby.CachedPlayers[j]
                    SetPlayerRoutingBucket(Player, 0)
                    TriggerClientEvent('Lobbies', Player, nil)
                end
                Lobby = nil
            end
        end 
    elseif data.type == 'Join Lobby' then 
        local lobby = Lobbies[data.Lobby]
        if lobby.Password then 
            local pass = lib.callback.await('Lobby:EnterPassword', source)
            if lobby.Password == pass then 
                SetPlayerRoutingBucket(source, data.Lobby)
                lobby.Players[#lobby.Players+1] = GetPlayerName(source)
                lobby.CachedPlayers[lobby.CachedPlayers+1] = source
            end
        else
            SetPlayerRoutingBucket(source, data.Lobby)
            lobby.Players[#lobby.Players+1] = GetPlayerName(source)
            lobby.CachedPlayers[lobby.CachedPlayers+1] = source
        end
        TriggerClientEvent('Lobbies', source, lobby.Settings)
    end
end)



lib.callback.register('GetLobbyCount', function()
    return Lobbies
end)

AddEventHandler('playerDropped', function ()
    for i = 1, #Lobbies do 
        local Lobby = Lobbies[i]
        if Lobby.Creator == source then 
            for j = 1, #Lobby.CachedPlayers do 
                local Player = Lobby.CachedPlayers[j]
                SetPlayerRoutingBucket(Player, 0)
                TriggerClientEvent('Lobbies', Player, nil)
            end
            Lobby = nil
        end
    end 
end)