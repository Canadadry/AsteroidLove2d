require "External-Lib/Class"
require "SceneGraph/Item"


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
    name = param.fN or param.fontName or "Default",
    size = param.fontSize or 20, 
    color = param.c or param.color or {0,0,0,255},
    data = nil
  }

  self:loadindFont()

  self.textMetrics = {w=0,h=0,x=0,y=0}

  self.onTextChanged:add( Text.geometryUpdated,self)
  self.onWidthChanged:add( Text.geometryUpdated,self)
  self.onHeightChanged:add( Text.geometryUpdated,self)
  self:geometryUpdated()
end 

function Text:geometryUpdated()
  self.textMetrics.w = self.font.data:getWidth(self.text)
  self.textMetrics.h = self.font.data:getHeight(self.text)
  self.textMetrics.x = (self.width - self.textMetrics.w)/2
  self.textMetrics.y = (self.height - self.textMetrics.h)/2
end


function Text:draw()
  local previousfont = love.graphics.getFont()
  love.graphics.setFont(self.font.data)
  love.graphics.setColor(self.font.color)
  love.graphics.print(self.text ,self.textMetrics.x,self.textMetrics.y)
  love.graphics.setFont(self.font.data)
end

function Text:loadindFont()
-- global font ressource manager -- 
if _G["fontManager"] == nil then 
  _G["fontManager"] = {}
  if self.font.name == "Default" then
    self.font.data = love.graphics.newFont(self.font.size)
  else 
    self.font.data = love.graphics.newFont(self.font.name,self.font.size)
  end
  _G["fontManager"][self.font.name .. self.font.size] = self.font.data
elseif _G["fontManager"][self.font.name .. self.font.size] == nil then    
  if self.font.name == "Default" then
    self.font.data = love.graphics.newFont(self.font.size)
  else 
    self.font.data = love.graphics.newFont(self.font.name,self.font.size)
  end
  _G["fontManager"][self.font.name .. self.font.size] = self.font.data
else
  self.font.data = _G["fontManager"][self.font.name .. self.font.size]
end
end


