local class  = require("middleclass.middleclass")
local zinput = require("zinput")
local detectors = require("detectors")

player = class("player")                --example class, can be whatever you want
player:include(zinput)                  --include the library into the player class

function player:initialize()            --setup the class members
    self.x = 400
    self.y = 300
end

function love.load()
    p = player:new()                    --create a new player object

    p:newbutton("up")                   --create buttons
    p:newbutton("down")
    p:newbutton("left")
    p:newbutton("right")

    p.inputs.up:addDetector(detectors.button.key("up"))
    p.inputs.down:addDetector(detectors.button.key("down"))
    p.inputs.left:addDetector(detectors.button.key("left"))
    p.inputs.right:addDetector(detectors.button.key("right"))

    p.inputs.up:addDetector(detectors.button.key("w"))
    p.inputs.down:addDetector(detectors.button.key("s"))
    p.inputs.left:addDetector(detectors.button.key("a"))
    p.inputs.right:addDetector(detectors.button.key("d"))



    p:newaxis("lx")
    p:newaxis("ly")

    p.inputs.lx:addDetector(detectors.axis.gamepad("leftx", 1))
    p.inputs.ly:addDetector(detectors.axis.gamepad("lefty", 1))



    p:newjoy("r")
    p.inputs.r:addDetector(detectors.joy.gamepad("right", 1))

end

function love.update(dt)
    p:inputUpdate()                     --updates all inputs, required

    if p.inputs.up("down") then         --inputs are checked like functions
        p.y=p.y - (100 * dt)
    elseif p.inputs.down("down") then
        p.y=p.y + (100 * dt)
    end

    if p.inputs.left("down") then
        p.x=p.x - (100 * dt)
    elseif p.inputs.right("down") then
        p.x=p.x + (100 * dt)
    end

    p.x = p.x + p.inputs.lx() * 100 * dt
    p.y = p.y + p.inputs.ly() * 100 * dt

    p.x = p.x + p.inputs.rx() * 100 * dt
    p.y = p.y + p.inputs.ry() * 100 * dt
end

function love.draw()
    love.graphics.setColor(0, 0, 255)
    love.graphics.rectangle("fill", p.x, p.y, 20, 20)
    love.graphics.print(p.x .." ".. p.y)
end
