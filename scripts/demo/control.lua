control = {}
control.camera = {}
control.camera.position = { x =0.0, y = 5.0, z = 20.0 }
control.camera.angle = { -math.pi/2.0, 0.0 }
control.camera.direction = { x = 0.0, y = 0.0, z = -1.0 }
control.camera.up = { x = 0.0, y = 1.0, z = 0.0 }
control.camera.tick = getTime()
control.forward = false
control.backward = false
control.left = false
control.right = false
control.window = { getWindowSize() }
control.tick = getTime()
control.samples = 2.0
control.locked = true
control.physics = false
control.distance = 0.1
control.console = {}
control.console.text = ""
control.console.previous = ""
control.console.visible = false
control.console.bug = true
control.hit = {}
control.grab = {}
control.grab.state = false
control.grab.model = false
control.grab.distance = 0.0

function control.mouseMovement(xpos,ypos)
    if(control.locked) then
        local l_difx,l_dify = xpos-math.floor(control.window[1]/2),ypos-math.floor(control.window[2]/2)
        control.camera.angle[1] = math.fmod(control.camera.angle[1]+l_difx/(math.pi*128.0),math.pi*2.0)
        control.camera.angle[2] = control.camera.angle[2]-l_dify/(math.pi*128.0)
        if(control.camera.angle[2] > math.pi/2.0-0.005) then
            control.camera.angle[2] = math.pi/2.0-0.005
        elseif(control.camera.angle[2] < -math.pi/2.0+0.005) then
            control.camera.angle[2] = -math.pi/2.0+0.005
        end
        local f_cosf = math.cos(control.camera.angle[2])
        control.camera.direction.x,control.camera.direction.y,control.camera.direction.z = f_cosf*math.cos(control.camera.angle[1]),math.sin(control.camera.angle[2]),f_cosf*math.sin(control.camera.angle[1])
        cameraSetDirection(data.scene.main.camera,control.camera.direction.x,control.camera.direction.y,control.camera.direction.z)
        
        f_cosf = math.cos(control.camera.angle[2]+math.pi/2.0)
        control.camera.up.x,control.camera.up.y,control.camera.up.z = f_cosf*math.cos(control.camera.angle[1]),math.sin(control.camera.angle[2]+math.pi/2.0),f_cosf*math.sin(control.camera.angle[1])
        
        setCursorPosition(math.floor(control.window[1]/2),math.floor(control.window[2]/2))
    end
end
addEvent("onCursorMove",control.mouseMovement)

function control.windowResize(width,height)
    cameraSetAspectRatio(data.scene.main.camera,width/height)
    control.window[1],control.window[2] = width,height
end
addEvent("onWindowResize",control.windowResize)

function control.keyPressing(key,action)
    if(control.console.visible == true) then return end
    if(key == 22) then --W
        control.forward = (action == 1)
    elseif(key == 18) then --S
        control.backward = (action == 1)
    elseif(key == 3) then --D
        control.right = (action == 1)
    elseif(key == 0) then --A
        control.left = (action == 1)
    end
    if(action == 1) then
        if(key == 8) then -- I
            modelResetAnimation(data.model.miku)
        elseif(key == 15) then -- P
            modelPlayAnimation(data.model.miku)
        elseif(key == 14) then -- O
            modelPauseAnimation(data.model.miku)
        ----
        elseif(key == 25) then --Z
            control.samples = control.samples-1.0
            if(control.samples < 0.0) then
                control.samples = 0.0
            end
            shaderSetUniformValue(data.shader.default.element,data.shader.default.shadowSamplesUniform,"float",control.samples)
        elseif(key == 23) then --X
            control.samples = control.samples+1.0
            if(control.samples > 4.0) then
                control.samples = 4.0
            end
            shaderSetUniformValue(data.shader.default.element,data.shader.default.shadowSamplesUniform,"float",control.samples)
        ----
        elseif(key == 39) then -- Left Alt
            control.locked = not control.locked
            if(control.locked) then
                setCursorMode("hl")
            else
                setCursorMode("vu")
            end
        ----
        elseif(key == 2) then --C
            soundPlay(data.sound.background)
        elseif(key == 21) then --V
            soundPause(data.sound.background)
        elseif(key == 1) then --B
            soundStop(data.sound.background)
        ----
        elseif(key == 13) then --N
            control.physics = not control.physics
            physicsSetEnabled(control.physics)
        ----
        elseif(key == 16) then --Q
            local vx,vy,vz = 0.0,0.0,0.0
            for _,v in ipairs(data.model.rigid_body) do
                vx,vy,vz = modelGetVelocity(v)
                if(vx ~= false) then
                    vy = vy+9.8
                    modelSetVelocity(v,vx,vy,vz)
                end
            end
        ----
        elseif(key == 38) then -- Left Shift
            control.distance = 0.5
        ----
        elseif(key == 36) then
            closeApplication()
        ----
        elseif(key == 54) then
            control.console.visible = true
            addEvent("onKeyPress",control.consoleInputKey)
            addEvent("onTextInput",control.consoleInputText) 
        end
    elseif(action == 0) then
        if(key == 38) then
            control.distance = 0.05
        end
    end
end
addEvent("onKeyPress",control.keyPressing)

