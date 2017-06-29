target = {}

function target.init()
    target.shadow = RenderTarget(1024,1024,0,"depth","linear")
end
addEventHandler("onEngineStart",target.init)

function target.getShadowTarget()
    return target.shadow
end