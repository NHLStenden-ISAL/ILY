local Class = require("lib.middleclass")

local Colors = require("src.colors")

local FunkyTextTransformer = Class("FunkyTextTransformer")

function FunkyTextTransformer:initialize(control)
    self.control = control
end

function FunkyTextTransformer:transform(codeElements)
    for _, codeElement in ipairs(codeElements) do
        if (codeElement:has("struct")) then
            self.control:scoped(self, codeElement.codeElement.identifier, codeElement, self.transformStruct)
        end
    end

    self.control:newLine()

    for _, codeElement in ipairs(codeElements) do
        if (codeElement:has("struct")) then
            
            self.control:scoped(self, codeElement.codeElement.identifier, codeElement, self.transformStuctData)
            self.control:newLine()
        end
    end
end

function FunkyTextTransformer:transformStruct(struct)
    self.control:print("keywordStruct", "struct", Colors.syntax.keywordStruct)
    self.control:space()
    self.control:print("identifier", struct.codeElement.identifier, Colors.syntax.text, e)
    self.control:print("terminator", ";", Colors.syntax.text)
    self.control:newLine()
end

function FunkyTextTransformer:transformStuctData(struct)
    for _, field in ipairs(struct.struct.fields) do
        self.control:scoped(self, field.codeElement.identifier, field, self.transformStructField, struct)
        self.control:newLine()
    end
end

function FunkyTextTransformer:transformStructField(field, struct)
    self.control:print("structIdentifier", struct.codeElement.identifier, Colors.syntax.text)
    self.control:print("arrow", "->", Colors.syntax.text)
    self.control:print("identifier", field.codeElement.identifier, Colors.syntax.field)
    self.control:space()
    self.control:print("typeIndicator", ":", Colors.syntax.text)
    self.control:space()
    self.control:print("type", field.field.type.codeElement.identifier, Colors.syntax.type)
    self.control:print("terminator", ";", Colors.syntax.text)
end

return FunkyTextTransformer