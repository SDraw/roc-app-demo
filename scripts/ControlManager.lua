-- CharacterCamera class
CharacterCamera = {}
CharacterCamera.__index = CharacterCamera
CharacterCamera.ms_limitDirectionUp = math.pi/2.0
CharacterCamera.ms_limitDirectionDown = -math.pi/2.0
CharacterCamera.ms_limitFOVUp = math.pi-0.05
CharacterCamera.ms_limitFOVDown = 0.005
CharacterCamera.ms_limitDistanceDown = 1.0
CharacterCamera.ms_limitDistanceUp = 8.0

function CharacterCamera.new(ud1)
    local l_data = {
        m_center = { x = 0, y = 0, z = 0 },
        m_angle = { math.pi, 0 },
        m_distance = 1.0,
        m_distanceLerp = 1.0,
        m_offset = 0,
        m_direction = { x = 0, y = 0.0, z = 1.0 },
        m_directionQuat = Quat(0,0,0),
        m_position = { x = 0, y = 0, z = 1.0 },
        m_fov = math.pi/4,
        m_camera = ud1
    }
    return setmetatable(l_data,CharacterCamera)
end
function CharacterCamera:delete()
    self.m_position = nil
    self.m_angle = nil
    self.m_direction = nil
    self.m_fov = nil
end

function CharacterCamera:setCenter(val1,val2,val3)
    self.m_center.x = val1
    self.m_center.y = val2
    self.m_center.z = val3
end
function CharacterCamera:getCenter()
    return self.m_center.x,self.m_center.y,self.m_center.z
end

function CharacterCamera:addAngles(val1,val2)
    self.m_angle[1] = math.fmod(self.m_angle[1]+val1,math.pi2)
    self.m_angle[2] = math.clamp(self.m_angle[2]+val2,self.ms_limitDirectionDown,self.ms_limitDirectionUp)
end
function CharacterCamera:getAngles()
    return self.m_angle[1],self.m_angle[2]
end

function CharacterCamera:setOffset(val1)
    self.m_offset = val1
end
function CharacterCamera:getOffset()
    return self.m_offset
end

function CharacterCamera:setDistance(val1)
    self.m_distance = math.clamp(val1,self.ms_limitDistanceDown,self.ms_limitDistanceUp)
end
function CharacterCamera:getDistance()
    return self.m_distance
end

function CharacterCamera:setFOV(val1)
    self.m_fov = math.lerp(val1,self.ms_limitFOVDown,self.ms_limitFOVUp)
end
function CharacterCamera:getFOV()
    return self.m_fov
end

function CharacterCamera:getPosition()
    return self.m_position.x,self.m_position.y,self.m_position.z
end
function CharacterCamera:getDirection()
    return self.m_direction.x,self.m_direction.y,self.m_direction.z
end
function CharacterCamera:getDirectionQuat()
    return self.m_directionQuat
end

function CharacterCamera:update(val1) -- FPS
    
    self.m_directionQuat:setEuler(self.m_angle[2],self.m_angle[1],0)
    self.m_camera:setDirection(self.m_directionQuat:getXYZW())
    self.m_direction.x,self.m_direction.y,self.m_direction.z = self.m_camera:getDirection()
    
    if(math.epsilonNotEqual(self.m_distanceLerp,self.m_distance)) then
        self.m_distanceLerp = math.lerp(self.m_distanceLerp,self.m_distance, math.clamp(7.5/val1,0,1))
    end
    
    self.m_position.x = self.m_center.x-self.m_direction.x*self.m_distanceLerp + math.cos(self.m_angle[1])*self.m_offset
    self.m_position.y = self.m_center.y-self.m_direction.y*self.m_distanceLerp
    self.m_position.z = self.m_center.z-self.m_direction.z*self.m_distanceLerp - math.sin(self.m_angle[1])*self.m_offset
    
    self.m_camera:setPosition(self.m_position.x,self.m_position.y,self.m_position.z)
    if(self.m_angle[2] > 0) then
        self.m_camera:setFOV(self.m_fov+math.pi/4*((self.m_angle[2]/math.piHalf)^2))
    else
        self.m_camera:setFOV(self.m_fov)
    end
