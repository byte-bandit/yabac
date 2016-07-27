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
        production = ProductionQueue({thalers=1}, nil, 2)
    },
    {
        id = "lumberjack",
        name = "Lumberjack hut",
        tooltip = "The lumberjack will take care of a steady supply of wood.",
        gfx = love.graphics.newImage("assets/gfx/lumberjack.png"),
        production = ProductionQueue({wood=1}, nil, 1),
        env_inpact = {canExecute = function(self) return world:removeRandomResourceInRadius(2, self.x, self.y, 3) end}
    },
    {
        id = "sawmill",
        name = "Sawmill",
        tooltip = "Will produce timber to build from wood.",
        gfx = love.graphics.newImage("assets/gfx/sawmill.png"),
        production = ProductionQueue({timber=1}, {wood=1}, 3)                
    },
}

for i,v in ipairs(BuildingTable) do
    Class.include(v, Building)
end