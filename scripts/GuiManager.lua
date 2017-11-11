GuiManager = {}
GuiManager.__index = GuiManager

function GuiManager.init()
    local self = GuiManager
    
    self.ms_windowSize = { getWindowSize() }
    self.ms_shader = Shader("shaders/texture_vert.glsl","shaders/texture_frag.glsl")
    self.ms_font = {
        default = Font("fonts/Hack-Regular.ttf",12),
        console = Font("fonts/LiberationMono-Regular.ttf",12)
    }
    self.ms_texture = {
        box = Texture("rgba","textures/box.png","nearest",true)
    }
    self.ms_scene = Scene()
    self.ms_camera = Camera("screen")
    self.ms_camera:setOrthoParams(0,self.ms_windowSize[1],0,self.ms_windowSize[2])
    self.ms_scene:setCamera(self.ms_camera)
    self.ms_scene:setShader(self.ms_shader)
    
    RenderManager:addToQueue("gui",self.onRender_load)
    
    addEventHandler("onWindowResize",self.onWindowResize)
    addEventHandler("onGeometryCacheLoad",self.onGeometryCacheLoad)
end
addEventHandler("onEngineStart",GuiManager.init)

function GuiManager.onWindowResize(val1,val2)
    local self = GuiManager
    
    self.ms_windowSize[1],self.ms_windowSize[2] = val1,val2
    self.ms_camera:setOrthoParams(0,self.ms_windowSize[1],0,self.ms_windowSize[2])
end

function GuiManager.onGeometryCacheLoad()
    local self = GuiManager
    
    RenderManager:removeFromQueue("gui",self.onRender_load)
    RenderManager:addToQueue("gui",self.onRender_main)
end

function GuiManager.onRender_load()
    local self = GuiManager
    
    self.ms_scene:setActive()
    self.ms_texture.box:draw(0,0,self.ms_windowSize[1],self.ms_windowSize[2])
    local _,l_dif = math.modf(getTime())
    self.ms_font.default:draw(16,16, "Loading "..(l_dif >= 0.25 and "." or "")..(l_dif >= 0.5 and "." or "")..(l_dif >= 0.75 and "." or ""))
end

function GuiManager.onRender_main()
    local self = GuiManager
    
    self.ms_scene:setActive()
    
    local l_text = string.format("FPS: %.0f\n",RenderManager:getFPS())
    l_text = l_text..string.format("Camera position: %.4f, %.4f, %.4f\n",ControlManager:getCameraPosition())
    l_text = l_text..string.format("Camera direction: %.4f, %.4f, %.4f\n",ControlManager:getCameraDirection())
    
    self.ms_font.default:draw(17,self.ms_windowSize[2]-17,l_text, 0,0,0) -- fake outline
    self.ms_font.default:draw(16,self.ms_windowSize[2]-16,l_text)
end

GuiManager = setmetatable({},GuiManager)
