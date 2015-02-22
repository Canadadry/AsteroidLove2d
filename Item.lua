require "Plateform"

Item = class()

function Item:inherit()
  self.render = Item.render
  self.touched = self.touched or Item.touched
  self.update = self.update or Item.update
  self.push = Item.push
  self.containPoint = Item.containPoint
  self.getChildByName = Item.getChildByName
  self.findInChildbyName = Item.findInChildbyName
  self.create = Item.create
  self.centerIn = Item.centerIn
  self.anchorFill = Item.anchorFill
end

function Item:init(param)
  param = param or {}
  self.x        = Property(param.x or 0)
  self.y        = Property(param.y or 0)
  self.width    = Property(param.w or param.width or 100)
  self.height   = Property(param.h or param.height or 100)
  self.rotation = Property(param.rotation or param.r or 0)
  self.scale    = Property(param.scale or param.s or 1)
  self.visible  = param.visible or true
  self.children = {}
  self.childNameList= {}
  self.currentMatrix = nil
  self.name = param.name
  self.type = "Item"

  self.onWidthChanged:add(Item.geometryUpdated, self)
  self.onHeightChanged:add(Item.geometryUpdated, self)
  self.onRotationChanged:add(Item.geometryUpdated, self)
  self.onScaleChanged:add(Item.geometryUpdated, self)


  if param.children ~= nil then
    for key,value in ipairs(param.children) do
      self:push(value)
    end
  end 

  self.parent = param.parent
  if param.parent ~= nil then param.parent:push(self,param.name) end
end

function Item:containPoint(x,y)
  return x>=0 and y>=0 and x <= self.width and y<= self.height
end 

function Item:geometryUpdated()
  if self.geometryUpdated ~=nil and self.geometryUpdated ~= Item.geometryUpdated then self:geometryUpdated() end
end

function Item:create(item)
  self:push(_G[item.type](item))
end

function Item:render()
  Plateform.push()
  Plateform.translate(self.x,self.y)
  Plateform.rotate(self.rotation)
  --Plateform.scale(self.scale)

  self.currentMatrix = Transform(Plateform.getMatrix())

  if self.visible then
    if self.draw then self:draw() end

    for key,value in ipairs(self.children) do
      value:render()
    end
  end 
  Plateform.pop()
end   

function Item:update(dt)
  for key,value in ipairs(self.children) do
    value:update(dt)
    if value.update ~= Item.update then Item.update(value) end
  end
end 

function Item:touched(touch)
  for key,value in ipairs(self.children) do
    value:touched()
    if value.touched ~= Item.touched then Item.touched(value) end
  end
end 

function Item:push(child,name)
  self.children[#(self.children)+1] = child
  if name~=nil then  self.childNameList[name]=child end 
  child.parent = self
  child.name   = name
  if self.childAdded ~=nil then self:childAdded(child) end
  return child
end

--function Item:childAdded(child)
--end

function Item:getChildByName(name)
  return self.childNameList[name]
end

function Item:findInChildbyName(name)
  child = self:getChildByName(name)
  if child == nil then 
    for key,value in ipairs(self.children) do
      child = value:findInChildbyName(name)
      if child ~=nil then return child end  
    end
  end
  return child
end 

function Item:mapToItem(self, item, x,y)
  worldPoint = Plateform.localToWolrd(x,y,self.currentMatrix)
  if item == nil then return worldPoint end 
  return Plateform.worldToLOcal(worldPoint.x,worldPoint,item.currentMatrix)
end

function Item:mapFromItem(self,item,x,y)

  if item == nil then 
    worldPoint = { x= x, y=y}
  else
    worldPoint = Plateform.localToWolrd(x,y,item.currentMatrix)
  end
  return Plateform.worldToLOcal(worldPoint.x,worldPoint,self.currentMatrix)
end

function Item:centerIn(item)
  self.x = (item.width - self.width)/2
  self.y = (item.height - self.height)/2
end

function Item:anchorFill(item)
  self.x = 0
  self.y = 0
  self.width = item.width
  self.height = item.height
end



