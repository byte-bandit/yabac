Camera = require 'lib.hump.camera'
Class = require 'lib.hump.class'
Vector = require 'lib.hump.vector'

require 'src.blueprint'
require 'src.building'
require 'src.camera'
require 'src.hud'
require 'src.stack'
require 'src.world'

require 'data.buildings'
require 'data.states'

--- Callback function used for initial loading.
function love.load()
    world = World(love.graphics.newImage('assets/gfx/tileset.png'), 128, 128)
    hud = Hud()
    cameraManager = CameraManager()

    world:populate()
end

--- Callback function used for every draw frame.
function love.draw()
    cameraManager:attach()
    world:draw()
    cameraManager:detach()

    hud:draw()

    love.graphics.print("FPS: "..love.timer.getFPS(), 32, 32)
end

--- Callback function used for every update frame.
-- @param dt Delta time since the last update
function love.update(dt)
    world:update(dt)
    cameraManager:update(dt)
    hud:update(dt)
end

--- Callback function used for key pressed events.
-- @param key The pressed key
function love.keypressed(key)
    if key == 'escape' then love.event.quit() end
end

--- Callback function used for mouse wheel moved events.
-- @param x The delta x of the mouse wheel movement
-- @param y The delta y of the mouse wheel movement
function love:wheelmoved(x, y)
    cameraManager:handleMouseWheel(x, y)
end

--- Callback function used for mouse button pressed events.
-- @param x The x coordinate of the registered click event
-- @param y The y coordinate of the registered click event
-- @param button The registered mouse button
-- @param istouch Indicating whether or not the registered event was caused by a touch
function love.mousepressed(x, y, button, istouch)
end