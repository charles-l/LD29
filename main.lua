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
anim8 = require "libs.anim8.anim8"

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  Collider = HC(100, on_collision, collision_stop)
  love.graphics.setBackgroundColor(135, 206, 235)
  require "Physics"
  require "Player"
  require "Terrain"

  t = {}
  t.floor = Terrain(0, 500, love.graphics.getWidth(), love.graphics.getHeight())
  table.insert(t, Terrain(-10, 0, 20, love.graphics.getHeight() + 20))
  table.insert(t, Terrain(love.graphics.getWidth()-10, 0, 20, love.graphics.getHeight() + 20))

  player = Player(50, 300)
end

function love.draw()
  t.floor:draw()
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
    a:move(dx, dy)
  end
  if b == player.c then
    b:move(-dx, -dy)
  end
  if a == player.c and b == t.floor.c then
    player.onGround = true
  end
  if b == player.c and a == t.floor.c then
    player.onGround = true
  end
end
function collision_stop(dt, a, b)
  if (a == player.c and b == t.floor.c) or (b == player.c and a == t.floor.c) then
    player.onGround = false
  end
end
