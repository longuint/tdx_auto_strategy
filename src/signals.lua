local HttpService = game:GetService("HttpService")
local signals = {}

local baseURL =
    "https://raw.githubusercontent.com/longuint/tdx_auto_strategy/main/src/"
local interface = loadstring(HttpService:GetAsync(baseURL ..
                                                      '/enum/interface.lua'))

function signals:WaitForCash(cash, callback)
    local cleanedAmount = interface.BottomBar.Cash.Text:gsub("[%s$]", "")
    local currentAmount = tonumber(cleanedAmount)

    repeat task.wait() until currentAmount and currentAmount >= cash

    if currentAmount and currentAmount >= cash then callback() end
end

function signals:WaitForWaveChange(callback)
    interface.GameInfoBar.Wave.Changed:Connect(callback)
end

return signals
