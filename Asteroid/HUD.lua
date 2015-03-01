require "External-Lib/Class"
require "SceneGraph/Text"
require "SceneGraph/Row"

HUD = class()

function HUD:init(param)
  param = param or {}
  Item.inherit(self)
  Item.init(self,param)
  self.type = "HUD"

  self.heartSprite = love.graphics.newImage( "Asteroid/Assets/heart.png" )
  self.score = 0
  self.life = 3
  
  self:push(Row{
        x=20,
        y=20,
        spacing = 20,
        children = {
          HeartDisplay{heartSprite = self.heartSprite,life=self.life},
          Item{w=400},
          Text{text="Score : ",fontName = "Asteroid/Assets/visitor1.ttf", fontSize = 20, color = {255,255,255,255}},
          Text{text=self.score,fontName = "Asteroid/Assets/visitor1.ttf", fontSize = 20, color = {255,255,255,255}}
          }
      })
end

HeartDisplay = class()
function HeartDisplay:init(param)
  param = param or {}
  Item.inherit(self)
  Item.init(self,param)
  self.life = param.life or 3
  self.heartSprite = param.heartSprite or love.graphics.newImage( "Asteroid/Assets/heart.png" )
  self.width = 20
  self.height = self.width * self.life
end

function HeartDisplay:draw()
  love.graphics.setColor({255,255,255,255})
  for i=1,self.life do
    love.graphics.draw(self.heartSprite,(i-1)*20,20)
  end
end
