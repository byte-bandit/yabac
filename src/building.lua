Building = Class{}

function Building:init()
    self.queueList = {}

    if self.output then
        for k,v in pairs(self.output) do
            
        end
    end
end

function Building:draw()
    love.graphics.draw(self.gfx, self.x, self.y)
end

function Building:update(dt)
    for k,v in pairs(self.queueList) do
        v:update(dt)

        if (v.state == ProductionQueue.State.Finished) then
            -- collect result and restart queue
        end
    end
end