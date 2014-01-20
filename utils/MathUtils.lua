local MathUtils = {}

local sin, cos, atan2, pi = math.sin, math.cos, math.atan2, math.pi
local min, max, floor = math.min, math.max, math.floor

function MathUtils.round(n, dec)
    dec = 10 ^ (dec or 0)
    return floor(n * dec + .5) / dec
end

function MathUtils.clamp(low, n, high)
    return min(max(low, n), high)
end

function MathUtils.dist(x1, y1, x2, y2)
    local x, y = x2 - x1, y2 - y1
    return (x * x + y * y) ^ .5
end

function MathUtils.angle(x1, y1, x2, y2)
    return atan2(y2 - y1, x2 - x1)
end

function MathUtils.normalize(x, y)
    local mag = MathUtils.length(x, y)
    if mag == 0 then return 0, 0 end
    return x / mag, y / mag
end

function MathUtils.length(x, y)
    return (x * x + y * y) ^ .5
end

return MathUtils
