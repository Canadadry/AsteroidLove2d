require "EntityEngine/Entity"
require "EntityEngine/Body"
require "EntityEngine/View"
require "EntityEngine/Physic"

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
      body = Body{x= param.x,y=param.y,angle=param.angle},
      physic = Physic{drag = 1},
    })
  self.physic:thrust(300+ (param.power or 0))
  self:push(WarpInBound())
  self:push{ delay=0,  update=function (self,dt) self.delay = self.delay + dt if self.delay > 1 then print("bite") self.entity.isDead = true end end }
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

  Game = {
    entities = {},
    update = function (self,dt) for _,entity in pairs(self.entities) do entity:update(dt) end end,
      draw   = function (self)   for _,entity in pairs(self.entities) do  entity:draw() end end,
        removeDeadEntity = function (self) for _,entity in pairs(self.entities) do  if entity.isDead then self:remove(entity) end end end,
          insert   = function (self,entity) self.entities[entity] = entity end,
          remove   = function (self,entity) self.entities[entity] = nil end
        }

        function load()
          ship = Entity{
            view = View{sprite=love.graphics.newImage( "Assets/ship.png" )},
            body = Body{x= 400,y=300,angle=45},
            physic = Physic{drag = 0.9},
            gamepad = KeyBoardedGamePad()
          }
          ship:push(WarpInBound())
          ship:push(Weapon(),"weapon")
          ship.physic:thrust(100)

          Game:insert(ship)
        end

        function update(dt)
          Game:update(dt)
        end

        function draw()
          Game:draw()
          Game:removeDeadEntity()
        end


