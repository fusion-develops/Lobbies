local Lobbies = {}
local SetPlayerRoutingBucket = SetPlayerRoutingBucket
local GetPlayerName = GetPlayerName


RegisterNetEvent('Lobbies', function(data)
    if data.type == 'New Lobby' then 
        local index = #Lobbies+1
        if data.Password then 
            Lobbies[index] = {
                Players = {GetPlayerName(source)},
                index = index,
                Password = data.Password,
                Name = data.Name
            }
        else
            Lobbies[index] = {
                Players = {GetPlayerName(source)},
                index = index,
                Name = data.Name
            }
        end
        SetPlayerRoutingBucket(source, index)
    elseif data.type == 'Leave' then 
        SetPlayerRoutingBucket(source, 0)
    elseif data.type == 'Join Lobby' then 
        local lobby = Lobbies[data.Lobby]
        if lobby.Password then 
            local pass = lib.callback.await('Lobby:EnterPassword', source)
            if lobby.Password == pass then 
                SetPlayerRoutingBucket(source, data.Lobby)
                lobby.Players = lobby.Players ..' '.. GetPlayerName(source)
            end
        else
            SetPlayerRoutingBucket(source, data.Lobby)
            lobby.Players = lobby.Players ..' '.. GetPlayerName(source)
        end
    end
end)



lib.callback.register('GetLobbyCount', function()
    return Lobbies
end)