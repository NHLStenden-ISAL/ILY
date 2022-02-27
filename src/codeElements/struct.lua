local Class = require("lib.middleclass")

local Struct = Class("Struct")

function Struct:initialize(identifier)
    self.identifier = identifier
    self.fields = {}
end

function Struct:addField(field, i)
    table.insert(self.fields, i, field)
    field.parent = self
end

function Struct:indexOfField(field)
    for i, o_field in ipairs(self.fields) do
        if (field == o_field) then
            return i
        end
    end

    return -1
end

return Struct