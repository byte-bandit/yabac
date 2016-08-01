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
        if not self.origin then
            if self.canBuildRoad then
                love.audio.play(sndClick)
                self.origin = world:getWorldPosition()
            else
                love.audio.play(sndDenied)
            end
        else
            if self.canBuildRoad then
                world:createRoad(self.preview)
                love.audio.play(sndClick)
                self.preview = {}
                self.origin = nil
            else
                love.audio.play(sndDenied)
            end
        end
    end
end

STATE.ROAD.draw = function(self)
    if self.canBuildRoad then love.graphics.setColor(255, 255, 255, 127) else love.graphics.setColor(255, 0, 0, 127) end
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

        self.canBuildRoad = true
        for k,v in pairs(self.preview) do
            if not world:tileQuery(v, {"grass", "road"}) or buildingManager:queryBuilding(v * world.grain) then self.canBuildRoad = false end
        end

    else
        local pos = world:getWorldPosition()
        self.canBuildRoad = world:tileQuery(pos, {"grass", "road"}) and not buildingManager:queryBuilding(pos * world.grain)
    end
end