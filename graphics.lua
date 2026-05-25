local asteroids = require('share.the_scientist___asteroids')
local explosion = require('share.the_scientist___explosion')
local sprite = require('src.sprite')

local graphics = {
  bullet = require('share.the_scientist___spaceship_set_bullet'),
  spaceships = require('share.the_scientist___spaceships'),
  asteroids = require('share.the_scientist___asteroids'),
  explosion = require('share.the_scientist___explosion'),
  scroll = { x = 0, y = 0 },
  objects_layer_0 = {},
  objects_layer_1 = {},
  objects_layer_2 = {},
  sprites_layer_0 = {},
  sprites_layer_1 = {},
  sprites_layer_2 = {},
}

local background_image01 = love.graphics.newImage('share/spr_stars01.png')
local background_image02 = love.graphics.newImage('share/spr_stars02.png')
local battlespace = { width = 2560, height = 2560 }
local overdraw = { x = 400, y = 300, width = 800, height = 600 }
local canvas_layer_0 = love.graphics.newCanvas(battlespace.width + overdraw.width, battlespace.height + overdraw.height)

--pre-draw layer zero of the canvas with permanent background stars with minimum repeated tiling
love.graphics.setCanvas(canvas_layer_0)
for repeat_row = -1, 1 do
  for repeat_col = -1, 1 do
    love.graphics.origin()
    love.graphics.translate(repeat_row * battlespace.width + overdraw.x, repeat_col * battlespace.height + overdraw.y)
    love.graphics.draw(background_image01, 0, 0)
    love.graphics.draw(background_image02, 0, 0)    
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

-- Center "camera" on given x,y coordinates
function graphics.scroll_to(x, y)
  graphics.scroll.x = x - 400
  graphics.scroll.y = y - 225
end

function graphics.asteroid(size)
  local quad = asteroids.quads[size][love.math.random(3)]
  return sprite.new(asteroids[size], quad)
end

function graphics.explosion(size)
  return sprite.new(explosion.texture, explosion.animation_quads[1], explosion.animation_quads)
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
      graphics.draw_layer(graphics.objects_layer_0)
      graphics.draw_layer(graphics.objects_layer_1)
      graphics.draw_layer(graphics.objects_layer_2)
    end
  end
end

return graphics
