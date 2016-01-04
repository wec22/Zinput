local zinput={
    _VERSION     = 'Zinput v0.1',
    _DESCRIPTION = 'A simple love2d input mixin for middleclass based on tactile',
    _URL         = 'HTTPS://github.com/wec22/Zinput',
    inputs={}
}

local button={
    __call=function(self,what)
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
    end,
}
button.__index=button

local axis={
    __call=function(self,what)
        what=what or "value"
        if what=="value" then
            return self.value
        elseif what=="prev" then
            return self.prev
        elseif what=="vel" then
            return self.vel
        end
    end
}
axis.__index=axis

--
function zinput:newbutton(name,...)
    self.inputs[name]={
        detectors={...},
        prev=false,
        value=false
    }
    setmetatable(self.inputs[name],button)
end
function zinput:newaxis(name,...)
    self.inputs[name]={
        prev=0,
        value=0,
        vel=0,
        dz=0.5,
        detectors={...}
    }
    setmetatable(self.inputs[name],axis)
end

--
function zinput:inputUpdate()
    for k,v in next, self.inputs do
        self.inputs[k]:update()
    end
end
function zinput:newbutton(name,...)
    self.inputs[name]={
        detectors={...},
        prev=false,
        value=false
    }
    setmetatable(self.inputs[name],button)
end
function zinput:newaxis(name,...)
    self.inputs[name]={
        prev=0,
        value=0,
        vel=0,
        dz=0.5,
        detectors={...}
    }
    setmetatable(self.inputs[name],axis)
end


--button definitions
function button:addDetector(detector)
    table.insert(self.detectors,detector)
end
function button:update()
    self.prev=self.value
    self.value=false

    --loop to go through detectors and check if true
    for i in ipairs(self.detectors) do
        if self.detectors[i]() then
            self.value=true
            break
        end
    end
end


--axis definitions
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
    --get the instantaneous velocity during this frame
    self.vel=(self.value-self.prev)/love.timer.getDelta()
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
