-- ControlCamera class
ControlCamera = {}
ControlCamera.__index = ControlCamera
ControlCamera.ms_limitDirectionUp = math.pi/2.0
ControlCamera.ms_limitDirectionDown = -math.pi/2.0
ControlCamera.ms_limitFOVUp = math.pi-0.05
ControlCamera.ms_limitFOVDown = 0.005
ControlCamera.ms_limitDistanceDown = 1.0
ControlCamera.ms_limitDistanceUp = 50.0

function ControlCamera.new(ud1)
    local l_data = {
        m_center = { x = 0, y = 0, z = 0 },
        m_angle = { 0, 0 },
        m_distance = 1.0,
        m_distanceLerp = 1.0,
        m_offset = 0,
        m_direction = { x = 0, y = 0.0, z = 1.0 },
        m_up = { x = 0, y = 0, z = 0 },
        m_position = { x = 0, y = 0, z = 1.0 },
        m_fov = math.pi/4,
        m_camera = ud1
    }
    return setmetatable(l_data,ControlCamera)
end
function ControlCamera:delete()
    self.m_position = nil
    self.m_angle = nil
    self.m_direction = nil
    self.m_fov = nil
end

function ControlCamera:setCenter(val1,val2,val3)
    self.m_center.x = val1
    self.m_center.y = val2
    self.m_center.z = val3
end
function ControlCamera:getCenter()
    return self.m_center.x,self.m_center.y,self.m_center.z
end

function ControlCamera:setAngles(val1,val2)
    self.m_angle[1] = math.fmod(val1,math.pi2)
    self.m_angle[2] = math.clamp(val2,self.ms_limitDirectionDown,self.ms_limitDirectionUp)
end
function ControlCamera:getAngles()
    return self.m_angle[1],self.m_angle[2]
end

function ControlCamera:setOffset(val1)
    self.m_offset = val1
end
function ControlCamera:getOffset()
    return self.m_offset
end

function ControlCamera:setDistance(val1)
    self.m_distance = math.clamp(val1,self.ms_limitDistanceDown,self.ms_limitDistanceUp)
end
function ControlCamera:getDistance()
    return self.m_distance
end

function ControlCamera:setFOV(val1)
    self.m_fov = math.lerp(val1,self.ms_limitFOVDown,self.ms_limitFOVUp)
end
function ControlCamera:getFOV()
    return self.m_fov
end

function ControlCamera:getPosition()
    return self.m_position.x,self.m_position.y,self.m_position.z
end
function ControlCamera:getDirection()
    return self.m_direction.x,self.m_direction.y,self.m_direction.z
end

function ControlCamera:update(val1) -- FPS
    local l_dir = math.cos(self.m_angle[2])
    self.m_direction.x = l_dir*math.sin(self.m_angle[1])
    self.m_direction.y = math.sin(self.m_angle[2])
    self.m_direction.z = l_dir*math.cos(self.m_angle[1])
    
    l_dir = math.cos(self.m_angle[2]+math.pi/2.0)
    self.m_up.x = l_dir*math.sin(self.m_angle[1])
    self.m_up.y = math.cos(self.m_angle[2])
    self.m_up.z = l_dir*math.cos(self.m_angle[1])
    
    if(math.epsilonNotEqual(self.m_distanceLerp,self.m_distance)) then
        self.m_distanceLerp = math.lerp(self.m_distanceLerp,self.m_distance,math.clamp(7.5/val1,0,1))
    end
    
    self.m_position.x = self.m_center.x-self.m_direction.x*self.m_distanceLerp + math.sin(self.m_angle[1]-math.piHalf)*self.m_offset
    self.m_position.y = self.m_center.y-self.m_direction.y*self.m_distanceLerp
    self.m_position.z = self.m_center.z-self.m_direction.z*self.m_distanceLerp + math.cos(self.m_angle[1]-math.piHalf)*self.m_offset
    
    self.m_camera:setPosition(self.m_position.x,self.m_position.y,self.m_position.z)
    self.m_camera:setDirection(self.m_direction.x,self.m_direction.y,self.m_direction.z)
    self.m_camera:setUpDirection(self.m_up.x,self.m_up.y,self.m_up.z)
    self.m_camera:setFOV(self.m_fov)
    
    -- Dizzy fun
    --local l_dizzyAngle = math.piHalf+math.sin(getTime()*16)*(math.pi/16)
    --self.m_camera:setUpDirection(math.cos(l_dizzyAngle),math.sin(l_dizzyAngle),0)
end
----
-- ControlState static class
ControlState = {}
ControlState.__index = ControlState

function ControlState.init()
   local self = ControlState
   
   self.ms_state = {
        left = false,
        right = false,
        forward = false,
        backward = false
   }
   
   addEventHandler("onKeyPress",self.onKeyPress)
   addEventHandler("onWindowFocus",self.onWindowFocus)
end

function ControlState.onKeyPress(str1,val1)
    local self = ControlState
    
    if(str1 == "w") then
        self.ms_state.forward = (val1 == 1)
    elseif(str1 == "a") then
        self.ms_state.left = (val1 == 1)
    elseif(str1 == "s") then
        self.ms_state.backward = (val1 == 1)
    elseif(str1 == "d") then
        self.ms_state.right = (val1 == 1)
    end
end

function ControlState.onWindowFocus(val1)
    local self = ControlState
    if(val1 == 0) then
        for k,_ in pairs(self.ms_state) do
            self.ms_state[k] = false
        end
    end
