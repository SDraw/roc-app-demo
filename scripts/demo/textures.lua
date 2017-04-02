texture = {}

function texture.init()
    --texture.irradiance = textureCreate("cube","linear",false,
    --    {   "textures/cubemap/px.png","textures/cubemap/nx.png",
    --        "textures/cubemap/py.png","textures/cubemap/ny.png",
    --        "textures/cubemap/pz.png","textures/cubemap/nz.png"     }
    --)
    texture.box = textureCreate("rgba","nearest",true,"textures/box.png")
    texture.crosshair = {
        free = textureCreate("rgba","linear",false,"textures/crosshair/free.png"),
        fill = textureCreate("rgba","linear",false,"textures/crosshair/fill.png")
    }
    texture.logo = textureCreate("rgba","nearest",false,"textures/roc_logo.png")
    texture.black = textureCreate("rgba","nearest",true,"textures/black.png")
end
addEvent("onAppStart",texture.init)
