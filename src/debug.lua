Debug = {}
Debug.values = {}

function Debug:draw()
    --love.graphics.print(table.concat(Debug.values, "\n"), 16, 48)
    Debug.values = {}
end

function Debug:print(...)
    for i,v in ipairs({...}) do
        table.insert(Debug.values, tostring(v))
    end
end