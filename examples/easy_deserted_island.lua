local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService('Players')
local Workspace = game:GetService("Workspace")

local module = {}

-- #region TDX

local remotes = ReplicatedStorage:WaitForChild('Remotes')

local LocalPlayerGui = Players.LocalPlayer.PlayerGui

local PlayerInterface;
local Interface = {};

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

local function hasEnoughCash(cash)
    local text = string.gsub(Interface.BottomBar.Cash.Text, "[$]+", "")
    print(text)
    print(tonumber(text))
    return tonumber(text) >= cash
end

function module:WaitForCash(cash, callback)
    task.wait(1)
    repeat task.wait(0.5) until hasEnoughCash(cash)
    print('finished obtaining $' .. cash)
    callback()
end

function module:WaitForWaveChange(callback)
    local connection = Interface.GameInfoBar.Wave:GetPropertyChangedSignal(
                           'Text')
    connection = connection:Connect(callback)
    connection:Disconnect()
end

function module:WaitForWaveEquals(wave, callback)
    repeat task.wait() until Interface.GameInfoBar.Wave.Text == "WAVE " .. wave
    callback()
end

function module:SkipWave()

    local connection = Interface.SkipWave:GetPropertyChangedSignal('Visible')
    connection = connection:Connect(function()
        if Interface.SkipWave.Visible == true then
            remotes:WaitForChild('SkipWaveVoteCast'):FireServer(unpack({
                [1] = true
            }))
            connection:Disconnect()
        end
    end)

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

module.inLobbyElevator = false

local function JoinLobby(lobbyNumber, apcNumber)
    local Player = Players.LocalPlayer.Character
    Player:PivotTo(Workspace['APCs' .. apcNumber][lobbyNumber]['APC'].Detector
                       .CFrame)
    module.inLobbyElevator = true
end

module.elevatorText = ""

function module:SearchForGame(mapName, callback)
    local Lobbies = Workspace['APCs']:GetChildren()
    local Lobbies2 = Workspace['APCs2']:GetChildren()

    repeat
        for i, lobby in pairs(Lobbies) do
            local LobbyScreen =
                lobby['mapdisplay']:WaitForChild('screen')['displayscreen']
            local Map = LobbyScreen['map'].Text
            if Map == mapName and not module:IsThereMoreThanOnePlayerInLobby(
                lobby['mapdisplay']:WaitForChild('screen')['displayscreen']['plrcount']
                    .Text) then JoinLobby(lobby.Name, "") end

            lobby['mapdisplay']:WaitForChild('screen')['displayscreen']['plrcount']:GetPropertyChangedSignal(
                'Text'):Connect(function()
                if module:IsThereMoreThanOnePlayerInLobby(
                    lobby['mapdisplay']:WaitForChild('screen')['displayscreen']['plrcount']
                        .Text) then module:LeaveLobby() end
            end)
        end

        for i, lobby in pairs(Lobbies2) do
            local LobbyScreen =
                lobby['mapdisplay']:WaitForChild('screen')['displayscreen']
            local Map = LobbyScreen['map'].Text

            module.elevatorText =
                lobby['mapdisplay']:WaitForChild('screen')['displayscreen']['plrcount']
                    .Text

            if Map == mapName and not module:IsThereMoreThanOnePlayerInLobby(
                lobby['mapdisplay']:WaitForChild('screen')['displayscreen']['plrcount']
                    .Text) then JoinLobby(lobby.Name, 2) end

            lobby['mapdisplay']:WaitForChild('screen')['displayscreen']['plrcount']:GetPropertyChangedSignal(
                'Text'):Connect(function()
                if module:IsThereMoreThanOnePlayerInLobby(
                    lobby['mapdisplay']:WaitForChild('screen')['displayscreen']['plrcount']
                        .Text) then module:LeaveLobby() end
            end)
        end
        task.wait(5)
    until module.inLobbyElevator

    callback()

end

function module:Game(action) action() end

function isEndScreenOpen()
    return PlayerInterface:WaitForChild('GameOverScreen').Visible
end

function didWin(screen)
    return screen:WaitForChild('Main'):WaitForChild('VictoryText').Visible
end

function module:RequestTeleportToLobby()
    remotes:WaitForChild('RequestTeleportToLobby'):FireServer()
end

function module:LeaveLobby() remotes.Network.LeaveQueue:FireServer() end

function module:IsThereMoreThanOnePlayerInLobby(lobbyText)
    local text = lobbyText:gsub("[/4]", "")
    return tonumber(text) > 1
end

function module:InLobby() return game.PlaceId == 11739766412 end

-- #endregion
-- #region UI Functions
local UI = {}

