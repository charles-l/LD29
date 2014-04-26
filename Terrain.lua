Terrain = class("Terrain")
function Terrain:initialize(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.c = Collider:addRectangle(self.x, self.y, self.w, self.h)
end

function Terrain:draw()
  self.c:draw('line')
  love.graphics.setColor(153, 76, 52)
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end
