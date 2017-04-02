sound = {
    music = { "dazzled","fantasy","magical","poetry","rain","strnzeit","snow outside" },
    background = false,
    index = 0,
    length = 0.0,
    volume = 100.0
}

function sound.init()
    math.randomseed(getTickCount())
    sound.index = math.random(1,#sound.music)-1
end
addEvent("onAppStart",sound.init)

function sound.playBackground()
    addEvent("onOGLPreRender",sound.updateBackground)
end

function sound.updateBackground()
    if(not sound.background) then
        sound.index = (sound.index+1)%#sound.music+1
        sound.background = soundCreate("sound/"..sound.music[sound.index]..".ogg")
        soundSetVolume(sound.background,0.0)
        soundPlay(sound.background)
        sound.length = soundGetDuration(sound.background)
    else
        local l_state = soundGetState(sound.background)
        if(l_state == "playing") then
            local l_time = soundGetTime(sound.background)
            if(l_time <= 3.0) then
                soundSetVolume(sound.background,(l_time/3.0)*100.0)
            elseif(l_time >= sound.length-3.0) then
                soundSetVolume(sound.background,(sound.length-l_time)/3.0*100.0)
            end
        elseif(l_state == "stopped") then
            soundDestroy(sound.background)
            sound.background = false
        end
    end
end

function sound.setGlobalVolume(val1)
    sound.volume = val1
    soundSetGlobalVolume(sound.volume)
end
function sound.getGlobalVolume()
    return sound.volume
end