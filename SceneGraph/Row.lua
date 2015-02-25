require "External-Lib/Class"
require "SceneGraph/Item"


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
    maxHeight = 0
    for _,child in ipairs(self.children) do
      child.x = currentPosX
      currentPosX = currentPosX +  child.width + self.spacing
      if (child.height+child.y) > maxHeight then maxHeight = (child.height+child.y) end
    end
    self.height = maxHeight
    self.width = currentPosX - self.spacing

  end
end

function Row:childAdded(child)
  child.onXChanged:add(Row.geometryUpdated, self)
  child.onYChanged:add(Row.geometryUpdated, self)
  child.onWidthChanged:add(Row.geometryUpdated, self)
  child.onHeightChanged:add(Row.geometryUpdated, self)  self:geometryUpdated()
end 


