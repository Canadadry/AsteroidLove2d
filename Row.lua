require "class"

Row=class()

function Row:inherit()
  self.geometryUpdated = self.geometryUpdated or Item.geometryUpdated
end

function Row:init(param)
  param = param or {}
  Item.inherit(self)
  Item.init(self,param)
  self.type = "Row"
  self.spacing = param.spacing or 10
  self.finished = true
  self:geometryUpdated()
end 

function Row:geometryUpdated()
  if self.finished == true then
    currentPosX = 0
    for _,child in ipairs(self.children) do
      child.x = currentPosX
      currentPosX = currentPosX +  child.width + self.spacing
    end
  end
end

function Row:childAdded(child)
  child.onWidthChanged:add(Row.geometryUpdated, self)
  self:geometryUpdated()
end 


