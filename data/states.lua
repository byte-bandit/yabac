STATE = {}

STATE.BUILD = State("build")
STATE.ROAD = State("road")
STATE.DEMOLISH = State("demolish")

STATE.BUILD.click = function(self, x, y, button)
    if button == 2 then 
        love.audio.play(sndClick2)
        gameState:pop()
    elseif button == 1 and hud:isCursorOutsideHud() then
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
    elseif button == 1 and hud:isCursorOutsideHud() then
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

STATE.DEMOLISH.area = {}

STATE.DEMOLISH.click = function(self, x, y, button)
    if not love.mouse.isDown(1) and button == 2 then
        love.audio.play(sndClick2)
        self.area = {}
        gameState:pop()
    end
end

STATE.DEMOLISH.draw = function(self)
    if #self.area > 0 then
        local x = self.area[1].x * world.grain
        local y = self.area[1].y * world.grain
        local w = ((self.area[2].x * world.grain) - x) + world.grain
        local h = ((self.area[2].y * world.grain) - y) + world.grain

        cameraManager:attach()

        love.graphics.setColor(255, 0, 0, 127)
        love.graphics.rectangle("fill", x, y, w, h)
        love.graphics.setColor(255, 255, 255, 255)

        cameraManager:detach()
    end
end

STATE.DEMOLISH.update = function(self, dt)
    if love.mouse.isDown(1) then
        if #self.area < 1 then
            self.area[1] = world:getWorldPosition()
            love.audio.play(sndClick)
        end
        self.area[2] = world:getWorldPosition()
    else
        if #self.area > 0 then
            buildingManager:removeBuildingsWithin(self.area[1], self.area[2]) 
            world:removeRoadsWithin(self.area[1], self.area[2])
            love.audio.play(sndDemolish)
            self.area = {}
        end
    end
end