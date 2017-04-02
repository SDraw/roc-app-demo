physics = {}

function physics.init()
    physicsSetFloorEnabled(true)
end
addEvent("onAppStart",physics.init)

function physics.flip()
    physicsSetEnabled(not physicsGetEnabled())
end
function physics.chaos()
    if(not physicsGetEnabled()) then return end
    local vx,vy,vz = 0.0,0.0,0.0
    for _,v in ipairs(model.rigid_body) do
        vx,vy,vz = modelGetCollisionProperty(v,"velocity")
        if(vx ~= false) then
            vx = vx+9.8*math.random2()*2.5
            vy = vy+9.8*math.random2()*2.5
            vz = vz+9.8*math.random2()*2.5
            modelSetCollisionProperty(v,"velocity",vx,vy,vz)
        end
    end
end

function math.random2()
    local l_rand = math.random()
    if(math.random() < 0.5) then l_rand = -1.0*l_rand end
    return l_rand
end
