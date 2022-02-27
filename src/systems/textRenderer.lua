local TextRenderer = ecs.system({
    pool = {"textElement", "position", "color"},
})

local function linear(t, b, c, d) return c * t / d + b end
local function outCubic(t, b, c, d) return c * (math.pow(t / d - 1, 3) + 1) + b end

function TextRenderer:draw()
    love.graphics.push("all")
    love.graphics.translate(self:getWorld().singletons.camera.x,
                            self:getWorld().singletons.camera.y)

    local font = self:getWorld().singletons.font
    love.graphics.setFont(font)

    for _, e in ipairs(self.pool) do
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

        -- if (e:has("selectable")) then
            local width = font:getWidth(e.textElement.content)
            local height = font:getHeight()

            if (e:has("selected")) then
                love.graphics.setColor({0, 0, 0, 0.3})
                love.graphics.rectangle("fill", x, y, width, height)
            end
        -- end

        local r = e.color.r
        local g = e.color.g
        local b = e.color.b
        local a = e.color.a

        if (e:has("animateColor")) then
            local oldR = e.animateColor.r
            local oldG = e.animateColor.g
            local oldB = e.animateColor.b
            local oldA = e.animateColor.a

            local time = e.animateColor.animationTime
            local duration = e.animateColor.animationDuration

            local clampedTime = math.min(time, duration)

            r = linear(clampedTime, oldR, r - oldR, duration)
            g = linear(clampedTime, oldG, g - oldG, duration)
            b = linear(clampedTime, oldB, b - oldB, duration)
            a = linear(clampedTime, oldA, a - oldA, duration)
        end
        love.graphics.setColor(r, g, b, a)
        love.graphics.print(e.textElement.content, x, y)
    end

    love.graphics.pop()
end

return TextRenderer
