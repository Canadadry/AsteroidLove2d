require "External-Lib/class"

Transform = class()


function Transform:init(param)
  self.data = {}
  self.stack = {}
  self:copy(param)

  getmetatable(self).__tostring = function (self) 
    return  (self.data._11 .. " , " .. self.data._12 .. " , " .. self.data._13 ) .. '\n'
    .. (self.data._21 .. " , " .. self.data._22 .. " , " .. self.data._23 ) .. '\n'
    .. (self.data._31 .. " , " .. self.data._32 .. " , " .. self.data._33 )
  end
end 

function Transform:combine(matrix)
  tmp = Transform{
    matrix.data._11 * self.data._11 + matrix.data._21 * self.data._12 + matrix.data._31 * self.data._13,
    matrix.data._12 * self.data._11 + matrix.data._22 * self.data._12 + matrix.data._32 * self.data._13,
    matrix.data._13 * self.data._11 + matrix.data._23 * self.data._12 + matrix.data._33 * self.data._13,
    matrix.data._11 * self.data._21 + matrix.data._21 * self.data._22 + matrix.data._31 * self.data._23,
    matrix.data._12 * self.data._21 + matrix.data._22 * self.data._22 + matrix.data._32 * self.data._23,
    matrix.data._13 * self.data._21 + matrix.data._23 * self.data._22 + matrix.data._33 * self.data._23,
    matrix.data._11 * self.data._31 + matrix.data._21 * self.data._32 + matrix.data._31 * self.data._33,
    matrix.data._12 * self.data._31 + matrix.data._22 * self.data._32 + matrix.data._32 * self.data._33,
    matrix.data._13 * self.data._31 + matrix.data._23 * self.data._32 + matrix.data._33 * self.data._33
  }
  self:copy(tmp)
  return self
end 

function Transform:copy(matrix)
  if matrix~=nil and matrix.data == nil then 
    if matrix[5] == nil then 
      self.data._11 = matrix[1] or 1
      self.data._12 = matrix[2] or 0
      self.data._13 = 0
      self.data._21 = matrix[3] or 0
      self.data._22 = matrix[4] or 1
      self.data._23 = 0
      self.data._31 = 0
      self.data._32 = 0
      self.data._33 = 1
    else   
      self.data._11 = matrix[1] or 1
      self.data._12 = matrix[2] or 0
      self.data._13 = matrix[3] or 0
      self.data._21 = matrix[4] or 0
      self.data._22 = matrix[5] or 1
      self.data._23 = matrix[6] or 0
      self.data._31 = matrix[7] or 0
      self.data._32 = matrix[8] or 0
      self.data._33 = matrix[9] or 1
    end 
  else 
    self.data._11 = matrix.data._11 
    self.data._12 = matrix.data._12
    self.data._13 = matrix.data._13
    self.data._21 = matrix.data._21
    self.data._22 = matrix.data._22
    self.data._23 = matrix.data._23
    self.data._31 = matrix.data._31
    self.data._32 = matrix.data._32
    self.data._33 = matrix.data._33
  end 
end


function Transform:rotate(angle)
  angle = angle/180*math.pi
  self:combine(Transform{ math.cos(angle),-math.sin(angle),0,
      math.sin(angle), math.cos(angle),0,
      0,               0,1})
  return self
end   

function Transform:translate(x,y)
  self:combine(Transform{ 1, 0, x,
      0, 1, y,
      0, 0, 1})
  return self
end

function Transform:scale(x)
  self:combine(Transform{ x, 0, 0,
      0, x, 0,
      0, 0, 1})
  return self
end

function Transform:identity()
  self.data._11 = 1
  self.data._12 = 0
  self.data._13 = 0
  self.data._21 = 0
  self.data._22 = 1
  self.data._23 = 0
  self.data._31 = 0
  self.data._32 = 0
  self.data._33 = 1

  return self
end

function Transform:invert()
  det =  self.data._11 * self.data._22 * self.data._33 
  +  self.data._21 * self.data._32 * self.data._13 
  +  self.data._31 * self.data._12 * self.data._23 
  -  self.data._13 * self.data._22 * self.data._31 
  -  self.data._23 * self.data._32 * self.data._11 
  -  self.data._33 * self.data._12 * self.data._21

  if det == 0 then return Transform() end 

  return Transform{
    (self.data._22 * self.data._33 - self.data._23 * self.data._32) / det,
    (self.data._32 * self.data._13 - self.data._33 * self.data._12) / det,
    (self.data._12 * self.data._23 - self.data._13 * self.data._22) / det,
    (self.data._31 * self.data._23 - self.data._33 * self.data._21) / det,
    (self.data._11 * self.data._33 - self.data._13 * self.data._31) / det,
    (self.data._21 * self.data._13 - self.data._23 * self.data._11) / det,
    (self.data._21 * self.data._32 - self.data._22 * self.data._31) / det,
    (self.data._31 * self.data._12 - self.data._32 * self.data._11) / det,
    (self.data._11 * self.data._22 - self.data._12 * self.data._21) / det
  }
end

function Transform:push()
  self.stack[#(self.stack)+1] = Transform(self)
end

function Transform:pop()
  if (#self.stack) > 0 then 
    self:copy(self.stack[#self.stack])
    self.stack[#self.stack] = nil
  else
    print("WARNING : pop transform more than pushed")
  end
end

function Transform:applyToPoint(x,y)
  return {
    x = self.data._11*x + self.data._12*y + self.data._13,
    y = self.data._21*x + self.data._22*y + self.data._23,
  }
end 

function Transform:applyInverseToPoint(x,y)
  inverse = self:invert();
  return {
    x = inverse.data._11*x + inverse.data._12*y + inverse.data._13,
    y = inverse.data._21*x + inverse.data._22*y + inverse.data._23,
  }
end 


