require "class"

Column=class()

function Column:inherit()
  self.geometryUpdated = self.geometryUpdated or Item.geometryUpdated
end

function Column:init(param)
  param = param or {}
  Item.inherit(self)
  Item.init(self,param)
  self.type = "Column"
  self.spacing = param.spacing or 10
  self.finished = true
  self:geometryUpdated()
end 

function Column:geometryUpdated()
  if self.finished == true then
    currentPosY = 0
    for _,child in ipairs(self.children) do
      child.y = currentPosY
      currentPosY = currentPosY +  child.height + self.spacing
    end
  end
end

function Column:childAdded(child)
  child.onHeightChanged:add(Column.geometryUpdated, self)
  self:geometryUpdated()
end 


