require "External-Lib/Class"
require "External-Lib/Signal"

Health = class()

function Health:init(param)
    self.entity = param.entity
    self.life = param.life or 1
    self.recover = param.recover or 0
    self.lastTimeHit = self.recover
    self.invicible = self.lastTimeHit < self.recover
    self.onHurted = Signal("Health.onHurted")
end

function Health:hit(damage)
  if self.lastTimeHit > self.recover then
    self.lastTimeHit = 0 
    self.life = self.life - damage
    if self.life <= 0 then self.entity.isDead = true end
    self.onHurted:dispatch(self.entity)
  end
end

function Health:update(dt)
  self.invicible = self.lastTimeHit < self.recover
  self.lastTimeHit = self.lastTimeHit + dt
end