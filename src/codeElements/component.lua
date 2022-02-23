local Class = require("lib.middleclass")

local Component = Class("Component")

function Component:initialize(identifier)
    self.identifier = identifier
    self.fields = {}

    self.root = true
end

function Component:addField(field)
    table.insert(self.fields, field)
    field.parent = self
end

return Component