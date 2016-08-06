data.scene = {}

data.scene.main = {}

data.scene.main.scene = sceneCreate()

data.scene.main.light = lightCreate()
lightSetParams(data.scene.main.light,0.5,1.0,0.5,16.0)
lightSetColor(data.scene.main.light,0.811764,0.862745,0.996078)
lightSetDirection(data.scene.main.light,-0.707106,-0.707106,0.0)

data.scene.main.camera = cameraCreate("perspective")
cameraSetPosition(data.scene.main.camera,0.0,5.0,20.0)
cameraSetDirection(data.scene.main.camera,0.0,0.0,-1.0)
cameraSetFOV(data.scene.main.camera,math.pi/4)
local l_tx,l_ty = getWindowSize()
cameraSetPerspectiveSize(data.scene.main.camera,l_tx,l_ty)
cameraSetDepth(data.scene.main.camera,0.2,300.0)

sceneSetLight(data.scene.main.scene,data.scene.main.light)
sceneSetCamera(data.scene.main.scene,data.scene.main.camera)

data.scene.shadow = {}

data.scene.shadow.scene = sceneCreate()

data.scene.shadow.camera = cameraCreate("orthogonal")
cameraSetPosition(data.scene.shadow.camera,0.0,0.0,0.0)
cameraSetDirection(data.scene.shadow.camera,-0.707106,-0.707106,0.0)
cameraSetOrthoSize(data.scene.shadow.camera,-16.0,16.0,-16.0,16.0)
cameraSetDepth(data.scene.shadow.camera,-50.0,50.0)
sceneSetCamera(data.scene.shadow.scene,data.scene.shadow.camera)