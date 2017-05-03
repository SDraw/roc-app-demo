world = {}

function world.init()

    world.boundary = {}
    world.boundary[1] = collisionCreate("box",0, 16,100,16)
    collisionSetPosition(world.boundary[1],0,100,16+16)
    world.boundary[2] = collisionCreate("box",0, 16,100,16)
    collisionSetPosition(world.boundary[2],0,100,-16-16)
    world.boundary[3] = collisionCreate("box",0, 16,100,16)
    collisionSetPosition(world.boundary[3],16+16,100,0)
    world.boundary[4] = collisionCreate("box",0, 16,100,16)
    collisionSetPosition(world.boundary[4],-16-16,100,0)
    world.boundary[5] = collisionCreate("box",0, 32,16,32)
    collisionSetPosition(world.boundary[5],0,200+16,0)
    
    world.step = math.pi/18.0
    world.cubeStep = world.step/16
    
    addEventHandler("onOGLPreRender",world.update)
end
addEventHandler("onAppStart",world.init)

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
end