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
end
function Player:update(dt)
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
  if not self.onGround or (not self.onGround and (love.keyboard.isDown("a") or love.keyboard.isDown("d"))) then
    self.currentAnimation = self.jump
  end
  self.p.x, self.p.y = self.c:center()
end

function Player:draw()
  if self.right then
    self.currentAnimation:draw(self.sprite, self.p.x, self.p.y, 0, 2, 2, 13/2, self.sprite:getHeight()/2)
  else
    self.currentAnimation:draw(self.sprite, self.p.x, self.p.y, 0, -2, 2, 13/2, self.sprite:getHeight()/2)
  end
  if debug then
    self:debugDrawCol()
  end
end
