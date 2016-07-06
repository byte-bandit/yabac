State = Class {}

function State:init(name)
    self.name = name or "Unknown"
end

function State:draw()
end

function State:update(dt)
end

function State:click(x, y, button)
end