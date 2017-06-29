scene = {}

function scene.init()
    scene.main = {}
    scene.main.scene = Scene()
    scene.main.light = Light()
    scene.main.light:setParams(0.5,1.0,0.5,16.0)
    scene.main.light:setColor(1.0,1.0,1.0)
    scene.main.light:setDirection(-0.707106,-0.707106,0.0)
    scene.main.camera = Camera("perspective")
    scene.main.camera:setPosition(0.0,5.0,20.0)
    scene.main.camera:setDirection(0.0,0.0,-1.0)
    scene.main.camera:setFOV(math.pi/4)
    scene.main.temp = { getWindowSize() }
    scene.main.camera:setAspectRatio(scene.main.temp[1]/scene.main.temp[2])
    scene.main.temp = nil
    scene.main.camera:setDepth(0.2,300.0)
    scene.main.scene:setLight(scene.main.light)
    scene.main.scene:setCamera(scene.main.camera)
    addEventHandler("onWindowResize",scene.updateMainAspectRatio)
    
    scene.shadow = {}
    scene.shadow.scene = Scene()
    scene.shadow.camera = Camera("orthogonal")
    scene.shadow.camera:setPosition(0.0,0.0,0.0)
    scene.shadow.camera:setDirection(-0.707106,-0.707106,0.0)
    scene.shadow.camera:setOrthoParams(-32.0,32.0,-32.0,32.0)
    scene.shadow.camera:setDepth(-50.0,50.0)
    scene.shadow.scene:setCamera(scene.shadow.camera)
end
addEventHandler("onEngineStart",scene.init)

function scene.updateMainAspectRatio(width,height)
    scene.main.camera:setAspectRatio(width/height)
end

function scene.getMainScene()
    return scene.main.scene
end
function scene.getMainCamera()
    return scene.main.camera
end

function scene.getShadowScene()
    return scene.shadow.scene
end
function scene.getShadowCamera()
    return scene.shadow.camera
end