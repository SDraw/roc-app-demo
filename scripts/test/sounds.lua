data.sound = {}

data.sound["background"] = soundCreate("sound/bgm01.ogg",true)
soundSet3DPositionEnabled(data.sound["background"],true)
soundSet3DPosition(data.sound["background"], 0.0,0.0,0.0)
soundSet3DDistance(data.sound["background"], 20.0,50.0)
