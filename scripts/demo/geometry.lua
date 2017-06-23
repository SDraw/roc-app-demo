geometry = {}

function geometry.init()
    geometry.skybox = geometryCreate("models/skybox.rmf")
    geometry.plane = geometryCreate("models/plane.rmf")
    geometry.cube = geometryCreate("models/cube.rmf")
    geometry.cone = geometryCreate("models/cone.rmf")
    geometry.cylinder = geometryCreate("models/cylinder.rmf")
    geometry.sphere = geometryCreate("models/icosphere.rmf")
    geometry.rope = geometryCreate("models/rope.rmf")
    geometry.clouds = geometryCreate("models/clouds.rmf")
    geometry.fire = geometryCreate("models/flame.rmf")
    geometry.dummy = geometryCreate("models/dummy.rmf")
end
addEventHandler("onEngineStart",geometry.init)