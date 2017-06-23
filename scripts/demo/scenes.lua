scene = {}

function scene.init()
    scene.main = {}
    scene.main.scene = sceneCreate()
    scene.main.light = lightCreate()
    lightSetParams(scene.main.light,0.5,1.0,0.5,16.0)
    lightSetColor(scene.main.light,1.0,1.0,1.0)
    lightSetDirection(scene.main.light,-0.707106,-0.707106,0.0)
    scene.main.camera = cameraCreate("perspective")
    cameraSetPosition(scene.main.camera,0.0,5.0,20.0)
    cameraSetDirection(scene.main.camera,0.0,0.0,-1.0)
    cameraSetFOV(scene.main.camera,math.pi/4)
    scene.main.temp = { getWindowSize() }
    cameraSetAspectRatio(scene.main.camera,scene.main.temp[1]/scene.main.temp[2])
    scene.main.temp = nil
    cameraSetDepth(scene.main.camera,0.2,300.0)
    sceneSetLight(scene.main.scene,scene.main.light)
    sceneSetCamera(scene.main.scene,scene.main.camera)
    addEventHandler("onWindowResize",scene.updateMainAspectRatio)
    
    scene.shadow = {}
    scene.shadow.scene = sceneCreate()
    scene.shadow.camera = cameraCreate("orthogonal")
    cameraSetPosition(scene.shadow.camera,0.0,0.0,0.0)
    cameraSetDirection(scene.shadow.camera,-0.707106,-0.707106,0.0)
    cameraSetOrthoParams(scene.shadow.camera,-32.0,32.0,-32.0,32.0)
    cameraSetDepth(scene.shadow.camera,-50.0,50.0)
    sceneSetCamera(scene.shadow.scene,scene.shadow.camera)
end
addEventHandler("onEngineStart",scene.init)

function scene.updateMainAspectRatio(width,height)
    cameraSetAspectRatio(scene.main.camera,width/height)
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