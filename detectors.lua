local detectors={}

detectors.button={}
function detectors.button.key(key)
    return function()
        return love.keyboard.isDown(key)
    end
end
function detectors.button.gamepad(button,padnum)--requires verion >=0.9.0
    return function()
        local joystick = love.joystick.getJoysticks()[padnum]
        return joystick and joystick:isGamepadDown(button)
    end
end
function detectors.button.mouse(button)
    return function()
        return love.mouse.isDown(button)
    end
end

detectors.axis={}
function detectors.axis.gamepad(axis,padnum)--requires version >=0.9.0
    return function()
        local joystick = love.joystick.getJoysticks()[padnum]
        return joystick and joystick:getGamepadAxis(axis)
    end
end

detectors.joy={}
function detectors.joy.gamepad(axis,padnum)
    return detectors.axis.gamepad(axis.."x",padnum), detectors.axis.gamepad(axis.."y",padnum)
end

return detectors
