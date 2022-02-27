local Cursor = ecs.system({
    selected = {"textElement", "position", "selected", "selectable"},
})

local function linear(t, b, c, d) return c * t / d + b end
local function outCubic(t, b, c, d) return c * (math.pow(t / d - 1, 3) + 1) + b end

function Cursor:draw()
    love.graphics.push("all")
    love.graphics.translate(self:getWorld().singletons.camera.x,
                            self:getWorld().singletons.camera.y)

    local font = self:getWorld().singletons.font
    love.graphics.setFont(font)

    for _, e in ipairs(self.selected) do
        local x = e.position.x
        local y = e.position.y

        if (e:has("animatePosition")) then
            local oldX = e.animatePosition.x
            local oldY = e.animatePosition.y

            local time = e.animatePosition.animationTime
            local duration = e.animatePosition.animationDuration

            local clampedTime = math.min(time, duration)

            x = outCubic(clampedTime, oldX, x - oldX, duration)
            y = outCubic(clampedTime, oldY, y - oldY, duration)
        end

        do -- Cursor 
            local x1 = x + font:getWidth(" ") * e.selected.position.start
            local y1 = y + 2
            local x2 = x1
            local y2 = y1 + font:getHeight() - 4

            local opacity = (math.cos(e.selected.timeSinceLastMove * 4) + 1)

            love.graphics.setColor(1, 1, 1, opacity)
            love.graphics.line(x1, y1, x2, y2)
        end

        if (e.selected.position.start ~= e.selected.position.stop) then
            local x1 = x + font:getWidth(" ") * e.selected.position.start
            local y1 = y + font:getHeight()
            local x2 = x + font:getWidth(" ") * e.selected.position.stop
            local y2 = y1

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.line(x1, y1, x2, y2)
        end
    end

    love.graphics.pop()
end

return Cursor