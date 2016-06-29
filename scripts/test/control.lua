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
control.cursor = cursorCreate("textures/cursor.png")
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

local g_curPos = { x = false, y = false }
function control.mouseMovement(xpos,ypos)
    if(g_curPos.x == false or g_curPos.y == false) then
        g_curPos.x,g_curPos.y = xpos,ypos
        return
    end
    if(control.locked) then
        control.camera.angle[1] = math.fmod(control.camera.angle[1]+(xpos-g_curPos.x)/(math.pi*128.0),math.pi*2.0)
        control.camera.angle[2] = control.camera.angle[2]-(ypos-g_curPos.y)/(math.pi*128.0)
        if(control.camera.angle[2] > math.pi/2.0-0.005) then
            control.camera.angle[2] = math.pi/2.0-0.005
        elseif(control.camera.angle[2] < -math.pi/2.0+0.005) then
            control.camera.angle[2] = -math.pi/2.0+0.005
        end
        local f_cosf = math.cos(control.camera.angle[2])
        control.camera.direction.x,control.camera.direction.y,control.camera.direction.z = f_cosf*math.cos(control.camera.angle[1]),math.sin(control.camera.angle[2]),f_cosf*math.sin(control.camera.angle[1])
        cameraSetDirection(data.scene["main"].camera,control.camera.direction.x,control.camera.direction.y,control.camera.direction.z)
        
        f_cosf = math.cos(control.camera.angle[2]+math.pi/2.0)
        control.camera.up.x,control.camera.up.y,control.camera.up.z = f_cosf*math.cos(control.camera.angle[1]),math.sin(control.camera.angle[2]+math.pi/2.0),f_cosf*math.sin(control.camera.angle[1])
    end
    
    g_curPos.x,g_curPos.y = xpos,ypos
end
addEvent("onCursorMove",control.mouseMovement)

function control.windowResize(width,height)
    cameraSetPerspective(data.scene["main"].camera,math.pi/4,width,height,0.2,300.0)
    control.window[1],control.window[2] = width,height
end
addEvent("onWindowResize",control.windowResize)

function control.keyPressing(key,scan,action,mod)
    if(control.console.visible == true) then return end
    if(action ~= 2) then
        if(key == 87) then --W
            control.forward = (action == 1)
            return
        elseif(key == 83) then --S
            control.backward = (action == 1)
            return
        elseif(key == 68) then --D
            control.right = (action == 1)
            return
        elseif(key == 65) then --A
            control.left = (action == 1)
            return
        end
        if(action == 1) then
            if(key == 73) then -- I
                modelResetAnimation(data.model.miku)
                return
            elseif(key == 80) then -- P
                modelPlayAnimation(data.model.miku)
                return
            elseif(key == 79) then -- O
                modelPauseAnimation(data.model.miku)
                return
            end
            if(key == 90) then --Z
                control.samples = control.samples-1.0
                if(control.samples < 0.0) then
                    control.samples = 0.0
                end
                shaderSetUniformValue(data.shader["default"].element,data.shader["default"].shadowSamplesUniform,"float",control.samples)
                return
            elseif(key == 88) then--X
                control.samples = control.samples+1.0
                if(control.samples > 4.0) then
                    control.samples = 4.0
                end
                shaderSetUniformValue(data.shader["default"].element,data.shader["default"].shadowSamplesUniform,"float",control.samples)
                return
            end
            if(key == 342) then
                control.locked = not control.locked
                if(control.locked) then
                    setCursorMode("disabled")
                else
                    setCursorMode("normal")
                end
                g_curPos.x,g_curPos.y = getCursorPosition()
                return
            end
            if(key == 67) then --C
                soundPlay(data.sound["background"])
                return
            elseif(key == 86) then --V
                soundPause(data.sound["background"])
                return
            elseif(key == 66) then
                soundStop(data.sound["background"])
                return
            end
            if(key == 78) then --N
                control.physics = not control.physics
                physicsSetEnabled(control.physics)
                return
            end
            if(key == 81) then --Q
                local vx,vy,vz = 0.0,0.0,0.0
                for _,v in ipairs(data.model["rigid_body"]) do
                    vx,vy,vz = modelGetVelocity(v)
                    if(vx ~= false) then
                        vy = vy+9.8
                        modelSetVelocity(v,vx,vy,vz)
                    end
                end
                return
            end
            if(key == 340) then
                control.distance = 0.5
                return
            end
            if(key == 256) then
                closeApplication()
                return
            end
            if(key == 96) then
                control.console.visible = true
                addEvent("onKeyPress",control.consoleInputKey)
                addEvent("onTextInput",control.consoleInputText)
                return 
            end
        end
    end
    if(action == 0) then
        if(key == 340) then
            control.distance = 0.05
        end
    end
