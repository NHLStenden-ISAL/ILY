local Class = require("lib.middleclass")

local Relation = Class("Relation")

function Relation:initialize(entityA, entityB)
    self.entityA = entityA
    self.entityB = entityB
end

function Relation:getOther(entity)
    if (entity == self.entityA) then
        return self.entityB
    end

    if (entity == self.entityB) then
        return self.entityA
    end

    return nil
end

return Relation