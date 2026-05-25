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
local ESCAPE = 'escape'

local player_one = programs.spawn_starship(BLUE, 160, 160)
player_one.left_key = 'left'
player_one.right_key = 'right'
player_one.up_key = 'up'
player_one.fire_key = 's'
local player_two = programs.spawn_starship(CYAN, 2400, 160)
player_two.left_key = 'j'
player_two.right_key = 'l'
player_two.up_key = 'i'
local player_three = programs.spawn_starship(GREEN, 1120, 1280)
local player_four = programs.spawn_starship(MAGENTA, 1440, 1280)
local player_five = programs.spawn_starship(ORANGE, 160, 2400)
local player_six = programs.spawn_starship(YELLOW, 2400, 2400)

function love.load()
  --programs.spawn_rock(500, 500)
end

function love.update(dt)
  if player_one:is_firing(dt) then
    programs.spawn_bullet(player_one.position, player_one.angle)
  end
  programs.advance_physics(dt)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