UI.MakeBannerContainer = function()
    local Frame = Instance.new('Frame')

    Frame.Size = UDim2.new(0, 360, 0, 32)
    Frame.Position = UDim2.new(0.5, -180, 0, 32)

    Frame.BackgroundTransparency = 1
    Frame.ZIndex = 99999999

    return Frame

end

UI.MakeBanner = function(text, gui)
    local MainFrame = Instance.new('Frame')
    MainFrame.Size = UDim2.new(0, 360, 0, 32)
    MainFrame.Position = UDim2.new(0.5, -180, 0, 100)

    MainFrame.BackgroundColor3 = Color3.fromRGB(34, 51, 51)
    MainFrame.BackgroundTransparency = 0.3

    local MainFrameStroke = Instance.new('UIStroke')
    MainFrameStroke.Thickness = 3
    MainFrameStroke.Color = Color3.fromHex("#FF8E2C")
    MainFrameStroke.Parent = MainFrame

    local MainFrameCorner = Instance.new('UICorner')
    MainFrameCorner.CornerRadius = UDim.new(0, 3)
    MainFrameCorner.Parent = MainFrame

    local MainFrameTextFrame = Instance.new('Frame')
    MainFrameTextFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrameTextFrame.BackgroundTransparency = 1
    MainFrameTextFrame.Parent = MainFrame

    local MainFrameTextFrameText = Instance.new('TextLabel')
    MainFrameTextFrameText.Size = UDim2.new(1, 0, 1, 0)
    MainFrameTextFrameText.Font = Enum.Font.GothamBold
    MainFrameTextFrameText.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainFrameTextFrameText.Text = text
    MainFrameTextFrameText.TextXAlignment = Enum.TextXAlignment.Center
    MainFrameTextFrameText.TextYAlignment = Enum.TextYAlignment.Center
    MainFrameTextFrameText.BackgroundTransparency = 1
    MainFrameTextFrameText.RichText = true
    MainFrameTextFrameText.TextSize = 16
    MainFrameTextFrameText.Parent = MainFrameTextFrame

    MainFrame.Parent = gui

    return MainFrame

end
-- #endregion
-- #region Strategy

local actions = {
    function()
        module:Place("Grenadier", Vector3.new(-180.5770263671875,
                                              -9.067782402038574,
                                              -657.5142211914062))
        module:Upgrade(1, 1)
    end, function() module:Upgrade(1, 1) end,
    function() module:Upgrade(1, 2) end, function()
        module:Upgrade(1, 2)
        module:SkipWave()
    end, function()
        module:Place('Grenadier', Vector3.new(-183.38494873046875,
                                              -9.067782402038574,
                                              -658.7525634765625))

        module:WaitForCash(150, function() module:Upgrade(2, 1) end)
        module:WaitForCash(350, function() module:Upgrade(2, 2) end)
        module:SkipWave()
    end, function()
        module:WaitForCash(450, function() module:Upgrade(2, 1) end)
        module:WaitForCash(750, function() module:Upgrade(2, 2) end)
        module:SkipWave()
    end,
    function() module:WaitForCash(1600, function() module:Upgrade(2, 1) end) end,
    function() module:WaitForCash(1600, function() module:Upgrade(1, 1) end) end,
    function() module:SkipWave() end, function()
        module:WaitForCash(6350, function()
            module:Place('Juggernaut', Vector3.new(-190.18272399902344,
                                                   -9.067782402038574,
                                                   -670.2721557617188))
        end)
        module:WaitForCash(850, function() module:Upgrade(3, 1) end)
        module:WaitForCash(600, function() module:Upgrade(3, 2) end)
        module:SkipWave()
    end, function()
        module:WaitForCash(1600, function() module:Upgrade(3, 1) end)
        module:SkipWave()
    end, function()
        module:WaitForCash(3650, function() module:Upgrade(3, 2) end)
        module:SkipWave()
    end, function()
        module:WaitForCash(7500, function() module:Upgrade(3, 2) end)
        module:SkipWave()
    end, function() end, function()
        module:Place("EDJ", Vector3.new(-194.59683227539062, -9.057302474975586,
                                        -669.7723999023438))
        module:WaitForCash(500, function() module:Upgrade(4, 1) end)
        module:WaitForCash(850, function() module:Upgrade(4, 2) end)
        module:WaitForCash(1500, function() module:Upgrade(4, 1) end)
        module:WaitForCash(1100, function() module:Upgrade(4, 2) end)
        module:WaitForCash(4300, function() module:Upgrade(4, 1) end)
        module:SkipWave()
    end,
    function() module:WaitForCash(5500, function() module:Upgrade(4, 1) end) end,
    function() module:SkipWave() end, function()
        module:WaitForCash(14000, function() module:Upgrade(3, 2) end)
        module:SkipWave()
    end, function() module:SkipWave() end, function() module:SkipWave() end,
    function() end, function()
        module:WaitForCash(60000, function() module:Upgrade(3, 2) end)
        module:WaitForCash(6350, function()
            module:Place('Juggernaut', Vector3.new(-201.4980010986328,
                                                   -9.067782402038574,
                                                   -670.246826171875))
            module:WaitForCash(850, function() module:Upgrade(5, 1) end)
            module:WaitForCash(600, function() module:Upgrade(5, 2) end)
            module:WaitForCash(1600, function() module:Upgrade(5, 1) end)
            module:WaitForCash(3650, function() module:Upgrade(5, 2) end)
            module:SkipWave()
        end)
    end, function()
        module:WaitForCash(7500, function() module:Upgrade(5, 2) end)
        module:WaitForCash(14000, function() module:Upgrade(5, 2) end)
        module:WaitForCash(50000, function() module:SkipWave() end)
    end, function()
        module:WaitForCash(60000, function() module:Upgrade(5, 2) end)
        module:Place('Juggernaut', Vector3.new(-185.69247436523438,
                                               -9.067782402038574,
                                               -668.3163452148438))
        module:WaitForCash(850, function() module:Upgrade(6, 1) end)
        module:WaitForCash(600, function() module:Upgrade(6, 2) end)
        module:WaitForCash(1600, function() module:Upgrade(6, 1) end)
        module:WaitForCash(3650, function() module:Upgrade(6, 2) end)
        module:WaitForCash(7500, function() module:Upgrade(6, 2) end)
        module:WaitForCash(14000, function() module:Upgrade(6, 2) end)
        module:WaitForCash(40000, function() module:Ability(4) end)
        module:WaitForCash(60000, function()
            module:Upgrade(4, 1)
            module:Ability(4)
        end)
    end

}
-- #endregion

