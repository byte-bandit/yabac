require 'src.noise'

local function load()
    perlin:load()
end

World = Class {}

function World:init(tileset, grain, size, seed)
    self.tileset = tileset
    self.grain = grain
    self.size = size or Vector(128, 128)
    self.seed = seed or love.math.random()
    self.sb = love.graphics.newSpriteBatch(self.tileset, self.size.x * self.size.y, "stream")

    self.terrainInfo = {}
    self.quadInfo = {}

    local tw = tileset:getWidth()
    local th = tileset:getHeight()

    self.quads = {}
    self.quads["grass"] = love.graphics.newQuad(0, 0, self.grain, self.grain, tw, th)
    self.quads["water"] = love.graphics.newQuad(7 * self.grain, 0, self.grain, self.grain, tw, th)
    self.quads["mountain"] = love.graphics.newQuad(3 * self.grain, 0, self.grain, self.grain, tw, th)
    self.quads["forest"] = love.graphics.newQuad(2 * self.grain, 0, self.grain, self.grain, tw, th)

    load()
end

function World:populate()
    for i=0,self.size.x do
        self.terrainInfo[i] = {}
        self.quadInfo[i] = {}
        for j=0,self.size.y do
            local l = perlin:noise((i+1)/10, (j+1)/10, 0.3)
            local x = i * self.grain
            local y = j * self.grain
            if l >= -1 and l < -0.3 then
                self.terrainInfo[i][j] = 0
                self.quadInfo[i][j] = self.sb:add(self.quads["water"], x, y)
            elseif l >= -0.3 and l < 0 then
                self.terrainInfo[i][j] = 1
                self.quadInfo[i][j] = self.sb:add(self.quads["grass"], x, y)
            elseif l >= 0 and l < 0.5 then
                self.terrainInfo[i][j] = 2
                self.quadInfo[i][j] = self.sb:add(self.quads["forest"], x, y)
            elseif l >= 0.5 then
                self.terrainInfo[i][j] = 3
                self.quadInfo[i][j] = self.sb:add(self.quads["mountain"], x, y)
            end
        end
    end
end

function World:draw()
    love.graphics.draw(self.sb)

    love.graphics.setColor(255,0,0,255)
    love.graphics.line(0, 0, 16, 0)
    love.graphics.setColor(0, 255,0,255)
    love.graphics.line(0, 0, 0, 16)
    love.graphics.setColor(255, 255, 255, 255)
end

function World:update(dt)
    local mx, my = cameraManager:getCamera():mousePosition()

    local cx = math:clamp(0, (math.floor(mx/self.grain) ), self.size.x)
    local cy = math:clamp(0, (math.floor(my/self.grain) ), self.size.y)

    Debug:print("Mouse world: ["..mx..", "..my.."]")
    Debug:print("Hovering tile: "..self.terrainInfo[cx][cy].."["..cx..", "..cy.."]")
end