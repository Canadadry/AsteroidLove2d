require "EntityEngine/Entity"
require "EntityEngine/Body"
require "EntityEngine/View"
require "EntityEngine/Physic"
require "EntityEngine/Health"

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
end
function Weapon:update(dt) self.delay= self.delay +  dt end 
function Weapon:fire()
  if self.entity.body then 
    if self.delay > 0.3 then
      self.delay = 0
      Game:insert(Bullet({x=self.entity.body.x,y=self.entity.body.y,angle=self.entity.body.angle}))
    end 
  end
end

Bullet = class()
function Bullet:init(param)
  Entity.inherit(self)
  Entity.init(self,{
      view = View{sprite=love.graphics.newImage( "Assets/bullet.png" )},
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

Rock = class()
function Rock:init(param)
  Entity.inherit(self)
  Entity.init(self,{
      view = View{sprite=love.graphics.newImage( "Assets/rock.png" ),scale=param.scale},
      body = Body{x= param.x,y=param.y,angle=param.angle,size=32*(param.scale or 1)},
      physic = Physic{drag = 1},
      type= "Rock"
    })
  self.body.x = param.x or math.random(0,param.w)
  self.body.y = param.y or math.random(0,param.h)
  self.body.angle = math.random(0,360)
  self.physic:thrust(50)
  self:push(WarpInBound{w=param.w,h=param.h})
  self:push(CanBeHurt{by="Bullet"})
  self:push(Health{life=param.life or 4},"health")
  self.components.health.onHurted:add(
    function (self) 
      if self.isDead then return end
      self.view.scale = self.view.scale *0.66 
      self.body.radius = self.body.radius *0.66
      self.physic.velocityX = - 1.33 * self.physic.velocityX
      self.physic.velocityY = - 1.33 * self.physic.velocityY
      
      Game:insert(Rock{
          w=800,h=600,
          x=self.body.x,y=self.body.y,
          angle=self.body.angle,
          scale=self.view.scale,
          life=self.components.health.life
          }) 
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

Game = {
  entities = {},
  collisionDetected = Signal(),
  update = function (self,dt) for _,entity in pairs(self.entities) do entity:update(dt) end end,
  draw   = function (self)   for _,entity in pairs(self.entities) do  entity:draw() end end,
  removeDeadEntity = function (self) for _,entity in pairs(self.entities) do  if entity.isDead then self:remove(entity) end end end,
  insert   = function (self,entity) self.entities[entity] = entity end,
  remove   = function (self,entity) self.entities[entity] = nil end,
  resolveCollision = function (self) 
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
  end,
}

function load()
  ship = Entity{
    view = View{sprite=love.graphics.newImage( "Assets/ship.png" )},
    body = Body{x= 400,y=300,angle=45,size=16},
    physic = Physic{drag = 0.9},
    gamepad = KeyBoardedGamePad(),
    type = "Ship"
  }
  ship:push(WarpInBound())
  ship:push(Weapon(),"weapon")
  ship.physic:thrust(100)
  ship:push(CanBeHurt{by="Rock"})
  ship:push(Health{life=3,recover=1},"health")

  Game:insert(ship)
  for i=1,math.random(10,15) do
    Game:insert(Rock{w=800,h=600}) 
  end
end

function update(dt)
  Game:update(dt)
end

function draw()
  if ship.isDead then 
  else
    Game:draw()
    Game:resolveCollision()
    Game:removeDeadEntity()
  end
end


