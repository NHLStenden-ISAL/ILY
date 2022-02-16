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

local fontSmall = love.graphics.newFont("assets/FiraCode-Regular.ttf", 12)

love.graphics.setBackgroundColor(0.15, 0.15, 0.15, 1.0)
love.keyboard.setKeyRepeat(true)

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
    x = 350,
    y = 50,
    scale = 20,
}
world.singletons.textOutput = {}
world.singletons.selectors = {}
world.singletons.cursor = {
    preferredDepth = 1
}
world.singletons.animationTimer = {
    timer = 0
}

world:addSystems(
    -- systems.codeInserter,
    systems.cameraController,
    systems.textElementEditor,
    systems.textTransformer,
    systems.cursor,
    systems.textRenderer
)

local typeNumber = ecs.entity()
:give("codeElement", "number")
world:addEntity(typeNumber)

local typeBoolean = ecs.entity()
:give("codeElement", "boolean")
world:addEntity(typeBoolean)

local typeString = ecs.entity()
:give("codeElement", "string")
world:addEntity(typeString)

local typeEntity = ecs.entity()
:give("codeElement", "entity")
world:addEntity(typeEntity)

local typeEntityPosition = ecs.entity()
:give("codeElement", "entity<position>")
world:addEntity(typeEntityPosition)

local position, velocity, targetting, controllable
local position_x, position_y
local velocity_vx, velocity_vy
local targetting_target, targetting_power

do
    local e = ecs.entity()
    :give("codeElement", "position")
    :give("component", {})
    :give("visible")
    world:addEntity(e)

    do
        local field = ecs.entity()
        :give("codeElement", "x")
        :give("field", typeNumber)

        world:addEntity(field)

        table.insert(e.component.fields, field)

        position_x = field
    end

    do
        local field = ecs.entity()
        :give("codeElement", "y")
        :give("field", typeNumber)

        world:addEntity(field)

        table.insert(e.component.fields, field)

        position_y = field
    end

    position = e
end

do
    local e = ecs.entity()
    :give("codeElement", "velocity")
    :give("component", {})
    :give("visible")
    world:addEntity(e)

    do
        local field = ecs.entity()
        :give("codeElement", "vx")
        :give("field", typeNumber)

        world:addEntity(field)

        table.insert(e.component.fields, field)

        velocity_vx = field
    end

    do
        local field = ecs.entity()
        :give("codeElement", "vy")
        :give("field", typeNumber)

        world:addEntity(field)

        table.insert(e.component.fields, field)

        velocity_vy = field
    end

    velocity = e
end

do
    local e = ecs.entity()
    :give("codeElement", "targetting")
    :give("component", {})
    :give("visible")
    world:addEntity(e)

    do
        local field = ecs.entity()
        :give("codeElement", "target")
        :give("field", typeEntityPosition)

        world:addEntity(field)

        table.insert(e.component.fields, field)
        
        targetting_target = field
    end

    do
        local field = ecs.entity()
        :give("codeElement", "power")
        :give("field", typeNumber)

        world:addEntity(field)

        table.insert(e.component.fields, field)

        targetting_power = field
    end

    targetting = e
end

do
    local e = ecs.entity()
    :give("codeElement", "controllable")
    :give("component", {})
    :give("visible")
    world:addEntity(e)

    controllable = e
end

do
    local e = ecs.entity()
    :give("codeElement", "player")
    :give("archetype", {
        {
            component = position,
            arguments = {},
        },
        {
            component = velocity,
            arguments = {
                {field = velocity_vx, value = 0},
                {field = velocity_vy, value = 0},
            },
        },
        {
            component = controllable,
            arguments = {},
        },
    })
    :give("visible")
    world:addEntity(e)
end

do
    local e = ecs.entity()
    :give("codeElement", "enemy slow")
    :give("archetype", {
        {
            component = position,
            arguments = {},
        },
        {
            component = velocity,
            arguments = {
                {field = velocity_vx, value = 0},
                {field = velocity_vy, value = 0},
            },
        },
        {
            component = targetting,
            arguments = {
                {field = targetting_power, value = 10}
            },
        },
    })
    :give("visible")
    world:addEntity(e)
