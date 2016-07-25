STATE = {}

STATE.DEFAULT = State("default")
STATE.BUILD = State("build")

STATE.BUILD.click = function(self, x, y, button)
    if button == 2 then 
        gameState:pop()
    elseif button == 1 then
        if self.blueprint.canBuild then
            buildingManager:addBuilding(self.blueprint:create())
        end
    end
end

STATE.BUILD.draw = function(self)
    self.blueprint:draw()
end

STATE.BUILD.update = function(self, dt)
    self.blueprint:update(dt)
end