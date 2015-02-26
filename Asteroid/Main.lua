--require "EntityEngine/Example"
--require "SceneGraph/Example"
require "Asteroid/Game"

function load()
  Game:load()
  heartSprite = love.graphics.newImage( "Assets/heart.png" )
  
  startfield = StarField()
  
end

function update(dt)
  
  if Game.player.isDead then
    
    startfield:update(dt)
    if     love.keyboard.isDown(' ')  then Game:load() end 
  else
    Game:update(dt)
  end
end

function draw()   
  
    startfield:draw()
  if Game.player.isDead then
    love.graphics.print("Press Space to restart",200,200)
  else
    Game:draw()
    for i=1,Game.player.components.health.life do 
      love.graphics.draw(heartSprite,i*20,20)
    end
  end
end