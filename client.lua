local function Lobby()
   return lib.showMenu('Main')
end

lib.registerMenu({
    title = 'Lobbies',
    id = 'Main',
    position = 'top-right',
    options = {
        {label = 'Create A Lobby'},
        {label = 'Join A Lobby'},
        {label = "Leave Your Current Lobby"}
    }
}, function(selected)
    if selected == 1 then 
        local input = lib.inputDialog('Lobby Creation', {
            'Lobby Name', 
            'Password (Leave Blank If None)',
        })
        if input[2] and input[2]:len() > 3 then
            TriggerServerEvent('Lobbies', {type = 'New Lobby', Password = input[2], Name = input[1]})
        else
            TriggerServerEvent('Lobbies', {type = 'New Lobby', Name = input[1] or 'N/A'})
        end
    elseif selected == 2 then 
        local LobbyList = lib.callback.await('GetLobbyCount')
        local options = {
            {label = "Availible Lobbies", close = false}
        }

        for i = 1, #LobbyList do 
            options[#options+1] = {
                label = LobbyList[i].Name.. 'Made By'.. LobbyList[i].,                    
                description = 'Players In Lobby:' .. #LobbyList[i].Players
            }
        end

        lib.registerMenu({
            id = 'Join',
            title = 'Lobbies',
            position = 'top-right',
            options = options,

        }, function(selected)
            if selected > 1 then
                TriggerServerEvent('Lobbies', {type = 'Join Lobby', Lobby = selected})
            end
        end)
        lib.showMenu('Join')
    else
        TriggerServerEvent('Lobbies', {type = 'Leave'})
    end
end)


RegisterCommand('lobbies', Lobby)