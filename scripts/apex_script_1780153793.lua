-- No Servidor (Vulnerável)
    recompensaEvent.OnServerEvent:Connect(function(player, quantidade)
        player.leaderstats.Gold.Value = player.leaderstats.Gold.Value + quantidade
    end)