end
----

-- Character class
Character = {}
Character.__index = Character

function Character.new()
    local l_data = {
        m_model = false,
        m_collision = false,
        m_characterCamera = false,
        m_moveState = {
            left = false,
            right = false,
            forward = false,
            backward = false,
            jump = false
        },
        m_animList = {
            idle = false,
            walk = false
        }
    }
    return setmetatable(l_data,Character)
end

function Character:setModel(ud1)
    self.m_model = ud1
    if(self.m_model and self.m_collision) then
        self.m_model:setCollidableWith(self.m_collision,false)
        self.m_model:setCollision(self.m_collision)
    end
end
function Character:getModel()
    return self.m_model
end

function Character:setCollision(ud1)
    self.m_collision = ud1
    if(self.m_collision and self.m_model) then
        self.m_collision:setCollidableWith(self.m_model,false)
        self.m_model:setCollision(self.m_collision)
    end
end
function Character:getCollision()
    return self.m_collision
end

function Character:setCamera(mt1)
    self.m_characterCamera = mt1
end
function Character:getCamera()
    return self.m_characterCamera
end

function Character:setMoveState(str1,val1)
    self.m_moveState[str1] = val1
end
function Character:getMoveState(str1)
    return self.m_moveState[str1]
end

function Character:setAnimation(str1,ud1)
    self.m_animList[str1] = ud1
end
function Character:getAnimation(str1)
    return self.m_animList[str1]
end

function Character:update(val1) -- FPS
    if(math.bxor(self.m_moveState.left,self.m_moveState.right) or math.bxor(self.m_moveState.forward,self.m_moveState.backward)) then
        local l_cameraRot,_ = self.m_characterCamera:getAngles()
        
        local l_dirVec = { x = 0, y = 0 }
        if(self.m_moveState.forward) then l_dirVec.y = l_dirVec.y+1 end
        if(self.m_moveState.backward) then l_dirVec.y = l_dirVec.y-1 end
        if(self.m_moveState.left) then l_dirVec.x = l_dirVec.x-1 end
        if(self.m_moveState.right) then l_dirVec.x = l_dirVec.x+1 end
        
        local l_dirRot = math.atan(l_dirVec.y,l_dirVec.x)-math.piHalf
        
        local l_colRot = Quat(
            self.m_collision:getRotation()
            ):slerp(
                Quat(0,l_cameraRot+l_dirRot+math.pi,0),
                math.clamp(6.0/val1,0.0,1.0)
        )
        self.m_collision:setRotation(l_colRot:getXYZW())
        
        local l_moveX,l_moveY,l_moveZ = l_colRot:rotateVector(0,0,1)
        local l_moveSpeed = 5.625
        _,l_moveY,_ = self.m_collision:getVelocity()
        self.m_collision:setVelocity(l_moveX*l_moveSpeed,l_moveY,l_moveZ*l_moveSpeed)
        
        if(self.m_model:getAnimation() ~= self.m_animList.walk) then
            self.m_model:setAnimation(self.m_animList.walk)
            self.m_model:playAnimation(true)
        end
    else
        if(self.m_model:getAnimation() ~= self.m_animList.idle) then
            self.m_model:setAnimation(self.m_animList.idle)
            self.m_model:playAnimation(true)
        end
    end
    if(self.m_moveState.jump == true) then
        self.m_collision:applyImpulse(0,4.9*self.m_collision:getMass(),0)
        self.m_moveState.jump = false
    end
    
    local l_px,l_py,l_pz = self.m_collision:getPosition()
    self.m_characterCamera:setCenter(l_px,l_py+4.0,l_pz)
    self.m_characterCamera:update(val1)
end
----

ControlManager = {}
ControlManager.__index = ControlManager

function ControlManager.init()
    local self = ControlManager
    
    self.ms_character = false
    self.ms_characterCamera = false
    self.ms_shadowCamera = false
    
    addEventHandler("onGeometryCacheLoad",self.onGeometryCacheLoad)
end
addEventHandler("onEngineStart",ControlManager.init)

