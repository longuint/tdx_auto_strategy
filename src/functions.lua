local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local module = {}

local remotes = ReplicatedStorage:WaitForChild('Remotes')

function module:SkipWave()
    remotes:WaitForChild('SkipWaveVoteCast'):FireServer(unpack({[1] = true}))
end

function module:CastDifficulty(difficulty)
    remotes:WaitForChild('DifficultyVoteCast'):FireServer(unpack({
        [1] = difficulty
    }))
end

function module:CastReady()
    remotes:WaitForChild("DifficultyVoteReady"):FireServer()
end

function module:ToggleSpeedBoost()
    remotes:WaitForChild("ToggleSpeedupTier1"):FireServer(unpack({[1] = true}))
end

local function JoinLobby(lobbyNumber)
    local Player = Players.LocalPlayer.Character
    Player:PivotTo(Workspace['APCs'][lobbyNumber]['APC'].Detector.CFrame)
end

function module:SearchForGame(mapName)
    local Lobbies = Workspace['APCs']:GetChildren()
    table.insert(Lobbies, Workspace['APCs2']:GetChildren())
    for i, lobby in pairs(Lobbies) do
        local LobbyScreen = lobby['mapdisplay']['screen']['displayscreen']
        local Map = LobbyScreen['map'].Text
        if Map == mapName then JoinLobby(lobby.Name) end
    end
end

return module
