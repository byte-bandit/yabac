Building = Class{}

function Building:init()
end

function Building:draw()
    love.graphics.draw(self.gfx, self.x, self.y)
end