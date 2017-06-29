geometry = {}

function geometry.init()
    geometry.skybox = Geometry("models/skybox.rmf")
    geometry.plane = Geometry("models/plane.rmf")
    geometry.cube = Geometry("models/cube.rmf")
    geometry.cone = Geometry("models/cone.rmf")
    geometry.cylinder = Geometry("models/cylinder.rmf")
    geometry.sphere = Geometry("models/icosphere.rmf")
    geometry.rope = Geometry("models/rope.rmf")
    geometry.clouds = Geometry("models/clouds.rmf")
    geometry.fire = Geometry("models/flame.rmf")
    geometry.dummy = Geometry("models/dummy.rmf")
end
addEventHandler("onEngineStart",geometry.init)