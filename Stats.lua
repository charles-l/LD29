Stats = class('Stats')

function Stats:initialize(player)
  self.player = player
  self.score = 0
  self.heartIcon = love.graphics.newImage('res/heart.png')
  self.kills = 0
end

function Stats:addScore(score)
  self.score = self.score + score
end

function Stats:display()
  love.graphics.setFont(font[36])
  drawDropShadow(self.heartIcon, 10, 10, 2, {255, 255, 255}, 0, 3)
  drawDropShadow(tostring("x" .. self.player.health), 50, 10, 2)
  local score = string.format("%06d", tostring(self.score))
  drawDropShadow(score, 10, 50, 2)

  love.graphics.setFont(font[25])
  drawDropShadow("Jumpjuice", love.graphics.getWidth() - font[25]:getWidth("Jumpjuice") - 10, 10, 2)
  love.graphics.setColor(0, 0, 0, 100)
  love.graphics.rectangle('fill', love.graphics.getWidth() - 120, 52, (self.player.jumpsLeft * 5) + 10, 20)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.rectangle('fill', love.graphics.getWidth() - 120, 50, (self.player.jumpsLeft * 5) + 10, 20)
  love.graphics.setColor(232, 85, 54, 255)
  love.graphics.rectangle('fill', love.graphics.getWidth() - 115, 55, (self.player.jumpsLeft * 5), 10)
end
