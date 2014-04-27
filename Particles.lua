PartSys = class('PartSys')

function PartSys:initialize()
  self.systems = {}
end

function PartSys:newSystem(img, buffer)
  local s = love.graphics.newParticleSystem(img, buffer)
  table.insert(self.systems, s)
end

function PartSys:draw()
  for i,v in ipairs(self.systems) do
    love.graphics.draw(v)
  end
end

function PartSys:update(dt)
  for i,v in ipairs(self.systems) do
    v:update(dt)
  end
end
