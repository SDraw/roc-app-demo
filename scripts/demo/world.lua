world = {}

function world.init()

    world.boundary = {}
    world.boundary[1] = collisionCreate("box",16,100,16)
    collisionSetPosition(world.boundary[1],0,100,16+16)
    world.boundary[2] = collisionCreate("box",16,100,16)
    collisionSetPosition(world.boundary[2],0,100,-16-16)
    world.boundary[3] = collisionCreate("box",16,100,16)
    collisionSetPosition(world.boundary[3],16+16,100,0)
    world.boundary[4] = collisionCreate("box",16,100,16)
    collisionSetPosition(world.boundary[4],-16-16,100,0)
    world.boundary[5] = collisionCreate("box",32,16,32)
    collisionSetPosition(world.boundary[5],0,200+16,0)
    
    world.step = math.pi/18.0
    world.cubeStep = world.step/16
    
    addEvent("onOGLPreRender",world.update)
end
addEvent("onAppStart",world.init)

local g_animMap = {
    [1] = "idle", ["idle"] = 1,
    [2] = "walk", ["walk"] = 2
}
function world.update()
    local l_cx,l_cy,l_cz = control.getCameraPosition()
    modelSetPosition(model.skybox,l_cx,l_cy,l_cz)
    modelSetPosition(model.clouds,l_cx,300.0,l_cz)
    local l_fx,_,l_fz = modelGetPosition(model.fire,true)
    modelSetRotation(model.fire,0,math.atan2(l_fx-l_cx,l_fz-l_cz)+math.pi/2.0,0)
    
    l_cx,l_cy,l_cz = player.getPosition()
    cameraSetPosition(scene.getShadowCamera(),l_cx,l_cy,l_cz)
    
    local l_dx,l_dy,l_dz = control.getCameraDirection()
    local l_ux,l_uy,l_uz = control.getCameraUp()
    soundSetListenerOrientation(l_cx,l_cy,l_cz,l_dx,l_dy,l_dz,l_ux,l_uy,l_uz)
    
    model.cycloid.angle = (model.cycloid.angle+world.cubeStep*(60.0/render.getFPS()))%math.pi2
    for k,v in ipairs(model.cycloid) do
        local l_angle = model.cycloid.angle+world.step*k
        modelSetPosition(v,
            10.0*(math.cos(l_angle)+math.cos(7*l_angle)/7),
            10+10.0*(math.sin(l_angle)-math.sin(7*l_angle)/7),
            18.0
        )
        modelSetRotation(v,0,l_angle,math.pi2-l_angle)
    end
    
    --Let's make an imagine water cube area [(-16,0,-16),(16,5,16)]. If object has mass less or equal 1.0, then it will float.
    if(physicsGetEnabled()) then
        local l_time = getTime()
        local l_waveScaleX,_,l_waveScaleZ = modelGetScale(model.water)
        local _,l_gravY,_ = physicsGetGravity()
        l_gravY = -l_gravY/2.0
        local l_fpsDif = 60/render.getFPS()
        for _,v in ipairs(model.rigid_body) do
            local l_mass = modelGetCollisionProperty(v,"mass")
            if(l_mass ~= false) then
                local l_px,l_py,l_pz = modelGetPosition(v)
                if(math.clamp(l_px,-16.0,16.0) == l_px and math.clamp(l_pz,-16.0,16.0) == l_pz) then -- if object in cube area
                    local l_limitY = 5.0+math.sin(l_px/l_waveScaleX+l_time)*math.cos(l_pz/l_waveScaleZ+l_time)*0.25 -- wave margin, formula from water_vert.glsl
                    if(math.clamp(l_py,0.0,l_limitY) == l_py) then
                        local l_vx,l_vy,l_vz = modelGetCollisionProperty(v,"velocity")
                        l_vx = math.lerp(0.0,l_vx,0.99)
                        -- Mass multiplier - y=-x^2+2
                        l_mass = math.clamp(l_mass,0.0,1.5)
                        l_vy = math.lerp((-math.pow(l_mass,2)+2.0)*l_gravY*l_fpsDif,l_vy,0.96)
                        l_vz = math.lerp(0.0,l_vz,0.99)
                        modelSetCollisionProperty(v,"velocity",l_vx,l_vy,l_vz)
                        
                        local l_ax,l_ay,l_az = modelGetCollisionProperty(v,"angular_velocity")
                        l_ax = math.lerp(0.0,l_ax,0.98)
                        l_ay = math.lerp(0.0,l_ay,0.98)
                        l_az = math.lerp(0.0,l_az,0.98)
                        modelSetCollisionProperty(v,"angular_velocity",l_ax,l_ay,l_az)
                    end
                end
            end
        end
    end
end