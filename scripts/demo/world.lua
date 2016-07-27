world = {}

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

function world.update()
    data.fps = (data.fps+1.0/(getTime()-control.tick))/2
    control.updateTime()
    ----
    modelSetPosition(data.model.skybox,control.camera.position.x,control.camera.position.y,control.camera.position.z)
    
    local l_cosTick = math.cos(control.tick)
    local l_rot = math.fmod(control.tick,math.pi*2.0)
    modelSetPosition(data.model.cube,-4.0,2.0,-3.0*l_cosTick)
    modelSetRotation(data.model.cube,0.0,l_rot,0.0)
    
    soundSetSpeed(data.sound.background,2.0*math.abs(l_cosTick))
    
    soundSetListenerOrientation(
        control.camera.position.x,control.camera.position.y,control.camera.position.z,
        control.camera.direction.x,control.camera.direction.y,control.camera.direction.z,
        control.camera.up.x,control.camera.up.y,control.camera.up.z
    )
    
    control.hit.endX,control.hit.endY,control.hit.endZ,
    control.hit.normalX,control.hit.normalY,control.hit.normalZ,control.hit.model = physicsRayCast(
        control.camera.position.x,control.camera.position.y,control.camera.position.z,
        control.camera.position.x+control.camera.direction.x*20.0,control.camera.position.y+control.camera.direction.y*20.0,control.camera.position.z+control.camera.direction.z*20.0
    )
    
    if(control.grab.model ~= false) then
        modelSetPosition(control.grab.model,
            control.camera.position.x+control.camera.direction.x*control.grab.distance,
            control.camera.position.y+control.camera.direction.y*control.grab.distance,
            control.camera.position.z+control.camera.direction.z*control.grab.distance
        )
        modelSetVelocity(control.grab.model,0.0,0.0,0.0)
    end
end
addEvent("onOGLPreRender",world.update)

physicsSetFloorEnabled(true)