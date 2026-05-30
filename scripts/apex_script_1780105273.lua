local functions = {
    "getgenv", "getrenv", "getregistry", "getinstances", "getnilinstances",
    "getgc", "getloadedmodules", "getconnections", "fireclickdetector",
    "firetouchinterest", "gethui", "isexecutorclosure", "hookfunction"
}

print("--- DIAGNÓSTICO DE EXECUTOR ---")
for _, func in pairs(functions) do
    if _G[func] or (getgenv and getgenv()[func]) then
        print("[OK] " .. func)
    else
        print("[X] " .. func)
    end
end
print("--- FIM DO DIAGNÓSTICO ---")