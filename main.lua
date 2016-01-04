local class  = require("middleclass")
local zinput = require("zinput")

player=class("player")                  --example class, can be whatever you want
player:include(zinput)                  --include the library into the player class

function player:initialize()            --setup the class members
    self.x=400
    self.y=300
end

function love.load()
    p=player:new()                      --create a new player object
    p:newbutton("up",keyboard("w"))     --create buttons
    p:newbutton("down",keyboard("s"))
    p:newbutton("left",keyboard("a"))
    p:newbutton("right",keyboard("d"))

    p.inputs.up:addDetector(keyboard("up"))
    p.inputs.down:addDetector(keyboard("down"))
    p.inputs.left:addDetector(keyboard("left"))
    p.inputs.right:addDetector(keyboard("right"))
end

function love.update(dt)
    p:inputUpdate()                     --updates all inputs, required

    if p.inputs.up("down") then         --inputs are checked like functions
        p.y=p.y-(100*dt)
    elseif p.inputs.down("down") then
        p.y=p.y+(100*dt)
    end

    if p.inputs.left("down") then
        p.x=p.x-(100*dt)
    elseif p.inputs.right("down") then
        p.x=p.x+(100*dt)
    end
end

function love.draw()
    love.graphics.setColor(0,0,255)
    love.graphics.rectangle("fill",p.x,p.y,20,20)
    love.graphics.print(p.x .." ".. p.y)
end
