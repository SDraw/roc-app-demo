data.model = {}

data.model["skydome"] = modelCreate(data.geometry["skydome"])
modelSetRotation(data.model["skydome"],0.0,math.pi*1.25,0.0)

data.model.miku = modelCreate(data.geometry.miku)
modelSetAnimation(data.model.miku,data.animation.miku.dance)

data.model["plane"] = modelCreate(data.geometry["plane"])

data.model["rigid_body"] = {}
for i=1,25 do
    data.model["rigid_body"][i] = modelCreate(data.geometry["cone"])
    modelSetPosition(data.model["rigid_body"][i],4.0,1.0+2.0*(i-1),4.0)
    modelSetRigidity(data.model["rigid_body"][i],"cone",1.0, 1.0,1.0)
    modelSetFriction(data.model["rigid_body"][i],1.0)
end
for i=26,50 do
    local l_disp = ((-1)^(i%2))
    data.model["rigid_body"][i] = modelCreate(data.geometry["cylinder"])
    modelSetPosition(data.model["rigid_body"][i],4.0+0.25*l_disp,1.0+2.0*(i-26),-4.0+0.25*l_disp)
    modelSetRigidity(data.model["rigid_body"][i],"cylinder",1.0, 1.0,0.5,1.0)
    modelSetFriction(data.model["rigid_body"][i],1.0)
end
for i=51,100 do
    local l_disp = ((-1)^(i%2))
    data.model["rigid_body"][i] = modelCreate(data.geometry["cube"])
    modelSetPosition(data.model["rigid_body"][i],-4.0+0.5*l_disp,1.0+2.0*(i-51),4.0)
    modelSetRigidity(data.model["rigid_body"][i],"box",1.0, 1.0,1.0,1.0)
    modelSetFriction(data.model["rigid_body"][i],1.0)
end
for i=101,150 do
    local l_disp = ((-1)^(i%2))
    data.model["rigid_body"][i] = modelCreate(data.geometry["sphere"])
    modelSetPosition(data.model["rigid_body"][i],-4.0+0.25*l_disp,1.0+2.0*(i-101),-4.0+0.25*l_disp)
    modelSetRigidity(data.model["rigid_body"][i],"sphere",1.0, 1.0)
    modelSetFriction(data.model["rigid_body"][i],1.0)
end

for i=#data.model["rigid_body"]+1,#data.model["rigid_body"]+1 do
    data.model["rigid_body"][i] = modelCreate(data.geometry["cube"])
    modelSetPosition(data.model["rigid_body"][i],-8.0,2.0,-8.0)
    modelSetRigidity(data.model["rigid_body"][i],"box",1.0, 1.0,1.0,1.0)
end

data.model.rope = modelCreate(data.geometry["rope"])
modelSetPosition(data.model.rope,-12.0,2.0,-8.0)

data.model["cube"] = modelCreate(data.geometry["cube_cloud"])