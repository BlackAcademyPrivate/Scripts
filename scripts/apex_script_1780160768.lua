local TextChatService = game:GetService("TextChatService")
local textChannel = TextChatService.TextChannels.RBXGeneral -- Canal padrão

-- Isso envia uma mensagem como se fosse o jogador
textChannel:SendAsync("Olá, estou usando o Delta!")