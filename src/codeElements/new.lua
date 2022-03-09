local Class = require("lib.middleclass")

local New = Class("New")

function New:initialize()
    self.parent = nil
end

return New