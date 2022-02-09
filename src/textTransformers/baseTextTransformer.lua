local Class = require("lib.middleclass")

local Colors = require("src.colors")

local BaseTextTransformer = Class("BaseTextTransformer")

function BaseTextTransformer:initialize(control)
    self.control = control
end

function BaseTextTransformer:transform(codeElements)
    for _, codeElement in ipairs(codeElements) do
        if (codeElement:has("struct")) then
            self.control:scoped(self, codeElement.codeElement.identifier, codeElement, self.transformStruct)
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
        self.control:scoped(self, field.codeElement.identifier, field, self.transformStructField)
        self.control:newLine()
    end
    self.control:print("closeBrace", "}", Colors.syntax.text)
    self.control:newLine()
end

function BaseTextTransformer:transformStructField(field)
    self.control:print("identifier", field.codeElement.identifier, Colors.syntax.field)
    self.control:space()
    self.control:print("typeIndicator", ":", Colors.syntax.text)
    self.control:space()
    self.control:print("type", field.field.type.codeElement.identifier, Colors.syntax.type)
    self.control:print("terminator", ";", Colors.syntax.text)
end

return BaseTextTransformer