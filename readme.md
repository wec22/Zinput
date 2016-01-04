#Zinput


Zinput is a simple input library for love2d based on [tactile](https://github.com/tesselode/tactile).

It is designed to be used as a mixin for [middleclass](https://github.com/kikito/middleclass).

The name is a parody of xinput


Usage
----
###Installing
-------
- Make sure you include [middleclass](https://github.com/kikito/middleclass)
- Require the file: `local zinput = require("zinput")`
- Include the mixin into the class: `class:include(zinput)`

###Inputs
-------
######Buttons
- Create a button: `object:newbutton(name[,detector])`
- Add a detector: `object.inputs.name:addDetector(detector)`

######Axes
- Create an axis: `object:newaxis(name[,detector])`
- Add a detector: `object.inputs.name:addDetector(detector)`

###Detectors
- Detectors are functions that return the value of the input
- Button detectors return true if pressed or false if up
- Axis detectors return a value between -1 and 1

###Reading values
- Buttons and axes are read the same way `object.inputs.name([what])`
- What is either a button or axis enum. default value = "value"

###Button enums
- "value":    true if button is currently down (default)
- "prev":     true if button was down last frame
- "down":     same as "value"
- "up":       true if button is not pressed (opposite of "down")
- "pressed":  true if button was first pressed this frame
- "released": true if the button was released this frame

###Axis enums
- "value":    returns the value of the axis this frame
- "prev":     returns the value of the axis last frame
- "vel":      returns the velocity of the axis

Example
-------
```lua
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


```
