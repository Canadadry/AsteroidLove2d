require "class"

Image=class()

function Image:inherit()
  self.draw = Image.draw
end

function Image:init(param)
    param = param or {}
    Item.inherit(self)
    Item.init(self,param)
    self.type = "Image"
    self.sprite = param.sprite 
end 

function Image:draw()
  love.graphics.setColor({255,255,255,255})
  w,h = self.sprite:getDimensions()
  love.graphics.draw(self.sprite, 0, 0 , self.width/w, self.height/h )
end