end

do
    local e = ecs.entity()
    :give("codeElement", "enemy fast")
    :give("archetype", {
        {
            component = position,
            arguments = {},
        },
        {
            component = velocity,
            arguments = {
                {field = velocity_vx, value = 0},
                {field = velocity_vy, value = 0},
            },
        },
        {
            component = targetting,
            arguments = {
                {field = targetting_power, value = 30}
            },
        },
    })
    :give("visible")
    world:addEntity(e)
end

do
    local e = ecs.entity()
    :give("codeElement", "apply velocity")
    :give("function", {})
    :give("visible")
    world:addEntity(e)

    do
        local argument = ecs.entity()
        :give("codeElement", "e")
        :give("functionArgument", typeEntity)

        world:addEntity(argument)

        table.insert(e["function"].arguments, argument)
    end

    do
        local argument = ecs.entity()
        :give("codeElement", "dt")
        :give("functionArgument", typeNumber)

        world:addEntity(argument)

        table.insert(e["function"].arguments, argument)
    end
end


function love.update(dt)
    local friction = 10;
    local ratio = 1 / (1 + (dt * friction));
    world.singletons.scrollVelocity = world.singletons.scrollVelocity * ratio

    world.singletons.indentDepth = math.max(0, world.singletons.indentDepth + world.singletons.scrollVelocity * dt)

    world:emit("update", dt)
end

function love.draw()
    world:emit("draw")

    local fps = love.timer.getFPS()
    local averageDeltatime = love.timer.getAverageDelta()
    local memoryUsage = collectgarbage("count")
    local stats = love.graphics.getStats()
    local name, version, vendor, device = love.graphics.getRendererInfo()

    local info = string.format([[
FPS: %u
Deltatime: %.4f

Memory usage: %u Kb

Draw calls: %u
Canvas switches: %u
Texture memory: %u Kb
Images: %u
Canvases: %u
Fonts: %u
Shader switches: %u
Draw calls batched: %u

Renderer name: %s
Renderer version: %s
Graphics card vendor: %s
Graphics card: %s
    ]], 
    fps,
    averageDeltatime,
    memoryUsage,
    stats.drawcalls, 
    stats.canvasswitches, 
    stats.texturememory / 1024,
    stats.images,
    stats.canvases,
    stats.fonts,
    stats.shaderswitches,
    stats.drawcallsbatched,
    name,
    version,
    vendor,
    device
)


    love.graphics.setColor(0.6, 0.6, 0.6, 1)
    love.graphics.setFont(fontSmall)
    love.graphics.print(info, 10, 10)
end

function love.keypressed(key)
    if (key == "1") then
        world.singletons.detail = "full"
        return;
    end
    if (key == "2") then
        world.singletons.detail = "part"
        return;
    end
    if (key == "3") then
        world.singletons.detail = "structure"
        return;
    end

    if (key == "6") then
        love.event.quit("restart")
        return;
    end

    world:emit("keypressed", key)
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

function love.textinput(t)
    if (tonumber(t) ~= nil) then
        return
    end

    world:emit("textinput", t)
end



-- local lines = love.filesystem.lines("src/locale.txt")
-- local t = {}
-- local data = ""

-- for line in lines do
--     table.insert(t, line)
-- end

-- data = data..("locale = {\r\n")
-- data = data..("\tukToUs={\r\n")
-- for i = 1, #t/2 do
--     local uk = t[i]
--     local us = t[i + #t/2]

--     data = data..("\t\t"..uk.."=".."\""..us.."\",\r\n")
-- end
-- data = data..("}\r\n")
-- data = data..("\tusToUk={\r\n")
-- for i = 1, #t/2 do
--     local uk = t[i]
--     local us = t[i + #t/2]

--     data = data..("\t\t"..us.."=".."\""..uk.."\",\r\n")
-- end
-- data = data..("}\r\n")
-- data = data..("}\r\n")

-- love.filesystem.write("output.lua", data)