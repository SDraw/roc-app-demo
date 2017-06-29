world = {}

function world.init()

    world.boundary = {}
    world.boundary[1] = Collision("box",0, 16,100,16)
    world.boundary[1]:setPosition(0,100,16+16)
    world.boundary[2] = Collision("box",0, 16,100,16)
    world.boundary[2]:setPosition(0,100,-16-16)
    world.boundary[3] = Collision("box",0, 16,100,16)
    world.boundary[3]:setPosition(16+16,100,0)
    world.boundary[4] = Collision("box",0, 16,100,16)
    world.boundary[4]:setPosition(-16-16,100,0)
    world.boundary[5] = Collision("box",0, 32,16,32)
    world.boundary[5]:setPosition(0,200+16,0)
    
    world.step = math.pi/18.0
    world.cubeStep = world.step/16
    
    addEventHandler("onPreRender",world.update)
end
addEventHandler("onEngineStart",world.init)

function world.update()
    local l_cx,l_cy,l_cz = control.getCameraPosition()
    model.skybox:setPosition(l_cx,l_cy,l_cz)
    model.clouds:setPosition(l_cx,300.0,l_cz)
    local l_fx,_,l_fz = model.fire:getPosition(true)
    model.fire:setRotation(0,math.atan2(l_fx-l_cx,l_fz-l_cz)+math.pi/2.0,0)
    
    l_cx,l_cy,l_cz = player.getPosition()
    scene.getShadowCamera():setPosition(l_cx,l_cy,l_cz)
    
    local l_dx,l_dy,l_dz = control.getCameraDirection()
    local l_ux,l_uy,l_uz = control.getCameraUp()
    soundSetListenerOrientation(l_cx,l_cy,l_cz,l_dx,l_dy,l_dz,l_ux,l_uy,l_uz)
    
    model.cycloid.angle = (model.cycloid.angle+world.cubeStep*(60.0/render.getFPS()))%math.pi2
    for k,v in ipairs(model.cycloid) do
        local l_angle = model.cycloid.angle+world.step*k
        v:setPosition(
            10.0*(math.cos(l_angle)+math.cos(7*l_angle)/7),
            10+10.0*(math.sin(l_angle)-math.sin(7*l_angle)/7),
            18.0
        )
        v:setRotation(0,l_angle,math.pi2-l_angle)
    end
end