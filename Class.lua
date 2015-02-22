function class()
  local cls = {}
  setmetatable(cls,
    {
      __call = function (c, param)
        param = param or {}
        local instance = setmetatable({},{
            __index = function(self, key) 
              if getmetatable(self).__properties[key] ~= nil then
                return getmetatable(self).__properties[key].value
              else
                return getmetatable(self).__parentTable[key]
              end
            end,
            __properties = {},
            __parentTable = c,
            __newindex = function(self, key, value)
              local property = getmetatable(self).__properties[key]
              if type(value) == "table" and value.__isProperty == true then
                rawset(getmetatable(self).__properties,key,value)
              elseif property ~= nil then 
                if property.value ~= value then 
                  property.value =  value
                  if property.callBack ~= nil then property.callBack(property.object,value) end
                end
              else 
                rawset(self,key,value)
              end
            end
          })
        if instance.init then instance:init(param) end
        return instance
      end,
      __index = {}
    })
  return cls
end

function Property(value, callBack, object)
  return {value = value, callBack = callBack, object = object, __isProperty = true}
end
