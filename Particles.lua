PS = class('PS')

function PS:initialize()
  self.systems = {}
end

function PS:newSystem(img, buffer)
  local s = love.graphics.newParticleSystem(img, buffer)
  table.insert(self.systems, s)
end

function PS:draw()
  for i,v in ipairs(self.systems) do
    love.graphics.draw(v)
  end
end

function PS:update(dt)
  for i,v in ipairs(self.systems) do
    v:update(dt)
  end
end
