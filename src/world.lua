require 'src.noise'

local function load()
    perlin:load()
end

World = Class {}

function World:init(tileset, width, height, seed)
    self.tileset = tileset
    self.width = width
    self.height = height or width
    self.seed = seed or love.math.random()
    self.sb = love.graphics.newSpriteBatch(self.tileset, self.width*self.height, "stream")

    self.terrainInfo = {}
    self.quadInfo = {}

    self.quads = {}
    self.quads["grass"] = love.graphics.newQuad(0, 0, 16, 16, tileset:getWidth(), tileset:getHeight())
    self.quads["water"] = love.graphics.newQuad(7 * 16, 0, 16, 16, tileset:getWidth(), tileset:getHeight())
    self.quads["mountain"] = love.graphics.newQuad(3 * 16, 0, 16, 16, tileset:getWidth(), tileset:getHeight())
    self.quads["forest"] = love.graphics.newQuad(2 * 16, 0, 16, 16, tileset:getWidth(), tileset:getHeight())

    load()
end

function World:populate()
    for i=0,self.width do
        self.terrainInfo[i] = {}
        self.quadInfo[i] = {}

        for j=0,self.height do
            local l = perlin:noise((i+1)/10, (j+1)/10, 0.3)
            if l >= -1 and l < -0.3 then
                self.terrainInfo[i][j] = 0
                self.quadInfo[i][j] = self.sb:add(self.quads["water"], i*16, j*16)
            elseif l >= -0.3 and l < 0 then
                self.terrainInfo[i][j] = 1
                self.quadInfo[i][j] = self.sb:add(self.quads["grass"], i*16, j*16)
            elseif l >= 0 and l < 0.5 then
                self.terrainInfo[i][j] = 2
                self.quadInfo[i][j] = self.sb:add(self.quads["forest"], i*16, j*16)
            elseif l >= 0.5 then
                self.terrainInfo[i][j] = 3
                self.quadInfo[i][j] = self.sb:add(self.quads["mountain"], i*16, j*16)
            end
        end
    end
end

function World:draw()
    love.graphics.draw(self.sb)
end

function World:update()

end