local TestTextTransformer = require("src.textTransformers.testTextTransformer")

-- local Locale = require("src.locale")

local TextTransformer = ECS.system({
    pool = {"codeElement"},
    old = {"textElement", "position"},
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

    self.currentSelectables = {}
    self.previousSelectables = {}

    self.textTransformer = TestTextTransformer(self)

    self.toDelete = {}

    self.depth = 0
end

function TextTransformer:themeChanged()
    self.dirty = true
end

function TextTransformer:beginScope(entity)
    local scope = self.currentIdentifierScope[#self.currentIdentifierScope][entity] or {}
    self.currentIdentifierScope[#self.currentIdentifierScope][entity] = scope
    self.currentIdentifierScope[#self.currentIdentifierScope + 1] = scope

    local previous = self.previousIdentifierScope[#self.previousIdentifierScope] and self.previousIdentifierScope[#self.previousIdentifierScope][entity]
    if (previous) then
        self.previousIdentifierScope[#self.previousIdentifierScope + 1] = previous
    else
        self.previousIdentifierScope[#self.previousIdentifierScope + 1] = {}
    end

    self.depth = self.depth + 1
end

function TextTransformer:endScope(previous)
    self.depth = self.depth - 1

    self.previousIdentifierScope[#self.previousIdentifierScope] = nil
    self.currentIdentifierScope[#self.currentIdentifierScope] = nil
end

function TextTransformer:print(rawIdentifier, text, color, selectableCodeElement)
    local previousScope = self.previousIdentifierScope[#self.previousIdentifierScope]

    if (previousScope and previousScope[rawIdentifier]) then
        local e = previousScope[rawIdentifier]

        if (e.textElement.content ~= text) then
            e.textElement.content = text
        end

        if (e.position.x ~= self.cursor.x or e.position.y ~= self.cursor.y) then
            e:give("animatePosition", {x = e.position.x, y = e.position.y}, {x = self.cursor.x, y = self.cursor.y}, 0.2, "outCubic")
        end

        if (e.color.value[1] ~= color[1] or e.color.value[2] ~= color[2] or e.color.value[3] ~= color[3] or e.color.value[4] ~= color[4]) then
            e:give("animateColor", {unpack(e.color.value)}, {unpack(color)}, 0.2, "linear")
        end

        self.currentIdentifierScope[#self.currentIdentifierScope][rawIdentifier] = e
        self.toDelete[e] = nil

        if (selectableCodeElement) then
            e:give("selectable", selectableCodeElement, self.depth)

            e.selectable.up = self.previousSelectables
            e.selectable.left = #self.currentSelectables > 0 and self.currentSelectables[#self.currentSelectables] or nil
            e.selectable.down = {}
            e.selectable.right = nil

            for _, previous in ipairs(self.previousSelectables) do
                table.insert(previous.selectable.down, e)
            end

            if (#self.currentSelectables > 0) then
                self.currentSelectables[#self.currentSelectables].selectable.right = e
            end

            table.insert(self.currentSelectables, e)
        else
            e:remove("selectable")
        end
    else
        local startColor = {color[1], color[2], color[3], 0}
        local endColor = {color[1], color[2], color[3], color[4]}

        local e = ECS.entity()
        :give("textElement", text)
        :give("color")
        :give("position", self.cursor.x, self.cursor.y)
        :give("animateColor", startColor, endColor, 0.2, "linear")

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

    if (selectableCodeElement) then
        self.depth = self.depth + 1
    end
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
    if (self.dirty) then
        self.dirty = false
        self:transformDataToText()
    end
end

function TextTransformer:transformDataToText()
    self:reset()

    self.textTransformer.doInsertionPoint = self:getWorld().singletons.doInsertionPoint
    self.textTransformer:transform(self.pool)

    for e, _ in pairs(self.toDelete) do
        e:destroy()
    end
    self.toDelete = {}
end

function TextTransformer:keypressed(key)
    if (key == "tab") then
        self.textTransformer.bracesOnNewLine = not self.textTransformer.bracesOnNewLine
        self.dirty = true
    end
end

return TextTransformer
