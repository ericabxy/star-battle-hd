--- a short description
-- @classmod src.rock
local hitbox = require('src.hitbox')
local vector = require('src.vector')

local rock = {}

-- class table
local Rock = {
  speed = 20,
}

function Rock:Rock(sprite, x, y)
  local _, _, width, height = sprite.quad:getViewport()
  self.position = vector.new(x, y)
  self.velocity = vector.new(0, 0)
  self.angle = { r = love.math.random() * (2 * math.pi) }
  --
  self.sprite = sprite
  self.sprite.position = self.position  -- sprite and rock reference same position
  self.sprite.angle = self.angle  -- sprite and rock reference same angle
  self.sprite.origin.ox = width / 2
  self.sprite.origin.oy = height / 2
  --
  self.hitbox = hitbox.new((-width / 8) * 3, (-height / 8) * 3, (width / 8) * 7, (height / 8) * 7)
  self.hitbox.origin = self.position
end

function Rock:despawn()
  self.remove_me_from_all_lists = true
  self.sprite.remove_me_from_all_lists = true
end

function Rock:update(dt)
  self.position.x = (self.position.x + math.cos(self.angle.r) * self.speed * dt) % 2560
  self.position.y = (self.position.y + math.sin(self.angle.r) * self.speed * dt) % 2560
end

function rock.new(...)
  local self = {}
  setmetatable(self, { __index = Rock })
  self:Rock(...)
  return self
end

return rock
