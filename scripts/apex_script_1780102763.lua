local executor = "Desconhecido"

if getgenv then
    executor = "Executor Genérico (Ex: Fluxus, KRNL, Solara, Wave)"
    if gethui then
        executor = "Executor Genérico com GUI (Ex: Fluxus, KRNL, Solara, Wave)"
    end
end

if syn then
    if syn.request then
        executor = "Synapse X"
    end
end

if http and http.request then
    executor = "HTTP Service (Pode ser de vários executores)"
end

if request then
    executor = "Request (Pode ser de vários executores)"
end

return executor