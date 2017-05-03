animation = {}

function animation.init()
    animation.dummy = {
        idle = animationCreate("animations/dummy_idle.raf"),
        walk = animationCreate("animations/dummy_walk.raf")
    }
end
addEventHandler("onAppStart",animation.init)
