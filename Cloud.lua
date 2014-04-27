Cloud = class('Cloud')
Cloud.static.cloudSprites = {}
for i=1, 3 do
  table.insert(Cloud.static.cloudSprites, love.graphics.newImage('res/cloud' .. i .. '.png'))
end

function Cloud:initialize(x, y, scale, speed, sprite, alpha)
  self.p = vector(x, y)
  self.scale = scale
  self.speed = speed
  self.sprite = Cloud.static.cloudSprites[sprite]
  self.alpha = alpha
end

function Cloud:draw()
  love.graphics.draw(self.sprite, self.p.x, self.p.y, 0, self.scale, math.abs(self.scale))
end

function Cloud:update(dt)
  self.p.x = self.p.x + self.speed * dt
end
CloudController = class('CloudController')
function CloudController:initialize(density)
  self.density = density
  self.clouds = {}
end

function CloudController:update(dt)
  if #self.clouds < self.density then
    table.insert(self.clouds, 
      Cloud(
        -100,
        math.random(0, 200), 
        math.random(2, 3) * math.ceil(math.random(-1,1)), 
        math.random(40, 80), 
        math.floor(math.random(1, 3)),
        100
      )
    )
  end
  for i,v in ipairs(self.clouds) do
    v:update(dt)
    if(v.p.x > love.graphics.getWidth() + 100) then
      table.remove(self.clouds, i)
    end
  end
end
function CloudController:draw()
  for i,v in ipairs(self.clouds) do
    love.graphics.setColor(255, 255, 255, self.alpha)
    v:draw()
  end
end
