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

local Themes = require("src.themes")

local function linear(t, b, c, d) return c * t / d + b end
local oldBackgroundColor = Themes.current.colors.background
local backgroundColor = oldBackgroundColor

love.graphics.setBackgroundColor(backgroundColor)
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
    scale = 15,
}
world.singletons.textOutput = {}
world.singletons.selectors = {}
world.singletons.animationTimer = {
    timer = 0
}
world.singletons.textNavigationMode = "global"

world:addSystems(
    -- systems.codeInserter,
    systems.cameraController,
    systems.textElementEditor,
    systems.textTransformer,
    systems.textRenderer,
    systems.animateTextElementStepper,
    systems.cursor,
    systems.cursorRenderer
)

local CodeElements = require("src.codeElements")

local structNumber = ecs.entity(world)
:give("codeElement", CodeElements.struct("number"))

local structBoolean = ecs.entity(world)
:give("codeElement", CodeElements.struct("boolean"))

local structString = ecs.entity(world)
:give("codeElement", CodeElements.struct("string"))

do
    local x = ecs.entity(world)
    :give("codeElement", CodeElements.componentField("x", structNumber))

    local y = ecs.entity(world)
    :give("codeElement", CodeElements.componentField("y", structNumber))

    local e = ecs.entity(world)
    :give("codeElement", CodeElements.component("position"))

    e.codeElement.codeElement:addField(x)
    e.codeElement.codeElement:addField(y)
end

do
    local vx = ecs.entity(world)
    :give("codeElement", CodeElements.componentField("vx", structNumber))

    local vy = ecs.entity(world)
    :give("codeElement", CodeElements.componentField("vy", structNumber))

    local e = ecs.entity(world)
    :give("codeElement", CodeElements.component("velocity"))

    e.codeElement.codeElement:addField(vx)
    e.codeElement.codeElement:addField(vy)
end

do
    local e = ecs.entity(world)
    :give("codeElement", CodeElements.component("controllable"))
end

do
    local n = ecs.entity(world)
    :give("codeElement", CodeElements.functionArgument("n", structNumber))

    local e = ecs.entity(world)
    :give("codeElement", CodeElements["function"]("fib", structNumber))

    e.codeElement.codeElement:addArgument(n)
end

do
    local a = ecs.entity(world)
    :give("codeElement", CodeElements.functionArgument("a", structNumber))

    local b = ecs.entity(world)
    :give("codeElement", CodeElements.functionArgument("b", structNumber))

    local e = ecs.entity(world)
    :give("codeElement", CodeElements["function"]("sum", structNumber))

    e.codeElement.codeElement:addArgument(a)
    e.codeElement.codeElement:addArgument(b)
end

do
    local structName = ecs.entity(world)
    :give("codeElement", CodeElements.functionArgument("name", structString))

    local e = ecs.entity(world)
    :give("codeElement", CodeElements["function"]("print name", structNumber))

    e.codeElement.codeElement:addArgument(structName)
end


function love.update(dt)
    local friction = 10;
    local ratio = 1 / (1 + (dt * friction));
    world.singletons.scrollVelocity = world.singletons.scrollVelocity * ratio

    world.singletons.indentDepth = math.max(0, world.singletons.indentDepth + world.singletons.scrollVelocity * dt)

    world:emit("update", dt)
end

function love.draw()
    local t = world.singletons.animationTimer.timer
    local maxt = 0.2
    local r = linear(math.min(t, maxt), oldBackgroundColor[1], backgroundColor[1] - oldBackgroundColor[1], maxt)
    local g = linear(math.min(t, maxt), oldBackgroundColor[2], backgroundColor[2] - oldBackgroundColor[2], maxt)
    local b = linear(math.min(t, maxt), oldBackgroundColor[3], backgroundColor[3] - oldBackgroundColor[3], maxt)
    local a = linear(math.min(t, maxt), oldBackgroundColor[4], backgroundColor[4] - oldBackgroundColor[4], maxt)

    love.graphics.setBackgroundColor(r, g, b, a)

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
        Themes.current = Themes.standard
        world:emit("themeChanged")

        oldBackgroundColor = backgroundColor
        backgroundColor = Themes.current.colors.background
        return;
    end
    if (key == "2") then
        Themes.current = Themes.purpor
        world:emit("themeChanged")
        oldBackgroundColor = backgroundColor
        backgroundColor = Themes.current.colors.background
        return;
    end
    if (key == "3") then
        Themes.current = Themes.oil
        world:emit("themeChanged")
        oldBackgroundColor = backgroundColor
        backgroundColor = Themes.current.colors.background
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