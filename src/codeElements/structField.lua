local Class = require("lib.middleclass")

local StructField = Class("StructField")

function StructField:initialize(identifier, type)
    self.identifier = identifier
    self.type = type

    self.parent = nil
end

return StructField