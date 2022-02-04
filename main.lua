local launch_type = arg[2]
if launch_type == "test" or launch_type == "debug" then
    lldebugger = require "lldebugger"

    if launch_type == "debug" then
        lldebugger.start()
    end
end

local love_errorhandler = love.errhand

function love.errorhandler(msg)
    if lldebugger then
        lldebugger.start()
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end

love.graphics.setNewFont("assets/FiraCode-Regular.ttf", 24)
love.graphics.setBackgroundColor(0.15, 0.15, 0.15, 1.0)

ecs = require("lib.concord")

local systems = {}
ecs.utils.loadNamespace("src/components")
ecs.utils.loadNamespace("src/systems", systems)

local world = ecs.world()
world.singletons = {}

world.singletons.indentDepth = 40
world.singletons.detail = "full"
world.singletons.scrollVelocity = 0
world.singletons.camera = {
    x = 200,
    y = 200,
    scale = 1,
}
world.singletons.textOutput = {}
world.singletons.codeElementsSequence = {
    root = nil
}

world:addSystems(
    systems.codeInserter,
    systems.cameraController,
    systems.codeElementSequenceUpdater,
    systems.textTransformer,
    systems.textRenderer
)

local e = ecs.entity()
:give("codeElement", "test")
:give("structData", {
    {name = "test", type = "number"}
})
:give("visible")


local e2 = ecs.entity()
:give("codeElement", "test2")
:give("structData", {
    {name = "test", type = "number"}
})
:give("visible")

local e3 = ecs.entity()
:give("codeElement", "test3")
:give("structData", {
    {name = "test", type = "number"},
    {name = "foo", type = "bar"},
})
:give("visible")

local e4 = ecs.entity()
:give("codeElement", "fntest3")
:give("functionData")
:give("visible")

e.codeElement.prev = {prev = nil, next = e}

local eto2 = {prev = e, next = e2}
e.codeElement.next = eto2
e2.codeElement.prev = eto2

local e2toe3 = {prev = e2, next = e3}
e2.codeElement.next = e2toe3
e3.codeElement.prev = e2toe3

local e3toe4  = {prev = e3, next = e4}
e3.codeElement.next = e3toe4
e4.codeElement.prev = e3toe4

e4.codeElement.next = {prev = e4, next = nil}

world:addEntity(e)
world:addEntity(e2)
world:addEntity(e3)
world:addEntity(e4)


function love.update(dt)
    local friction = 10;
    local ratio = 1 / (1 + (dt * friction));
    world.singletons.scrollVelocity = world.singletons.scrollVelocity * ratio

    world.singletons.indentDepth = math.max(0, world.singletons.indentDepth + world.singletons.scrollVelocity * dt)

    world:emit("update", dt)
    world:emit("transformDataToText")
end

function love.draw()
    world:emit("draw")
end

function love.keypressed(key)
    world:emit("keypressed", key)

    if (key == "1") then
        world.singletons.detail = "full"
        world:emit("transformDataToText")
    end
    if (key == "2") then
        world.singletons.detail = "part"
        world:emit("transformDataToText")
    end
    if (key == "3") then
        world.singletons.detail = "structure"
        world:emit("transformDataToText")
    end
    if (key == "4") then
        e:remove("codeElement")
    end
    

    if (key == "5") then
        local e = world.singletons.codeElementsSequence.root
        print("Root: " ..e.codeElement.identifier)

        while (e) do
            e = world.singletons.codeElementsSequence[e]

            if (e) then
                print(e.codeElement.identifier)
            end
        end 
    end

    if (key == "6") then
        love.event.quit("restart")
    end
end

function love.mousemoved(x, y, dx, dy)
    world:emit("mousemoved", x, y, dx, dy)
end

function love.wheelmoved(x, y)
    if (love.keyboard.isDown("lshift")) then
        world.singletons.scrollVelocity = world.singletons.scrollVelocity + y * 60
        
    else
        world:emit("wheelmoved", x, y)
        world:emit("transformDataToText")
    end
end