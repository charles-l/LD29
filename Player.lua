Player = class('Player')
Player:include(DynCol)
Player:include(Stateful)

function Player:initialize(x, y)
  self:createCol(x, y, 26, 36)
  self.speed = 5
  self.sprite = love.graphics.newImage('res/ninja.png')
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
  self.invincible = false
end
function Player:update(dt)
  if #player.arrows > 40 then
    Collider:remove(player.arrows[1].c)
    player.arrows[1].dead = true
  end
  self.invincible = false
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
    if v.dead then
      table.remove(self.arrows, i)
    end
  end
end
function love.keypressed(k)
  if k == 'w' then
    if player.onGround or player.jumpsLeft > 0 then
      love.audio.rewind(sfx.jump)
      love.audio.play(sfx.jump)
    end
  end
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
  for i,v in ipairs(self.arrows) do
    v:draw()
  end
end
local Invincible = Player:addState('Invincible')
function Invincible:draw()
  self.invincible = true
  love.graphics.setColor(225, 255, 255, 100)
  if self.right then
    self.currentAnimation:draw(self.sprite, self.p.x, self.p.y, 0, 2, 2, 13/2, self.sprite:getHeight()/2)
  else
    self.currentAnimation:draw(self.sprite, self.p.x, self.p.y, 0, -2, 2, 13/2, self.sprite:getHeight()/2)
  end
  love.graphics.setColor(225, 255, 255, 255)
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
  if gamestate.current() == game then
    if b == "l" then
      player:fireArrow(player.firePower)
      player.firePower = 10
    end
  end
end

Arrow = class('Arrow')
Arrow:include(DynCol)
Arrow.static.sprite = love.graphics.newImage('res/arrow.png')
function Arrow:initialize(parent, angle, power)
  self.v = vector(math.cos(angle) * power, math.sin(angle) * power)
  self.power = power
  self.parent = parent
  local x, y = self.parent.c:center()
  self:createCol(x, y, 20, 1)
  self.c:rotate(angle)
  self.c.data = self
  self.dead = false
  sfx.shoot:rewind()
  sfx.shoot:play()
end
function Arrow:update(dt)
  self.c:move(self.v.x, self.v.y)
  for i,v in ipairs(ws.worms) do
    if self.c:collidesWith(v.c) then
      if not v.dead then
        sfx.hit:rewind()
        sfx.hit:play()
        sfx.death:rewind()
        sfx.death:play()
        stat.kills = stat.kills + 1
        v.dead = true
        stat:addScore(10)
      end
    end
  end
end
function Arrow:draw()
  local x, y = self.c:center()
  love.graphics.draw(Arrow.static.sprite, x, y, self.c:rotation(), -2, 2, Arrow.static.sprite:getWidth()/2, Arrow.static.sprite:getHeight()/2)
  if debug then
    self:debugDrawCol()
  end
end
