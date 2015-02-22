require "class"
require "Plateform"

TouchArea=class()

function TouchArea:inherit()
  self.draw = Rectangle.draw
end


function TouchArea:init(param)
  param = param or {}
  Item.inherit(self)
  Item.init(self,param)
  self.type = "TouchArea"
  self.mouseGrabbed = false
  self.pressed = false
  self.mouseX = nil
  self.mouseY = nil
  self.mouseInside = false
  self.dragTarget = nil
  self.drag = {target = param.dragTarget, initialPosition = {x=nil,y=nil},alongXAxis = true, alongYAxis =true}
end 

function TouchArea:update()
  if self.currentMatrix == nil  then return end
  mouseX = love.mouse.getX()
  mouseY = love.mouse.getY()
  mouseTouched = love.mouse.isDown("l")

  if self.mouseGrabbed == false and mouseTouched ==  true then 

    localPoint = Plateform.worldToLocal(mouseX,mouseY,self.currentMatrix)

    if self:containPoint(localPoint.x,localPoint.y) then 
      self.mouseX = localPoint.x
      self.mouseY = localPoint.y
      if self.drag.target ~= nil then 
        targetInitial = Plateform.worldToLocal(mouseX,mouseY,self.drag.target.parent.currentMatrix)
        self.drag.initialPosition.x = targetInitial.x - self.drag.target.x
        self.drag.initialPosition.y = targetInitial.y - self.drag.target.y
      end
      self.mouseGrabbed = true
      self.pressed = true
      if self.onPressed ~= nil then self:onPressed() end 
    end
  elseif self.mouseGrabbed == true and mouseTouched ==  false then 
    -- first clicked 
    self.mouseGrabbed = false
    self.pressed = false
    if self.onReleased ~= nil then self:onReleased() end 
    self.mouseX = nil
    self.mouseY = nil
  elseif self.mouseGrabbed == true and mouseTouched ==  true then 
    localPoint = Plateform.worldToLocal(mouseX,mouseY,self.currentMatrix)
    self.mouseX = localPoint.x
    self.mouseY = localPoint.y
    if self.onMoved ~= nil then self:onMoved() end
    if self.drag.target ~= nil then 
      newOrigin =  Plateform.worldToLocal(mouseX,mouseY,self.drag.target.parent.currentMatrix)
      if self.drag.alongXAxis then self.drag.target.x = newOrigin.x - self.drag.initialPosition.x end
      if self.drag.alongYAxis then self.drag.target.y = newOrigin.y - self.drag.initialPosition.y end
    end 
  end 
end
