require "Asteroid/Main"
--require "EntityEngine/Example"
--require "SceneGraph/Example"

function love.load()
  math.randomseed(os.time())
  load()
end

function love.update(dt)
  update(dt)
end

function love.draw()
  draw()
end