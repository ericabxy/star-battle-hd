--- a short description
-- @classmod src.starship
local hitbox = require('src.hitbox')
local sprite = require('src.sprite')
local vector = require('src.vector')

local starship = {}

-- class table
local Starship = {
  time_until_ready_to_fire_bullet_in_milliseconds = 0,
  left_key = false,
  right_key = false,
  up_key = false,
  fire_key = false,
}

function Starship:Starship(sprite, x, y)
  local quad = love.graphics.newQuad(0, 0, 64, 32, 128, 192)
  -- new position and angle so its not glued to the base class
  self.position = vector.new(x, y)
  self.velocity = vector.new(0, 0)
  self.angle = { r = 0 }
  -- setup the sprite and everything else
  self.sprite = sprite
  self.sprite.position = self.position
  self.sprite.angle = self.angle
  self.sprite.origin.ox = 32
  self.sprite.origin.oy = 16
  --
  self.hitbox = hitbox.new(-16, -16, 32, 32)
  self.hitbox.origin = self.position
end

function Starship:animate_normal(dt)
  local flag = 120  -- frame lag for animation in milliseconds
  -- add delta time to timer as milliseconds
  self.sprite.animation.timer = self.sprite.animation.timer + dt * 1000
  if self.sprite.animation.timer > flag then
    self.sprite.animation.timer = self.sprite.animation.timer % flag
    self.sprite.animation.frame = (self.sprite.animation.frame + 1) % 12
    self.sprite.quad = self.sprite.animation.quads[self.sprite.animation.frame + 1]
  end
end

function Starship:is_firing(dt)
  if self.time_until_ready_to_fire_bullet_in_milliseconds == 0 then
    if love.keyboard.isDown(self.fire_key) then
      self.time_until_ready_to_fire_bullet_in_milliseconds = 500
      return true
    end
  end
end

function Starship:update(dt)
  local turn_speed = 3.5
  local ship_speed = 100
  if self.left_key and love.keyboard.isDown(self.left_key) then
    self.angle.r = self.angle.r - (dt * turn_speed)
  elseif self.right_key and love.keyboard.isDown(self.right_key) then
    self.angle.r = self.angle.r + (dt * turn_speed)
  end
  self.angle.r = self.angle.r % (2 * math.pi)
  if self.up_key and love.keyboard.isDown(self.up_key) then
    self.velocity.x = self.velocity.x + math.cos(self.angle.r) * ship_speed * dt
    self.velocity.y = self.velocity.y + math.sin(self.angle.r) * ship_speed * dt
  end
  self.position.x = (self.position.x + self.velocity.x * dt) % 2560
  self.position.y = (self.position.y + self.velocity.y * dt) % 2560
  self:animate_normal(dt)
  if self.time_until_ready_to_fire_bullet_in_milliseconds > 0 then
    self.time_until_ready_to_fire_bullet_in_milliseconds = self.time_until_ready_to_fire_bullet_in_milliseconds - dt * 1000
  else
    self.time_until_ready_to_fire_bullet_in_milliseconds = 0
  end
end

function starship.new(...)
  local self = {}
  setmetatable(self, { __index = Starship })
  self:Starship(...)
  return self
end

return starship
