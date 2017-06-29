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
addEventHandler("onEngineStart",sound.init)

function sound.playBackground()
    addEventHandler("onPreRender",sound.updateBackground)
end

function sound.updateBackground()
    if(not sound.background) then
        sound.index = (sound.index+1)%#sound.music+1
        sound.background = Sound("sound/"..sound.music[sound.index]..".ogg")
        sound.background:setVolume(0.0)
        sound.background:play()
        sound.length = sound.background:getDuration()
    else
        local l_state = sound.background:getState()
        if(l_state == "playing") then
            local l_time = sound.background:getTime()
            if(l_time <= 3.0) then
                sound.background:setVolume((l_time/3.0)*100.0)
            elseif(l_time >= sound.length-3.0) then
                sound.background:setVolume((sound.length-l_time)/3.0*100.0)
            end
        elseif(l_state == "stopped") then
            sound.background:destroy()
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