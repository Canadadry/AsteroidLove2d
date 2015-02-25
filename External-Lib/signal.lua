
local listenerMetaTable =  {__eq = function (a, b) return a.func == b.func and a.scope == b.scope end} 
local function newListener(func, scope)
  return setmetatable(  { func = func, scope = scope },listenerMetaTable )
end

Signal = setmetatable({},
  {
    __call = function (c,name)
      local instance = setmetatable({listeners = {}, name = name or "Unkonw"},{ __index =  c  })
      return instance
    end,
    __index = {}
  })

function Signal:add(func, scope)
  if func == nil then error("Function passed to signal:add() must not non-nil.") end
  table.insert(self.listeners, newListener(func, scope))
end

function Signal:dispatch(...)
  --print("Signal " .. self.name .. " dispateched")
  for _,listener in pairs(self.listeners) do
    if listener.scope then
      listener.func(listener.scope, ...)
    else
      listener.func(...)
    end
  end
end

function Signal:remove(func, scope)
  local listener = newListener(func, scope)

  local index = indexOf(listeners, listener)
  for _,index in ipairs(self.listeners) do
    if  index == value then break end
  end
  if index ~= nil then
    table.remove(listeners, index)
    self.numListeners = self.numListeners - 1
  end
end

function Signal:clear()
  self.listeners = {}
end

