local Class = require("lib.middleclass")

local ComponentField = Class("ComponentField")

function ComponentField:initialize(identifier, type)
    self.identifier = identifier
    self.type = type

    self.parent = nil
end

return ComponentField