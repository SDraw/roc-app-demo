texture = {}

function texture.init()
    --texture.irradiance = Texture("cube","linear",false,
    --    {   "textures/cubemap/px.png","textures/cubemap/nx.png",
    --        "textures/cubemap/py.png","textures/cubemap/ny.png",
    --        "textures/cubemap/pz.png","textures/cubemap/nz.png"     }
    --)
    texture.box = Texture("rgba","nearest",true,"textures/box.png")
    texture.crosshair = {
        free = Texture("rgba","linear",false,"textures/crosshair/free.png"),
        fill = Texture("rgba","linear",false,"textures/crosshair/fill.png")
    }
    texture.logo = Texture("rgba","nearest",false,"textures/roc_logo.png")
    texture.black = Texture("rgba","nearest",true,"textures/black.png")
end
addEventHandler("onEngineStart",texture.init)
