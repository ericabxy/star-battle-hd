--- @module programs
local graphics = require('graphics')
local bullet = require('src.bullet')
local explosion = require('src.explosion')
local rock = require('src.rock')
local starship = require('src.starship')

local LARGE = 'big'
local MEDIUM = 'med'
local SMALL = 'small'
local SPACE_WIDTH = 2560
local SPACE_HEIGHT = 2560

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

function random_rock_spawner(args)
  local sizes = { LARGE, MEDIUM, SMALL }
  local size = sizes[love.math.random(3)]
  -- Cancel immediately if spawning criteria are not met.
  if love.math.random(100) > args.spawnrate then return end
  if size == LARGE and #rocks_large_t >= args.large_maximum then return end
  if size == MEDIUM and #rocks_medium_t >= args.medium_maximum then return end
  if size == SMALL and #rocks_small_t >= args.small_maximum then return end
  -- Generate a random spawn location.
  local x, y = love.math.random( SPACE_WIDTH ), love.math.random( SPACE_HEIGHT )
  -- Cancel if location is in sight of any starship.
  for _, s in ipairs(starships_t) do
    if s.position.x > x - 400 and s.position.x < x + 400 and s.position.y > y - 300 and s.position.y < y + 300 then
      return
    end
  end
  local object = rock.new(graphics.sprites.asteroid(size), x, y)
  table.insert(rocks_tables[size], object)
end

function programs.advance_physics(dt)
  for x = #bullets_t, 1, -1 do
    bullets_t[x]:update(dt)
    if bullets_t[x].remove_me_from_all_lists then
      bullets_t[x]:despawn()
      table.remove(bullets_t, x)
    end
  end
  for x = #explosions_t, 1, -1 do
    explosions_t[x]:update(dt)
    if explosions_t[x].remove_me_from_all_lists then table.remove(explosions_t, x) end
  end
  for x = #rocks_large_t, 1, -1 do    
    local rock = rocks_large_t[x]
    rock:update(dt)
    for b = #bullets_t, 1, -1 do
      local bullet = bullets_t[b]
      if bullet.remove_me_from_all_lists == false and rock.hitbox:test_hitbox(bullet.hitbox) then
        programs.spawn_explosion(rock.position.x, rock.position.y, .5)
        programs.spawn_rock(rock.position.x, rock.position.y, MEDIUM)
        programs.spawn_rock(rock.position.x, rock.position.y, MEDIUM)
        bullet:despawn()
        rock:despawn()
      end
    end
    if rock.remove_me_from_all_lists then table.remove(rocks_large_t, x) end
  end
  for x = #rocks_medium_t, 1, -1 do
    local rock = rocks_medium_t[x]
    rock:update(dt)
    for b = #bullets_t, 1, -1 do
      local bullet = bullets_t[b]
      if bullet.remove_me_from_all_lists == false and rock.hitbox:test_hitbox(bullet.hitbox) then
        programs.spawn_explosion(rock.position.x, rock.position.y, .5)
        programs.spawn_rock(rock.position.x, rock.position.y, SMALL)
        programs.spawn_rock(rock.position.x, rock.position.y, SMALL)
        bullet:despawn()
        rock:despawn()
      end
    end
    if rock.remove_me_from_all_lists then table.remove(rocks_medium_t, x) end
  end
  for x = #rocks_small_t, 1, -1 do
    local rock = rocks_small_t[x]
    rock:update(dt)
    for b = #bullets_t, 1, -1 do
      local bullet = bullets_t[b]
      if bullet.remove_me_from_all_lists == false and rock.hitbox:test_hitbox(bullet.hitbox) then
        programs.spawn_explosion(rock.position.x, rock.position.y, .25)
        bullet:despawn()
        rock:despawn()
      end
    end
    if rock.remove_me_from_all_lists then table.remove(rocks_small_t, x) end
  end
  for x = #starships_t, 1, -1 do
    starships_t[x]:update(dt)
    if starships_t[x].remove_me_from_all_lists then
      table.remove(starships_t, x)
    end
  end
  random_rock_spawner({
    spawnrate = 1,
    large_maximum = 5,
    medium_maximum = 10,
    small_maximum = 20,
  })
  graphics.scroll_to(starships_t[1].position.x, starships_t[1].position.y)
end

function programs.spawn_bullet(x, y, angle)
  local new_bullet = bullet.new(graphics.sprites.bullet(), x, y, angle)
  table.insert(bullets_t, new_bullet)
end

function programs.spawn_explosion(x, y, size)
  local spawn = explosion.new(graphics.sprites.explosion(size), x, y)
  table.insert(explosions_t, spawn)
end

function programs.spawn_rock(x, y, size)
  local new_rock = rock.new(graphics.sprites.asteroid(size), x, y)
  table.insert(rocks_tables[size], new_rock)
end

function programs.spawn_starship(color, x, y)
  local object = starship.new(graphics.sprites.starship(color), x, y)
  table.insert(starships_t, object)
  return object
end

return programs
