--require "EntityEngine/Example"
--require "SceneGraph/Example"
require "Asteroid/Game"
require "Asteroid/HUD"

function load()
  Game:load()
  
  startfield = StarField()
  hud = HUD()
  
end

function update(dt)
  
  if Game.player.isDead then
    startfield:update(dt)
    if     love.keyboard.isDown(' ')  then Game:load() end 
  else
    Game:update(dt)
    hud:update(dt)
  end
end

function draw()   
  
    startfield:draw()
  if Game.player.isDead then
    love.graphics.print("Press Space to restart",200,200)
  else
    Game:draw()
  end
    hud:render()
end