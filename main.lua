require "Item"
require "Rectangle"
require "Image"
require "TouchArea"
require "Transform"
require "Column"
require "Row"
require "flux"

function love.load()

  root = 
  TouchArea{
    w = 640, h=480 ,
    children = {
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

  root.drag.target = root.children[1]
  root.drag.alongYAxis = false
  root.children[1]:push(Rectangle{w=100,h=100})
  root.children[1].children[1].height=150

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