Plateform ={}

------- LOVE2D implementation -------
if love ~= nil then
  require "SceneGraph/Transform"

  Plateform.currentMatrix = Transform{}

function Plateform.clear()
Plateform.currentMatrix:identity()
love.graphics.origin()
end


  function Plateform.push()
    Plateform.currentMatrix:push()
    love.graphics.push()
  end 

  function Plateform.translate(x,y)
    Plateform.currentMatrix:translate(x,y)
    love.graphics.translate(x,y)
  end 

  function Plateform.rotate(angle)
    Plateform.currentMatrix:rotate(angle)
    love.graphics.rotate(angle/180*math.pi)
  end 

  function Plateform.scale(scale)

    Plateform.currentMatrix:scale(scale)
    love.graphics.scale(scale)
  end 

  function Plateform.pop()
    Plateform.currentMatrix:pop()
    love.graphics.pop()
  end 

  function Plateform.localToWorld(x,y,matrix)
    return matrix:applyToPoint(x,y)
  end

  function Plateform.worldToLocal(x,y,matrix)
    return matrix:applyInverseToPoint(x,y)
  end
  
  function Plateform.getMatrix()
    return Plateform.currentMatrix
  end
  


------- CODEA  implementation -------

--[[
else 

  function Plateform.push()
  end 

  function Plateform.translate(x,y)
  end 

  function Plateform.rotate(angle)
  end 

  function Plateform.scale(scale)
  end 

  function Plateform.pop()
  end 

  local function multiplyVec2ByMatrix(x,y, mat)
    vec = vec4(x, y, 0, 1)
    -- Normaly the code below should look like "local resultVec = mat*vec"
    -- but as soon as something is broken in Codea right now multiply them manualy
    local resultVec = vec4(
      mat[1]*vec[1] + mat[5]*vec[2] + mat[09]*vec[3] + mat[13]*vec[4],
      mat[2]*vec[1] + mat[6]*vec[2] + mat[10]*vec[3] + mat[14]*vec[4],
      mat[3]*vec[1] + mat[7]*vec[2] + mat[11]*vec[3] + mat[15]*vec[4],
      mat[4]*vec[1] + mat[8]*vec[2] + mat[12]*vec[3] + mat[16]*vec[4]
    )
    return vec2(resultVec.x, resultVec.y)
  end

  function Plateform.localToWorld(x,y,matrix)
    return multiplyVec2ByMatrix(x,y, matrix)
  end

  function Plateform.worldToLocal(x,y,matrix)
    if matrix:determinant() == 0 then
      return nil
    else
      local resultVec = multiplyVec2ByMatrix(x,y, matrix:inverse())
      return vec2(resultVec.x, resultVec.y)
    end
  end

  function Plateform.getMatrix()
    return modelMatrix()
  end
  --]]
  
end 
