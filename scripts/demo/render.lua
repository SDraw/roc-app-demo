render = {}

function render.init()
    render.var = {
        fps = 60,
        time = getTime()
    }

    addEventHandler("onRender",render.stage.fpsUpdate)
    addEventHandler("onRender",render.stage.shadow)
    addEventHandler("onRender",render.stage.main)
    addEventHandler("onRender",render.stage.gui)

    render.info[1] = { title = "FPS", data = "" }
    render.info[2] = { title = "Camera position", data = "" }
    render.info[3] = { title = "Camera direction", data = "" }
    render.info[4] = { title = "Camera up", data = "" }
    render.info[5] = { title = "Tick", data = "" }
    render.info[6] = { title = "RayCast hit", data = "" }
    render.info[7] = { title = "RayCast normal", data = "" }
    render.info[8] = { title = "RayCast object", data = "" }

    render.fade.init = true
    render.fade.start = 0
    render.fade.lock = true
    addEventHandler("onRender",render.fade.processIn)
end
addEventHandler("onEngineStart",render.init)

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
    clearRenderArea(true,false)
    setActiveShader(shader.getShadowShader())
    setActiveScene(scene.getShadowScene())

    model.plane:draw(false)
    model.dummy:draw(false)
    for _,v in ipairs(model.rigid_body) do
        v:draw(false)
    end
end
function render.stage.main()
    setRenderTarget()
    clearRenderArea()
    
    setActiveShader(shader.getSkyboxShader())
    setActiveScene(scene.getMainScene())
    model.skybox:draw(false) -- Skybox has no-depth materials
    
    setActiveShader(shader.getCloudsShader())
    scene.getMainCamera():setDepth(1.0,2000.0)
    setActiveScene(scene.getMainScene())
    model.clouds:draw() -- Clouds has no-depth materials
    
    setActiveShader(shader.getMainShader())
    scene.getMainCamera():setDepth(0.2,300.0)
    setActiveScene(scene.getMainScene())
    local l_camera = scene.getShadowCamera()
    shader.updateMainShadowProjection(l_camera:getProjectionMatrix())
    shader.updateMainShadowView(l_camera:getViewMatrix())

    model.plane:draw()
    model.dummy:draw()
    for _,v in ipairs(model.rigid_body) do
        v:draw()
    end
    for _,v in ipairs(model.cycloid) do
        v:draw()
    end
    
    setActiveShader(shader.getFireShader())
    setActiveScene(scene.getMainScene())
    model.fire:draw()
end
function render.stage.gui()
    local l_ww,l_wh = window.getSize()
    setActiveShader(shader.getTextureShader())
    texture.logo:draw(10,16,256,36, 0, 1,1,1,0.75)
    if(control.isConsoleVisible()) then
        texture.box:draw(0,0,l_ww,16)
    end
    if(control.isCursorLocked()) then
        if(control.isHitDetected()) then
            texture.crosshair.fill:draw(l_ww/2-12,l_wh/2-12,24,24)
        else
            texture.crosshair.free:draw(l_ww/2-12,l_wh/2-12,24,24)
        end
    end

    setActiveShader(shader.getFontShader())
    render.info.update()
    render.info.draw(l_wh)

    if(control.isConsoleVisible()) then
        font.console:draw(8.0,4.0,"> "..control.getConsoleText()..((render.var.time%0.5 >= 0.25) and "|" or ""))
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
        render.info[8].data = l_hitElement and l_hitElement:getType().." -> "..tostring(l_hitElement) or ""
    else
        render.info[6].data = ""
        render.info[7].data = ""
        render.info[8].data = ""
    end
end
function render.info.draw(height)
    -- Two passes, outline is madness
    local l_text = ""
    for k,v in ipairs(render.info) do
        if(v.data:len() > 0) then
            l_text = l_text..v.title..": "..v.data.."\n"
        end
    end
    font.default:draw(11.0,height-15.0,l_text, 0.0,0.0,0.0)
    font.default:draw(10.0,height-14.0,l_text)
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
        removeEventHandler("onRender",render.fade.processIn)
        return
    end
    setActiveShader(shader.texture)
    setRenderTarget()
    local l_ww,l_wh = window.getSize()
    texture.black:draw(0,0,l_ww,l_wh, 0.0, 1.0,1.0,1.0,1.0-l_dif/3.0)
end

function render.fade.close()
    if(render.fade.lock) then return end
    render.fade.lock = true
    render.fade.start = getTime()
    addEventHandler("onRender",render.fade.processOut)
end

function render.fade.processOut()
    local l_dif = getTime()-render.fade.start
    local l_ww,l_wh = window.getSize()
    setActiveShader(shader.texture)
    setRenderTarget()
    texture.black:draw(0,0,l_ww,l_wh, 0.0, 1.0,1.0,1.0,l_dif/3.0)
    sound.setGlobalVolume((1.0-l_dif/3.0)*100.0)
    if(l_dif > 3.0) then
        closeWindow()
    end
end
