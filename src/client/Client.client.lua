local client = {}

function info(parsed)
    return client[string.lower(parsed.class)][string.lower(parsed.module)]
end

function proceed(parsed)
    local data = info({class = parsed.class, module = parsed.module})
    return data[parsed.method].method(parsed)
end

for _,class in pairs(script.Parent:WaitForChild('Framework'):GetChildren())do
    local _class = {}
    for _,module in pairs(class:GetChildren())do
        if (module:IsA('ModuleScript')) then _class[string.lower(module.Name)] = require(module) end
        print('@CLIENT: Required ' .. class.Name .. '.' .. module.Name)
    end
    client[string.lower(class.Name)] = _class
end

_G.across = function(parsed)
    return proceed(parsed)
end

_G.RemoteEvent.OnClientEvent:Connect(function(parsed)
    return proceed(parsed)
end)