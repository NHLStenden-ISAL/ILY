local Class = require("lib.middleclass")

local Root = Class("Root")

function Root:initialize(identifier)
    self.codeElements = {}

    self.isRoot = true
end

function Root:addCodeElement(codeElement, i)
    i = i or #self.codeElements + 1

    table.insert(self.codeElements, i, codeElement)
    codeElement.parent = self
end

function Root:indexOfCodeElement(codeElements)
    for i, o_codeElements in ipairs(self.codeElements) do
        if (codeElements == o_codeElements) then
            return i
        end
    end

    return -1
end

return Root