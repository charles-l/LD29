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
  t = Terrain(0, 500, love.graphics.getWidth(), love.graphics.getHeight())
  player = Player(10, 10)
end

function love.draw()
  t:draw()
  love.graphics.setColor(255, 255, 255)
  player:draw()
end

function love.update(dt)
  Collider:update(dt)
  player:update(dt)
end

function on_collision(dt, a, b, dx, dy)
  print("COLLISION")
  if a == player.c then
    a:move(dx, dy)
  end
  if b == player.c then
    b:move(-dx, -dy)
  end
end
