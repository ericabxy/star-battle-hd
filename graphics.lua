local asteroids = require('share.the_scientist___asteroids')
local backgrounds = require('share.bonsaiheldin_backgrounds')
local bullet = require('share.the_scientist___spaceship_set_bullet')
local explosion = require('share.the_scientist___explosion')
local starships = require('share.the_scientist___spaceships')
local weapons = require('share.the_scientist___spaceship_set_weapons')
local sprite = require('src.sprite')

local graphics = {
  sprites = {},  -- methods to return sprite objects
  scroll = { x = 0, y = 0 },
  sprites_layer_0 = {},
  sprites_layer_1 = {},
  sprites_layer_2 = {},
}

-- Sprite factories
function graphics.sprites.asteroid(size)
  local quad = asteroids.quads[size][love.math.random(3)]
  local sprite = sprite.new(asteroids[size], quad)
  table.insert(graphics.sprites_layer_0, sprite)
  return sprite
end

function graphics.sprites.bullet()
  local sprite = sprite.new(weapons.bullet.texture, weapons.bullet.quad)
  table.insert(graphics.sprites_layer_2, sprite)
  return sprite
end

function graphics.sprites.explosion(size)
  local sprite = sprite.new(explosion.texture, explosion.animation_quads)
  if size then sprite.scale = { sx = size, sy = size } end
  table.insert(graphics.sprites_layer_2, sprite)
  return sprite
end

function graphics.sprites.starship(color)
  local sprite = sprite.new(starships[color], starships.animation_quads)
  table.insert(graphics.sprites_layer_1, sprite)
  return sprite
end

local battlespace = { width = 2560, height = 2560 }
local overdraw = { x = 400, y = 300, width = 800, height = 600 }
local canvas_layer_0 = love.graphics.newCanvas(battlespace.width + overdraw.width, battlespace.height + overdraw.height)

--pre-draw layer zero of the canvas with permanent background stars with minimum repeated tiling
love.graphics.setCanvas(canvas_layer_0)
for repeat_row = -1, 1 do
  for repeat_col = -1, 1 do
    love.graphics.origin()
    love.graphics.translate(repeat_row * battlespace.width + overdraw.x, repeat_col * battlespace.height + overdraw.y)
    love.graphics.draw(backgrounds[1], 0, 0)
    love.graphics.draw(backgrounds[2], 0, 0)    
  end
end
love.graphics.setCanvas()

function graphics.draw_layer(t)
  for x = #t, 1, -1 do
    t[x].sprite:paint(-graphics.scroll.x, -graphics.scroll.y)
    if t[x].remove_me_from_all_lists then table.remove(t, x) end
    --if o.hitbox then o.hitbox:paint(graphics.scroll) end
  end
end

function graphics.draw_sprite_layer(t)
  for x = #t, 1, -1 do
    t[x]:paint(-graphics.scroll.x, -graphics.scroll.y)
    if t[x].remove_me_from_all_lists then table.remove(t, x) end
  end
end

-- Center "camera" on given x,y coordinates
function graphics.scroll_to(x, y)
  graphics.scroll.x = x - 400
  graphics.scroll.y = y - 225
end

function love.draw()
  love.graphics.origin()
  love.graphics.scale(2.4, 2.4)
  love.graphics.draw(canvas_layer_0, -graphics.scroll.x - overdraw.x, -graphics.scroll.y - overdraw.y)
  for repeat_row = -1, 1 do
    for repeat_col = -1, 1 do
      love.graphics.origin()
      love.graphics.scale(2.4, 2.4)
      love.graphics.translate(repeat_row * battlespace.width, repeat_col * battlespace.width)
      graphics.draw_sprite_layer(graphics.sprites_layer_0)
      graphics.draw_sprite_layer(graphics.sprites_layer_1)
      graphics.draw_sprite_layer(graphics.sprites_layer_2)
    end
  end
end

return graphics
