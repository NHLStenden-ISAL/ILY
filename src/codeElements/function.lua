local Class = require("lib.middleclass")

local Function = Class("Function")

function Function:initialize(identifier, returnType)
    self.identifier = identifier
    self.returnType = returnType
    self.arguments = {}

    self.root = true
end

function Function:addArgument(argument)
    table.insert(self.arguments, argument)
    argument.parent = self
end

return Function