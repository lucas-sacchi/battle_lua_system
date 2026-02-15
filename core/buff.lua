local Buff = {}
Buff.__index = Buff

function Buff:new(name, duration, attackMultiplier)
    local self = setmetatable({}, Buff)
    self.name = name
    self.duration = duration
    self.attackMultiplier = attackMultiplier or 1
    return self
end

return Buff
