require "External-Lib/Class"
require "SceneGraph/Item"
require "SceneGraph/Rectangle"
require "SceneGraph/Image"
require "SceneGraph/Text"
require "SceneGraph/TouchArea"
require "SceneGraph/Column"
require "SceneGraph/Row"
require "External-Lib/Flux"

require "EntityEngine/Screen"


Button = class()

function Button:init(param)
  param = param or {}
  Item.inherit(self)
  Item.init(self,param)
  self.type = "Button"
  self.triggered = Signal()
  self:push(Rectangle{w=param.w,h=param.h,c={255,255,255,255}})
  self:push(Rectangle{x=5,y=5,w=param.w-10,h=param.h-10,c={255,255,255,255}})
  self:push(Text{w=param.w,h=param.h,text=param.buttonName or param.bN or "Button"})
  local ta = self:push(TouchArea(param))
  ta.onPressed:add(function(button) button.children[2].color={255,0,0,255}end, self)
  ta.onReleased:add(function(button) button.children[2].color={255,255,255,255} if ta.mouseInside then button.triggered:dispatch(button.children[3].text) end end, self)

  if param.func ~= nil then self.triggered:add(param.func,param.scope) end

end

Menu = Screen()

function Menu:load()
  self.mainMenu = 
  Item{
    w=800,
    h=600,
    children = Column{
      centerInParent = true,
      spacing=10,
      children = { 
        Button{buttonName="Start Asteroid",func=Menu.menuSelected,scope=Menu,w=200,h=100},
        Button{buttonName="Parameters",func=Menu.menuSelected,scope=Menu,w=200,h=100}
      }
    }
  }
end

function Menu:menuSelected(menu)
  
  if menu == "Start Asteroid" then
    self:setNextScreen(Game)
  end
end

function Menu:update(dt)
  self.mainMenu:update(dt)
end

function Menu:draw()
  Plateform.clear()
  self.mainMenu:render()
end