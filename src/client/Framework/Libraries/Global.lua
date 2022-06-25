local remotes = game.ReplicatedStorage:WaitForChild('Remotes')
_G.RemoteEvent = remotes:WaitForChild('RemoteEvent')
_G.RemoteFunction = remotes:WaitForChild('RemoteFunction')
_G.Function = remotes:WaitForChild('Function')

_G.create = function(parsed)
    return function(_parsed)
        local instance = Instance.new(parsed)
        for key,value in pairs(_parsed) do
            instance[key] = value
        end
        return instance
    end
end

return {}