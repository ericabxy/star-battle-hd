--- @module src.sprite
local sprite = {}

-- class table
local Sprite = {
  position = { x = 0, y = 0 },
  scale = { sx = 1, sy = 1 },
  angle = { r = 0 },
}

function Sprite:Sprite(texture, quad)
  self.animation = { frame = 0, timer = 0, flag = 30, textures = { texture }, quads = { quad }}
  self.texture = type(texture) == 'table' and texture[1] or texture
  self.quad = type(quad) == 'table' and quad[1] or quad
  if type(texture) == 'table' then self.animation.textures = texture  end 
  if type(quad) == 'table' then self.animation.quads = quad end 
  self.origin = { ox = 0, oy = 0 }
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

function Sprite:animate(dt)
  self.animation.timer = self.animation.timer + dt * 1000
  if self.animation.timer > self.animation.flag then
    self.animation.timer = self.animation.timer % self.animation.flag
    if self.animation.frame < #self.animation.quads then
      self.animation.frame = self.animation.frame + 1
      self.quad = self.animation.quads[self.animation.frame + 1]
    else
      self.remove_me_from_all_lists = true
    end
  end
end

function sprite.new(...)
  local self = {}
  setmetatable(self, { __index = Sprite })
  self:Sprite(...)
  return self
end

return sprite
