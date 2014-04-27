Terrain = class("Terrain")
function Terrain:initialize(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.c = Collider:addRectangle(self.x, self.y, self.w, self.h)
  self.c.data = self
end

function Terrain:draw()
  love.graphics.setColor(153, 76, 52)
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
  love.graphics.setColor(255, 255, 255)
  if debug then
    self.c:draw('line')
  end
end
