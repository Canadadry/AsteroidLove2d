require "Item"
require "Rectangle"
require "Image"
require "TouchArea"
require "Transform"
require "Column"
require "Row"
require "flux"


function example1()

  local item = 
  TouchArea{
    w = 640, h=480 ,
    children = {
      Item{
        children={
          Rectangle{c={0,255,0,255}},
          Row{
            spacing = 20,
            children = {
              Rectangle{ x=100,y=100,re=45,c={255,0,0,255}},
              Rectangle{ x=100,y=100,re=45,c={255,0,0,255}},
              Rectangle{ x=100,y=100,re=45,c={255,0,0,255}},
              Rectangle{ x=100,y=100,re=45,c={255,0,0,255}},
              Rectangle{ x=100,y=100,re=45,c={255,0,0,255}},
              Rectangle{ x=100,y=100,re=45,c={255,0,0,255}},
              Rectangle{ x=100,y=100,re=45,c={255,0,0,255}}
            }
          }
        }
      }
    }
  }

  item.drag.target = item.children[1]
  item.drag.alongYAxis = false
  item.children[1].children[2].children[1].height=150
  item.children[1].children[2]:push(Rectangle{w=100,h=100})
  item.children[1].children[1]:anchorFill(item.children[1].children[2])

  return item
end


Button = class()

function Button:init(param)
  param = param or {}
  Item.inherit(self)
  Item.init(self,param)
  self.type = "Button"
  self.triggered = signal.new()
  self:push(Rectangle{w=param.w,h=param.h,c={255,255,255,255}})
  self:push(Rectangle{x=5,y=5,w=param.w-10,h=param.h-10,c={255,255,255,255}})
  ta = self:push(TouchArea(param))
  ta.onPressed:add(function(button) button.children[2].color={255,0,0,255}end, self)
  ta.onReleased:add(function(button) button.children[2].color={255,255,255,255} button.triggered.dispatch() end, self)

end


function love.load()
  root = Button{w=100,h=100}
end

function love.keyreleased(key)
end

function love.mousereleased( x, y, button )
end

function love.update(dt)
  Flux.update(dt)
  root:update(dt)

end

function love.draw()
  Plateform.clear()
  root:render()
end