BuildingTable = 
{
    {
        id = "road",
        name = "Road",
        tooltip = "Roads connect your buildings and production sites to a network. Also great for taking the ole horse for a ride.",
        gfx = love.graphics.newImage("assets/gfx/road.png"),
    },
    {
        id = "house",
        name = "Settler's house",
        tooltip = "Built from crude materials, it offers almost no comfort. But people will be glad for a roof and a place to sleep.",
        gfx = love.graphics.newImage("assets/gfx/house.png"),
        production = ProductionQueue({thalers=1}, nil, 5),
        cost = {timber=3, thalers=10}
    },
    {
        id = "lumberjack",
        name = "Lumberjack hut",
        tooltip = "The lumberjack will take care of a steady supply of wood.",
        gfx = love.graphics.newImage("assets/gfx/lumberjack.png"),
        production = ProductionQueue({wood=1}, nil, 6),
        env_inpact = {canExecute = function(self) return world:removeRandomResourceInRadius(2, self.x, self.y, 3) end},
        cost = {timber=2, thalers=10}
    },
    {
        id = "sawmill",
        name = "Sawmill",
        tooltip = "Will produce timber to build from wood.",
        gfx = love.graphics.newImage("assets/gfx/sawmill.png"),
        production = ProductionQueue({timber=1}, {wood=1}, 3),
        cost = {timber=5, thalers=20}            
    },
    {
        id = "forester",
        name = "Forester",
        tooltip = "A forester will wander out planting new trees.",
        gfx = love.graphics.newImage("assets/gfx/forester.png"),
        production = ProductionQueue(nil, {thalers=1}, 10),
        env_inpact = {canExecute = function(self) return true end, execute = function(self) world:addRandomResourceInRadius(2, self.x, self.y, 6, love.math.random(3,6)) end},
        cost = {timber=10, thalers=30}  
    }
}

for i,v in ipairs(BuildingTable) do
    Class.include(v, Building)
end