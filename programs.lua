--- @module programs
local graphics = require('graphics')
local bullet = require('src.bullet')
local explosion = require('src.explosion')
local rock = require('src.rock')
local starship = require('src.starship')

local programs = {}

-- object tables
local bullets_t = {}
local explosions_t = {}
local starships_t = {}
local rocks_t = {}
local rocks_medium_t = {}
local rocks_small_t = {}

function programs.advance_physics(dt)
  for x = #bullets_t, 1, -1 do
    bullets_t[x]:update(dt)
    for _, rock in ipairs(rocks_t) do
      if rock.hitbox:test_hitbox(bullets_t[x].hitbox) then
        programs.spawn_explosion(rock.position)
        programs.spawn_rock_medium(rock.position.x, rock.position.y)
        programs.spawn_rock_medium(rock.position.x, rock.position.y)
        bullets_t[x].remove_me_from_all_lists = true
        rock.remove_me_from_all_lists = true
      end
    end
    if bullets_t[x].remove_me_from_all_lists then
      table.remove(bullets_t, x)
    end
  end
  for x = #explosions_t, 1, -1 do
    explosions_t[x]:update(dt)
    if explosions_t[x].remove_me_from_all_lists then
      table.remove(explosions_t, x)
    end
  end
  for x = #rocks_t, 1, -1 do    
    rocks_t[x]:update(dt)
    if rocks_t[x].remove_me_from_all_lists then
      table.remove(rocks_t, x)
    end
  end
  for x = #rocks_medium_t, 1, -1 do
    local rock = rocks_medium_t[x]
    rock:update(dt)
    if rock.remove_me_from_all_lists then
      table.remove(rocks_medium_t, x)
    end
    for b = #bullets_t, 1, -1 do
      local bullet = bullets_t[b]
      if bullet.remove_me_from_all_lists == false and rock.hitbox:test_hitbox(bullet.hitbox) then
        programs.spawn_explosion_medium(rock.position)
        programs.spawn_rock_small(rock.position.x, rock.position.y)
        programs.spawn_rock_small(rock.position.x, rock.position.y)
        bullet.remove_me_from_all_lists = true
        rock.remove_me_from_all_lists = true
      end
    end
  end
  for x = #rocks_small_t, 1, -1 do
    local rock = rocks_small_t[x]
    rock:update(dt)
    if rock.remove_me_from_all_lists then
      table.remove(rocks_small_t, x)
    end
    for b = #bullets_t, 1, -1 do
      local bullet = bullets_t[b]
      if bullet.remove_me_from_all_lists == false and rock.hitbox:test_hitbox(bullet.hitbox) then
        programs.spawn_explosion_small(rock.position)
        bullet.remove_me_from_all_lists = true
        rock.remove_me_from_all_lists = true
      end
    end
  end
  for x = #starships_t, 1, -1 do
    starships_t[x]:update(dt)
    if starships_t[x].remove_me_from_all_lists then
      table.remove(starships_t, x)
    end
  end
  if #rocks_t < 20 and love.math.random(100) == 1 then
    programs.spawn_rock_randomly()
  end
  graphics.scroll_to(starships_t[1].position.x, starships_t[1].position.y)
end

function programs.spawn_bullet(position, angle)
  local new_bullet = bullet.new(graphics.bullet, position, angle)
  table.insert(bullets_t, new_bullet)
  table.insert(graphics.objects_layer_2, new_bullet)
end

function programs.spawn_explosion(position)
  local new_explosion = explosion.new(graphics.electric_explosion, position)
  table.insert(explosions_t, new_explosion)
  table.insert(graphics.objects_layer_2, new_explosion)
end

function programs.spawn_explosion_medium(position)
  local new_explosion = explosion.new(graphics.electric_explosion, position)
  new_explosion.sprite.scale = { sx = .5, sy = .5 }
  table.insert(explosions_t, new_explosion)
  table.insert(graphics.objects_layer_2, new_explosion)
end

function programs.spawn_explosion_small(position)
  local new_explosion = explosion.new(graphics.electric_explosion, position)
  new_explosion.sprite.scale = { sx = .25, sy = .25 }
  table.insert(explosions_t, new_explosion)
  table.insert(graphics.objects_layer_2, new_explosion)
end

function programs.spawn_rock(x, y)
  local tile_variant = love.math.random(3) - 1
  local quad = love.graphics.newQuad((tile_variant % 2) * 64, math.floor(tile_variant / 2) * 64, 64, 64, 128, 128)
  local new_rock = rock.new(graphics.rocks['big'], quad, x, y)
  table.insert(rocks_t, new_rock)
  table.insert(graphics.objects_layer_0, new_rock)
end

function programs.spawn_rock_medium(x, y)
  local tile_variant = love.math.random(3) - 1
  local quad = love.graphics.newQuad((tile_variant % 2) * 32, math.floor(tile_variant / 2) * 32, 32, 32, 64, 64)
  local new_rock = rock.new(graphics.rocks['med'], quad, x, y)
  table.insert(rocks_medium_t, new_rock)
  table.insert(graphics.objects_layer_0, new_rock)
end

function programs.spawn_rock_small(x, y)
  local tile_variant = love.math.random(3) - 1
  local quad = love.graphics.newQuad((tile_variant % 2) * 16, math.floor(tile_variant / 2) * 16, 16, 16, 32, 32)
  local new_rock = rock.new(graphics.rocks['small'], quad, x, y)
  table.insert(rocks_small_t, new_rock)
  table.insert(graphics.objects_layer_0, new_rock)
end

function programs.spawn_rock_randomly()
  local x, y = love.math.random( 2560 ), love.math.random( 2560 )
  for _, s in ipairs(starships_t) do
    if s.position.x > x - 400 and s.position.x < x + 400 and s.position.y > y - 300 and s.position.y < y + 300 then
      return
    end
  end
  programs.spawn_rock(x, y)
end

function programs.spawn_starship(color, x, y)
  local new_starship = starship.new(graphics.starships[color][1], x, y)
  table.insert(starships_t, new_starship)
  table.insert(graphics.objects_layer_2, new_starship)
  return new_starship
end

return programs