end
addEvent("onKeyPress",control.keyPressing)

function control.fire(key,action,mod)
    if(control.locked == true) then
        if(key == 0 and action > 0) then
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
        if(key == 1 and action > 0) then
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
function control.consoleInputKey(key,scan,action,mod)
    if(action == 1) then
        if(key == 256) then
            control.console.visible = false
            control.console.bug = true
            removeEvent("onKeyPress",control.consoleInputKey)
            removeEvent("onTextInput",control.consoleInputText)
            control.console.text = ""
            return
        end
        if(key == 257) then
            if(control.console.text:len() == 0) then return end
            load(control.console.text)()
            control.console.previous = control.console.text
            control.console.text = ""
            return
        end
        if(key == 265) then
            control.console.text = control.console.previous
            return
        end
    end
    if(action == 1 or action == 2) then
        if(key == 259) then
            local l_textLen = utf8.len(control.console.text)
            if(l_textLen > 0) then
                control.console.text = utf8.sub(control.console.text,0,l_textLen-1)
            end
            return
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
        cameraSetPosition(data.scene["main"].camera,control.camera.position.x,control.camera.position.y,control.camera.position.z)
    elseif(control.backward == true) then
        control.camera.position.x = control.camera.position.x-control.distance*l_dif*control.camera.direction.x
        control.camera.position.y = control.camera.position.y-control.distance*l_dif*control.camera.direction.y
        control.camera.position.z = control.camera.position.z-control.distance*l_dif*control.camera.direction.z
        cameraSetPosition(data.scene["main"].camera,control.camera.position.x,control.camera.position.y,control.camera.position.z)
    end
    if(control.right == true) then
        local disp = {
            x = math.cos(control.camera.angle[1]+math.pi/2.0),
            z = math.sin(control.camera.angle[1]+math.pi/2.0)
        }
        control.camera.position.x = control.camera.position.x+control.distance*l_dif*disp.x
        control.camera.position.z = control.camera.position.z+control.distance*l_dif*disp.z
        cameraSetPosition(data.scene["main"].camera,control.camera.position.x,control.camera.position.y,control.camera.position.z)
    elseif(control.left == true) then
        local disp = {
            x = math.cos(control.camera.angle[1]-math.pi/2.0),
            z = math.sin(control.camera.angle[1]-math.pi/2.0)
        }
        control.camera.position.x = control.camera.position.x+control.distance*l_dif*disp.x
        control.camera.position.z = control.camera.position.z+control.distance*l_dif*disp.z
        cameraSetPosition(data.scene["main"].camera,control.camera.position.x,control.camera.position.y,control.camera.position.z)
    end    
end
addEvent("onOGLPreRender",control.cameraUpdate)

function control.updateTime()
    control.tick = getTime()
end

function control.joystick(jnum,jname,jbuttons,jaxes)
    if(jnum == 0) then
        local l_x,l_y,l_z = 0.0,0.0,0.0
        if(not(jaxes[1] < 0.0 and jaxes[1] > -0.001)) then
            l_x = jaxes[1]
        end
        if(not(jaxes[2] < 0.0 and jaxes[2] > -0.001)) then
            l_z = jaxes[2]
        end
        if(not(jaxes[3] < 0.0 and jaxes[3] > -0.001)) then
            l_y = -jaxes[3]
        end
        if(not(l_x == 0.0 and l_y == 0.0 and l_z == 0.0)) then
            local l_own_x,l_own_y,l_own_z = modelGetVelocity(data.model["rigid_body"][#data.model["rigid_body"]])
            l_x = l_x+l_own_x
            l_y = l_y+l_own_y
            l_z = l_z+l_own_z
            modelSetVelocity(data.model["rigid_body"][#data.model["rigid_body"]],l_x,l_y,l_z)
        end
    end
end
addEvent("onJoypadEvent",control.joystick)

setCursor(control.cursor)
setCursorMode("disabled")