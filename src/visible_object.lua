--- a short description
-- @classmod src.visible_object
local hitbox = require('src.hitbox')
local sprite = require('src.sprite')
local vector = require('src.vector')

local visible_object = {}

-- class table
local VisibleObject = {
  speed = 0,
}

function VisibleObject:VisibleObject(texture, quad, x, y, width, height, ox, oy)
  self.sprite = sprite.new(texture, quad)
  self.position = vector.new(x, y)
  self.angle = { r = 0 }
  self.hitbox = hitbox.new(ox, oy, width, height)
  self.hitbox.origin = self.position
  self.sprite.position = self.position
  self.sprite.angle = self.angle
end

function VisibleObject:paint(scroll)
  self.sprite:paint(-scroll.x, -scroll.y)
end

function VisibleObject:update(dt)
  self.position.x = (self.position.x + math.cos(self.angle.r) * self.speed * dt) % 2560
  self.position.y = (self.position.y + math.sin(self.angle.r) * self.speed * dt) % 2560
end

function visible_object.extend(o)
  o = o or {}
  setmetatable(o, { __index = VisibleObject })
  return o
end

function visible_object.new(...)
  local self = {}
  setmetatable(self, { __index = VisibleObject })
  self:VisibleObject(...)
  return self
end

return visible_object
