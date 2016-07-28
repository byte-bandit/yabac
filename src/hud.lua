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

    self.suit.draw()

    offset = 0
    for k,v in pairs(resourceManager.resources) do
        if v > 0 then
            love.graphics.draw(ResourceTable[k].gfx, 8 + (48 * offset), 8)
            love.graphics.print(v, 32 + (48 * offset), 10)
            offset = offset + 1
        end
    end
end

function Hud:update(dt)
    self.wWidth = love.graphics.getWidth()
    self.wHeight = love.graphics.getHeight()
    self.qOrigin = Vector(self.wWidth - 96, 128)

    self.suit.layout:reset(self.qOrigin.x, self.qOrigin.y, 4, 4)

    for _,v in ipairs(BuildingTable) do
        if self.suit.ImageButton(v.gfx, {}, self.suit.layout:col(16,16)).hit then 
            if gameState:top() == STATE.BUILD then gameState:pop() end
            if v.id == "road" then
                gameState:push(STATE.ROAD)
            else
                gameState:push(STATE.BUILD)
                gameState:top().blueprint = Blueprint(v)
            end
        end
    end
end