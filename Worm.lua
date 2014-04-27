Worm = class('Worm')
Worm:include(DynCol)
Worm:include(Stateful)
Worm.static.sprite = love.graphics.newImage('res/worm.png')
function Worm:initialize(x, leapDist)
  self:createCol(x, love.graphics.getHeight() + math.random(100, 200), 20, 100)
  self.jumpV = 13
  self.speed = 4
  self.leapDist = leapDist
  self.g = anim8.newGrid(10, 40, Worm.static.sprite:getWidth(), Worm.static.sprite:getHeight())
  self.move = anim8.newAnimation(self.g('1-2', 1), 0.5)
  self.c.data = self
  self.dead = false
  self.timeLeft = timer.add(10, function() self.dead = true end)
end
function Worm:update(dt)
  self.c:move(0, -self.speed)
  if not self.c:collidesWith(t.floor.c) then
    self:gotoState('Leap')
  end
end

local Leap = Worm:addState('Leap')
function Leap:update(dt)
  self.move:update(dt)
  self:applyGravity(dt)
  self.jumpV = self.jumpV - 1*dt
  if self.c:rotation() < math.pi then
    self.c:rotate(self.leapDist/300)
  end
  self.c:move(self.leapDist, -self.jumpV)
  if self.c:collidesWith(t.floor.c) then
    self:gotoState('Burrow')
  end
end

local Burrow = Worm:addState('Burrow')
function Burrow:update(dt)
  self.p.x, self.p.y = self.c:center()
  self.c:move(0, self.speed)
end

function Worm:draw()
  local x, y = self.c:center()
  self.move:draw(Worm.static.sprite, x, y, self.c:rotation(), 2, 2, 5, Worm.static.sprite:getHeight()/2)
  if debug then
    self:debugDrawCol()
  end
end

WormSpawner = class('WormSpawner')
function WormSpawner:initialize(density)
  self.worms = {}
  self.density = density
  self.timer = timer.addPeriodic(1, function()
    for i=0, self.density do
      table.insert(self.worms, Worm(math.random(10, love.graphics.getWidth() - 50), math.random(-3, 3)))
    end
  end)
  self.densityTimer = timer.addPeriodic(10, function()
    self.density = self.density + 1
  end)
end

function WormSpawner:update(dt)
  for i,v in ipairs(self.worms) do
    if v.dead then
      table.remove(self.worms, i)
    end
    v:update(dt)
  end
end

function WormSpawner:drawWorms()
  for i,v in ipairs(self.worms) do
    v:draw()
  end
end
