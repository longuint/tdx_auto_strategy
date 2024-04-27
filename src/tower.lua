local ReplicatedStorage = game:GetService("ReplicatedStorage")
local module = {}

local remotes = ReplicatedStorage:WaitForChild('Remotes')

function module:Place(id, position)
    remotes:WaitForChild('PlaceTower'):InvokeServer(unpack({
        [1] = 0,
        [2] = id,
        [3] = position,
        [4] = 0
    }))
end

function module:Upgrade(id, path)
    remotes:WaitForChild('TowerUpgradeRequest'):FireServer(unpack({
        [1] = id,
        [2] = path
    }))
end

function module:Sell(id)
    remotes:WaitForChild('SellTower'):FireServer(unpack({[1] = id}))
end

function module:Ability(id)
    remotes:WaitForChild("TowerUseAbilityRequest"):InvokeServer(unpack({
        [1] = id,
        [2] = 1
    }))
end

--[[
    [0] - First
    [1] - Last
    [2] - Strongest
    [3] - Weakest
    [4] - Random
]]
function module:Target(id, target)
    remotes:WaitForChild('ChangeQueryType'):FireServer(unpack({
        [1] = id,
        [2] = target
    }))
end

return module
