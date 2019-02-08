GuiManager = {}
GuiManager.__index = GuiManager

function GuiManager.init()
    local self = GuiManager
    
    self.ms_windowSize = { getWindowSize() }
    self.ms_shader = Shader("shaders/texture_vert.glsl","shaders/texture_frag.glsl")
    self.ms_font = {
        default = Font("fonts/Hack-Regular.ttf",12)
    }
    self.ms_texture = {
        box = Texture("rgba","textures/box.png","nearest",true)
    }
    self.ms_scene = Scene()
    self.ms_camera = Camera("screen")
    self.ms_camera:setOrthoParams(0,self.ms_windowSize[1],0,self.ms_windowSize[2])
    self.ms_scene:setCamera(self.ms_camera)
    self.ms_scene:setShader(self.ms_shader)
    
    addEventHandler("onWindowResize",self.onWindowResize)
    addEventHandler("onGeometryCacheLoad",self.onGeometryCacheLoad)
    
    self.draw = self.draw_load
end
addEventHandler("onEngineStart",GuiManager.init)

function GuiManager.onWindowResize(val1,val2)
    local self = GuiManager
    
    self.ms_windowSize[1],self.ms_windowSize[2] = val1,val2
    self.ms_camera:setOrthoParams(0,self.ms_windowSize[1],0,self.ms_windowSize[2])
end

function GuiManager.onGeometryCacheLoad()
    local self = GuiManager
    
    self.draw = self.draw_main
end

function GuiManager:draw_load()
    self.ms_scene:setActive()
    self.ms_texture.box:draw(0,0,self.ms_windowSize[1],self.ms_windowSize[2])
    local _,l_dif = math.modf(getTime())
    self.ms_font.default:draw(16,16, "Loading "..('.'):rep(math.floor(l_dif/0.25)))
end

function GuiManager:draw_main()
    self.ms_scene:setActive()
    
    local l_text = string.format("FPS: %.0f\n",RenderManager:getFPS())
    l_text = l_text..string.format("Time: %.4f\n",getTime())
    l_text = l_text..string.format("Camera position: %.4f, %.4f, %.4f\n",ControlManager:getCameraPosition())
    l_text = l_text..string.format("Camera direction: %.4f, %.4f, %.4f\n",ControlManager:getCameraDirection())
    l_text = l_text..string.format("Camera angles: %.4f, %.4f\n",ControlManager:getCameraAngles())
    
    self.ms_font.default:draw(17,self.ms_windowSize[2]-17,l_text, 0,0,0) -- fake outline
    self.ms_font.default:draw(16,self.ms_windowSize[2]-16,l_text)
end

GuiManager = setmetatable({},GuiManager)
