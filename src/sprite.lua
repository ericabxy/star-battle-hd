--- @module src.sprite
local sprite = {}

-- class table
local Sprite = {
  origin = nil,  -- uninitialized
  position = { x = 0, y = 0 },
  scale = { sx = 1, sy = 1 },
  angle = { r = 0 },
  texture = false,
  quad = false,
}

function Sprite:Sprite(texture, quad)
  self.origin = { ox = 0, oy = 0 }
  self.texture = texture
  self.quad = quad
  self.animation = { frame = 0, timer = 0 }
end

function Sprite:paint(x, y)
  local x, y = x and x or 0, y and y or 0
  love.graphics.draw(
    self.texture,
    self.quad,
    self.position.x + x,
    self.position.y + y,
    self.angle.r,
    self.scale.sx,
    self.scale.sy,
    self.origin.ox,
    self.origin.oy
  )
end

function sprite.new(...)
  local self = {}
  setmetatable(self, { __index = Sprite })
  self:Sprite(...)
  return self
end

return sprite
