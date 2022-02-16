local Class = require("lib.middleclass")

local Colors = require("src.colors")

local BaseTextTransformer = Class("BaseTextTransformer")

function BaseTextTransformer:initialize(control)
    self.control = control
end

function BaseTextTransformer:transform(codeElements)
    for _, codeElement in ipairs(codeElements) do
        if (codeElement:has("struct")) then
            self.control:scoped(self, codeElement.codeElement.id, codeElement, self.transformStruct)
            self.control:newLine()
        end

        if (codeElement:has("component")) then
            self.control:scoped(self, codeElement.codeElement.id, codeElement, self.transformComponent)
            self.control:newLine()
        end

        if (codeElement:has("archetype")) then
            self.control:scoped(self, codeElement.codeElement.id, codeElement, self.transformArchetype)
            self.control:newLine()
        end

        if (codeElement:has("function")) then
            self.control:scoped(self, codeElement.codeElement.id, codeElement, self.transformFunction)
            self.control:newLine()
        end
    end
end

function BaseTextTransformer:transformStruct(e)
    self.control:print("keywordStruct", "struct", Colors.syntax.keywordStruct)
    self.control:space()
    self.control:print("identifier", e.codeElement.identifier, Colors.syntax.text, e)
    self.control:space()
    self.control:print("openBrace", "{", Colors.syntax.text)
    self.control:newLine()
    for _, field in ipairs(e.struct.fields) do
        self.control:indent()
        self.control:scoped(self, field.codeElement.id, field, self.transformStructField)
        self.control:newLine()
    end
    self.control:print("closeBrace", "}", Colors.syntax.text)
    self.control:newLine()
end

function BaseTextTransformer:transformStructField(field)
    self.control:print("identifier", field.codeElement.identifier, Colors.syntax.field, field)
    self.control:space()
    self.control:print("typeIndicator", ":", Colors.syntax.text)
    self.control:space()
    self.control:print("type", field.field.type.codeElement.identifier, Colors.syntax.type, field.field.type)
    self.control:print("terminator", ";", Colors.syntax.text)
end

function BaseTextTransformer:transformComponent(e)
    self.control:print("keywordComponent", "component", Colors.syntax.keywordStruct)
    self.control:space()
    self.control:print("identifier", e.codeElement.identifier, Colors.syntax.text, e)

    if (#e.component.fields > 0) then
        self.control:space()
        self.control:print("openBrace", "{", Colors.syntax.text)
        self.control:newLine()
        for _, field in ipairs(e.component.fields) do
            self.control:indent()
            self.control:scoped(self, field.codeElement.id, field, self.transformComponentField)
            self.control:newLine()
        end
        self.control:print("closeBrace", "}", Colors.syntax.text)
    end

    self.control:newLine()
end

function BaseTextTransformer:transformComponentField(field)
    self.control:print("identifier", field.codeElement.identifier, Colors.syntax.field, field)
    self.control:space()
    self.control:print("typeIndicator", ":", Colors.syntax.text)
    self.control:space()
    self.control:print("type", field.field.type.codeElement.identifier, Colors.syntax.type, field.field.type)
    self.control:print("terminator", ";", Colors.syntax.text)
end

function BaseTextTransformer:transformArchetype(e)
    self.control:print("keywordArchetype", "archetype", Colors.syntax.keywordStruct)
    self.control:space()
    self.control:print("identifier", e.codeElement.identifier, Colors.syntax.text, e)
    self.control:space()
    self.control:print("openBrace", "{", Colors.syntax.text)
    self.control:newLine()
    for _, component in ipairs(e.archetype.components) do
        self.control:indent()
        self.control:scoped(self, component.component.codeElement.id, component, self.transformArchetypeComponent)
        self.control:newLine()
    end
    self.control:print("closeBrace", "}", Colors.syntax.text)
    self.control:newLine()
end

function BaseTextTransformer:transformArchetypeComponent(e)
    self.control:print("identifier", e.component.codeElement.identifier, Colors.syntax.keywordStruct, e.component)
    if (#e.arguments > 0) then
        self.control:print("openBrace", "(", Colors.syntax.text)
        for i, argument in ipairs(e.arguments) do
            self.control:scoped(self, argument.field.codeElement.id, argument, self.transformArchetypeComponentField, i == #e.arguments)
        end
        self.control:print("closeBrace", ")", Colors.syntax.text)
    end
end

function BaseTextTransformer:transformArchetypeComponentField(e, last)
    self.control:print("identifier", e.field.codeElement.identifier, Colors.syntax.field, e.field)
    self.control:space()
    self.control:print("assign", "=", Colors.syntax.text)
    self.control:space()
    self.control:print("value", e.value, Colors.syntax.type)

    if (not last) then
        self.control:print("seperator", ",", Colors.syntax.text)
        self.control:space()
    end
end

function BaseTextTransformer:transformFunction(e)
    self.control:print("keywordFunction", "function", Colors.syntax.keywordStruct)
    self.control:space()
    self.control:print("identifier", e.codeElement.identifier, Colors.syntax.text, e)
    self.control:print("openBrace", "(", Colors.syntax.text)
    for i, argument in ipairs(e["function"].arguments) do
        self.control:scoped(self, argument.codeElement.id, argument, self.transformFunctionArgument, i == #e["function"].arguments)
    end
    self.control:print("closeBrace", ")", Colors.syntax.text)
    self.control:space()
    self.control:print("openCurlyBrace", "{", Colors.syntax.text)
    self.control:newLine()
    self.control:print("closeCurlyBrace", "}", Colors.syntax.text)
    self.control:newLine()

end

function BaseTextTransformer:transformFunctionArgument(e, last)
    self.control:print("identifier", e.codeElement.identifier, Colors.syntax.field, e)
    self.control:space()
    self.control:print("typeIndicator", ":", Colors.syntax.text)
    self.control:space()
    self.control:print("type", e.functionArgument.type.codeElement.identifier, Colors.syntax.type, e.functionArgument.type)

    if (not last) then
        self.control:print("seperator", ",", Colors.syntax.text)
        self.control:space()
    end
end

return BaseTextTransformer