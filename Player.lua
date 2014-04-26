Player = class('Player')
Player:include(DynCol)

function Player:initialize(x, y)
  self:createCol(x, y, 26, 36)
  self.speed = 5
  self.sprite = love.graphics.newImage('res/ninja.png')
  self.quads = {}
  for i = 0, 6 do
    self.quads[i] = love.graphics.newQuad(i * 13, 0, 13, 19, self.sprite:getWidth(), self.sprite:getHeight())
  end
  self.onGround = false
  self.jumpsLeft = 20
  self.jumpV = 0

  self.g = anim8.newGrid(13, 19, self.sprite:getWidth(), self.sprite:getHeight())
  self.idle = anim8.newAnimation(self.g('1-2', 1), 0.5)
  self.walk = anim8.newAnimation(self.g('3-5', 1), 0.1)
  self.jump = anim8.newAnimation(self.g('6-6', 1), 5)
  self.currentAnimation = self.idle
  self.right = true
  self.health = 5
  self.arrows = {}
  self.firePower = 10
end
function Player:update(dt)
  self.p.x, self.p.y = self.c:center()
  self.currentAnimation:update(dt)
  if self.onGround then
    self.jumpsLeft = 20
    self.currentAnimation = self.idle
  end
  if not self.onGround then
    self:applyGravity(dt)
  end
  self.c:move(0, -self.jumpV)
  if not self.onGround then
    if self.jumpV > 0 then
      self.jumpV = self.jumpV - 1
    end
  end
  if love.keyboard.isDown("a") then
    self.currentAnimation = self.walk
    self.c:move(-self.speed, 0)
    self.right = false
  end
  if love.keyboard.isDown("d") then
    self.currentAnimation = self.walk
    self.c:move(self.speed, 0)
    self.right = true
  end
  if love.keyboard.isDown("w") then
    if self.onGround or (self.jumpsLeft > 0) then
      self.jumpV = 20
      self.jumpsLeft = self.jumpsLeft - 1
    end
  end
  if love.mouse.isDown('l') then
    if self.firePower < 40 then
      self.firePower = self.firePower + 15 * dt
    end
  end

  if not self.onGround or (not self.onGround and (love.keyboard.isDown("a") or love.keyboard.isDown("d"))) then
    self.currentAnimation = self.jump
  end
  for i,v in ipairs(self.arrows) do
    v:update(dt)
  end
end
function Player:draw()
  local x, y = self.c:center()

  if self.right then
    self.currentAnimation:draw(self.sprite, self.p.x, self.p.y, 0, 2, 2, 13/2, self.sprite:getHeight()/2)
  else
    self.currentAnimation:draw(self.sprite, self.p.x, self.p.y, 0, -2, 2, 13/2, self.sprite:getHeight()/2)
  end
  if debug then
    self:debugDrawCol()
  end
  for i,v in ipairs(self.arrows) do
    v:draw()
  end
end
function Player:fireArrow(power)
  table.insert(self.arrows, Arrow(self, math.atan2(love.mouse.getY() - self.p.y, love.mouse.getX() - self.p.x), power))
end
function love.mousereleased(x, y, b)
  if b == "l" then
    player:fireArrow(player.firePower)
  end
end

Arrow = class('Arrow')
Arrow:include(DynCol)
function Arrow:initialize(parent, angle, speed)
  self.v = vector(math.cos(angle) * speed, math.sin(angle) * speed)
  local x, y = parent.c:center()
  self:createCol(x, y, 20, 1)
  self.c:rotate(angle)
end
function Arrow:update(dt)
  self.c:move(self.v.x, self.v.y)
end
function Arrow:draw()
  self:debugDrawCol()
end
