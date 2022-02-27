local Class = require("lib.middleclass")

local Component = Class("Component")

function Component:initialize(identifier)
    self.identifier = identifier
    self.fields = {}
end

function Component:addField(field, i)
    table.insert(self.fields, i, field)
    field.parent = self
end

function Component:indexOfField(field)
    for i, o_field in ipairs(self.fields) do
        if (field == o_field) then
            return i
        end
    end

    return -1
end

return Component