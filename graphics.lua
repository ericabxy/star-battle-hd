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

local graphics = {
  objects_layer_0 = {},
  objects_layer_1 = {},
  objects_layer_2 = {},
  scroll = { x = 0, y = 0 },
}

--create canvas for drawing entire battle scene
graphics.battlespace0 = love.graphics.newCanvas(battlespace.width + overdraw.width, battlespace.height + overdraw.height)
--create starship sprites
graphics.blue_starship = {
  love.graphics.newImage('share/blue_ship1.png'),
  love.graphics.newImage('share/blue_ship2.png'),
  love.graphics.newImage('share/blue_ship3.png'),
}
graphics.bullet = love.graphics.newImage('share/bullet.png')
graphics.cyan_starship = {
  love.graphics.newImage('share/cyan_ship1.png'),
  love.graphics.newImage('share/cyan_ship2.png'),
  love.graphics.newImage('share/cyan_ship3.png'),
}
graphics.electric_explosion = love.graphics.newImage('share/electric_explosion.png')
graphics.green_starship = {
  love.graphics.newImage('share/green_ship1.png'),
  love.graphics.newImage('share/green_ship2.png'),
  love.graphics.newImage('share/green_ship3.png'),
} graphics.magenta_starship = {
  love.graphics.newImage('share/magenta_ship1.png'),
  love.graphics.newImage('share/magenta_ship2.png'),
  love.graphics.newImage('share/magenta_ship3.png'),
} graphics.orange_starship = {
  love.graphics.newImage('share/orange_ship1.png'),
  love.graphics.newImage('share/orange_ship2.png'),
  love.graphics.newImage('share/orange_ship3.png'),
} graphics.rocks = {
  big = love.graphics.newImage('share/Rocks_big.png'),
  med = love.graphics.newImage('share/Rocks_med.png'),
  small = love.graphics.newImage('share/Rocks_small.png'),
} graphics.yellow_starship = {
  love.graphics.newImage('share/yellow_ship1.png'),
  love.graphics.newImage('share/yellow_ship2.png'),
  love.graphics.newImage('share/yellow_ship3.png'),
}
graphics.starships = {
  blue = graphics.blue_starship,
  cyan = graphics.cyan_starship,
  green = graphics.green_starship,
  magenta = graphics.magenta_starship,
  orange = graphics.orange_starship,
  yellow = graphics.yellow_starship,
}
--player window quads
graphics.player_window_half = love.graphics.newQuad(0, 0, 400, 600, battlespace.width, battlespace.height)  -- half-split screen is divided horizontally
graphics.player_window_quarter = love.graphics.newQuad(0, 0, 400, 300, battlespace.width, battlespace.height)  -- quad-split screen is divided both ways

function graphics.draw_battlespace()
  love.graphics.draw(background_image01, -graphics.scroll.x, -graphics.scroll.y)
  love.graphics.draw(background_image02, -graphics.scroll.x, -graphics.scroll.y)
end

function graphics.draw_layer(t)
  for x = #t, 1, -1 do
    local o = t[x]
    o.sprite:paint(-graphics.scroll.x, -graphics.scroll.y)
    if o.remove_me_from_all_lists then
      table.remove(t, x)
    end
    if o.hitbox then
      --o.hitbox:paint(graphics.scroll)
    end
  end
end

function graphics.draw_player_window_half()
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
      graphics.draw_layer(graphics.objects_layer_0)
      graphics.draw_layer(graphics.objects_layer_1)
      graphics.draw_layer(graphics.objects_layer_2)
    end
  end
end

return graphics
