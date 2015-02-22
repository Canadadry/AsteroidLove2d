require "External-Lib/class"
require "External-Lib/flux"
require "SceneGraph/Item"
require "External-Lib/Plateform"

signal = require "External-Lib/signal"


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
  self.drag = {target = param.dragTarget,
    initialPosition = {x=nil,y=nil},
    kinetic = {enable = param.kineticDrag or true,oldPosition={x=0,y=0},timeCounter = 0},
    alongXAxis = true, alongYAxis =true}
  self.onPressed = signal.new()
  self.onReleased = signal.new()
  self.onMoved = signal.new()
end 

function TouchArea:update(dt)
  if self.currentMatrix == nil  then return end
  mouseX = love.mouse.getX()
  mouseY = love.mouse.getY()
  mouseTouched = love.mouse.isDown("l")

  

  if self.drag.target ~= nil and self.pressed == true and self.drag.kinetic.enable then 
    if self.drag.kinetic.timeCounter > 0.2 then 
      self.drag.kinetic.oldPosition.x = self.drag.target.x
      self.drag.kinetic.oldPosition.y = self.drag.target.y
      self.drag.kinetic.timeCounter = 0
    else
      self.drag.kinetic.timeCounter = self.drag.kinetic.timeCounter + dt
    end
  end

    localPoint = Plateform.worldToLocal(mouseX,mouseY,self.currentMatrix)
    self.mouseInside = self:containPoint(localPoint.x,localPoint.y)

  if self.mouseGrabbed == false and mouseTouched ==  true then 


    if self.mouseInside then 
      self.mouseX = localPoint.x
      self.mouseY = localPoint.y
      if self.drag.target ~= nil then 
        targetInitial = Plateform.worldToLocal(mouseX,mouseY,self.drag.target.parent.currentMatrix)
        self.drag.initialPosition.x = targetInitial.x - self.drag.target.x
        self.drag.initialPosition.y = targetInitial.y - self.drag.target.y
      end
      self.mouseGrabbed = true
      self.pressed = true
      self.onPressed:dispatch() 
    end
  elseif self.mouseGrabbed == true and mouseTouched ==  false then 
    -- first clicked 
    self.mouseGrabbed = false
    self.pressed = false
    self.onReleased:dispatch()
    self.mouseX = nil
    self.mouseY = nil

    if self.drag.target ~= nil and self.drag.kinetic.enable then 
      local targetX = self.drag.target.x + (self.drag.target.x - self.drag.kinetic.oldPosition.x)
      local targetY = self.drag.target.y + (self.drag.target.y - self.drag.kinetic.oldPosition.y)
      Flux.to(self.drag.target, 0.5, {x = targetX, y = targetY }):ease("sineout")
    end

  elseif self.mouseGrabbed == true and mouseTouched ==  true then 
    self.mouseX = localPoint.x
    self.mouseY = localPoint.y
    self.onMoved:dispatch()
    if self.drag.target ~= nil then 
      newOrigin =  Plateform.worldToLocal(mouseX,mouseY,self.drag.target.parent.currentMatrix)
      if self.drag.alongXAxis then self.drag.target.x = newOrigin.x - self.drag.initialPosition.x end
      if self.drag.alongYAxis then self.drag.target.y = newOrigin.y - self.drag.initialPosition.y end
    end 
  end 
end
