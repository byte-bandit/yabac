BuildingManager = Class{}

function BuildingManager:init()
    self.buildings = {}
end

function BuildingManager:addBuilding(building)
    table.insert(self.buildings, building)
end

function BuildingManager:draw()
    for _,v in ipairs(self.buildings) do
        v:draw()
    end
end

function BuildingManager:update(dt)
    for _,v in ipairs(self.buildings) do
        v:update(dt)
    end
end

function BuildingManager:queryBuilding(pos)
    for k,v in pairs(self.buildings) do
        if v.x == pos.x and v.y == pos.y then return v end
    end

    return nil
end

function BuildingManager:removeBuildingsWithin(from, to)
    target = Vector(math.min(from.x, to.x), math.min(from.y, to.y)) * world.grain
    dest = Vector(math.max(from.x, to.x), math.max(from.y, to.y)) * world.grain

    for k,v in pairs(self.buildings) do
        if v.x >= target.x and v.x <= dest.x and v.y >= target.y and v.y <= dest.y then
            self.buildings[k] = nil
        end
    end
end