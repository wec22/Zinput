local zinput={
    _VERSION     = 'Zinput v0.1',
    _DESCRIPTION = 'A simple love2d input mixin for middleclass based on tactile',
    _URL         = 'HTTPS://github.com/wec22/Zinput',
    inputs={}
}
function zinput:inputUpdate()
    for i=1, #self.inputs do
        self.axis[i]:update()
    end
end
function zinput:newbutton(name,...)
    self.inputs[name]=button:new(...)
end
function zinput:newaxis(name,...)
    self.inputs[name]=button:new(...)
end

local button={}
function button.__call(self,what)
    what=what or "value"
    if what=="value" or "down" then         --always true if down
        return self.value
    elseif what=="prev" then                --true if button was pressed last frame
        return self.prev
    elseif what=="pressed" then             --true if first pressed this frame
        return self.value and not self.prev
    elseif what=="released" then            --true if released this frame
        return not self.value and self.prev
    elseif what=="up" then                  --always true if the button is not pressed opposite of "value" or "down"
    end
end
function button:new(detector,...)
    local temp={
        detectors={...},
        prev=false,
        value=false
    }
    return setmetatable(temp,button)
end
function button:addDetector(detector)
    table.insert(self.detectors,detector)
end
function button:update()
    self.prev=self.value
    self.value=false

    --loop to go through detectors and check if true
    for i in #self.detectors do
        if i() then
            self.value=true
            break
        end
    end
end


local axis={}
function axis.__call(self,what)
    what=what or "value"
    if what=="value" then
        return self.value
    elseif what=="prev" then
        return self.prev
    elseif what=="vel" then
        return self.vel
    end
end
function axis:new(name,...)
    local temp={
        prev=0,
        value=0,
        vel=0,
        dz=0.5,
        detectors={...}
    }
    return setmetatable(temp,axis)
end
function axis:addDetector(detector)
    table.insert(self.detectors,detector)
end
function axis:update()
    self.prev=self.value
    self.value=0
    for i=1, #self.detectors do
        local value = self.detectors[i]()
        if math.abs(value)>dz then
            self.value=value
        end
    end
    --get the instantaneous velosity during this frame
    self.vel=(self.value-self.prev)/2
end
function axis:setdeadzone(dz)
    self.dz=dz
end


--detectors
function gampadbutton(button,pad)
    return function()
        local joystick = love.joystick.getJoysticks()[pad]
        return joystick and joystick:isGamepadDown(button)
    end
end
function keyboard(key)
    return function()
        return love.keyboard.isDown(key)
    end
end


return zinput
