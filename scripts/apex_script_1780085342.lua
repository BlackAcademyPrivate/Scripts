local Lighting = game:GetService("Lighting")

-- 1. Defina os limites de horário (em formato de 24h)
local INICIO_DIA = 6.0     -- 06:00
local INICIO_TARDE = 12.0   -- 12:00
local INICIO_NOITE = 18.0   -- 18:00

-- Variável para guardar o último período e evitar execuções repetidas
local ultimoPeriodo = ""

-- 2. Funções de comando para cada período
local function executarComandosDia()
	print("[SISTEMA] Amanheceu! Executando comandos do Dia.")
	-- Adicione seus comandos de DIA aqui. Exemplos:
	-- workspace.Baseplate.Color = Color3.fromRGB(120, 200, 120) -- Grama verde clara
	-- Lighting.Ambient = Color3.fromRGB(128, 128, 128)
end

local function executarComandosTarde()
	print("[SISTEMA] Entardeceu! Executando comandos da Tarde.")
	-- Adicione seus comandos de TARDE aqui. Exemplos:
	-- Lighting.Ambient = Color3.fromRGB(150, 110, 90) -- Tom mais alaranjado
end

local function executarComandosNoite()
	print("[SISTEMA] Anoiteceu! Executando comandos da Noite.")
	-- Adicione seus comandos de NOITE aqui. Exemplos:
	-- workspace.StreetLights:AtivarPostes() 
	-- Lighting.Ambient = Color3.fromRGB(30, 30, 50) -- Tom azul escuro
end

-- 3. Função principal que checa o horário e decide qual comando rodar
local function atualizarPeriodo()
	local horaAtual = Lighting.ClockTime
	local periodoAtual = ""

	-- Determina em qual período a hora atual se encaixa
	if horaAtual >= INICIO_DIA and horaAtual < INICIO_TARDE then
		periodoAtual = "Dia"
	elseif horaAtual >= INICIO_TARDE and horaAtual < INICIO_NOITE then
		periodoAtual = "Tarde"
	else
		periodoAtual = "Noite" -- Entre 18:00 e 05:59
	end

	-- Só executa os comandos se o período realmente mudou
	if periodoAtual ~= ultimoPeriodo then
		ultimoPeriodo = periodoAtual

		if periodoAtual == "Dia" then
			executarComandosDia()
		elseif periodoAtual == "Tarde" then
			executarComandosTarde()
		elseif periodoAtual == "Noite" then
			executarComandosNoite()
		end
	end
end

-- 4. Conecta a verificação à mudança de horário do jogo
Lighting:GetPropertyChangedSignal("ClockTime"):Connect(atualizarPeriodo)

-- Executa uma vez logo que o jogo inicia para definir o estado inicial
atualizarPeriodo()