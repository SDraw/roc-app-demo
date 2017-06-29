animation = {}

function animation.init()
    animation.dummy = {
        idle = Animation("animations/dummy_idle.raf"),
        walk = Animation("animations/dummy_walk.raf")
    }
end
addEventHandler("onEngineStart",animation.init)
