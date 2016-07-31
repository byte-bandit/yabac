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

    self.terrainIds = {}
    self.terrainIds["water"] = 0
    self.terrainIds["grass"] = 1
    self.terrainIds["forest"] = 2
    self.terrainIds["mountain"] = 3
    self.terrainIds["road"] = 4

    self.quads = {}
    self.quads["grass"] = {id = self.terrainIds["grass"], quad = love.graphics.newQuad(0, 0, self.grain, self.grain, tw, th)}
    self.quads["water"] = {id = self.terrainIds["water"], quad = love.graphics.newQuad(7 * self.grain, 0, self.grain, self.grain, tw, th)}
    self.quads["mountain"] = {id = self.terrainIds["mountain"], quad = love.graphics.newQuad(3 * self.grain, 0, self.grain, self.grain, tw, th)}
    self.quads["forest"] = {id = self.terrainIds["forest"], quad = love.graphics.newQuad(2 * self.grain, 0, self.grain, self.grain, tw, th)}
    self.quads["road"] = {id = self.terrainIds["road"], quad = love.graphics.newQuad(5 * self.grain, 2 * self.grain, self.grain, self.grain, tw, th)}
end

function World:addQuad(point, q)
    local x = point.x
    local y = point.y
    local quad = self.quads[q]

    self.terrainInfo[x][y] = quad.id
    self.quadInfo[x][y] = self.sb:add(quad.quad, x * self.grain, y * self.grain)
end

function World:setQuad(point, q)
    local x = point.x
    local y = point.y
    local quad = self.quads[q]
    
    self.terrainInfo[x][y] = quad.id
    self.sb:set(self.quadInfo[x][y], quad.quad, x * self.grain, y * self.grain)
end

function World:populate()
    local zed = love.math.random()

    for i=0,self.size.x do
        self.terrainInfo[i] = {}
        self.quadInfo[i] = {}
        for j=0,self.size.y do
            local l = love.math.noise((i+1)/30, (j+1)/30, zed)
            if l >= 0 and l < 0.5 then
                self:addQuad(Vector(i, j), "water")
            elseif l >= 0.5 and l < 0.7 then
                self:addQuad(Vector(i, j), "grass")
            elseif l >= 0.7 then
                self:addQuad(Vector(i, j), "mountain")
            end
        end
    end

    self:populateForest()
end

function World:populateForest()
    local amount = love.math.random(10,18)
    local currentAmount = 0

    while currentAmount < amount do
        local randomPoint = Vector(love.math.random(0, self.size.x), love.math.random(0, self.size.y))

        if self.terrainInfo[randomPoint.x][randomPoint.y] == self.terrainIds["grass"] then
            self:setQuad(randomPoint, "forest")

            local forestSize = love.math.random(120,360)
            for i=0,forestSize do
                local flag = true
                while flag do
                    local decider = love.math.random(1,4)

                    if decider == 1 then randomPoint.x = randomPoint.x + 1
                    elseif decider == 2 then randomPoint.x = randomPoint.x - 1
                    elseif decider == 3 then randomPoint.y = randomPoint.y - 1
                    elseif decider == 4 then randomPoint.y = randomPoint.y + 1
                    end

                    randomPoint = self:clampToBounds(randomPoint:unpack())

                    if self.terrainInfo[randomPoint.x][randomPoint.y] == self.terrainIds["grass"] then flag = false end
                end

                self:setQuad(randomPoint, "forest")
            end

            currentAmount = currentAmount + 1
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
    local clamped = self:getWorldPosition()

    Debug:print("Mouse world: ["..mx..", "..my.."]")
    Debug:print("Hovering tile: "..self.terrainInfo[clamped.x][clamped.y].."["..clamped.x..", "..clamped.y.."]")
end

function World:getWorldPosition()
    local mx, my = cameraManager:getCamera():mousePosition()
    return self:clampToBounds(self:worldToMapCoordinates(Vector(mx, my)):unpack())
end

function World:clampToBounds(x, y)
    return Vector(math:clamp(0, x, self.size.x), math:clamp(0, y, self.size.y))
end

function World:worldToMapCoordinates(coords)
    return Vector(math.floor(coords.x/self.grain), math.floor(coords.y/self.grain))
end

function World:getResourcesInRadius(resource, x, y, radius)
    local x,y = self:worldToMapCoordinates(Vector(x, y)):unpack()

    result = {}

    for i=x-radius,x+radius do
        for n=y-radius,y+radius do
            local clamped = self:clampToBounds(i, n)

            if self.terrainInfo[clamped.x][clamped.y] == resource then table.insert(result, {clamped:unpack()}) end
        end
    end

    return result
end

function World:addRandomResourceInRadius(resource, x, y, radius)

    res = self:getResourcesInRadius(self.terrainIds["grass"], x, y, radius)

    if #res > 0 then
        target = res[math.random(#res)]
        self:setQuad(Vector(target[1], target[2]), "forest")
        return true
    end

    return false
end

function World:removeRandomResourceInRadius(resource, x, y, radius)
    res = self:getResourcesInRadius(resource, x, y, radius)

    if #res > 0 then
        target = res[math.random(#res)]
        self:setQuad(Vector(target[1], target[2]), "grass")
        return true
    end

    return false
end

function World:createRoad(vectors)
    for k,v in pairs(vectors) do
        self:setQuad(v, "road")
    end
end