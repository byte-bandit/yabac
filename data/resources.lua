ResourceTable = 
{
    {
        id = "wood",
        name = "Wooden logs",
        tooltip = "Tree logs, ready to be sawed.",
        gfx = love.graphics.newImage("assets/gfx/r_wood.png")
    },
    {
        id = "timber",
        name = "Timber",
        tooltip = "Wooden planks, perfect for your everyday building necessities.",
        gfx = love.graphics.newImage("assets/gfx/r_timber.png")
    },
}

function ResourceTable:getResource(id)
    for k,v in pairs(ResourceTable) do
        if v.id == id then return v end
    end
end