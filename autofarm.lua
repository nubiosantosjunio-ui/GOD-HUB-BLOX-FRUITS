--[[
    🔥 GOD HUB - Baseado no REDZ HUB
    - Keyless (sem chave)
    - 100% funcional para Blox Fruits
    - Interface GOD HUB
--]]

-- Carrega o REDZ HUB original e modifica
local redzSource = game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau")

-- Modifica o nome e aparência
local modifiedSource = redzSource:gsub("REDZ HUB", "GOD HUB")
local modifiedSource = modifiedSource:gsub("redz", "god")
local modifiedSource = modifiedSource:gsub("Redz", "God")

-- Executa o script modificado
local func = loadstring(modifiedSource)
if func then
    func()
    print("✅ GOD HUB carregado com sucesso!")
else
    -- Fallback: carrega o script original
    print("⚠️ Falha ao modificar, carregando REDZ HUB original...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"))()
end
