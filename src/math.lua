function math:clamp(min, val, max)
    if val > max then
        return max
    elseif val < min then
        return min
    else
        return val
    end
end

function math:max(a, b)
    if a > b then return a else return b end
end

function math:min(a, b)
    if a > b then return b else return a end
end

function math:round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end