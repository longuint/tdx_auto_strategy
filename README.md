# TDX Auto Strategy

> ⚠ This is for educational purposes only. ⚠ <br>
> I am not responsible for any damages caused by using this code

## Example Easy Mode Strategy

```lua

local TDX = loadstring(game.HttpService:GetAsync("https://raw.githubusercontent.com/longuint/tdx_auto_strategy/main/src/game.lua"))


if TDX:InLobby() then
    TDX["functions"]:SearchForGame("BLOX OUT")
else
    TDX:Game(
        function()
            TDX["tower"]:Place('Shotgunner', Vector3.new(-180,-9,-657))
        end,
    )
end
```

This provided file should go in your `autoexec` file.
