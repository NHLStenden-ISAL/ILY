local launch_type = arg[2]
if launch_type == "test" or launch_type == "debug" then
    lldebugger = require "lldebugger"

    if launch_type == "debug" then
        lldebugger.start()
    end
end

---@diagnostic disable-next-line: undefined-field
local love_errorhandler = love.errhand

function love.errorhandler(msg)
    if lldebugger then
        lldebugger.start()
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end