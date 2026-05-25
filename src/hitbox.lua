--- @module src.hitbox
local hitbox = {}

-- class table
local HitBox = {
  origin = { x = 0, y = 0 }
}

function HitBox:HitBox(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
end

-- render visual data for debugging
function HitBox:paint(scroll)
  love.graphics.rectangle('line', -scroll.x + self.origin.x + self.x, -scroll.y + self.origin.y + self.y, self.width, self.height)
end

function HitBox:test_hitbox(o)
  local aminx = self.origin.x + self.x
  local amaxx = self.origin.x + self.x + self.width
  local aminy = self.origin.y + self.y
  local amaxy = self.origin.y + self.y + self.height
  local bminx = o.origin.x + o.x
  local bmaxx = o.origin.x + o.x + o.width
  local bminy = o.origin.y + o.y
  local bmaxy = o.origin.y + o.y + o.height
  return aminx <= bmaxx and amaxx >= bminx and aminy <= bmaxy and amaxy >= bminy
end

function hitbox.new(...)
  local self = {}
  setmetatable(self, { __index = HitBox })
  self:HitBox(...)
  return self
end

return hitbox
