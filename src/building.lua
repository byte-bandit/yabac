Building = Class{}

function Building:init()
end

function Building:draw()
    love.graphics.draw(self.gfx, self.x, self.y)
end

function Building:update(dt)
    if self.production then
        self.production:update(dt)

        if self.production.state == ProductionQueue.State.Finished then
            resourceManager:add(self.production.output)
            self.production.progress = 0
            self.production.state = ProductionQueue.State.Halted
        end
    end
end