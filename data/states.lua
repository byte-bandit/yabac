STATE = {}

STATE.DEFAULT = State("default")
STATE.BUILD = State("build")
STATE.ROAD = State("road")

STATE.BUILD.click = function(self, x, y, button)
    if button == 2 then 
        gameState:pop()
    elseif button == 1 then
        if self.blueprint.canBuild then
            buildingManager:addBuilding(self.blueprint:create())
        end
    end
end

STATE.BUILD.draw = function(self)
    self.blueprint:draw()
end

STATE.BUILD.update = function(self, dt)
    self.blueprint:update(dt)
end

STATE.ROAD.click = function(self, x, y, button)
    if button == 2 then 
        gameState:pop()
    end
end

STATE.ROAD.draw = function(self)
    love.graphics.setColor(255, 255, 255, 127)
    for k,v in pairs(self.preview) do
        love.graphics.draw(BuildingTable[1].gfx, v.x * world.grain, v.y * world.grain) 
    end
    love.graphics.setColor(255, 255, 255, 255)
end

STATE.ROAD.update = function(self, dt)
    self.preview = {}
    table.insert(self.preview, Vector(self.origin.x, self.origin.y))

    local pos = world:getWorldPosition()
    local dx = math.abs(pos.x - self.origin.x)
    local dy = math.abs(pos.y - self.origin.y)

    if dx > dy then
        for i=1,dx do
            table.insert(self.preview, Vector(self.origin.x + i, self.origin.y))
        end
    else
        for i=1,dy do
            table.insert(self.preview, Vector(self.origin.x, self.origin.y + i))
        end
    end
end