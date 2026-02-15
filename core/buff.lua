local Buff = {}
Buff.__index = Buff

function Buff:new(name, duration, modifiers)
    local self = setmetatable({}, Buff)

    self.name = name
    self.duration = duration

    self.modifiers = modifiers or {}

    return self
end

return Buff
