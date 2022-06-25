local server = {}

_G.across = function(parsed)
    return proceed(parsed)
end

function info(parsed)
    return server[string.lower(parsed.class)][string.lower(parsed.module)]
end

function proceed(parsed)
    local data = info({class = parsed.class, module = parsed.module})
    if (server[string.lower(parsed.class)][string.lower(parsed.module)].allowClient ~= true and parsed.fromClient) then return end
    if (data.allowClient ~= true and parsed.fromClient) then return end
    return data[parsed.method].method(parsed)
end

for _,class in pairs(script.Parent.Framework:GetChildren())do
    local _class = {}
    for _,module in pairs(class:GetChildren())do
        if (module:IsA('ModuleScript')) then _class[string.lower(module.Name)] = require(module) end
        print('@SERVER: Required ' .. class.Name .. '.' .. module.Name)
    end
    server[string.lower(class.Name)] = _class
end

_G.RemoteEvent.OnServerEvent:Connect(function(player, parsed)
    local _parsed = parsed
    if parsed.player == nil then
        _parsed.player = player
    end
    proceed(_parsed)
end)

_G.RemoteFunction.OnServerInvoke = function(player, parsed)
    local _parsed = parsed
    _parsed.player = player
    return proceed(_parsed)
end

_G.Function.OnInvoke = function(parsed)
    return proceed(parsed)
end