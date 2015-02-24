require "External-Lib/class"
require "External-Lib/signal"

Health = class()

function Health:init(param)
    self.entity = param.entity
    self.life = param.life or 1
end

function Health:hit(damage)
  print("bite")
    self.life = self.life - damage;
    if self.life <= 0 then
        self.entity.isDead = true
    end
end

function Health:update(dt)
end