require "Asteroid/Menu"
require "Asteroid/Game"

require "External-Lib/Flux"
require "EntityEngine/Screen"

function load()
  screenManager = ScreenManager(Menu)
end

function update(dt)
   Flux.update(dt)
   screenManager:update(dt)
end

function draw()   
  screenManager:draw()
end