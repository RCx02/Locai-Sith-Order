local remotes = game.ReplicatedStorage:WaitForChild('Remotes')
_G.RemoteEvent = remotes:WaitForChild('RemoteEvent')
_G.RemoteFunction = remotes:WaitForChild('RemoteFunction')
_G.Function = remotes:WaitForChild('Function')

return {}