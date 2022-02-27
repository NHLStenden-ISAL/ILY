local PATH = (...):gsub('%.init$', '')

local CodeElements = {
    root = require(PATH..".root"),
    new = require(PATH..".new"),
    struct = require(PATH..".struct"),
    structField = require(PATH..".structField"),
    component = require(PATH..".component"),
    componentField = require(PATH..".componentField"),
    ["function"] = require(PATH..".function"),
    functionArgument = require(PATH..".functionArgument"),
}

return CodeElements