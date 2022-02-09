local BaseTextTransformer = require("src.textTransformers.baseTextTransformer")
local FunkyTextTransformer = require("src.textTransformers.funkyTextTransformer")
local WeirdBrachesTextTransformer = require("src.textTransformers.weirdBrachesTextTransformer")

local TextTransformer = ecs.system({
    pool = {"codeElement", "visible"},
    old = {"textElement"}
})

function TextTransformer:init()
    self.dirty = false

    self.pool.onAdded = function(pool, e) self.dirty = true end
    self.pool.onRemoved = function(pool, e) self.dirty = true end

    self.cursor = {x = 0, y = 0}
    self.output = {}

    self.identifierTree = {}
    self.currentIdentifierScope = {self.identifierTree}

    self.previousIdentifierTree = {}
    self.previousIdentifierScope = {}

    self.previousSelectable = nil

    self.textTransformer = BaseTextTransformer(self)

    self.toDelete = {}
end

function TextTransformer:scoped(textTransformer, identifier, element, func, ...)
    local scope = {}
    self.currentIdentifierScope[#self.currentIdentifierScope][identifier] = scope
    self.currentIdentifierScope[#self.currentIdentifierScope + 1] = scope

    local previous = self.previousIdentifierScope[#self.previousIdentifierScope] and self.previousIdentifierScope[#self.previousIdentifierScope][identifier]
    if (previous) then
        self.previousIdentifierScope[#self.previousIdentifierScope + 1] = previous
    end

    func(textTransformer, element, ...)

    if (previous) then
        self.previousIdentifierScope[#self.previousIdentifierScope] = nil
    end
    self.currentIdentifierScope[#self.currentIdentifierScope] = nil
end

function TextTransformer:print(rawIdentifier, text, color, selectableCodeElement)
    local previousScope = self.previousIdentifierScope[#self.previousIdentifierScope]

    if (previousScope and previousScope[rawIdentifier]) then
        local e = previousScope[rawIdentifier]

        e.textElement.text = text
        e.textElement.oldPosition = e.textElement.position
        e.textElement.position = {x = self.cursor.x, y = self.cursor.y}
        e.textElement.color = color

        self.toDelete[e] = nil
        print("updated", rawIdentifier)
    else
        local position = {x = self.cursor.x, y = self.cursor.y}

        local e = ecs.entity()
        e:give("textElement", text, position, color)

        self:getWorld():addEntity(e)

        self.currentIdentifierScope[#self.currentIdentifierScope][rawIdentifier] = e

        print("made", rawIdentifier)
    end

    -- if (selectableCodeElement) then
    --     e:give("selectable", selectableCodeElement, self.previousSelectable, nil, self.depth)

    --     if (self.previousSelectable) then
    --         self.previousSelectable.selectable.next = e
    --     end

    --     self.previousSelectable = e
    -- end

    local font = love.graphics.getFont()
    self.cursor.x = self.cursor.x + font:getWidth(text)
end

function TextTransformer:space()
    local font = love.graphics.getFont()
    self.cursor.x = self.cursor.x + font:getWidth(" ")
end

function TextTransformer:indent()
    local font = love.graphics.getFont()
    local fraction = font:getWidth(" ") * 0.1

    self.cursor.x = self.cursor.x + (self:getWorld().singletons.indentDepth * fraction)
end

function TextTransformer:outdent()
    local font = love.graphics.getFont()
    local fraction = font:getWidth(" ") * 0.1

    self.cursor.x = self.cursor.x - (self:getWorld().singletons.indentDepth * fraction)
end

function TextTransformer:newLine()
    local font = love.graphics.getFont()
    self.cursor.x = 0
    self.cursor.y = self.cursor.y + font:getHeight()
end

function TextTransformer:reset()
    self.cursor.x = 0
    self.cursor.y = 0

    self.depth = 0

    self.output = {}

    self.previousIdentifierTree = self.identifierTree
    self.previousIdentifierScope = {self.previousIdentifierTree}

    self.identifierTree = {}
    self.currentIdentifierScope = {self.identifierTree}

    for _, e in ipairs(self.old) do
        self.toDelete[e] = true
    end
end

function TextTransformer:update(dt)
    self:getWorld().singletons.animationTimer.timer = self:getWorld().singletons.animationTimer.timer + dt

    if (self.dirty) then
        self.dirty = false
        self:transformDataToText()
    end
end

function TextTransformer:keypressed(key)
    self:getWorld().singletons.animationTimer.timer = 0

    print('----')

    if (key == "[") then
        self.textTransformer = BaseTextTransformer(self)
        self:transformDataToText()
    end

    if (key == "]") then
        self.textTransformer = FunkyTextTransformer(self)
        self:transformDataToText()
    end

    if (key == "=") then
        self.textTransformer = WeirdBrachesTextTransformer(self)
        self:transformDataToText()
    end
end

function TextTransformer:transformDataToText()
    self:reset()

    self.textTransformer:transform(self.pool)

    for e, _ in pairs(self.toDelete) do
        e:destroy()
    end
    self.toDelete = {}

    self:getWorld().singletons.textOutput = self.output
end

return TextTransformer
