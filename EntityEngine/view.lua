require "External-Lib/class"
require "External-Lib/Plateform"

View = class()

function View:init(param)
  param = param or {}
  self.entity = param.entity 
  self.sprite = param.sprite
  self.width , self.height = self.sprite:getDimensions()
end

function View:update()
end

function View:draw()
  if self.entity.body then 
    Plateform.push()
    Plateform.translate(self.entity.body.x,self.entity.body.y)
    Plateform.rotate(self.entity.body.angle)
    love.graphics.setColor({255,255,255,255})
    love.graphics.draw(self.sprite, -self.width/2,-self.height/2)
    Plateform.pop()
  end
end

