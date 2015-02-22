require "class"

Text=class()

function Text:inherit()
  self.draw = self.draw or Rectangle.draw
end

function Text:init(param)
    param = param or {}
    Item.inherit(self)
    Item.init(self,param)
    self.type = "Text"
    self.text = Property(param.t or param.text or "hello world!")
    self.font ={
      name = param.fN or param.fontName or "Arial.ttf",
      size = 20, 
      color = param.c or param.color or {0,0,0,255}
    }
    self.textMetrics = {w=0,h=0,x=0,y=0}
     
    self.onTextChanged:add( Text.geometryUpdated,self)
    self.onWidthChanged:add( Text.geometryUpdated,self)
    self.onHeightChanged:add( Text.geometryUpdated,self)
    self:geometryUpdated()
end 

function Text:geometryUpdated()
self.textMetrics.w = love.graphics.getFont():getWidth(self.text)
self.textMetrics.h = love.graphics.getFont():getHeight(self.text)
self.textMetrics.x = (self.width - self.textMetrics.w)/2
self.textMetrics.y = (self.height - self.textMetrics.h)/2
end


function Text:draw()
  love.graphics.setColor(self.font.color)
  love.graphics.print(self.text ,self.textMetrics.x,self.textMetrics.y)
end


