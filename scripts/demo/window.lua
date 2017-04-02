window = {}

function window.init()
    window.size = { 0,0 }
    window.size[1],window.size[2] = getWindowSize()
    setWindowIcon("coal.png")
    setWindowTitle("RunOnCoal Demo Scene / デモシーン / Демосцена")
    addEvent("onWindowResize",window.updateSize)
end
addEvent("onAppStart",window.init)

function window.updateSize(width,height)
    window.size[1],window.size[2] = width,height
end

function window.getSize()
    return window.size[1],window.size[2]
end
