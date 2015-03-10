require "Asteroid/Menu"
require "Asteroid/Death"
require "Asteroid/Game"

require "External-Lib/Flux"
require "EntityEngine/Screen"

function load()
  screenManager = ScreenManager(Menu)
  starField = StarField{w=800,h=600,number=300}
end

function update(dt)
   Flux.update(dt)
   screenManager:update(dt)
end

function draw()   
  starField:draw()
  screenManager:draw()
end