font = {}

function font.init()
    font.default = fontCreate("fonts/Hack-Regular.ttf",12)
    font.console = fontCreate("fonts/LiberationMono-Regular.ttf",12)
end
addEvent("onAppStart",font.init)