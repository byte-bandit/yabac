Hud = Class {}


function Hud:init()
    self.suit = require 'lib.suit'
    self.resourceGrid = {}
    self.resourceGrid[0] = "thalers"
    self.resourceGrid[1] = "wood"
    self.resourceGrid[2] = "timber"

    self.hud_bg = love.graphics.newImage('assets/gfx/hud_bg.png')
    self.hud_bg:setWrap("repeat", "repeat")

    self.buttongfx = {}
    self.buttongfx[0] = love.graphics.newImage('assets/gfx/btn.png')
    self.buttongfx[1] = love.graphics.newImage('assets/gfx/btn_hover.png')
    self.buttongfx[2] = love.graphics.newImage('assets/gfx/btn_click.png')

    self.btnDemolish = love.graphics.newImage('assets/gfx/demolish.png')

    self.volumeSlider = {value = 1, min = 0, max = 1, step = 0.1}

    self.hud_quads = 
    {
        love.graphics.newQuad(0, 0, 4096, 32, 16, 16),
        love.graphics.newQuad(0, 0, 256, 4096, 16, 16)
    }

    self:update()
end

function Hud:draw()

    love.graphics.draw(self.hud_bg, self.hud_quads[1], 0, 0)
    love.graphics.draw(self.hud_bg, self.hud_quads[1], 0, self.wHeight - 32)
    love.graphics.draw(self.hud_bg, self.hud_quads[2], self.wWidth - 256, 0)

    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("fill", self.wWidth - 256 + 16, 32, 256 - 32, self.wHeight - 64, 8)
    love.graphics.rectangle("fill", 4, self.wHeight - 28, self.wWidth - 8, 24, 4)
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.setFont(fntMopsLarge)
    love.graphics.print("Buildings", self.wWidth - 180, 48)
    love.graphics.setFont(fntMops)
    love.graphics.print("Music volume", self.wWidth - 224, self.wHeight - 96)

    self.suit.draw()
    for k,v in pairs(self.buildingListHelpTable) do
        love.graphics.draw(v[1], v[2] + 6, v[3] + 6, 0, 1.2)
    end

    offset = 0
    for k,v in pairs(self.resourceGrid) do
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.rectangle("fill", 4 + (offset * 128+8), 4, 96, 24, 4)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(ResourceTable[v].gfx, 8 + (offset * 128+8), 8)
        love.graphics.print(resourceManager.resources[v], 32 + (offset * 128+8), 6)
        offset = offset + 1
    end

    if self.tooltip then love.graphics.print(self.tooltip, 8, self.wHeight - 26) end

    local state = gameState:top()
    if state and state.name == "build" and state.blueprint and state.blueprint.building.cost then
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
    self.buildingListHelpTable = {}

    --self.suit.layout:reset(self.qOrigin.x, self.qOrigin.y, 4, 4)
    local x = self.wWidth - 224
    local y = 128
    local dx = 0
    local dy = 0

    for _,v in ipairs(BuildingTable) do

        local state = self.suit.ImageButton(self.buttongfx[0], {hovered=self.buttongfx[1], active=self.buttongfx[2], id = v.id}, x + dx, y +dy)
        table.insert(self.buildingListHelpTable, {v.gfx, x+dx, y+dy})

        if state.hit then 
            love.audio.play(sndClick)
            if gameState:top() == STATE.BUILD or gameState:top() == STATE.ROAD then gameState:pop() end
            if v.id == "road" then
                gameState:push(STATE.ROAD)
            else
                gameState:push(STATE.BUILD)
                gameState:top().blueprint = Blueprint(v)
            end
        end

        if state.hovered then self.tooltip = v.tooltip end

        dx = dx + 48

        if dx == 192 then
            dx = 0
            dy = dy + 48
        end
    end

    state = self.suit.ImageButton(self.buttongfx[0], {hovered=self.buttongfx[1], active=self.buttongfx[2], id = "demolish"}, x + dx, y +dy)
    table.insert(self.buildingListHelpTable, {self.btnDemolish, x+dx, y+dy})

    if state.hit then
        love.audio.play(sndClick)
        gameState:pop()
        gameState:push(STATE.DEMOLISH)
    end

    if state.hovered then self.tooltip = "Demolish constructed buildings and roads." end

    if self.suit.Slider(self.volumeSlider, self.wWidth - 224, self.wHeight - 64, 192, 12).changed then
        for k,v in pairs(music.tracks) do
            v:setVolume(self.volumeSlider.value)
        end
    end    
end

function Hud:isCursorOutsideHud()
    local x, y = love.mouse.getPosition()

    return x > 0 and x < self.wWidth - 256 and y > 32 and y < self.wHeight - 32
end