WindowManager = {}
WindowManager.__index = WindowManager

function WindowManager.init()
    setWindowIcon("icons/coal.png")
    setWindowTitle("RunOnCoal Demo Scene / デモシーン / Демосцена")
    --setWindowFramelimit(0)
end
addEventHandler("onEngineStart",WindowManager.init)

WindowManager = setmetatable({},WindowManager)
