math.pi2 = math.pi*2.0
function math.lerp(a,b,blend)
    return (a+(b-a)*blend)
end
function math.clamp(n,low,high) return math.min(math.max(n,low),high) end

function getVectorFromAngle2D(val1)
    return math.cos(val1),math.sin(val1)
end
