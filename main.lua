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

world:addSystems(
    systems.textRenderer,
    systems.codeInserter,
    systems.cameraController
)

local e = ecs.entity()
e:give("identifier", "test")
e:give("structData", {
    {name = "test", type = "number"}
})

local e2 = ecs.entity()
e2:give("identifier", "test2")
e2:give("structData", {
    {name = "test", type = "number"}
})

local e3 = ecs.entity()
e3:give("identifier", "test3")
e3:give("structData", {
    {name = "test", type = "number"},
    {name = "foo", type = "bar"}
})

local e4 = ecs.entity()
e4:give("identifier", "test3")
e4:give("functionData")

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
end

function love.draw()
    world:emit("draw")
end

function love.keypressed(key)
    world:emit("keypressed", key)

    if (key == "1") then
        world.singletons.detail = "full"
    end
    if (key == "2") then
        world.singletons.detail = "part"
    end
    if (key == "3") then
        world.singletons.detail = "structure"
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
    end
end