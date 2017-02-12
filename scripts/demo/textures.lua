data.texture = {}

data.texture.irradiance = textureCreate("cube",false,
    {   "textures/cubemap/px.png","textures/cubemap/nx.png",
        "textures/cubemap/py.png","textures/cubemap/ny.png",
        "textures/cubemap/pz.png","textures/cubemap/nz.png"     }
)
data.texture.box = textureCreate("rgba",true,"textures/box.png")
data.texture.logo = textureCreate("rgba",true,"textures/roc_logo.png")

data.texture.crosshair = {}
data.texture.crosshair.free = textureCreate("rgba",false,"textures/crosshair/free.png")
data.texture.crosshair.fill = textureCreate("rgba",false,"textures/crosshair/fill.png")