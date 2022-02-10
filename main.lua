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
    scale = 24,
}
world.singletons.textOutput = {}
world.singletons.selectors = {}
world.singletons.cursor = {
    selected = nil
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

local foo

do
    local e = ecs.entity()
    :give("codeElement", "foo")
    :give("struct", {})
    :give("visible")
    world:addEntity(e)

    do
        local field = ecs.entity()
        :give("codeElement", "a")
        :give("field", typeNumber)
        -- :give("selected")
        world:addEntity(field)

        table.insert(e.struct.fields, field)
    end

    do
        local field = ecs.entity()
        :give("codeElement", "b")
        :give("field", typeString)
        -- :give("selected")
        world:addEntity(field)

        table.insert(e.struct.fields, field)
    end

    foo = e
end

do
    local e = ecs.entity()
    :give("codeElement", "bar")
    :give("struct", {})
    :give("visible")
    world:addEntity(e)

    local field = ecs.entity()
    :give("codeElement", "c")
    :give("field", foo)
    world:addEntity(field)

    table.insert(e.struct.fields, field)
end

do
    local e = ecs.entity()
    :give("codeElement", "qux")
    :give("struct", {})
    :give("visible")
    world:addEntity(e)

    local field = ecs.entity()
    :give("codeElement", "d")
    :give("field", foo)
    world:addEntity(field)

    table.insert(e.struct.fields, field)
end

do
    local e = ecs.entity()
    :give("codeElement", "quux")
    :give("struct", {})
    :give("visible")
    world:addEntity(e)

    do
        local field = ecs.entity()
        :give("codeElement", "e")
        :give("field", typeString)
        world:addEntity(field)

        table.insert(e.struct.fields, field)
    end

    do
        local field = ecs.entity()
        :give("codeElement", "f")
        :give("field", typeBoolean)
        world:addEntity(field)

        table.insert(e.struct.fields, field)
    end

    do
        local field = ecs.entity()
        :give("codeElement", "g")
        :give("field", typeNumber)
        world:addEntity(field)

        table.insert(e.struct.fields, field)
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