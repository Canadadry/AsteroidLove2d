require "External-Lib/Class"
require "SceneGraph/Item"


Rectangle=class()

function Rectangle:inherit()
  self.draw = self.draw or Rectangle.draw
end

function Rectangle:init(param)
    param = param or {}
    Item.inherit(self)
    Item.init(self,param)
    self.type = "Rectangle"
    self.color = param.c or param.color or {255,255,255,255}
end 

function Rectangle:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", 0, 0, self.width, self.height )
end


