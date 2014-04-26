Physics = class('Physics')

Physics.GRAVITY_Y = 100
Physics.DRAG = .5 

DynCol = {
  createCol = function(self, x, y, w, h)
    self.p = vector(x, y)
    self.w = w
    self.h = h
    self.c = Collider:addRectangle(self.p.x, self.p.y, self.w, self.h)
  end,
  updateCol = function(self, dt)
      self.c:move(0, (Physics.GRAVITY_Y/30))
  end,
  debugDrawCol = function(self)
    self.c:draw('line')
  end
}
