-- GLOBALS
HC = require "libs.hardoncollider"
timer = require "libs.hump.timer"
camera = require "libs.hump.camera"
gamestate = require "libs.hump.gamestate"
vector = require "libs.hump.vector"
class = require "libs.middleclass.middleclass"
require "libs.struct"
require "libs.stateful.stateful"
gui = require "libs.Quickie"
debug = true

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  Collider = HC(100, on_collision, collision_stop)
  love.graphics.setBackgroundColor(135, 206, 235)
  require "Physics"
  require "Player"
  require "Terrain"

  t = {}
  table.insert(t, Terrain(0, 500, love.graphics.getWidth(), love.graphics.getHeight()))
  table.insert(t, Terrain(-10, 0, 20, love.graphics.getHeight() + 20))
  table.insert(t, Terrain(love.graphics.getWidth()-10, 0, 20, love.graphics.getHeight() + 20))

  player = Player(10, 10)
end

function love.draw()
  for i,v in ipairs(t) do
    v:draw()
  end
  love.graphics.setColor(255, 255, 255)
  player:draw()
end

function love.update(dt)
  Collider:update(dt)
  player:update(dt)
end

function on_collision(dt, a, b, dx, dy)
  if a == player.c then
    player.canJump = true
    a:move(dx, dy)
  end
  if b == player.c then
    player.canJump = true
    b:move(-dx, -dy)
  end
end
