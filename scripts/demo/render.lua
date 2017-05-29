render = {}

function render.init()
    render.var = {
        fps = 60,
        time = getTime()
    }

    addEventHandler("onOGLRender",render.stage.fpsUpdate)
    addEventHandler("onOGLRender",render.stage.shadow)
    addEventHandler("onOGLRender",render.stage.main)
    addEventHandler("onOGLRender",render.stage.gui)

    render.info[1] = { title = "FPS: ", data = "" }
    render.info[2] = { title = "Camera position: ", data = "" }
    render.info[3] = { title = "Camera direction: ", data = "" }
    render.info[4] = { title = "Camera up: ", data = "" }
    render.info[5] = { title = "Tick: ", data = "" }
    render.info[6] = { title = "RayCast hit: ", data = "" }
    render.info[7] = { title = "RayCast normal: ", data = "" }
    render.info[8] = { title = "RayCast object: ", data = "" }

    render.fade.init = true
    render.fade.start = 0
    render.fade.lock = true
    addEventHandler("onOGLRender",render.fade.processIn)
end
addEventHandler("onAppStart",render.init)

function render.getFPS()
    return render.var.fps
end

render.stage = {}

function render.stage.fpsUpdate()
    local l_time = getTime()
    render.var.fps = 1.0/(l_time-render.var.time)
    render.var.time = l_time
end

function render.stage.shadow()
    setRenderTarget(target.getShadowTarget())
    clearRenderArea("depth")
    setActiveShader(shader.getShadowShader())
    setActiveScene(scene.getShadowScene())

    modelDraw(model.plane,false,true)
    modelDraw(model.dummy,false,true)
    for _,v in ipairs(model.rigid_body) do
        modelDraw(v,false,true)
    end
end
function render.stage.main()
    setRenderTarget()
    clearRenderArea("depth")
    clearRenderArea("color")
    
    setActiveShader(shader.getSkyboxShader())
    setActiveScene(scene.getMainScene())
    modelDraw(model.skybox,false) -- Skybox has no-depth materials
    
    setActiveShader(shader.getCloudsShader())
    cameraSetDepth(scene.getMainCamera(),1.0,2000.0)
    setActiveScene(scene.getMainScene())
    modelDraw(model.clouds,true) -- Clouds has no-depth materials
    
    setActiveShader(shader.getMainShader())
    cameraSetDepth(scene.getMainCamera(),0.2,300.0)
    setActiveScene(scene.getMainScene())
    local l_camera = scene.getShadowCamera()
    shader.updateMainShadowProjection(cameraGetProjectionMatrix(l_camera))
    shader.updateMainShadowView(cameraGetViewMatrix(l_camera))

    modelDraw(model.plane,true,true)
    modelDraw(model.dummy,true,true)
    for _,v in ipairs(model.rigid_body) do
        modelDraw(v,true,true)
    end
    for _,v in ipairs(model.cycloid) do
        modelDraw(v,true,true)
    end
    
    setActiveShader(shader.getFireShader())
    setActiveScene(scene.getMainScene())
    modelDraw(model.fire,true,true)
end
function render.stage.gui()
    local l_ww,l_wh = window.getSize()
    setActiveShader(shader.getTextureShader())
    drawableDraw(texture.logo,10,16,256,36, 0, 1,1,1,0.75)
    if(control.isConsoleVisible()) then
        drawableDraw(texture.box,0,0,l_ww,16)
    end
    if(control.isCursorLocked()) then
        if(control.isHitDetected()) then
            drawableDraw(texture.crosshair.fill,l_ww/2-12,l_wh/2-12,24,24)
        else
            drawableDraw(texture.crosshair.free,l_ww/2-12,l_wh/2-12,24,24)
        end
    end

    setActiveShader(shader.getFontShader())
    render.info.update()
    render.info.draw(l_wh)

    if(control.isConsoleVisible()) then
        fontDraw(font.console,8.0,4.0,"> "..control.getConsoleText()..((render.var.time%0.5 >= 0.25) and "|" or ""))
    end
end

render.info = {}
function render.info.update()
    render.info[1].data = string.format("%.0f",render.var.fps)
    render.info[2].data = string.format("%.4f,%.4f,%.4f",control.getCameraPosition())
    render.info[3].data = string.format("%.4f,%.4f,%.4f",control.getCameraDirection())
    render.info[4].data = string.format("%.4f,%.4f,%.4f",control.getCameraUp())
    render.info[5].data = string.format("%.4f",render.var.time)
    if(control.isHitDetected()) then
        render.info[6].data = string.format("%.4f,%.4f,%.4f",control.getHitPosition())
        render.info[7].data = string.format("%.4f,%.4f,%.4f",control.getHitNormal())
        local l_hitElement = control.getHitElement()
        render.info[8].data = (type(l_hitElement) == "userdata") and elementGetType(l_hitElement).." -> "..tostring(l_hitElement) or tostring(l_hitElement)
    else
        render.info[6].data = ""
        render.info[7].data = ""
        render.info[8].data = ""
    end
end
function render.info.draw(height)
    -- Two passes, outline is madness
    local l_line = height-15.0
    for k,v in ipairs(render.info) do
        if(string.len(v.data) > 0) then
            fontDraw(font.default,11.0,l_line,v.title..v.data, 0.0,0.0,0.0,1.0)
            l_line = l_line-12.0
        end
    end
    l_line = height-14.0
    for k,v in ipairs(render.info) do
        if(string.len(v.data) > 0) then
            fontDraw(font.default,10.0,l_line,v.title..v.data)
            l_line = l_line-12.0
        end
    end
end

render.fade = {}
function render.fade.processIn()
    if(render.fade.init) then
        render.fade.init = false
        render.fade.start = getTime()
        sound.playBackground()
    end
    local l_dif = getTime()-render.fade.start
    if(l_dif > 3.0) then
        render.fade.lock = false
        removeEventHandler("onOGLRender",render.fade.processIn)
        return
    end
    setActiveShader(shader.texture)
    setRenderTarget()
    local l_ww,l_wh = window.getSize()
    drawableDraw(texture.black,0,0,l_ww,l_wh, 0.0, 1.0,1.0,1.0,1.0-l_dif/3.0)
end

function render.fade.close()
    if(render.fade.lock) then return end
    render.fade.lock = true
    render.fade.start = getTime()
    addEventHandler("onOGLRender",render.fade.processOut)
end

function render.fade.processOut()
    local l_dif = getTime()-render.fade.start
    local l_ww,l_wh = window.getSize()
    setActiveShader(shader.texture)
    setRenderTarget()
    drawableDraw(texture.black,0,0,l_ww,l_wh, 0.0, 1.0,1.0,1.0,l_dif/3.0)
    sound.setGlobalVolume((1.0-l_dif/3.0)*100.0)
    if(l_dif > 3.0) then
        closeWindow()
    end
end
