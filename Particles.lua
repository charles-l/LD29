PartSys = class('PartSys')

function PartSys:initialize()
  self.system = love.graphics.newParticleSystem(love.graphics.newImage('res/bloodParticle.png'), 100)
  self.system:setLinearAcceleration(0, 50, 0, 100)
  self.system:setParticleLifetime(2)
  self.system:setSpread(math.pi)
  self.system:setSpeed(10, 50)
  self.system:setRotation(0, math.pi)
  self.system:setSizes(4, 2, .5)
end

function PartSys:blood(x,y)
  self.system:setPosition(x, y)
  self.system:emit(20)
end

function PartSys:draw()
  love.graphics.draw(self.system)
end

function PartSys:update(dt)
  self.system:update(dt)
end