function ControlManager.onGeometryCacheLoad()
    local self = ControlManager
    
    local l_ww,l_wh = getWindowSize()
    setCursorPosition(math.floor(l_ww/2),math.floor(l_wh/2))
    self.ms_cursorLock = true
    setCursorMode(not self.ms_cursorLock,self.ms_cursorLock)
    
    -- Character init
    self.ms_characterCamera = CharacterCamera.new(SceneManager:getCamera("main"))
    self.ms_characterCamera:setDistance(4.0)
    self.ms_characterCamera:setOffset(1.5)
    
    self.ms_character = Character.new()
    self.ms_character:setCamera(self.ms_characterCamera)
    
    local l_model = WorldManager:getModel("dummy")
    l_model:setPosition(0,-4.5,0)
    self.ms_character:setModel(l_model)
    
    local l_col = Collision("cone",20.0, 1.5,9.0)
    l_col:setPosition(0,4.5,0)
    l_col:setAngularFactor(0,0,0)
    l_col:setFriction(50)
    self.ms_character:setCollision(l_col)
    
    self.ms_character:setAnimation("idle",AnimationCache:get("dummy","idle"))
    self.ms_character:setAnimation("walk",AnimationCache:get("dummy","walk"))
    ----
    
    addEventHandler("onCursorMove",self.onCursorMove)
    addEventHandler("onMouseScroll",self.onMouseScroll)
    addEventHandler("onKeyPress",self.onKeyPress)
    addEventHandler("onWindowFocus",self.onWindowFocus)
    addEventHandler("onPreRender",self.onPreRender)
end

function ControlManager.onWindowFocus(val1)
    local self = ControlManager
    
    if(val1 == 0) then
        self.ms_character:setMoveState("left",false)
        self.ms_character:setMoveState("right",false)
        self.ms_character:setMoveState("forward",false)
        self.ms_character:setMoveState("backward",false)
        self.ms_character:setMoveState("jump",false)
    end
end

local g_cameraMoveFraction = math.pi*128.0
function ControlManager.onCursorMove(val1,val2)
    local self = ControlManager
    
    if(self.ms_cursorLock) then
        local l_ww,l_wh = getWindowSize()
        self.ms_characterCamera:addAngles((math.floor(l_ww/2)-val1)/g_cameraMoveFraction,(math.floor(l_wh/2)-val2)/g_cameraMoveFraction)
        setCursorPosition(math.floor(l_ww/2),math.floor(l_wh/2))
    end
end

function ControlManager.onMouseScroll(f_wheel,f_delta)
    local self = ControlManager
    
    if(f_wheel == 0) then
        local l_dist = self.ms_characterCamera:getDistance()
        l_dist = l_dist-f_delta/2
        self.ms_characterCamera:setDistance(l_dist)
    end 
end

function ControlManager.onKeyPress(str1,val1)
    local self = ControlManager
    
    if((str1 == "tab") and (val1 == 1)) then
        self.ms_cursorLock = not self.ms_cursorLock
        setCursorMode(not self.ms_cursorLock,self.ms_cursorLock)
    elseif(str1 == "w") then
        self.ms_character:setMoveState("forward",val1 == 1)
    elseif(str1 == "a") then
        self.ms_character:setMoveState("left",val1 == 1)
    elseif(str1 == "s") then
        self.ms_character:setMoveState("backward",val1 == 1)
    elseif(str1 == "d") then
        self.ms_character:setMoveState("right",val1 == 1)
    elseif(str1 == "space") then
        self.ms_character:setMoveState("jump",val1 == 1)
    end
end

function ControlManager.onPreRender()
    local self = ControlManager
    
    local l_fps = RenderManager:getFPS()
    self.ms_character:update(l_fps)
end

function ControlManager:getCameraPosition()
    return self.ms_characterCamera:getPosition()
end
function ControlManager:getCameraDirection()
    return self.ms_characterCamera:getDirection()
end
function ControlManager:getCameraAngles()
    return self.ms_characterCamera:getAngles()
end

ControlManager = setmetatable({},ControlManager)

-- ^(?([^\r\n])\s)*[^\s+?/]+[^\n]*$