end

function ControlState:isMoving()
    return ((self.ms_state.forward ~= self.ms_state.backward) or (self.ms_state.left ~= self.ms_state.right))
end

function ControlState:getDirectionAngle()
    local l_angle = 0.0
    if(self.ms_state.forward) then
        if(self.ms_state.right) then l_angle = -0.25*math.pi
        elseif(self.ms_state.left) then l_angle = 0.25*math.pi end
    elseif(self.ms_state.backward) then
        if(self.ms_state.right) then l_angle = -0.75*math.pi
        elseif(self.ms_state.left) then l_angle = 0.75*math.pi
        else l_angle = -math.pi end
    else
        if(self.ms_state.right) then l_angle = -0.5*math.pi
        elseif(self.ms_state.left) then l_angle = 0.5*math.pi end
    end
    return l_angle
end
----

ControlManager = {}
ControlManager.__index = ControlManager

function ControlManager.init()
    local self = ControlManager
    
    self.ms_camera = false
    self.ms_shadowCamera = false
    
    addEventHandler("onGeometryCacheLoad",self.onGeometryCacheLoad)
end
addEventHandler("onEngineStart",ControlManager.init)

function ControlManager:getCameraPosition()
    return self.ms_camera:getPosition()
end
function ControlManager:getCameraDirection()
    return self.ms_camera:getDirection()
end

function ControlManager.onGeometryCacheLoad()
    local self = ControlManager
    
    local l_ww,l_wh = getWindowSize()
    setCursorPosition(math.floor(l_ww/2),math.floor(l_wh/2))
    setCursorMode(false,true)
    
    self.ms_camera = ControlCamera.new(SceneManager:getCamera("main"))
    self.ms_camera:setDistance(4.0)
    self.ms_camera:setOffset(1.5)
    
    self.ms_shadowCamera = SceneManager:getCamera("shadow")
    
    self.ms_controlModel = WorldManager:getModel("dummy")
    self.ms_controlModelAnim = {
        idle = AnimationCache:get("dummy","idle"),
        walk = AnimationCache:get("dummy","walk")
    }
    ControlState.init()
    
    addEventHandler("onCursorMove",self.onCursorMove)
    addEventHandler("onMouseScroll",self.onMouseScroll)
    addEventHandler("onPreRender",self.onPreRender)
end

local g_cameraMoveFraction = math.pi*128.0
function ControlManager.onCursorMove(val1,val2)
    local self = ControlManager
    
    local l_ww,l_wh = getWindowSize()
    local l_difX,l_difY = (val1-math.floor(l_ww/2))/g_cameraMoveFraction, (val2-math.floor(l_wh/2))/g_cameraMoveFraction
    
    local l_angle1,l_angle2 = self.ms_camera:getAngles()
    l_angle1,l_angle2 = l_angle1-l_difX,l_angle2-l_difY
    
    self.ms_camera:setAngles(l_angle1,l_angle2)
    
    setCursorPosition(math.floor(l_ww/2),math.floor(l_wh/2))
end

function ControlManager.onMouseScroll(f_wheel,f_delta)
    local self = ControlManager
    
    if(f_wheel == 0) then
        local l_dist = self.ms_camera:getDistance()
        l_dist = l_dist-f_delta/2
        self.ms_camera:setDistance(l_dist)
    end 
end

function ControlManager.onPreRender()
    local self = ControlManager
    
    local l_fps = RenderManager:getFPS()
    -- Update controlled model
    if(ControlState:isMoving()) then
        local l_rot,_ = self.ms_camera:getAngles()
        l_rot = l_rot+ControlState:getDirectionAngle()
        
        local l_modelRot = Quat(self.ms_controlModel:getRotation())
        local l_dirRot = Quat(0,l_rot,0)
        l_modelRot:slerp(l_dirRot, math.clamp(6.0/l_fps,0.0,1.0))
        self.ms_controlModel:setRotation(l_modelRot:getXYZW())
        
        local l_moveZ,l_moveX = getVectorFromAngle2D(l_rot)
        local l_moveSpeed = 5.625/l_fps -- 5.625 units per second
        local l_px,l_py,l_pz = self.ms_controlModel:getPosition()
        l_px,l_pz = l_px+l_moveX*l_moveSpeed,l_pz+l_moveZ*l_moveSpeed
        self.ms_controlModel:setPosition(l_px,l_py,l_pz)
        
        if(self.ms_controlModel:getAnimation() ~= self.ms_controlModelAnim.walk) then
            self.ms_controlModel:setAnimation(self.ms_controlModelAnim.walk)
            self.ms_controlModel:playAnimation()
        end
    else
        if(self.ms_controlModel:getAnimation() ~= self.ms_controlModelAnim.idle) then
            self.ms_controlModel:setAnimation(self.ms_controlModelAnim.idle)
            self.ms_controlModel:playAnimation()
        end
    end
    
    local l_px,l_py,l_pz = self.ms_controlModel:getPosition()
    self.ms_camera:setCenter(l_px,l_py+8.5,l_pz)
    self.ms_camera:update(l_fps)
    self.ms_shadowCamera:setPosition(self.ms_camera:getPosition())
end

ControlManager = setmetatable({},ControlManager)

-- ^(?([^\r\n])\s)*[^\s+?/]+[^\n]*$