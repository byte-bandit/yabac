Debug = {}

function Debug:print(...)
    local args = {...}
    printResult = ""
    for i,v in ipairs(args) do
        printResult = printResult .. tostring(v) .. "\n"
    end
    love.graphics.print(printResult, 16, 48)
end