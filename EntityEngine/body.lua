require "External-lib/class"

Body = class()

function Body:init(param)
    param = param or {}
    self.entity = entity
    self.x = param.x or 0
    self.y = param.y or 0
    self.angle = param.angle or param.rotation or param.r or 0
    self.radius = param.raduis or param.size or param.s or 0
end

function Body:testCollision(entity)
    if entity.body == nil then return false end 
    local dx = self.x - entity.body.x;
    local dy = self.y - entity.body.y;
    
    return ((dx * dx) + (dy * dy)) <= (self.radius + otherEntity.body.radius)
end