function control.fire(key,action,mod)
    if(control.locked == true) then
        if(key == 0 and action == 1) then
            if(control.hit.endX and type(control.hit.model) == "userdata") then
                if(getElementType(control.hit.model) == "model") then
                    modelSetVelocity(control.hit.model,control.camera.direction.x*20.0,control.camera.direction.y*20.0,control.camera.direction.z*20.0)
                end
            end
        end
    end
end
addEvent("onMouseKeyPress",control.fire)

function control.grab.func(key,action,mod)
    if(control.locked == true) then
        if(key == 1 and action == 1) then
            if(control.grab.state == false and type(control.hit.model) == "userdata" and getElementType(control.hit.model) == "model") then
                control.grab.state = true
                control.grab.model = control.hit.model
                local l_px,l_py,l_pz = modelGetPosition(control.grab.model,true)
                l_px,l_py,l_pz = l_px-control.camera.position.x,l_py-control.camera.position.y,l_pz-control.camera.position.z
                control.grab.distance = math.sqrt(l_px*l_px+l_py*l_py+l_pz*l_pz)
            else
                control.grab.state = false
                control.grab.model = false
                control.grab.distance = 0.0
            end
        end
    end
end
addEvent("onMouseKeyPress",control.grab.func)

function control.consoleInputText(str1)
    if(control.console.bug == true) then
        control.console.bug = false
        return
    end
    control.console.text = control.console.text..str1
end
function control.consoleInputKey(key,action)
    if(action == 1) then
        if(key == 36) then -- Escape
            control.console.visible = false
            control.console.bug = true
            removeEvent("onKeyPress",control.consoleInputKey)
            removeEvent("onTextInput",control.consoleInputText)
            control.console.text = ""
        elseif(key == 58) then -- Return
            if(control.console.text:len() == 0) then return end
            load(control.console.text)()
            control.console.previous = control.console.text
            control.console.text = ""
        elseif(key == 73) then -- Arrow up
            control.console.text = control.console.previous
        elseif(key == 59) then
            local l_textLen = utf8.len(control.console.text)
            if(l_textLen > 0) then
                control.console.text = utf8.sub(control.console.text,0,l_textLen-1)
            end
        end
    end
end

function control.cameraUpdate()
    local l_gTick = getTime()
    local l_dif = 60.0*(l_gTick-control.camera.tick)
    control.camera.tick = l_gTick
    if(control.forward == true) then
        control.camera.position.x = control.camera.position.x+control.distance*l_dif*control.camera.direction.x
        control.camera.position.y = control.camera.position.y+control.distance*l_dif*control.camera.direction.y
        control.camera.position.z = control.camera.position.z+control.distance*l_dif*control.camera.direction.z
        cameraSetPosition(data.scene.main.camera,control.camera.position.x,control.camera.position.y,control.camera.position.z)
    elseif(control.backward == true) then
        control.camera.position.x = control.camera.position.x-control.distance*l_dif*control.camera.direction.x
        control.camera.position.y = control.camera.position.y-control.distance*l_dif*control.camera.direction.y
        control.camera.position.z = control.camera.position.z-control.distance*l_dif*control.camera.direction.z
        cameraSetPosition(data.scene.main.camera,control.camera.position.x,control.camera.position.y,control.camera.position.z)
    end
    if(control.right == true) then
        local disp = {
            x = math.cos(control.camera.angle[1]+math.pi/2.0),
            z = math.sin(control.camera.angle[1]+math.pi/2.0)
        }
        control.camera.position.x = control.camera.position.x+control.distance*l_dif*disp.x
        control.camera.position.z = control.camera.position.z+control.distance*l_dif*disp.z
        cameraSetPosition(data.scene.main.camera,control.camera.position.x,control.camera.position.y,control.camera.position.z)
    elseif(control.left == true) then
        local disp = {
            x = math.cos(control.camera.angle[1]-math.pi/2.0),
            z = math.sin(control.camera.angle[1]-math.pi/2.0)
        }
        control.camera.position.x = control.camera.position.x+control.distance*l_dif*disp.x
        control.camera.position.z = control.camera.position.z+control.distance*l_dif*disp.z
        cameraSetPosition(data.scene.main.camera,control.camera.position.x,control.camera.position.y,control.camera.position.z)
    end    
end
addEvent("onOGLPreRender",control.cameraUpdate)

function control.updateTime()
    control.tick = getTime()
end

control.joypad = {}

function control.joypad.connect(jid,state)
    if(state == 1) then
        addEvent("onJoypadButton",control.joypad.button)
        addEvent("onJoypadAxis",control.joypad.axis)
        print("Joypad connected",jid,state)
    else
        removeEvent("onJoypadButton",control.joypad.button)
        removeEvent("onJoypadAxis",control.joypad.axis)
        print("Joypad disconnected",jid,state)
    end
end
addEvent("onJoypadConnect",control.joypad.connect)

function control.joypad.button(jid,jbutton,jstate)
    print("onJoypadButton",jid,jbutton,jstate)
    if(jid == 0 and jbutton == 0 and jstate == 1) then
        local l_x,l_y,l_z = modelGetVelocity(data.model.rigid_body[#data.model.rigid_body])
        l_y = l_y+9.8
        modelSetVelocity(data.model.rigid_body[#data.model.rigid_body],l_x,l_y,l_z)
    end
end
function control.joypad.axis(jid,jaxis,jvalue)
    print("onJoypadAxis",jid,jaxis,jvalue)
end

setCursorMode("hl")