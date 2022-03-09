require("src.debugHandler")

love.keyboard.setKeyRepeat(true)

local Themes = require("src.themes")
ECS = require("lib.concord")

local Systems = {}
ECS.utils.loadNamespace("src/components")
ECS.utils.loadNamespace("src/systems", Systems)

local World = ECS.world()
World.singletons = {}
World.singletons.indentDepth = 40

World:addSystems(
    Systems.backgroundRenderer,

    Systems.cameraController,
    Systems.textElementEditor,
    Systems.textTransformer,
    Systems.textRenderer,

    Systems.animatePositionStepper,
    Systems.animateColorStepper,

    Systems.cursor,
    Systems.cursorRenderer,

    Systems.debugRenderer
)

local CodeElements = require("src.codeElements")

local root = ECS.entity(World)
:give("codeElement", CodeElements.root())

local structNumber = ECS.entity(World)
:give("codeElement", CodeElements.struct("number"))
root.codeElement.codeElement:addCodeElement(structNumber)

local structBoolean = ECS.entity(World)
:give("codeElement", CodeElements.struct("boolean"))
root.codeElement.codeElement:addCodeElement(structBoolean)

local structString = ECS.entity(World)
:give("codeElement", CodeElements.struct("string"))
root.codeElement.codeElement:addCodeElement(structString)

do
    local x = ECS.entity(World)
    :give("codeElement", CodeElements.componentField("x", structNumber))

    local y = ECS.entity(World)
    :give("codeElement", CodeElements.componentField("y", structNumber))

    local e = ECS.entity(World)
    :give("codeElement", CodeElements.component("position"))

    e.codeElement.codeElement:addField(x, 1)
    e.codeElement.codeElement:addField(y, 2)

    root.codeElement.codeElement:addCodeElement(e)
end

do
    local vx = ECS.entity(World)
    :give("codeElement", CodeElements.componentField("vx", structNumber))

    local vy = ECS.entity(World)
    :give("codeElement", CodeElements.componentField("vy", structNumber))

    local e = ECS.entity(World)
    :give("codeElement", CodeElements.component("velocity"))

    e.codeElement.codeElement:addField(vx, 1)
    e.codeElement.codeElement:addField(vy, 2)

    root.codeElement.codeElement:addCodeElement(e)
end

do
    local e = ECS.entity(World)
    :give("codeElement", CodeElements.component("controllable"))
end

do
    local n = ECS.entity(World)
    :give("codeElement", CodeElements.functionArgument("n", structNumber))

    local e = ECS.entity(World)
    :give("codeElement", CodeElements["function"]("fib", structNumber))

    e.codeElement.codeElement:addArgument(n, 1)

    root.codeElement.codeElement:addCodeElement(e)
end

do
    local a = ECS.entity(World)
    :give("codeElement", CodeElements.functionArgument("a", structNumber))

    local b = ECS.entity(World)
    :give("codeElement", CodeElements.functionArgument("b", structNumber))

    local e = ECS.entity(World)
    :give("codeElement", CodeElements["function"]("sum", structNumber))

    e.codeElement.codeElement:addArgument(a, 1)
    e.codeElement.codeElement:addArgument(b, 2)

    root.codeElement.codeElement:addCodeElement(e)
end

do
    local structName = ECS.entity(World)
    :give("codeElement", CodeElements.functionArgument("name", structString))

    local e = ECS.entity(World)
    :give("codeElement", CodeElements["function"]("print name", structNumber))

    e.codeElement.codeElement:addArgument(structName)

    root.codeElement.codeElement:addCodeElement(e)
end

local background = ECS.entity(World)
:give("background")
:give("color", {unpack(Themes.current.colors.background)})

local camera = ECS.entity(World)
:give("camera", 800, 15)
:give("scale", 25)
:give("position", 500, 50)

function love.update(dt)
    World:emit("update", dt)
end

function love.draw()
    World:emit("draw")
end

function love.keypressed(key)
    local themes = {"standard", "purpor", "oil"}

    for i, themeName in ipairs(themes) do
        if (key == tostring(i)) then
            Themes.current = Themes[themeName]

            background:give(
                "animateColor",
                {unpack(background.color.value)},
                Themes.current.colors.background,
                0.2,
                "linear"
            )

            World:emit("themeChanged")

            return;
        end
    end

    if (key == "6") then
        love.event.quit("restart")
        return;
    end

    World:emit("keypressed", key)
end

function love.mousemoved(x, y, dx, dy)
    World:emit("mousemoved", x, y, dx, dy)
end

function love.wheelmoved(x, y)
    World:emit("wheelmoved", x, y)
end

function love.textinput(t)
    if (tonumber(t) ~= nil) then
        return
    end

    World:emit("textinput", t)
end