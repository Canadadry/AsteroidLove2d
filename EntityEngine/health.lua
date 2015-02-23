require "External-Lib/class"
local signal = require "External-Lib/signal"

Health = class()

function Health:init(param)
    self.entity = param.entity
    self.died = signal.new()
    self.hurt = signal.new()
    self.life = param.life or 1
end

function Health:hit(damage)
    self.life = self.life - damage;
    self.hurt.dispatch(self);
    if self.life <= 0 then
        self.died.dispatch(self);
        self.entity.isDead = true
    end
end

function Health:update(dt)
end