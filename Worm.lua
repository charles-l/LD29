Worm = class('Worm')
Worm:include(DynCol)
Worm:include(Stateful)

function Worm:initialize(x)
  self:createCol(x, love.graphics.getHeight() - 100, 20, 100)
  self.jumpV = 13
  self.speed = 4
end
function Worm:update(dt)
  self.c:move(0, -self.speed)
  if not self.c:collidesWith(t.floor.c) then
    self:gotoState('Leap')
  end
end

local Leap = Worm:addState('Leap')
function Leap:update(dt)
  self:applyGravity(dt)
  self.jumpV = self.jumpV - 1*dt
  if self.c:rotation() < math.pi then
    self.c:rotate(.01)
  end
  self.c:move(self.jumpV/10, -self.jumpV)
  if self.c:collidesWith(t.floor.c) then
    self:gotoState('Burrow')
  end
end

local Burrow = Worm:addState('Burrow')
function Burrow:update(dt)
  self.c:move(0, self.speed)
end

function Worm:draw()
  self:debugDrawCol()
end
