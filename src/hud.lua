Hud = Class {}

function Hud:init()
    self.suit = require 'lib.suit'
    self:update()

    self.hud_bg = love.graphics.newImage('assets/gfx/hud_bg.png')
    self.hud_bg:setWrap("repeat", "repeat")

    self.hud_quads = 
    {
        love.graphics.newQuad(0, 0, 4096, 32, 16, 16),
        love.graphics.newQuad(0, 0, 256, 4096, 16, 16)
    }
end

function Hud:draw()

    love.graphics.draw(self.hud_bg, self.hud_quads[1], 0, 0)
    love.graphics.draw(self.hud_bg, self.hud_quads[1], 0, self.wHeight - 32)
    love.graphics.draw(self.hud_bg, self.hud_quads[2], self.wWidth - 128, 0)

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("fill", self.wWidth - 128 + 16, 32 + 16, 128 - 32, self.wHeight - 96, 8)
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

    if self.tooltip then love.graphics.print(self.tooltip, 8, self.wHeight - 24) end
end

function Hud:update(dt)
    self.wWidth = love.graphics.getWidth()
    self.wHeight = love.graphics.getHeight()
    self.qOrigin = Vector(self.wWidth - 96, 128)
    self.tooltip = nil

    self.suit.layout:reset(self.qOrigin.x, self.qOrigin.y, 4, 4)

    for _,v in ipairs(BuildingTable) do

        local btn = self.suit.ImageButton(v.gfx, {}, self.suit.layout:col(16,16))

        if btn.hit then 
            if gameState:top() == STATE.BUILD then gameState:pop() end
            if v.id == "road" then
                gameState:push(STATE.ROAD)
            else
                gameState:push(STATE.BUILD)
                gameState:top().blueprint = Blueprint(v)
            end
        end

        if btn.hovered then self.tooltip = v.tooltip end
    end
end