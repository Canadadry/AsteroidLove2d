require "External-Lib/Class"


Screen = class()

function Screen:inherit()
  self.draw = self.update or Screen.draw
  self.update = self.update or Screen.update
  self.load = self.update or Screen.load
  self.setNextScreen = Screen.setNextScreen
  self.getNextScreen = Screen.getNextScreen
end

function Screen:init()
  self.nextScreen = nil 
  self.isScreenFinishing = false
end

function Screen:load()
end

function Screen:update(dt)
end

function Screen:draw()
end

function Screen:setNextScreen(next_screen,param)
  self.nextScreen = next_screen
  self.param = param
  self.isScreenFinishing = true
end

function Screen:getNextScreen()
  local next_screen = self.nextScreen
  self.nextScreen = nil
  self.isScreenFinishing = false
  
  return  next_screen
end

ScreenManager = class()

function ScreenManager:init(currentScreen,param)
  param = param or {}
  self.currentScreen =  currentScreen
  self.currentScreen:load(param)
end

function ScreenManager:update(dt)
  self.currentScreen:update(dt)
end

function ScreenManager:draw()
  self.currentScreen:draw()
  if self.currentScreen.isScreenFinishing  == true then 
    self.currentScreen = self.currentScreen:getNextScreen()
    self.currentScreen:load(self.param)
    end
end

  