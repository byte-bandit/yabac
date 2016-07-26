ResourceManager = Class{}

function ResourceManager:init()
    self.resources = {}

    for k,v in pairs(ResourceTable) do
        self.resources[k] = 0
    end
end

function ResourceManager:add(res)
    res = res or {}

    for k,v in pairs(res) do
        self.resources[k] = self.resources[k] + v
    end
end

function ResourceManager:tryRemove(res)
    res = res or {}

    success = true
    for k,v in pairs(res) do
        if self.resources[k] < v then success = false end
    end

    if success then
        for k,v in pairs(res) do
            self.resources[k] = self.resources[k] - v
        end
    end

    return success
end