font = {}

function font.init()
    font.default = Font("fonts/Hack-Regular.ttf",12)
    font.console = Font("fonts/LiberationMono-Regular.ttf",12)
end
addEventHandler("onEngineStart",font.init)