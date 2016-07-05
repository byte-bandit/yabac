Class = require 'lib.hump.class'
Camera = require 'lib.hump.camera'
Vector = require 'lib.hump.vector'

require 'src.camera'
require 'src.building'
require 'src.world'
require 'src.blueprint'
require 'src.hud'
require 'src.stack'

STATE = {
    SELECT = 1,
    BUILD = 2
}

stt = Stack({1,2,3})
stt:push(5)
stt:push(7)

print("Size: "..stt:pop())
print("Size: "..stt:pop())
print("Size: "..stt:pop())

buildings = {}
blueprint = Blueprint(5)

function love.load()
    local tileset = love.graphics.newImage('assets/gfx/tileset.png')
    house = love.graphics.newImage('assets/gfx/house.png')

    cameraManager = CameraManager()
    world = World(tileset, 128, 128)
    world:populate()

    require 'data.buildings'

    hud = Hud()
end

function love.draw()
    cameraManager:attach()

    love.graphics.setColor(255,0,0,255)
    love.graphics.line(0, 0, 16, 0)
    love.graphics.setColor(0, 255,0,255)
    love.graphics.line(0, 0, 0, 16)
    love.graphics.setColor(255, 255, 255, 255)

    world:draw()

    if blueprint.canbuild then love.graphics.setColor(0, 255, 0, 127) else love.graphics.setColor(255, 0, 0, 127) end
    love.graphics.draw(house, blueprint.x, blueprint.y)
    love.graphics.setColor(255, 255, 255, 255)

    for _,v in ipairs(buildings) do
        love.graphics.draw(house, v.x, v.y)
    end

    cameraManager:detach()

    hud:draw()

    love.graphics.print("FPS: "..love.timer.getFPS(), 32, 32)
end

function love.update()
    cameraManager:update()
    world:update()
    blueprint:update()
    hud:update()

    local ox = blueprint.x / 32
    local oy = blueprint.y / 32

    --if (lens[ox][oy] == 0 and lens[ox+1][oy] == 0 and lens[ox][oy+1] == 0 and lens[ox+1][oy+1] == 0) then
    --    blueprint.canbuild = true
    --else
    --    blueprint.canbuild = false
    --end
end

function love.keypressed(key)
end

function love:wheelmoved(x, y)
    cameraManager:handleMouseWheel(x, y)
end

function love.mousepressed(x, y, button, istouch)
    if (button == 1 and blueprint.canbuild) then
        table.insert(buildings, Building(blueprint.x, blueprint.y))
        print("Amount of buildings: "..#buildings)
    end
end