local HttpService = game:GetService('HttpService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local module = {}

local baseURL = "https://raw.githubusercontent.com/longuint/tdx_auto_strategy/main/src/"

local remotes = ReplicatedStorage:WaitForChild('Remotes')

module.signals = loadstring(HttpService:GetAsync(baseURL .. 'signals.lua'))
module.interface = loadstring(HttpService:GetAsync(baseURL .. '/enum/interface.lua'))
module.functions = loadstring(HttpService:GetAsync(baseURL .. 'functions.lua'))
module.tower = loadstring(HttpService:GetAsync(baseURL .. 'tower.lua'))

function module:Game(actions, wave)
    wave = wave or 1

    if wave > #actions then
        return
    end

    actions[wave]()

    self:Game(actions, wave + 1)
end

function module:InLobby()
    return game.PlaceId == 11739766412
end

return module
