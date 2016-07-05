Hud = Class {}

function Hud:init()
    self.suit = require 'lib.suit'
    self:update()
end

function Hud:draw()
    love.graphics.setColor(80, 80, 80, 255)
    love.graphics.rectangle("fill", 0, 0, self.wWidth, 32)
    love.graphics.rectangle("fill", self.wWidth - 128, 0, 128, self.wWidth)
    love.graphics.setColor(255, 255, 255, 255)

    self:drawBuildingList()

    self.suit.draw()
end

function Hud:update()
    self.wWidth = love.graphics.getWidth()
    self.wHeight = love.graphics.getHeight()
    self.qOrigin = Vector(self.wWidth - 96, 128)

    self.suit.layout:reset(self.qOrigin.x, self.qOrigin.y, 20, 20)

    -- put a button at the layout origin
    -- the cell of the button has a size of 200 by 30 pixels
    local state = self.suit.Button("Click?", self.suit.layout:row(200,30))

    -- if the button was pressed, take damage
    if state.hit then print("Ouch!") end
end

function Hud:drawBuildingList()
    local c = 0
    for _,v in ipairs(BuildingTable) do
        love.graphics.draw(v.gfx, self.qOrigin.x + (c * 32), self.qOrigin.y)
        c = c + 1
    end
end