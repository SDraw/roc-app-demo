data.sound = {}

data.sound.background = soundCreate("sound/magical.ogg",true)

function data.sound.init()
    soundPlay(data.sound.background)
end
addEvent("onAppStart",data.sound.init)
