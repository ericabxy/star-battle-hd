--- @module programs
local graphics = require('graphics')
local bullet = require('src.bullet')
local explosion = require('src.explosion')
local rock = require('src.rock')
local starship = require('src.starship')

local LARGE = 'big'
local MEDIUM = 'med'
local SMALL = 'small'

local programs = {}

-- object tables
local bullets_t = {}
local explosions_t = {}
local starships_t = {}
local rocks_large_t = {}
local rocks_medium_t = {}
local rocks_small_t = {}
local rocks_tables = {
  [LARGE] = rocks_large_t,
  [MEDIUM] = rocks_medium_t,
  [SMALL] = rocks_small_t
}

function programs.advance_physics(dt)
  for x = #bullets_t, 1, -1 do
    bullets_t[x]:update(dt)
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
  for x = #rocks_large_t, 1, -1 do    
    local rock = rocks_large_t[x]
    rock:update(dt)
    if rock.remove_me_from_all_lists then
      table.remove(rocks_large_t, x)
    end
    for b = #bullets_t, 1, -1 do
      local bullet = bullets_t[b]
      if bullet.remove_me_from_all_lists == false and rock.hitbox:test_hitbox(bullet.hitbox) then
        programs.spawn_explosion(rock.position.x, rock.position.y, .5)
        programs.spawn_rock(rock.position.x, rock.position.y, MEDIUM)
        programs.spawn_rock(rock.position.x, rock.position.y, MEDIUM)
        bullet.remove_me_from_all_lists = true
        rock.remove_me_from_all_lists = true
      end
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
        programs.spawn_explosion(rock.position.x, rock.position.y, .5)
        programs.spawn_rock(rock.position.x, rock.position.y, SMALL)
        programs.spawn_rock(rock.position.x, rock.position.y, SMALL)
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
        programs.spawn_explosion(rock.position.x, rock.position.y, .25)
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
  if #rocks_large_t < 20 and love.math.random(100) == 1 then
    programs.spawn_rock_randomly()
  end
  graphics.scroll_to(starships_t[1].position.x, starships_t[1].position.y)
end

function programs.spawn_bullet(position, angle)
  local new_bullet = bullet.new(graphics.bullet.texture, graphics.bullet.quad, position, angle)
  table.insert(bullets_t, new_bullet)
  table.insert(graphics.objects_layer_2, new_bullet)
end

function programs.spawn_explosion(x, y, size)
  local spawn = explosion.new(x, y, graphics.explosion(size))
  spawn.sprite.scale = { sx = size, sy = size }
  table.insert(explosions_t, spawn)
  table.insert(graphics.objects_layer_2, spawn)
end

function programs.spawn_rock(x, y, size)
  local quad = graphics.asteroids.quads[size][love.math.random(3)]
  local new_rock = rock.new(x, y, graphics.asteroid(size))
  table.insert(rocks_tables[size], new_rock)
  table.insert(graphics.objects_layer_0, new_rock)
end

function programs.spawn_rock_randomly()
  local x, y = love.math.random( 2560 ), love.math.random( 2560 )
  for _, s in ipairs(starships_t) do
    if s.position.x > x - 400 and s.position.x < x + 400 and s.position.y > y - 300 and s.position.y < y + 300 then
      return
    end
  end
  programs.spawn_rock(x, y, LARGE)
end

function programs.spawn_starship(color, x, y)
  local spawn = starship.new(graphics.spaceships[color][1], x, y)
  spawn.sprite.animation.quads = graphics.spaceships.animation_quads
  table.insert(starships_t, spawn)
  table.insert(graphics.objects_layer_2, spawn)
  return spawn
end

return programs
