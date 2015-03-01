require "External-Lib/Class"
require "SceneGraph/Text"
require "External-Lib/Flux"

HUD = class()

StaticHUD = nil

function HUD:init(param)
StaticHUD = self
  self.heartSprite = love.graphics.newImage( "Asteroid/Assets/heart.png" )
  self.score = 0
  self.life = 3
  self.scoreText = Text{x=650,y=18,height = 20,text="Score : 0",fontName = "Asteroid/Assets/visitor1.ttf", fontSize = 20, color = {255,255,255,255}}

end

function HUD:draw()
    love.graphics.setColor({255,255,255,255})
    for i=1,self.life do
      love.graphics.draw(self.heartSprite,i*20,20)
    end

    self.scoreText.text = "Score : " .. self.score
    self.scoreText:render()
end
