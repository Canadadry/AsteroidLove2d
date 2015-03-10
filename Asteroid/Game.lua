require "EntityEngine/Entity"
require "EntityEngine/Body"
require "EntityEngine/View"
require "EntityEngine/Physic"
require "EntityEngine/Health"
require "Asteroid/StarField"
require "EntityEngine/Screen"

require "Asteroid/HUD"




KeyBoardedGamePad = class()
function KeyBoardedGamePad:init(param)
  self.rotationSpeed = param.speed or 100
  self.thrustPower = param.power or 10
end
function KeyBoardedGamePad:update(dt)
  if self.entity.body and self.entity.physic then  
    if     love.keyboard.isDown("left")  then self.entity.body.angle = self.entity.body.angle - self.rotationSpeed*dt
    elseif love.keyboard.isDown("right") then self.entity.body.angle = self.entity.body.angle + self.rotationSpeed*dt end
    if     love.keyboard.isDown("up")  then self.entity.physic:thrust( self.thrustPower)
    elseif love.keyboard.isDown("down") then self.entity.physic:thrust(-self.thrustPower) end
  end
  if self.entity.components.weapon then
    if love.keyboard.isDown(' ') then
      self.entity.components.weapon:fire()
    end
  end
end

Weapon = class()
function Weapon:init(param)
  self.delay = 0
  self.rate = param.rate or 0.3
end
function Weapon:update(dt) self.delay= self.delay +  dt end 
function Weapon:fire()
  if self.entity.body then 
    if self.delay > self.rate then
      self.delay = 0
      Game:insert(Bullet({x=self.entity.body.x,y=self.entity.body.y,angle=self.entity.body.angle}))
    end 
  end
end

Bullet = class()
function Bullet:init(param)
  Entity.inherit(self)
  Entity.init(self,{
      view = View{sprite=love.graphics.newImage( "Asteroid/Assets/bullet.png" )},
      body = Body{x= param.x,y=param.y,angle=param.angle,size=8},
      physic = Physic{drag = 1},
      type = "Bullet"
    })
  self.physic:thrust(300+ (param.power or 0))
  self:push(WarpInBound())
  self:push(CanBeHurt{by="Rock"})
  self:push(Health(),"health")
  self:push{ delay=0,  update=function (self,dt) self.delay = self.delay + dt if self.delay > 1 then self.entity.isDead = true end end }
end

Option = class()
Option.type = {
    {
      name = "Health",
      asset ="Asteroid/Assets/heart.png",
      action = function () Game.player.components.health:heal(1) end 
      }
  }
