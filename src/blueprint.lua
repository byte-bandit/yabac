Blueprint = Class {}

function Blueprint:init(building)
    self.building = building
    self.x = 0
    self.y = 0
    self.canBuild = false
end

function Blueprint:update(dt)
    local mx, my = cameraManager:getCamera():mousePosition()

    self.x = (math.floor(mx/16) )*16
    self.y = (math.floor(my/16) )*16

    if self.x < 0 then self.x = 0 end
    if self.y < 0 then self.y = 0 end

    -- todo: Check upper bounds
end

function Blueprint:draw()
    cameraManager:attach()
    love.graphics.draw(self.building.gfx, self.x, self.y)
    cameraManager:detach()
end