--- a short description
-- @classmod bullet
local hitbox = require('src.hitbox')
local vector = require('src.vector')

local bullet = {}

-- class table
local Bullet = {
  remove_me_from_all_lists = false,  -- track whether to de-reference this object from lists
  time_left = 1000,  -- time bullet stays active in milliseconds
  speed = 500,
}

function Bullet:Bullet(sprite, x, y, angle)
  local quad = love.graphics.newQuad(0, 0, 16, 4, 16, 4)
  self.position = vector.new(x, y)
  self.velocity = vector.new(0, 0)
  self.angle = { r = angle }
  self.sprite = sprite
  self.sprite.position = self.position
  self.sprite.angle = self.angle
  self.sprite.origin.ox = 8
  self.sprite.origin.oy = 2
  self.hitbox = hitbox.new(-8, -8, 16, 16)
  self.hitbox.origin = self.position
end

function Bullet:despawn()
  self.remove_me_from_all_lists = true
  self.sprite.remove_me_from_all_lists = true
end

function Bullet:update(dt)
  self.position.x = (self.position.x + math.cos(self.angle.r) * self.speed * dt) % 2560
  self.position.y = (self.position.y + math.sin(self.angle.r) * self.speed * dt) % 2560
  self.time_left = self.time_left - dt * 1000
  if self.time_left < 0 then self.remove_me_from_all_lists = true end
end

function bullet.new(...)
  local self = {}
  setmetatable(self, { __index = Bullet })
  self:Bullet(...)
  return self
end

return bullet
