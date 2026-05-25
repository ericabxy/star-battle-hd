local graphics = require('graphics')
local programs = require('programs')
local bullet = require('src.bullet')
local explosion = require('src.explosion')
local rock = require('src.rock')
local starship = require('src.starship')

local BLUE = 'blue'
local CYAN = 'cyan'
local GREEN = 'green'
local MAGENTA = 'magenta'
local ORANGE = 'orange'
local YELLOW = 'yellow'

local players = {}

function game_mode_01()
  players[1] = programs.spawn_starship(BLUE, 160, 160)
  players[1].left_key = 'left'
  players[1].right_key = 'right'
  players[1].up_key = 'up'
  players[1].fire_key = 's'
  players[2] = programs.spawn_starship(CYAN, 2400, 160)
  players[2].left_key = 'j'
  players[2].right_key = 'l'
  players[2].up_key = 'i'
  players[3] = programs.spawn_starship(GREEN, 1120, 1280)
  players[4] = programs.spawn_starship(MAGENTA, 1440, 1280)
  players[5] = programs.spawn_starship(ORANGE, 160, 2400)
  players[6] = programs.spawn_starship(YELLOW, 2400, 2400)
end

function love.load()
  game_mode_01()
  --programs.spawn_rock(500, 500)
end

function love.update(dt)
  if players[1] and players[1]:is_firing(dt) then
    local x = players[1].position.x + math.cos(players[1].angle.r) * 32
    local y = players[1].position.y + math.sin(players[1].angle.r) * 32
    programs.spawn_bullet(x, y, players[1].angle.r)
  end
  programs.advance_physics(dt)
end

local ESCAPE = 'escape'

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
