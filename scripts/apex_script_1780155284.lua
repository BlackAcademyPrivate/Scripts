local report = {}

table.insert(report, "--- ReplicatedStorage ---")
for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetChildren()) do
    table.insert(report, "[" .. obj.ClassName .. "] " .. obj.Name)
end

table.insert(report, "\n--- Workspace ---")
for _, obj in ipairs(game:GetService("Workspace"):GetChildren()) do
    table.insert(report, "[" .. obj.ClassName .. "] " .. obj.Name)
end

return table.concat(report, "\n")