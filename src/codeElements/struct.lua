local Class = require("lib.middleclass")

local Struct = Class("Struct")

function Struct:initialize(identifier)
    self.identifier = identifier
    self.fields = {}

    self.root = true
end

function Struct:addField(field)
    table.insert(self.fields, field)
    field.parent = self
end

return Struct