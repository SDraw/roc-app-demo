model = {}

function model.init()

    model.skybox = modelCreate(geometry.skybox)
    modelSetRotation(model.skybox,0.0,math.pi*1.25,0.0)
    
    model.clouds = modelCreate(geometry.clouds)
    modelSetPosition(model.clouds,0.0,300.0,0.0)
    modelSetScale(model.clouds,10.0,1.0,10.0)
    
    model.plane = modelCreate(geometry.plane)
    
    model.rigid_body = {}
    for i=1,25 do
        model.rigid_body[i] = modelCreate(geometry.cone)
        modelSetPosition(model.rigid_body[i],4.0,1.0+2.0*(i-1),4.0)
        modelSetCollision(model.rigid_body[i],"cone",1.0, 1.0,1.0)
        modelSetCollisionProperty(model.rigid_body[i],"friction",1.0)
    end
    for i=26,50 do
        local l_disp = math.pow(-1,i%2)
        model.rigid_body[i] = modelCreate(geometry.cylinder)
        modelSetPosition(model.rigid_body[i],4.0+0.25*l_disp,1.0+2.0*(i-26),-4.0+0.25*l_disp)
        modelSetCollision(model.rigid_body[i],"cylinder",1.0, 1.0,0.5,1.0)
        modelSetCollisionProperty(model.rigid_body[i],"friction",1.0)
    end
    for i=51,100 do
        model.rigid_body[i] = modelCreate(geometry.cube)
        modelSetPosition(model.rigid_body[i],-4.0+0.5*math.pow(-1,i%2),1.0+2.0*(i-51),4.0)
        modelSetRotation(model.rigid_body[i],0,math.pi*((i-50)/50),0)
        modelSetCollision(model.rigid_body[i],"box",10.0, 1.0,1.0,1.0)
        modelSetCollisionProperty(model.rigid_body[i],"friction",1.0)
    end
    for i=101,150 do
        local l_disp = math.pow(-1,i%2)
        model.rigid_body[i] = modelCreate(geometry.sphere)
        modelSetPosition(model.rigid_body[i],-4.0+0.25*l_disp,1.0+2.0*(i-101),-4.0+0.25*l_disp)
        modelSetCollision(model.rigid_body[i],"sphere",0.25, 1.0)
        modelSetCollisionProperty(model.rigid_body[i],"friction",1.0)
    end
    
    for i=#model.rigid_body+1,#model.rigid_body+1 do
        model.rigid_body[i] = modelCreate(geometry.cube)
        modelSetPosition(model.rigid_body[i],-8.0,10.0,-8.0)
        modelSetCollision(model.rigid_body[i],"box",10.0, 1.0,1.0,1.0)
    end
    
    model.cycloid = {
        angle = 0
    }
    for i=1,36 do
        model.cycloid[i] = modelCreate(geometry.cube)
    end
    
    model.dummy = modelCreate(geometry.dummy)
    
    model.water = modelCreate(geometry.water)
    modelSetPosition(model.water,0.0,5.0,0.0)
    modelSetScale(model.water,2.0,1.0,2.0)
    
    model.fire = modelCreate(geometry.fire)
end
addEvent("onAppStart",model.init)