function Option:init(param)
  local id = math.random(1,#Option.type)
  print(id,Option.type[id])
  Entity.inherit(self)
  Entity.init(self,{
      view = View{sprite=love.graphics.newImage(Option.type[id].asset),axisAligned = true},
      body = Body{x= param.x,y=param.y,angle=param.angle,size=8},
      physic = Physic{drag = 1},
      type = "Option"..self.type[id].name
    })
  self.physic:thrust(100)
  self:push(WarpInBound())
  self:push(CanBeHurt{by="Ship"})
  self:push(Health(),"health")
  self:push{ delay=0,  update=function (self,dt) self.delay = self.delay + dt if self.delay > 30 then self.entity.isDead = true end end }
  self.components.health.onHurted:add(Option.type[id].action)
end


Rock = class()
function Rock:init(param)
  Entity.inherit(self)
  Entity.init(self,{
      view = View{sprite=love.graphics.newImage( "Asteroid/Assets/rock.png" ),scale=param.scale},
      body = Body{x= param.x,y=param.y,angle=param.angle,size=32*(param.scale or 1)},
      physic = Physic{drag = 1},
      type= "Rock"
    })
  local maxLife = 4
  self.body.x = param.x or math.random(0,param.w)
  self.body.y = param.y or math.random(0,param.h)
  self.body.angle = math.random(0,360)
  self.physic:thrust(50)
  self:push(WarpInBound{w=param.w,h=param.h})
  self:push(CanBeHurt{by="Bullet"})
  self:push(Health{life=param.life or maxLife},"health")
  self.components.health.onHurted:add(
    function (self) 
      if self.isDead then return end
      self.view.scale = self.view.scale *0.66 
      self.body.radius = self.body.radius *0.66
      self.physic.velocityX = - 1.33 * self.physic.velocityX
      self.physic.velocityY = - 1.33 * self.physic.velocityY
      Game.score = Game.score + 10* (maxLife - self.components.health.life + 1)
      Game:insert(Rock{
          w=800,h=600,
          x=self.body.x,y=self.body.y,
          angle=self.body.angle,
          scale=self.view.scale,
          life=self.components.health.life
        }) 
      if math.random(1,10) == 1 then 
        Game:insert(Option{
          w=800,h=600,
          x=self.body.x,y=self.body.y,
          angle=self.body.angle+45,
          life=self.components.health.life
        }) 
      end
    end
  )
end

WarpInBound = class()
function WarpInBound:init(param)
  self.w = param.w or 800
  self.h = param.h or 600
end
function WarpInBound:update(dt)
  if self.entity.body then  
    if self.entity.body.x < 0      then self.entity.body.x = self.entity.body.x + self.w end
    if self.entity.body.x > self.w then self.entity.body.x = self.entity.body.x - self.w end
    if self.entity.body.y < 0      then self.entity.body.y = self.entity.body.y + self.h end
    if self.entity.body.y > self.h then self.entity.body.y = self.entity.body.y - self.h end 
  end    
end

CanBeHurt = class()
function CanBeHurt:init(param)
  self.by = param.by
  Game.collisionDetected:add(CanBeHurt.handleCollision,self)
end
function CanBeHurt:handleCollision(entity_l,entity_r)
--    print(self.entity,entity_l,entity_r)
  if self.entity == entity_l and ( self.by == nil or  self.by == entity_r.type) then      
    if self.entity.components.health then self.entity.components.health:hit(1) end
  end
  if  self.entity == entity_r and ( self.by == nil or  self.by == entity_l.type) then       
    if self.entity.components.health then self.entity.components.health:hit(1) end
  end
end 

Ship = class()
 
 function Ship:init(param)
  Entity.inherit(self)
  Entity.init(self,{
    view = View{sprite=love.graphics.newImage( "Asteroid/Assets/ship.png" )},
    body = Body{x= param.x or 400, y=param.y or 300,angle=45,size=16},
    physic = Physic{drag = 0.9},
    gamepad = param.gamepad or KeyBoardedGamePad(),
    type = "Ship"
  })
  self:push(WarpInBound())
  self:push(Weapon{rate=0.2},"weapon")
  self.physic:thrust(100)
  self:push(CanBeHurt{by="Rock"})
  self:push(Health{life=3,recover=1},"health")

 end
 


Game = Screen()
function Game:load(param)
  param = param or {}
--  param.count = 1
  self.score = 0
  self.entities = {}
  self.collisionDetected = Signal("Game.collisionDetected")
  self.player = nil
  
  self.hud = HUD()

  self:insertPlayer(Ship())
  for i=1,(param.count or math.random(10,15)) do
    self:insert(Rock{w=800,h=600}) 
  end
end

function Game:update(dt)
  for _,entity in pairs(self.entities) do entity:update(dt) end
end

function Game:draw()
  if self.player.isDead then 
    self:setNextScreen(Death)
  else
--    if #self.entities == 1 then 
--    self:setNextScreen(Death)
--    else 
      for _,entity in pairs(self.entities) do  entity:draw() end
      Game:resolveCollision()

      for _,entity in pairs(self.entities) do  if entity.isDead then self:remove(entity) end end
--    end 
  end
  
  self.hud.life = self.player.components.health.life
  self.hud.maxLife = self.player.components.health.maxLife
  self.hud.score  = self.score
  self.hud:draw()
end

function Game:resolveCollision() 
  for _,entity_l in pairs(self.entities) do 
    if entity_l.body then
      for _,entity_r in pairs(self.entities) do
        if entity_l ~= entity_r and entity_r.body then 
          if entity_l.body:testCollision(entity_r) then 
            Game.collisionDetected:dispatch(entity_l,entity_r) 
          end 
        end 
      end
    end
  end 
end

function Game:insertPlayer(entity) 
  self.player = entity
  self:insert(entity)
end

function Game:insert(entity) self.entities[entity] = entity end
function Game:remove(entity) self.entities[entity] = nil end

