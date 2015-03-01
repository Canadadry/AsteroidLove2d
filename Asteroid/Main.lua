--require "EntityEngine/Example"
--require "SceneGraph/Example"
require "Asteroid/Game"
require "Asteroid/HUD"
require "External-Lib/Flux"

function load()
  Game:load()

  startfield = StarField()
  hud = HUD()

end

function update(dt)
  Flux.update(dt)
  if Game.player.isDead then
    startfield:update(dt)
    if     love.keyboard.isDown(' ')  then Game:load() end 
  else
    Game:update(dt)
  end
end

function draw()   

  startfield:draw()

  if not Game.player.isDead then
    Game:draw()
  end

  hud.life = Game.player.components.health.life
  hud.score  = Game.score
  hud:draw()
end