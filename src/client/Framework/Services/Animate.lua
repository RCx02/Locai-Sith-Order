local animate = {}
local tracks = {}

local player = game.Players.LocalPlayer

animate.play = {
    method = function(parsed)
        local animationData = _G.animations[parsed.alias]

        if animationData[2] ~= nil then
            player.Character.Humanoid.WalkSpeed = animationData[2]
        end

        if animationData[3] ~= nil then
            player.Character.Humanoid.JumpPower = animationData[3]
        end

        if tracks[parsed.alias] ~= nil then tracks[parsed.alias].animation:Play() tracks[parsed.alias].playing = true return end
    
        local animation = _G.create('Animation'){
            Name = parsed.alias,
            AnimationId = 'rbxassetid://'..animationData[1]
        }
    
        local track = player.Character:WaitForChild('Humanoid'):LoadAnimation(animation)
        track:Play()
        tracks[parsed.alias] = {animation = track, playing = true}
    end
}

animate.init = {
    method = function()
        tracks = {}
    end
}

animate.stop = {
    method = function(parsed)
        if tracks[parsed.alias].playing then
            tracks[parsed.alias].playing = false
            tracks[parsed.alias].animation:Stop()

            player.Character.Humanoid.WalkSpeed = _G.RemoteFunction:InvokeServer({class = 'services', module = 'playerService', method = 'characterStat', key = 'WalkSpeed'})
            player.Character.Humanoid.JumpPower = _G.RemoteFunction:InvokeServer({class = 'services', module = 'playerService', method = 'characterStat', key = 'JumpPower'})
        end
    end
}

return animate