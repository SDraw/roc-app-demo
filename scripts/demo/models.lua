model = {}

function model.init()

    model.skybox = Model(geometry.skybox)
    
    model.clouds = Model(geometry.clouds)
    model.clouds:setPosition(0.0,300.0,0.0)
    model.clouds:setScale(10.0,1.0,10.0)
    
    model.plane = Model(geometry.plane)
    
    model.rigid_body = {}
    for i=1,25 do
        model.rigid_body[i] = Model(geometry.cone)
        model.rigid_body[i]:setPosition(4.0,1.0+2.0*(i-1),4.0)
        local l_col = Collision("cone",1.0, 1.0,1.0)
        l_col:attach(model.rigid_body[i])
    end
    for i=26,50 do
        local l_disp = math.pow(-1,i%2)
        model.rigid_body[i] = Model(geometry.cylinder)
        model.rigid_body[i]:setPosition(4.0+0.25*l_disp,1.0+2.0*(i-26),-4.0+0.25*l_disp)
        local l_col = Collision("cylinder",1.0, 1.0,0.5,1.0)
        l_col:attach(model.rigid_body[i])
    end
    for i=51,100 do
        model.rigid_body[i] = Model(geometry.cube)
        model.rigid_body[i]:setPosition(-4.0+0.5*math.pow(-1,i%2),1.0+2.0*(i-51),4.0)
        model.rigid_body[i]:setRotation(0,math.pi*((i-50)/50),0)
        local l_col = Collision("box",10.0, 1.0,1.0,1.0)
        l_col:attach(model.rigid_body[i])
    end
    for i=101,150 do
        local l_disp = math.pow(-1,i%2)
        model.rigid_body[i] = Model(geometry.sphere)
        model.rigid_body[i]:setPosition(-4.0+0.25*l_disp,1.0+2.0*(i-101),-4.0+0.25*l_disp)
        local l_col = Collision("sphere",0.25, 1.0)
        l_col:attach(model.rigid_body[i])
    end
    
    for i=#model.rigid_body+1,#model.rigid_body+1 do
        model.rigid_body[i] = Model(geometry.cube)
        model.rigid_body[i]:setPosition(-8.0,10.0,-8.0)
        local l_col = Collision("box",10.0, 1.0,1.0,1.0)
        l_col:attach(model.rigid_body[i])
    end
    
    model.cycloid = {
        angle = 0
    }
    for i=1,36 do
        model.cycloid[i] = Model(geometry.cube)
    end
    
    model.dummy = Model(geometry.dummy)
    
    model.fire = Model(geometry.fire)
end
addEventHandler("onEngineStart",model.init)