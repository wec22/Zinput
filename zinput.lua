local zinput = {
    _VERSION     = 'Zinput v0.1',
    _DESCRIPTION = 'A simple love2d input mixin for middleclass based on tactile',
    _URL         = 'HTTPS://github.com/wec22/Zinput',
    inputs = {}
}

local button = {
    __call = function(self, what)
        what = what or "value"
        local time = self.time
        if what == "value" or what == "down" then         --always true if down
            return self.value, time
        elseif what == "prev" then                --true if button was pressed last frame
            return self.prev
        elseif what == "pressed" then             --true if first pressed this frame
            self.time = 0
            return self.value and not self.prev, time
        elseif what == "released" then            --true if released this frame
            self.time = 0
            return not self.value and self.prev, time
        elseif what == "up" then                  --always true if the button is not pressed opposite of "value" or "down"
            return not self.value, time
        end
    end
}
button.__index=button
function zinput:newbutton(name, ...)
    assert(type(name) == "string", "name must be a string")
    self.inputs[name] = {
        detectors = {...},
        prev = false,
        value = false,
        time = 0
    }
    setmetatable(self.inputs[name], button)
end

--button definitions
function button:addDetector(detector)
    assert(type(detector) == "function", "detector must be a function")
    table.insert(self.detectors, detector)
end
function button:update(dt)
    self.prev = self.value
    self.value = false
    self.time = self.time + (dt or 0)
    --loop to go through detectors and check if true
    for i in ipairs(self.detectors) do
        if self.detectors[i]() then
            self.value = true
            break
        end
    end
end

local axis = {
    __call = function(self, what)
        what = what or "value"
        assert(type(what) == "string", "'what' must be a string")

        if what == "value" then
            return self.value
        elseif what == "prev" then
            return self.prev
        elseif what == "vel" then
            return self.vel
        end
    end
}
axis.__index = axis

function zinput:newaxis(name, ...)
    self.inputs[name] = {
        prev = 0,
        value = 0,
        vel = 0,
        dz = 0.5,
        detectors = {...}
    }
    setmetatable(self.inputs[name], axis)
end
--axis definitions
function axis:addDetector(detector)
    assert(type(detector)=="function", "detector must be a function")
    table.insert(self.detectors, detector)
end
function axis:update(dt)
    self.prev = self.value
    self.value = 0
    for i in pairs(self.detectors) do
        local value = self.detectors[i]() or 0
        if math.abs(value) > self.dz then
            self.value = value
        end
    end
    --get the instantaneous velocity during this frame
    self.vel = (self.value - self.prev) / (dt or love.timer.getDelta())
end
function axis:setdeadzone(dz)
    self.dz = dz
end

--experimental joystick wrapper for axes
local joy = {}
joy.__index = joy

function zinput:newjoy(name, x, y, ...)
    self:newaxis(name..'x', x)
    self:newaxis(name..'y', y)

    self.inputs[name] = {
        x = self.inputs[name..'x'],
        y = self.inputs[name..'y']
    }
    setmetatable(self.inputs[name],joy)
end
function joy:update()
    --doesn't need to do anything since the axes are updated already
    --it just needs to exist
end
function joy:addDetector(x, y)
    self.x:addDetector(x)
    self.y:addDetector(y)
end

function zinput:inputUpdate(dt)
    for k,v in next, self.inputs do
        self.inputs[k]:update(dt)
    end
end

return zinput
