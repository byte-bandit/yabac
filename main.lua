Camera = require 'lib.hump.camera'
Class = require 'lib.hump.class'
Vector = require 'lib.hump.vector'

require 'src.blueprint'
require 'src.building'
require 'src.buildingManager'
require 'src.camera'
require 'src.debug'
require 'src.hud'
require 'src.productionQueue'
require 'src.resourceManager'
require 'src.state'
require 'src.stack'
require 'src.world'

require 'data.buildings'
require 'data.resources'
require 'data.states'

--- Callback function used for initial loading.
function love.load()
    world = World(love.graphics.newImage('assets/gfx/tileset.png'), 16, Vector(128, 128))
    love.graphics.setFont(love.graphics.newFont('assets/font/Mops.ttf', 16 ))
    hud = Hud()
    cameraManager = CameraManager()
    gameState = Stack()
    gameState:push(STATE.DEFAULT)

    world:populate()

    buildingManager = BuildingManager()
    resourceManager = ResourceManager()
end

--- Callback function used for every draw frame.
function love.draw()
    cameraManager:attach()
    world:draw()
    buildingManager:draw()
    cameraManager:detach()

    gameState:top():draw()

    hud:draw()

    Debug:draw()
end

--- Callback function used for every update frame.
-- @param dt Delta time since the last update
function love.update(dt)
    world:update(dt)
    buildingManager:update(dt)
    cameraManager:update(dt)
    gameState:top():update(dt)
    hud:update(dt)

    Debug:print(
        "FPS: "..love.timer.getFPS(), 
        "State: "..gameState:top().name)
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
    gameState:top():click(x, y, button)
end