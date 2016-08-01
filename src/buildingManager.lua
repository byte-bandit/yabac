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
        if v.x == pos.x and v.y == pos.y then return true end
    end

    return false
end