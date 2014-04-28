PartSys = class('PartSys')

function PartSys:initialize()
  self.system = love.graphics.newParticleSystem(love.graphics.newImage('res/bloodParticle.png'), 100)
  self.dirtSystem = love.graphics.newParticleSystem(love.graphics.newImage('res/bloodParticle.png'), 100)

  self.system:setLinearAcceleration(0, 50, 0, 100)
  self.system:setParticleLifetime(2)
  self.system:setSpread(math.pi)
  self.system:setSpeed(10, 50)
  self.system:setRotation(0, math.pi)
  self.system:setSizes(4, 2, .5)
  self.system:setColors(255, 255, 255)
  self.dirtSystem:setLinearAcceleration(0, 50, 0, 100)
  self.dirtSystem:setParticleLifetime(1)
  self.dirtSystem:setSpread(math.pi)
  self.dirtSystem:setSpeed(10, 50)
  self.dirtSystem:setRotation(0, math.pi)
  self.dirtSystem:setSizes(4, 3)
  self.dirtSystem:setColors(100, 94, 52)
end

function PartSys:blood(x,y)
  self.system:setPosition(x, y)
  self.system:emit(20)
end
function PartSys:dirt(x,y)
  self.dirtSystem:setPosition(x, y)
  self.dirtSystem:emit(10)
end

function PartSys:draw()
  love.graphics.draw(self.system)
  love.graphics.draw(self.dirtSystem)
end

function PartSys:update(dt)
  self.system:update(dt)
  self.dirtSystem:update(dt)
end
