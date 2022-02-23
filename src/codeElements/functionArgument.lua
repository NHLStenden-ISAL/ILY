local Class = require("lib.middleclass")

local FunctionArgument = Class("FunctionArgument")

function FunctionArgument:initialize(name, type)
    self.name = name
    self.type = type
end

return FunctionArgument