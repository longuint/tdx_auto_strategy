local Players = game:GetService('Players')
local LocalPlayerGui = Players.LocalPlayer.PlayerGui
local Interface = LocalPlayerGui:WaitForChild('Interface')

return {
    ['SkipWave'] = Interface:WaitForChild('TopAreaQueueFrame'):WaitForChild(
        'SkipWaveVoteScreen'),
    ['GameInfoBar'] = {
        ['Base'] = Interface:WaitForChild('GameInfoBar'),
        ['Lives'] = Interface:WaitForChild('GameInfoBar'):WaitForChild(
            'LivesBar'):WaitForChild('LivesText'),
        ['Wave'] = Interface:WaitForChild('GameInfoBar'):WaitForChild('Wave')
            :WaitForChild('WaveText'),
        ['Time'] = Interface:WaitForChild('GameInfoBar')
            :WaitForChild('TimeLeft'):WaitForChild('TimeLeftText')
    },
    ['GameOverScreen'] = Interface:WaitForChild('GameOverScreen'),
    ['TowerUI'] = {['Base'] = Interface:WaitForChild('TowerUI')},
    ['BottomBar'] = {
        ['Base'] = Interface:WaitForChild('BottomBar'),
        -- ['TowersBar'] = Interface:WaitForChild('BottomBar'):WaitForChild('TowersBar'),
        ['Cash'] = Interface:WaitForChild('BottomBar'):WaitForChild('CashFrame')
            :WaitForChild('Text')
    }
}