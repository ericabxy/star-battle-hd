return {
  big = love.graphics.newImage('share/Rocks_big.png'),
  med = love.graphics.newImage('share/Rocks_med.png'),
  small = love.graphics.newImage('share/Rocks_small.png'),
  quads = {
    big = {
      love.graphics.newQuad(0, 0, 64, 64, 128, 128), 
      love.graphics.newQuad(64, 0, 64, 64, 128, 128), 
      love.graphics.newQuad(0, 64, 64, 64, 128, 128) 
    },
    med = {
      love.graphics.newQuad(0, 0, 32, 32, 64, 64), 
      love.graphics.newQuad(32, 0, 32, 32, 64, 64), 
      love.graphics.newQuad(0, 32, 32, 32, 64, 64) 
    },
    small = {
      love.graphics.newQuad(0, 0, 16, 16, 32, 32), 
      love.graphics.newQuad(16, 0, 16, 16, 32, 32), 
      love.graphics.newQuad(0, 16, 16, 16, 32, 32)
    }
  }
}
