data.fps = 0

rendering = {}
rendering.stage = {}

function rendering.stage.shadow()
    setRenderTarget(data.target.shadow)
    oglClear("depth")
    
    setActiveShader(data.shader.shadow)
    setActiveScene(data.scene.shadow.scene)
    
    modelDraw(data.model.plane,false,true,23)
    modelDraw(data.model.miku,false,true,10)
    modelDraw(data.model.rope,false,true,5)
    for _,v in ipairs(data.model.rigid_body) do
        modelDraw(v,false,true,2)
    end
end
function rendering.stage.main()
    setRenderTarget()
    oglClear("depth")
    oglClear("color")
    
    setActiveShader(data.shader.default.element)
    setActiveScene(data.scene.main.scene)
    
    modelDraw(data.model.skybox)
    oglClear("depth")
    
    modelDraw(data.model.plane,true,true,23)
    modelDraw(data.model.miku,true,true,10)
    for _,v in ipairs(data.model.rigid_body) do
        modelDraw(v,true,true,2)
    end
end
function rendering.stage.gui()
    
    local l_bgmTime = soundGetTime(data.sound.background)
    local l_bgmState = soundGetState(data.sound.background)
    
    setRenderTarget()
    oglClear("depth")
    setActiveShader(data.shader.texture)
    
    textureDraw(data.texture.logo,10,16,256,36, 0, 1,1,1,0.75)
    if(control.console.visible == true) then
        textureDraw(data.texture.box,0,0,control.window[1],16)
    end
    if(control.locked == true) then
        if(control.hit.endX ~= false) then
            textureDraw(data.texture.crosshair.fill,control.window[1]/2-12,control.window[2]/2-12,24,24)
        else
            textureDraw(data.texture.crosshair.free,control.window[1]/2-12,control.window[2]/2-12,24,24)
        end
    end
    
    setActiveShader(data.shader.text)
    local l_text = string.format("FPS: %.0f",data.fps)
    fontDraw(data.font.default,18.0,control.window[2]-38.0,l_text, 0,0,0,1)
    l_text = string.format("Shadow samples: %.0f",control.samples)
    fontDraw(data.font.default,18.0,control.window[2]-58.0,l_text, 0,0,0,1)
    l_text = string.format("Camera position: %.4f,%.4f,%.4f",control.camera.position.x,control.camera.position.y,control.camera.position.z)
    fontDraw(data.font.default,18.0,control.window[2]-78.0,l_text, 0,0,0,1)
    l_text = string.format("Camera direction: %.4f,%.4f,%.4f",control.camera.direction.x,control.camera.direction.y,control.camera.direction.z)
    fontDraw(data.font.default,18.0,control.window[2]-98.0,l_text, 0,0,0,1)
    l_text = string.format("Camera up: %.4f,%.4f,%.4f",control.camera.up.x,control.camera.up.y,control.camera.up.z)
    fontDraw(data.font.default,18.0,control.window[2]-118.0,l_text, 0,0,0,1)
    l_text = string.format("Tick: %.4f",control.tick)
    fontDraw(data.font.default,18.0,control.window[2]-138.0,l_text, 0,0,0,1)
    l_text = string.format("BGM time: %.4f",l_bgmTime)
    fontDraw(data.font.default,18.0,control.window[2]-158.0,l_text, 0,0,0,1)
    l_text = string.format("BGM state: %s",l_bgmState)
    fontDraw(data.font.default,18.0,control.window[2]-178.0,l_text, 0,0,0,1)
    if(control.hit.endX ~= false) then
        l_text = string.format("RayCast end: %.4f,%.4f,%.4f",control.hit.endX,control.hit.endY,control.hit.endZ)
        fontDraw(data.font.default,18.0,control.window[2]-198.0,l_text, 0,0,0,1)
        l_text = string.format("RayCast normal: %.4f,%.4f,%.4f",control.hit.normalX,control.hit.normalY,control.hit.normalZ)
        fontDraw(data.font.default,18.0,control.window[2]-218.0,l_text, 0,0,0,1)
        if(type(control.hit.model) == "userdata") then
            l_text = "RayCast object: "..getElementType(control.hit.model).." -> "..tostring(control.hit.model)
        elseif(type(control.hit.model) == "string") then
            l_text = "RayCast object: "..control.hit.model
        end
        fontDraw(data.font.default,18.0,control.window[2]-238.0,l_text, 0,0,0,1)
    else
        fontDraw(data.font.default,18.0,control.window[2]-198.0,"RayCast end: No hit", 0,0,0,1)
    end
    
    l_text = string.format("FPS: %.0f",data.fps)
    fontDraw(data.font.default,17.0,control.window[2]-37.0,l_text)
    l_text = string.format("Shadow samples: %.0f",control.samples)
    fontDraw(data.font.default,17.0,control.window[2]-57.0,l_text)
    l_text = string.format("Camera position: %.4f,%.4f,%.4f",control.camera.position.x,control.camera.position.y,control.camera.position.z)
    fontDraw(data.font.default,17.0,control.window[2]-77.0,l_text)
    l_text = string.format("Camera direction: %.4f,%.4f,%.4f",control.camera.direction.x,control.camera.direction.y,control.camera.direction.z)
    fontDraw(data.font.default,17.0,control.window[2]-97.0,l_text)
    l_text = string.format("Camera up: %.4f,%.4f,%.4f",control.camera.up.x,control.camera.up.y,control.camera.up.z)
    fontDraw(data.font.default,17.0,control.window[2]-117.0,l_text)
    l_text = string.format("Tick: %.4f",control.tick)
    fontDraw(data.font.default,17.0,control.window[2]-137.0,l_text)
    l_text = string.format("BGM time: %.4f",l_bgmTime)
    fontDraw(data.font.default,17.0,control.window[2]-157.0,l_text)
    l_text = string.format("BGM state: %s",l_bgmState)
    fontDraw(data.font.default,17.0,control.window[2]-177.0,l_text)
    if(control.hit.endX ~= false) then
        l_text = string.format("RayCast end: %.4f,%.4f,%.4f",control.hit.endX,control.hit.endY,control.hit.endZ)
        fontDraw(data.font.default,17.0,control.window[2]-197.0,l_text)
        l_text = string.format("RayCast normal: %.4f,%.4f,%.4f",control.hit.normalX,control.hit.normalY,control.hit.normalZ)
        fontDraw(data.font.default,17.0,control.window[2]-217.0,l_text)
        if(type(control.hit.model) == "userdata") then
            l_text = "RayCast object: "..getElementType(control.hit.model).." -> "..tostring(control.hit.model)
        elseif(type(control.hit.model) == "string") then
            l_text = "RayCast object: "..control.hit.model
        end
        fontDraw(data.font.default,17.0,control.window[2]-237.0,l_text)
    else
        fontDraw(data.font.default,17.0,control.window[2]-197.0,"RayCast end: No hit")
    end
    if(control.console.visible == true) then
        fontDraw(data.font.console,8.0,4.0,"> "..control.console.text.."_")
    end
end
addEvent("onOGLRender",rendering.stage.shadow)
addEvent("onOGLRender",rendering.stage.main)
addEvent("onOGLRender",rendering.stage.gui)