STATE = {}

STATE.DEFAULT = State("default")
STATE.BUILD = State("build")

STATE.BUILD.click = function(self, x, y, button)
    if button == 2 then gameState:pop() end
end

STATE.BUILD.draw = function(self)
    self.blueprint:draw()
end

STATE.BUILD.update = function(self, dt)
    self.blueprint:update(dt)
end