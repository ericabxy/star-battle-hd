--- a short description
-- @classmod src.vector
local vector = {}

-- class table
local Vector = {
  x = 0,
  y = 0,
}

function Vector:Vector(x, y)
  self.x = x
  self.y = y
end

function vector.new(...)
  local self = {}
  setmetatable(self, { __index = Vector })
  self:Vector(...)
  return self
end

return vector
