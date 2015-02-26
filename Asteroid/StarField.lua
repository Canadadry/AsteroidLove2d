require "External-Lib/Class"

StarField =class()

function StarField:init(param)
  self.w  = param.w or 800
  self.h = param.h or 600
  self.particles ={}
  self.numberOfParticle = param.number or 300

  for i=1,self.numberOfParticle do
    local newParticle = self:createParticle(1000)
    self.particles[newParticle] = newParticle 
  end
  
end

function StarField:update(dt)
  for _,particle in pairs(self.particles) do
    self:updateParticle(particle,dt)
  end
end

function StarField:draw()
    for _,particle in pairs(self.particles) do
      love.graphics.circle("fill",particle.x,particle.y,1)
  end

end

function StarField:updateParticle(particle,dt)
  particle.x = particle.x + particle.speed.x*dt
  particle.y = particle.y + particle.speed.y*dt
  
  particle.speed.x = particle.speed.x * 1.03
  particle.speed.y = particle.speed.y * 1.03

  if particle.x < 0 or particle.x > self.w or particle.y < 0 or particle.y > self.h then 
    self.particles[particle] = nil 
    local newParticle = self:createParticle()
    self.particles[newParticle] = newParticle 
  end    
end

function StarField:createParticle(radius)
  radius = math.random(0,radius or 300)
  angle  = math.random(0,360)/180*math.pi
  x      = radius * math.cos(angle) + self.w/2
  y      = radius * math.sin(angle) + self.h/2
  speed  = math.random(30,80) 

  return {x=x,y=y,angle=angle,speed={x=speed* math.cos(angle),y=speed* math.sin(angle)}}
end


