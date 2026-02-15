local Status = {}
Status.__index = Status

function Status:new(name, duration, effectFunction)
    local self = setmetatable({}, Status)
    self.name = name
    self.duration = duration
    self.effectFunction = effectFunction
    return self
end

function Status:apply(target)
    self.effectFunction(target)
end

return Status
