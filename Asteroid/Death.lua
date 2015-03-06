require "External-Lib/Class"
require "SceneGraph/Item"
require "SceneGraph/Text"

require "EntityEngine/Screen"

Death = Screen()

function Death:load()
  self.mainMenu = 
  Item{
    w=800,
    h=600,
    children = Text{
      centerInParent = true,
      text = "You're dead,\nPress Space to restart!",
      color = {255,255,255,255},
      fontName = "Asteroid/Assets/visitor1.ttf",
      fontSize = 40
    }
  }
  self.previousPressed = love.keyboard.isDown(' ')
end


function Death:update(dt)
  self.mainMenu:update(dt)
  if self.previousPressed == false and love.keyboard.isDown(' ') == true then 
    self:setNextScreen(Game)
  end
  self.previousPressed = love.keyboard.isDown(' ')
end

function Death:draw()
  Plateform.clear()
  self.mainMenu:render()
end