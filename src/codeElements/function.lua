local Class = require("lib.middleclass")

local Function = Class("Function")

function Function:initialize(identifier, returnType)
    self.identifier = identifier
    self.returnType = returnType
    self.arguments = {}
end

function Function:addArgument(argument)
    table.insert(self.arguments, argument)
    argument.parent = self
end

function Function:indexOfArgument(argument)
    for i, o_argument in ipairs(self.arguments) do
        if (argument == o_argument) then
            return i
        end
    end

    return -1
end

return Function