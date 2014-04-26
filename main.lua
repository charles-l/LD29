-- GLOBALS
math.randomseed(os.time())
HC = require "libs.hardoncollider"
timer = require "libs.hump.timer"
camera = require "libs.hump.camera"
gamestate = require "libs.hump.gamestate"
vector = require "libs.hump.vector"
class = require "libs.middleclass.middleclass"
require "libs.struct"
Stateful = require "libs.stateful.stateful"
gui = require "libs.Quickie"
anim8 = require "libs.anim8.anim8"

debug = false

game = {}

function game:enter()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  Collider = HC(100, on_collision, collision_stop)
  love.graphics.setBackgroundColor(135, 206, 235)
  require "Physics"
  require "Player"
  require "Terrain"
  require "Cloud"
  require "Worm"
  require "Stats"

  t = {}
  t.floor = Terrain(0, 500, love.graphics.getWidth(), love.graphics.getHeight())
  table.insert(t, Terrain(-10, 0, 20, love.graphics.getHeight() + 20))
  table.insert(t, Terrain(love.graphics.getWidth()-10, 0, 20, love.graphics.getHeight() + 20))

  player = Player(50, 300)
  cc = CloudController(4)
  w = Worm(40)
  stat = Stats(player)
end

function game:draw()
  cc:draw()
  t.floor:draw()
  for i,v in ipairs(t) do
    v:draw()
  end
  love.graphics.setColor(255, 255, 255)
  w:draw()
  player:draw()
  stat:display()
end

function game:update(dt)
  Collider:update(dt)
  player:update(dt)
  cc:update(dt)
  w:update(dt)
end

function on_collision(dt, a, b, dx, dy)
  if a == player.c then
    if player.arrows[#player.arrows] ~= nil then
      if b == player.arrows[#player.arrows].c then
        return
      end
    end
    a:move(dx, dy)
  end
  if b == player.c then
    if player.arrows[#player.arrows] ~= nil then
      if a == player.arrows[#player.arrows].c then
        return
      end
    end
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
function love.load()
  font = {}
  font[12] = love.graphics.newFont('res/BMgermar.TTF', 12)
  font[25] = love.graphics.newFont('res/BMgermar.TTF', 25)
  font[36] = love.graphics.newFont('res/BMgermar.TTF', 36)
  font[50] = love.graphics.newFont('res/BMgermar.TTF', 50)
  love.graphics.setFont(font[36])
  gamestate.registerEvents()
  gamestate.switch(game)
end
function drawDropShadow(imgOrString, x, y, sDist, color, r, sx)
  love.graphics.setColor(0, 0, 0, 100)
  if type(imgOrString) == "string" then
    love.graphics.print(imgOrString, x + sDist, y + sDist, r or 0)
    love.graphics.setColor({255, 255, 255} or color)
    love.graphics.print(imgOrString, x, y, r or 0)
  elseif type(imgOrString) == "userdata" then
    love.graphics.draw(imgOrString, x + sDist, y + sDist, r or 0, sx or 1)
    love.graphics.setColor({255, 255, 255} or color)
    love.graphics.draw(imgOrString, x, y, r or 0, sx or 1)
  end
end