local ScreenGui = Instance.new('ScreenGui')
ScreenGui.Name = 'strategy'
ScreenGui.Parent = Players.LocalPlayer.PlayerGui
ScreenGui.Enabled = true

local BannerContainer = UI.MakeBannerContainer()
local Banner = UI.MakeBanner("", BannerContainer)

BannerContainer.Parent = ScreenGui

if not module:InLobby() then
    Banner.UIStroke.Color = Color3.fromHex('#A2FF2C')
    Banner.Frame.TextLabel.Text = "<i>Searching for lobby</i>"
    module:SearchForGame("DESERTED ISLAND", function()
        Banner.Frame.TextLabel.Text = "Found Lobby!"
    end)
else

    PlayerInterface = LocalPlayerGui:WaitForChild('Interface')

    Interface = {
        ['SkipWave'] = PlayerInterface:WaitForChild('TopAreaQueueFrame')
            :WaitForChild('SkipWaveVoteScreen'),
        ['GameInfoBar'] = {
            ['Base'] = PlayerInterface:WaitForChild('GameInfoBar'),
            ['Lives'] = PlayerInterface:WaitForChild('GameInfoBar')
                :WaitForChild('LivesBar'):WaitForChild('LivesText'),
            ['Wave'] = PlayerInterface:WaitForChild('GameInfoBar'):WaitForChild(
                'Wave'):WaitForChild('WaveText'),
            ['Time'] = PlayerInterface:WaitForChild('GameInfoBar'):WaitForChild(
                'TimeLeft'):WaitForChild('TimeLeftText')
        },
        ['GameOverScreen'] = PlayerInterface:WaitForChild('GameOverScreen'),
        ['TowerUI'] = {['Base'] = PlayerInterface:WaitForChild('TowerUI')},
        ['BottomBar'] = {
            ['Base'] = PlayerInterface:WaitForChild('BottomBar'),
            -- ['TowersBar'] = Interface:WaitForChild('BottomBar'):WaitForChild('TowersBar'),
            ['Cash'] = PlayerInterface:WaitForChild('BottomBar'):WaitForChild(
                'CashFrame'):WaitForChild('Text')
        }
    }

    module:CastDifficulty('Easy')
    module:CastReady()
    module:ToggleSpeedBoost()

    for i, v in pairs(actions) do
        Banner.UIStroke.Color = Color3.fromHex('#FF8E2C')
        Banner.Frame.TextLabel.Text = '<i>InstructionAction</i>: ' .. i - 1
        module:WaitForWaveEquals(i, function() module:Game(v) end)
    end
    Banner.UIStroke.Color = Color3.fromHex('#FF392C')
    Banner.Frame.TextLabel.Text = 'End of InstructionActions'
    repeat task.wait(1) until isEndScreenOpen()
    module:RequestTeleportToLobby()

end
