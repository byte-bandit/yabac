Hud = Class {}


function Hud:init()
    self.suit = require 'lib.suit'
    self.resourceGrid = {}
    self.resourceGrid[0] = "thalers"
    self.resourceGrid[1] = "wood"
    self.resourceGrid[2] = "timber"
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
    love.graphics.draw(self.hud_bg, self.hud_quads[2], self.wWidth - 256, 0)

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("fill", self.wWidth - 256 + 16, 32, 256 - 32, self.wHeight - 64, 8)
    love.graphics.rectangle("fill", 4, self.wHeight - 28, self.wWidth - 8, 24, 4)
    love.graphics.setColor(255, 255, 255, 255)

    self.suit.draw()

    offset = 0
    for k,v in pairs(self.resourceGrid) do
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.rectangle("fill", 4 + (offset * 128+8), 4, 96, 24, 4)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(ResourceTable[v].gfx, 8 + (offset * 128+8), 8)
        love.graphics.print(resourceManager.resources[v], 32 + (offset * 128+8), 10)
        offset = offset + 1
    end

    if self.tooltip then love.graphics.print(self.tooltip, 8, self.wHeight - 24) end

    local state = gameState:top()
    if state.name == "build" and state.blueprint and state.blueprint.building.cost then
        for k,v in pairs(state.blueprint.building.cost) do
            if resourceManager.resources[k] >= v then love.graphics.setColor(0, 255, 0, 255) else love.graphics.setColor(255, 0, 0, 255) end
            local x = 0

            if k == "thalers" then
                x = 32
            elseif k == "wood" then
                x = 32 + (1 * 128 + 8)
            elseif k == "timber" then
                x = 32 + (2 * 128 + 8)
            end

            love.graphics.print(v, x, 28)
        end

        love.graphics.setColor(255, 255, 255, 255)
    end
end

function Hud:update(dt)
    self.wWidth = love.graphics.getWidth()
    self.wHeight = love.graphics.getHeight()
    self.qOrigin = Vector(self.wWidth - 224, 128)
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