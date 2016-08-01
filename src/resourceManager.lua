ResourceManager = Class{}

function ResourceManager:init()
    self.resources = {}

    self.resources["thalers"] = 200
    self.resources["wood"] = 0
    self.resources["timber"] = 30
end

function ResourceManager:add(res)
    res = res or {}

    for k,v in pairs(res) do
        self.resources[k] = self.resources[k] + v
    end
end

function ResourceManager:tryRemove(res)
    res = res or {}

    if self:hasResource(res) then
        for k,v in pairs(res) do
            self.resources[k] = self.resources[k] - v
        end

        return true
    else
        return false
    end
end

function ResourceManager:hasResource(res)
    res = res or {}

    for k,v in pairs(res) do
        if self.resources[k] < v then return false end
    end

    return true
end

function ResourceManager:payCost(building)
    if not building.cost then return true else return self:tryRemove(building.cost) end
end