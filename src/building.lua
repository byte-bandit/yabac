Building = Class{}

function Building:init()
end

function Building:draw()
    if self.production.state == ProductionQueue.State.Unable then love.graphics.setColor(0, 0, 255, 255) end
    love.graphics.draw(self.gfx, self.x, self.y)
    love.graphics.setColor(255, 255, 255, 255)
end

function Building:update(dt)
    if self.production then
        self.production:update(dt)

        if self.production.state == ProductionQueue.State.Finished then
            resourceManager:add(self.production.output)
            self.production.progress = 0
            self.production.state = ProductionQueue.State.Paused
            self:restartProduction()
        elseif self.production.state == ProductionQueue.State.Unable then
            self:restartProduction()
        end
    end
end

function Building:restartProduction()
    if self.env_inpact then
        if self.env_inpact.canExecute(self) then
            self.production.state = ProductionQueue.State.Halted
        else
            self.production.state = ProductionQueue.State.Unable
        end
    else
        self.production.state = ProductionQueue.State.Halted
    end
end