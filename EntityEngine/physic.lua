require "External-Lib/Class"

Physic = class()

function Physic:init(param)
    param = param or {}
    self.entity = entity
    self.drag= param.drag or 0.98
    self.velocityX=0
    self.velocityY=0
end

function Physic:update(dt)
    if self.entity.body then
    self.entity.body.x = self.entity.body.x + self.velocityX*dt;
    self.entity.body.y = self.entity.body.y + self.velocityY*dt;
    
    self.velocityX = self.velocityX * self.drag;
    self.velocityY = self.velocityY * self.drag;
    end
end

function Physic:thrust(power)
    self.velocityX = self.velocityX + math.sin(math.pi-math.rad(self.entity.body.angle)) * power
    self.velocityY = self.velocityY + math.cos(math.pi-math.rad(self.entity.body.angle)) * power
end