BuildingTable = 
{
    {
        id = "house",
        name = "Settler's house",
        tooltip = "Built from crude materials, it offers almost no comfort. But people will be glad for a roof and a place to sleep.",
        gfx = love.graphics.newImage("assets/gfx/house.png"),
    },
    {
        id = "lumberjack",
        name = "Lumberjack hut",
        tooltip = "The lumberjack will take care of a steady supply of wood.",
        gfx = love.graphics.newImage("assets/gfx/lumberjack.png"),
        output =
        {
            {
                id = "wood",
                cooldown = 10,
                qty = 1
            }
        }
    },
    {
        id = "sawmill",
        name = "Sawmill",
        tooltip = "Will produce timber to build from wood.",
        gfx = love.graphics.newImage("assets/gfx/sawmill.png"),
        output =
        {
            {
                id = "timber",
                cooldown = 15,
                qty = 1,
                input =
                {
                    {
                        id = "wood",
                        qty = 1
                    }
                }
            }
        }
    },
}

for i,v in ipairs(BuildingTable) do
    Class.include(v, Building)
end