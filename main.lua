-- GLOBALS
math.randomseed(os.time())

debug = false

menu = {}

function menu:enter()
  self.logo = {}
  self.logo.sprite = love.graphics.newImage('res/logo.png')
  self.logo.p = vector(love.graphics.getWidth()/2, -100)
  self.logo.timer = timer.new()
  self.logo.timer:tween(1.6, self.logo.p, {x = x, y = love.graphics.getHeight()/2}, 'in-bounce')
  self.help = {}
  self.help.x = 2000
  self.help.images = {love.graphics.newImage('res/help0.png'), love.graphics.newImage('res/help1.png')}
  self.logo.timer:add(3, function()
    self.logo.timer:tween(1, self.logo.p, {x = x, y = -100}, 'in-back')
  end)
  self.logo.timer:add(4, function()
    self.logo.timer:tween(1.6, self.help, {x = love.graphics.getWidth()/2}, 'in-out-quad')
  end)
  self.logo.timer:add(8, function()
    self.logo.timer:tween(1.6, self.help, {x = love.graphics.getWidth()/2 - self.help.images[1]:getWidth() - 300}, 'in-out-quad')
  end)
end

function menu:draw()
  love.graphics.draw(self.help.images[1], self.help.x, love.graphics.getHeight()/2, 0, 1, 1, self.help.images[1]:getWidth()/2, self.help.images[1]:getHeight()/2)
  love.graphics.draw(self.help.images[2], self.help.x + 800, love.graphics.getHeight()/2, 0, 1, 1, self.help.images[2]:getWidth()/2, self.help.images[2]:getHeight()/2)
  love.graphics.draw(self.logo.sprite, self.logo.p.x, self.logo.p.y, 0, 1, 1, self.logo.sprite:getWidth()/2, self.logo.sprite:getHeight()/2)
  love.graphics.print("Press Space to start", love.graphics.getWidth()/2, love.graphics.getHeight() - 100, 0, 1, 1, font[36]:getWidth("Press Space to start")/2, font[36]:getHeight()/2)
end

function menu:update(dt)
  self.logo.timer:update(dt)
  if love.keyboard.isDown(' ') then
    gamestate.switch(game)
  end
end

game = {}
function game:init()
  love.graphics.setBackgroundColor(135, 206, 235)
  require "Physics"
  require "Player"
  require "Terrain"
  require "Cloud"
  require "Worm"
  require "Stats"
  require "Particles"
end
function game:enter()
  Collider = HC(100, on_collision, collision_stop)

  t = {}
  t.floor = Terrain(0, 500, love.graphics.getWidth(), love.graphics.getHeight())
  table.insert(t, Terrain(-10, 0, 20, love.graphics.getHeight() + 20))
  table.insert(t, Terrain(love.graphics.getWidth()-10, 0, 20, love.graphics.getHeight() + 20))

  player = Player(50, 300)
  cc = CloudController(4)
  stat = Stats(player)
  ws = WormSpawner(1)
  PS = PartSys()
end

function game:draw()
  cc:draw()
  t.floor:draw()
  for i,v in ipairs(t) do
    v:draw()
  end
  love.graphics.setColor(255, 255, 255)
  PS:draw()
  player:draw()
  ws:drawWorms()
  stat:display()
end

function game:update(dt)
  timer.update(dt)
  Collider:update(dt)
  ws:update(dt)
  player:update(dt)
  cc:update(dt)
  PS:update(dt)
  -- MAJOR HACK TO MAKE IT CLEAN UP SHAPES!
  for i,v in Collider:activeShapes() do
    if v["data"] ~= nil then
      if v.data.dead then
        Collider:remove(v)
      end
    end
  end
  if player.health < 1 then
    gamestate.switch(dead)
  end
end

function game:leave()
  Collider = nil
  t = nil
  player = nil
  cc = nil
  ws = nil
  PS = nil
end

dead = {}
function dead:enter()
  self.menuTimer = timer.new()
  self.showStats = false
  self.showMessage = false
  self.menuTimer:add(1, function() self.showMessage = true end)
  self.menuTimer:add(2, function() self.showStats = true end)
end

