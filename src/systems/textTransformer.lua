local BaseTextTransformer = require("src.textTransformers.baseTextTransformer")
local FunkyTextTransformer = require("src.textTransformers.funkyTextTransformer")
local WeirdBrachesTextTransformer = require("src.textTransformers.weirdBrachesTextTransformer")

local Stack = require("src.datastructures.stack")

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
    -- self.currentIdentifierScope = Stack()
    -- self.currentIdentifierScope.push(self.identifierTree)


    self.previousIdentifierTree = {}
    self.previousIdentifierScope = {}
    -- self.previousIdentifierScope = Stack()

    self.currentSelectables = {}
    self.previousSelectables = {}

    self.textTransformer = BaseTextTransformer(self)

    self.toDelete = {}

    self.depth = 0
end

function TextTransformer:scoped(textTransformer, identifier, element, func, ...)
    identifier = "codeElement-"..tostring(identifier)
    
    local scope = self.currentIdentifierScope[#self.currentIdentifierScope][identifier] or {}
    self.currentIdentifierScope[#self.currentIdentifierScope][identifier] = scope
    self.currentIdentifierScope[#self.currentIdentifierScope + 1] = scope
    
    local previous = self.previousIdentifierScope[#self.previousIdentifierScope] and self.previousIdentifierScope[#self.previousIdentifierScope][identifier]
    if (previous) then
        self.previousIdentifierScope[#self.previousIdentifierScope + 1] = previous
    else
        self.previousIdentifierScope[#self.previousIdentifierScope + 1] = {}
    end
    
    self.depth = self.depth + 1
    func(textTransformer, element, ...)
    self.depth = self.depth - 1

    if (previous) then
        self.previousIdentifierScope[#self.previousIdentifierScope] = nil
    end
    self.currentIdentifierScope[#self.currentIdentifierScope] = nil
end

function TextTransformer:print(rawIdentifier, text, color, selectableCodeElement)
    local previousScope = self.previousIdentifierScope[#self.previousIdentifierScope]

    if (previousScope and previousScope[rawIdentifier]) then
        local e = previousScope[rawIdentifier]

        e.textElement.content = text
        e.textElement.oldPosition = e.textElement.position
        e.textElement.position = {x = self.cursor.x, y = self.cursor.y}
        e.textElement.color = color
        e.textElement.new = false

        self.currentIdentifierScope[#self.currentIdentifierScope][rawIdentifier] = e
        self.toDelete[e] = nil

        if (selectableCodeElement) then
            e:give("selectable", selectableCodeElement, self.depth)

            e.selectable.up = self.previousSelectables
            e.left = #self.currentSelectables > 0 and self.currentSelectables[#self.currentSelectables] or nil

            for _, previous in ipairs(self.previousSelectables) do
                table.insert(previous.selectable.down, e)
            end

            if (#self.currentSelectables > 0) then
                self.currentSelectables[#self.currentSelectables].right = e
            end

            table.insert(self.currentSelectables, e)
        else
            e:remove("selectable")
        end
    else
        local position = {x = self.cursor.x, y = self.cursor.y}

        local e = ecs.entity()
        e:give("textElement", text, position, color)
        e.textElement.new = true

        self:getWorld():addEntity(e)

        self.currentIdentifierScope[#self.currentIdentifierScope][rawIdentifier] = e

        if (selectableCodeElement) then
            e:give("selectable", selectableCodeElement, self.depth)

            e.selectable.up = self.previousSelectables
            e.selectable.left = #self.currentSelectables > 0 and self.currentSelectables[#self.currentSelectables] or nil

            for _, previous in ipairs(self.previousSelectables) do
                table.insert(previous.selectable.down, e)
            end

            if (#self.currentSelectables > 0) then
                self.currentSelectables[#self.currentSelectables].selectable.right = e
            end

            table.insert(self.currentSelectables, e)
        end
    end

    local font = self:getWorld().singletons.font
    self.cursor.x = self.cursor.x + font:getWidth(text)
end

function TextTransformer:space()
    local font = self:getWorld().singletons.font
    self.cursor.x = self.cursor.x + font:getWidth(" ")
end

function TextTransformer:indent()
    local font = self:getWorld().singletons.font
    local fraction = font:getWidth(" ") * 0.1

    self.cursor.x = self.cursor.x + (self:getWorld().singletons.indentDepth * fraction)
end

function TextTransformer:newLine()
    local font = self:getWorld().singletons.font
    self.cursor.x = 0
    self.cursor.y = self.cursor.y + font:getHeight()

    self.depth = 0
    if (#self.currentSelectables > 0) then
        self.previousSelectables = self.currentSelectables
        self.currentSelectables = {}
    end
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

    self.currentSelectables = {}
    self.previousSelectables = {}

    for _, e in ipairs(self.old) do
        self.toDelete[e] = true
    end

    self.depth = 0
end

function TextTransformer:codeElementChanged(e)
    self.dirty = true
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
