Player = class('Player')
Player:include(DynCol)

function Player:initialize(x, y)
  self:createCol(x, y, 26, 38)
  self.speed = 5
  self.sprite = love.graphics.newImage('res/ninja.png')
  self.quads = {}
  for i = 0, 6 do
    self.quads[i] = love.graphics.newQuad(i * 13, 0, 13, 19, self.sprite:getWidth(), self.sprite:getHeight())
  end
  self.canJump = true
end

function Player:update(dt)
  self:updateCol(dt)
  if love.keyboard.isDown("a") then
    self.c:move(-self.speed, 0)
  end
  if love.keyboard.isDown("d") then
    self.c:move(self.speed, 0)
  end
  if love.keyboard.isDown("w") then
    if self.canJump then
      print("jump!")
      self.c:move(0, -30)
      self.canJump = false
    end
  end
  self.p.x, self.p.y = self.c:center()
end

function Player:draw()
  love.graphics.draw(self.sprite, self.quads[1], self.p.x, self.p.y, 0, 2, 2, 13/2, self.sprite:getHeight()/2)
  if _G.debug then
    self:debugDrawCol()
  end
end
