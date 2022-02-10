local Class = require("lib.middleclass")

local Colors = require("src.colors")

local WeirdBrachesTextTransformer = Class("WeirdBracesTextFormatter")

function WeirdBrachesTextTransformer:initialize(control)
    self.control = control
end

function WeirdBrachesTextTransformer:transform(codeElements)
    for _, codeElement in ipairs(codeElements) do
        if (codeElement:has("struct")) then
            self.control:scoped(self, codeElement.codeElement.id, codeElement, self.transformStruct)
            self.control:newLine()
        end
    end
end

function WeirdBrachesTextTransformer:transformStruct(e)
    self.control:print("keywordStruct", "struct", Colors.syntax.keywordStruct)
    self.control:space()
    self.control:print("identifier", e.codeElement.identifier, Colors.syntax.text, e)
    self.control:newLine()
    self.control:print("openBrace", "{", Colors.syntax.text)
    self.control:newLine()
    for _, field in ipairs(e.struct.fields) do
        self.control:indent()
        self.control:scoped(self, field.codeElement.id, field, self.transformStructField)
        self.control:newLine()
    end
    self.control:print("closeBrace", "}", Colors.syntax.text)
    self.control:print("terminator", ";", Colors.syntax.text)
    self.control:newLine()
end

function WeirdBrachesTextTransformer:transformStructField(field)
    self.control:print("type", field.field.type.codeElement.identifier, Colors.syntax.type)
    self.control:space()
    self.control:print("typeIndicator", ":", Colors.syntax.text)
    self.control:space()
    self.control:print("identifier", field.codeElement.identifier, Colors.syntax.field)
    self.control:print("terminator", ";", Colors.syntax.text)
end

return WeirdBrachesTextTransformer