function dead:draw()
  love.graphics.setColor(255, 255, 255)
  if not self.showStats then
    love.graphics.setFont(font[50])
    love.graphics.print("You dead", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 1, 1, font[50]:getWidth("You dead")/2, font[50]:getHeight()/2)
    if self.showMessage then
      love.graphics.setFont(font[36])
      love.graphics.print("But you still did good", love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 40, 0, 1, 1, font[36]:getWidth("But you still did good")/2, font[36]:getHeight()/2)
    end
  else
    love.graphics.print("Final Score", love.graphics.getWidth()/2, love.graphics.getHeight()/2 - 40, 0, 1, 1, font[36]:getWidth("Final Score")/2, font[36]:getHeight()/2)
    love.graphics.print(stat.score, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 1, 1, font[36]:getWidth(stat.score)/2, font[36]:getHeight()/2)
    love.graphics.print("Kills", love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 40, 0, 1, 1, font[36]:getWidth("Kills")/2, font[36]:getHeight()/2)
    love.graphics.print(stat.kills, love.graphics.getWidth()/2, love.graphics.getHeight()/2 + 80, 0, 1, 1, font[36]:getWidth(stat.kills)/2, font[36]:getHeight()/2)
    love.graphics.print("Press R to restart", love.graphics.getWidth()/2, love.graphics.getHeight() - 100, 0, 1, 1, font[36]:getWidth("Press R to restart")/2, font[36]:getHeight()/2)
  end
end

function dead:update(dt)
  self.menuTimer:update(dt)
  if love.keyboard.isDown('r') then
    gamestate.switch(game)
  end
end

function on_collision(dt, a, b, dx, dy)
  if a == player.c then
    if b["data"] ~= nil then
      if b.data:isInstanceOf(Terrain) then
        a:move(dx, dy)
      end
    end
  end
  if b == player.c then
    if a["data"] ~= nil then
      if a.data:isInstanceOf(Terrain) then
        b:move(-dx, -dy)
      end
    end
  end

  if a == player.c then
    if b["data"] ~= nil then
      if b.data:isInstanceOf(Worm) and b.data.dead == false then
        if not player.invincible then
        sfx.hit:rewind()
        sfx.hit:play()
          player.health = player.health - 1
          player:gotoState('Invincible')
          timer.do_for(3, function()player:gotoState('Invincible')end, function()player:gotoState(nil)end)
        end
        b.data.dead = true
      end
    end
  end

  if b == player.c then
    if a["data"] ~= nil then
      if a.data:isInstanceOf(Worm) and a.data.dead == false then
        if not player.invincible then
        sfx.hit:rewind()
        sfx.hit:play()
          player.health = player.health - 1
          timer.do_for(3, function()player:gotoState('Invincible')end, function()player:gotoState(nil)end)
        end
        a.data.dead = true
      end
    end
  end

  if a == player.c and b == t.floor.c then
    player.onGround = true
  end
  if b == player.c and a == t.floor.c then
    player.onGround = true
  end
  if a["data"] ~= nil and b["data"] ~= nil then
    if a.data:isInstanceOf(Arrow) then
      if b.data:isInstanceOf(Terrain) then
        if not a.data.dead then
          sfx.hit:rewind()
          sfx.hit:play()
          a.data.dead = true
        end
      end
    end
  end
  if b["data"] ~= nil and a["data"] ~= nil then
    if b.data:isInstanceOf(Arrow) then
      if a.data:isInstanceOf(Terrain) then
        if not b.data.dead then
          sfx.hit:rewind()
          sfx.hit:play()
          b.data.dead = true
        end
      end
    end
  end
end
function collision_stop(dt, a, b)
  if (a == player.c and b == t.floor.c) or (b == player.c and a == t.floor.c) then
    player.onGround = false
  end
end
function love.load()
  HC = require "libs.HardonCollider"
  timer = require "libs.hump.timer"
  camera = require "libs.hump.camera"
  gamestate = require "libs.hump.gamestate"
  vector = require "libs.hump.vector"
  class = require "libs.middleclass.middleclass"
  require "libs.struct"
  Stateful = require "libs.stateful.stateful"
  gui = require "libs.Quickie"
  anim8 = require "libs.anim8.anim8"

  love.graphics.setDefaultFilter('nearest', 'nearest')
  font = {}
  font[12] = love.graphics.newFont('res/BMgermar.TTF', 12)
  font[25] = love.graphics.newFont('res/BMgermar.TTF', 25)
  font[36] = love.graphics.newFont('res/BMgermar.TTF', 36)
  font[50] = love.graphics.newFont('res/BMgermar.TTF', 50)
  sfx = {}
  sfx.jump = love.audio.newSource('res/jump.wav', 'static')
  sfx.jump:setVolume(.3)
  sfx.hit = love.audio.newSource('res/hit.wav', 'static')
  sfx.hit:setVolume(.3)
  sfx.shoot = love.audio.newSource('res/shoot.wav', 'static')
  sfx.shoot:setVolume(.3)
  sfx.death = love.audio.newSource('res/death.wav', 'static')
  sfx.death:setVolume(.3)
  love.graphics.setFont(font[36])
  music = love.audio.newSource('res/music.mp3', 'stream')
  music:setLooping(true)
  music:play()
  gamestate.registerEvents()
  gamestate.switch(menu)
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
