Building = Class{}

function Building:init()
    if self.output then
        self.cdTable = {}
        for p,v in pairs(self.output) do
            self.cdTable[v] = 0
        end
    end
end

function Building:draw()
    love.graphics.draw(self.gfx, self.x, self.y)
end

function Building:update(dt)
    if self.output then
        for p,v in pairs(self.output) do
            if self.cdTable[v] < v.cooldown then 
                self.cdTable[v] = self.cdTable[v] + dt
            else
                self.cdTable[v] = 0
                resources[v.id] = resources[v.id] + v.qty
            end
        end
    end
end