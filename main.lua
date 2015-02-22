require "Item"
require "Rectangle"
require "Image"
require "TouchArea"
require "Transform"
require "Column"
require "flux"

function love.load()

--  root = Rectangle({x=400,y=150,re=45,c={255,0,0,255}})
--  root:push(Rectangle({x=100,y=100,r=45,c={0,255,0,128}}))
--      :push(Rectangle({x=100,y=100,r=45,c={0,255,0,128}}))
--      :push(Rectangle({x=100,y=100,r=45,c={0,255,0,128}}))
--      :push(Rectangle({x=100,y=100,r=45,c={0,255,0,128}}))
--      :push(Rectangle({x=100,y=100,r=45,c={0,255,0,128}}))
--      :push(TouchArea({x=100,y=100,r=45,c={0,255,0,128}}),"ta")
--      :push(Image({sprite=love.graphics.newImage( "test.png" ),x=100,y=100,r=45,c={0,255,0,128}}))

--      ta =root:findInChildbyName("ta")
--      ta.onPressed = function (self) self.children[2].color={255,0,0,255} end
--      ta.onReleased = function (self) self.children[2].color={128,128,0,255} end 
--      ta.drag.target =  ta

--      ta:push(Rectangle{c={128,128,0,255}}) 

--      loadstring("print(self)")(ta)

  root = 
  TouchArea{
    w = 640, h=480 ,
    children = {
      Column{
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
  root.drag.alongXAxis = false
  root.children[1]:push(Rectangle{type="Rectangle",w=100,h=100,name="test"})
  


end

function love.keyreleased(key)
end

function love.mousereleased( x, y, button )
end

function love.draw()
  Flux.update(1/60)
  Plateform.clear()
  root:update()
  root:render()


end