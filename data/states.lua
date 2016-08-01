STATE = {}

STATE.DEFAULT = State("default")
STATE.BUILD = State("build")
STATE.ROAD = State("road")

STATE.BUILD.click = function(self, x, y, button)
    if button == 2 then 
        love.audio.play(sndClick2)
        gameState:pop()
    elseif button == 1 then
        if self.blueprint.canBuild then
            buildingManager:addBuilding(self.blueprint:create())
        else
            love.audio.play(sndDenied)
        end
    end
end

STATE.BUILD.draw = function(self)
    self.blueprint:draw()
end

STATE.BUILD.update = function(self, dt)
    self.blueprint:update(dt)
end

STATE.ROAD.preview = {}

STATE.ROAD.click = function(self, x, y, button)
    if button == 2 then
        love.audio.play(sndClick2)
        if self.origin then self.origin = nil else gameState:pop() end
    elseif button == 1 then
        love.audio.play(sndClick)
        if not self.origin 
            then self.origin = world:getWorldPosition()
        else
            world:createRoad(self.preview)
            self.preview = {}
            self.origin = nil
        end
    end
end

STATE.ROAD.draw = function(self)
    love.graphics.setColor(255, 255, 255, 127)
    if self.origin then
        for k,v in pairs(self.preview) do
            cameraManager:attach()
            love.graphics.draw(BuildingTable[1].gfx, v.x * world.grain, v.y * world.grain) 
            cameraManager:detach()
        end
    else
        local x, y = world:getWorldPosition():unpack()
        cameraManager:attach()
        love.graphics.draw(BuildingTable[1].gfx, x * world.grain, y * world.grain) 
        cameraManager:detach()
    end
    love.graphics.setColor(255, 255, 255, 255)
end

STATE.ROAD.update = function(self, dt)
    if self.origin then
        self.preview = {}
        table.insert(self.preview, Vector(self.origin.x, self.origin.y))

        local pos = world:getWorldPosition()
        local dx = math.abs(pos.x - self.origin.x)
        local dy = math.abs(pos.y - self.origin.y)
        local fac = 1

        if dx > dy then
            if self.origin.x > pos.x then fac = -1 end
            for i=1,dx do
                table.insert(self.preview, Vector(self.origin.x + i * fac, self.origin.y))
            end
        else
            if self.origin.y > pos.y then fac = -1 end
            for i=1,dy do
                table.insert(self.preview, Vector(self.origin.x, self.origin.y + i * fac))
            end
        end
    end
end