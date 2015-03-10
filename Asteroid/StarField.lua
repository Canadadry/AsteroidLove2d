require "External-Lib/Class"

StarField =class()

function StarField:init(param)
  self.w  = param.w or 800
  self.h = param.h or 600
  self.particles ={}
  self.numberOfParticle = param.number or 300

  for i=1,self.numberOfParticle do
    local newParticle = self:createParticleInScreen(self.w,self.h)
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
      love.graphics.setColor{255,255,255,(255-particle.minus_alpha)}
      love.graphics.circle("fill",particle.x,particle.y,particle.radius)
--      simulate motion blur
--      love.graphics.setLineWidth(particle.radius)
--      love.graphics.line(particle.x,particle.y,particle.x_dt,particle.y_dt)
end

end

function StarField:updateParticle(particle,dt)
  particle.x = particle.x + particle.speed.x*dt
  particle.y = particle.y + particle.speed.y*dt
  
  particle.x_dt = particle.x + particle.speed.x*dt
  particle.y_dt = particle.y + particle.speed.y*dt
  
  particle.speed.x = particle.speed.x * 1.03
  particle.speed.y = particle.speed.y * 1.03

  
  particle.minus_alpha = particle.minus_alpha * 0.97
  
  if particle.x < 0 or particle.x > self.w or particle.y < 0 or particle.y > self.h then 
    self.particles[particle] = nil 
    local newParticle = self:createParticle()
    self.particles[newParticle] = newParticle 
  end    
end

function StarField:createParticleInRadius(radius)
  radius = math.random(0,radius or 300)
  angle  = math.random(0,360)/180*math.pi
  x      = radius * math.cos(angle) + self.w/2
  y      = radius * math.sin(angle) + self.h/2
  speed  = math.random(30,80) 

  return {x=x,y=y,angle=angle,speed={x=speed* math.cos(angle),y=speed* math.sin(angle)}, radius = math.random(0,2),minus_alpha = 255}
end

function StarField:createParticleInScreen(width,heigh)
  x = math.random(0,width or 800)
  y = math.random(0,height or 600)
  angle  = math.atan2(y,x)
  speed  = math.random(30,80) 

  return {x=x,y=y,angle=angle,speed={x=speed* math.cos(angle),y=speed* math.sin(angle)}, radius = math.random(0,2),minus_alpha = 0}
end

