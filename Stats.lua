Stats = class('Stats')

function Stats:initialize(player)
  self.player = player
  self.score = 0
  self.heartIcon = love.graphics.newImage('res/heart.png')
end

function Stats:score(score)
  self.score = self.score + score
end

function Stats:display()
  drawDropShadow(self.heartIcon, 10, 10, 2, {255, 255, 255}, 0, 3)
  drawDropShadow(tostring("x" .. self.player.health), 50, 10, 2)
  local score = string.format("%06d", tostring(self.score))
  drawDropShadow(score, 10, 50, 2)
end
