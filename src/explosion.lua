--- a short description
-- @classmod explosion
local sprite = require('src.sprite')
local vector = require('src.vector')

local explosion = {}

-- class table
local Explosion = {
  remove_me_from_all_lists = false,  -- track whether to de-reference this object from lists
  time_left = 1500,  -- time bullet stays active in milliseconds
  speed = 500,
}

function Explosion:Explosion(texture, position)
  local quad = love.graphics.newQuad(0, 0, 128, 128, 384, 512)
  self.position = vector.new(position.x, position.y)
  -- setup the sprite
  self.sprite = sprite.new(texture, quad)
  self.sprite.position = self.position
  self.sprite.origin.ox = 64
  self.sprite.origin.oy = 64
  self.sprite.scale = { sx = 1.00, sy = 1.00 }
end

function Explosion:paint(scroll)
  self.sprite:paint(-scroll.x, -scroll.y)
end

function Explosion:update(dt)
  local flag = 30  -- frame lag time in seconds
  self.sprite.animation.timer = self.sprite.animation.timer + dt * 1000
  if self.sprite.animation.timer > flag then
    self.sprite.animation.timer = self.sprite.animation.timer % flag
    if self.sprite.animation.frame <= 12 then
      self.sprite.animation.frame = self.sprite.animation.frame + 1
      self.sprite.quad:setViewport((self.sprite.animation.frame % 3) * 128, math.floor(self.sprite.animation.frame / 3) * 128, 128, 128)
    else
      self.remove_me_from_all_lists = true
    end
  end
end

function explosion.new(...)
  local self = {}
  setmetatable(self, { __index = Explosion })
  self:Explosion(...)
  return self
end

return explosion
