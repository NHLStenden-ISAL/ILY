local Class = require("lib.middleclass")

local CodeElements = require("src.codeElements")

local Themes = require("src.themes")

local TestTextTransformer = Class("TestTextTransformer")

function TestTextTransformer:initialize(control)
    self.control = control

    self.bracesOnNewLine = false
end

function TestTextTransformer:transform(codeElements)
    for _, entity in ipairs(codeElements) do
        if (entity.codeElement.codeElement.isRoot) then
            self:transformEntity(entity, true)
        end
    end
end

function TestTextTransformer:transformEntity(entity, scoped, ...)
    if (scoped) then
        self.control:beginScope(entity)
    end

---@diagnostic disable-next-line: redundant-parameter
    self[entity.codeElement.codeElement.class](self, entity, entity.codeElement.codeElement, ...)

    if (scoped) then
        self.control:endScope()
    end
end

TestTextTransformer[CodeElements.root] = function(self, entity, root)
    for _, codeElement in ipairs(root.codeElements) do
        self:transformEntity(codeElement, true)
        self.control:newLine()
    end
end

TestTextTransformer[CodeElements.new] = function(self, entity, new)
    local colors = Themes.current.colors

    self.control:print("empty", "lol", colors.syntax.text)
    self.control:newLine()
end

TestTextTransformer[CodeElements.struct] = function(self, entity, struct)
    local colors = Themes.current.colors

    self.control:print("keywordStruct", "struct", colors.syntax.keywordStruct)
    self.control:space()
    self.control:print("identifier", struct.identifier, colors.syntax.identifier, entity)
    -- self.control:print("genericsOpen", "<", colors.syntax.text)
    -- self.control:print("generic", "number", colors.syntax.field, entity)
    -- self.control:print("genericsClose", ">", colors.syntax.text)

    if (#struct.fields > 0) then
        if (self.bracesOnNewLine) then
            self.control:newLine()
        else
            self.control:space()
        end

        self.control:print("curlyBraceOpen", "{", colors.syntax.text)
        self.control:newLine()

        local maxLength = self:getFieldsMaxLength(struct.fields)

        for _, field in ipairs(struct.fields) do
            self:transformEntity(field, true, maxLength)
        end

        self.control:print("curlyBraceClose", "}", colors.syntax.text)
    else
        self.control:print("terminator", ";", colors.syntax.text)
    end

    self.control:newLine()
end

TestTextTransformer[CodeElements.structField] = function(self, entity, structField, typeIndiciatorAlign)
    local colors = Themes.current.colors

    local baseTypeIndicatorDistance = #structField.identifier

    self.control:indent()
    self.control:print("identifier", structField.identifier, colors.syntax.field, entity)

    for i = 1, typeIndiciatorAlign - baseTypeIndicatorDistance + 1 do
        self.control:space()
    end

    self.control:print("typeIndicator", ":", colors.syntax.text)
    self.control:space()

    local type = self:extract(structField.type)
    self.control:print("type", type.identifier, colors.syntax.type, structField.type)

    self.control:print("terminator", ";", colors.syntax.text)
    self.control:newLine()
end

TestTextTransformer[CodeElements.component] = function(self, entity, component)
    local colors = Themes.current.colors

    self.control:print("keywordComponent", "component", colors.syntax.keywordComponent)
    self.control:space()
    self.control:print("identifier", component.identifier, colors.syntax.identifier, entity)

    if (#component.fields > 0) then
        if (self.bracesOnNewLine) then
            self.control:newLine()
        else
            self.control:space()
        end

        self.control:print("curlyBraceOpen", "{", colors.syntax.text)
        self.control:newLine()

        local maxLength = self:getFieldsMaxLength(component.fields)

        for _, field in ipairs(component.fields) do
            self:transformEntity(field, true, maxLength)
        end

        self.control:print("curlyBraceClose", "}", colors.syntax.text)
    else
        self.control:print("terminator", ";", colors.syntax.text)
    end

    self.control:newLine()
end

TestTextTransformer[CodeElements.componentField] = function(self, entity, componentField, typeIndiciatorAlign)
    local colors = Themes.current.colors

    local baseTypeIndicatorDistance = #componentField.identifier

    self.control:indent()
    self.control:print("identifier", componentField.identifier, colors.syntax.field, entity)

    for i = 1, typeIndiciatorAlign - baseTypeIndicatorDistance + 1 do
        self.control:space()
    end

    self.control:print("typeIndicator", ":", colors.syntax.text)
    self.control:space()

    local type = self:extract(componentField.type)
    self.control:print("type", type.identifier, colors.syntax.type, componentField.type)

    self.control:print("terminator", ";", colors.syntax.text)
    self.control:newLine()
end

TestTextTransformer[CodeElements["function"]] = function(self, entity, func)
    local colors = Themes.current.colors

    local action = {
        location = "end",
        key = "return",
        action = function(world)
            local e = ECS.entity(world)
            :give("codeElement", CodeElements["function"]("temp"))

            entity.parent:addCodeElement(e, 7)
        end
    }

    self.control:print("keywordFunction", "function", colors.syntax.keywordFunction)
    self.control:space()
    self.control:print("identifier", func.identifier, colors.syntax.identifier, entity, action)
    self.control:print("parenthesesOpen", "(", colors.syntax.text)

    for i, field in ipairs(func.arguments) do
        self:transformEntity(field, true, i == #func.arguments)
    end
    self.control:print("parenthesesClose", ")", colors.syntax.text)
    self.control:space()
    self.control:print("returnTypeIndicator", ":", colors.syntax.text)
    self.control:space()
    self.control:print("type", func.returnType and func.returnType.codeElement.codeElement.identifier or "void", colors.syntax.type, func.returnType)

    if (self.bracesOnNewLine) then
        self.control:newLine()
    else
        self.control:space()
    end

    self.control:print("curlyBraceOpen", "{", colors.syntax.text)
    self.control:newLine()
    self.control:print("curlyBraceClose", "}", colors.syntax.text)
    self.control:newLine()
end

TestTextTransformer[CodeElements["functionArgument"]] = function(self, entity, functionArgument, last)
    local colors = Themes.current.colors

    self.control:print("identifier", functionArgument.name, colors.syntax.field, entity)
    self.control:space()
    self.control:print("typeIndicator", ":", colors.syntax.text)
    self.control:space()

    self.control:print("type", functionArgument.type.codeElement.codeElement.identifier, colors.syntax.type, functionArgument.type)

    if (not last) then
        self.control:print("seperator", ",", colors.syntax.text)
        self.control:space()
    end
end

function TestTextTransformer:extract(entity)
    return entity.codeElement.codeElement
end

function TestTextTransformer:getFieldsMaxLength(fields)
    local maxLength = 0

    for _, field in ipairs(fields) do
        maxLength = math.max(maxLength, #field.codeElement.codeElement.identifier)
    end

    return maxLength
end

return TestTextTransformer