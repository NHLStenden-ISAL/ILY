local TextRenderer = ecs.system({pool = {"textElement"}})

local function linear(t, b, c, d) return c * t / d + b end
local function outCubic(t, b, c, d) return c * (math.pow(t / d - 1, 3) + 1) + b end

function TextRenderer:draw()
    love.graphics.push("all")
    love.graphics.translate(self:getWorld().singletons.camera.x,
                            self:getWorld().singletons.camera.y)

    local font = self:getWorld().singletons.font
    love.graphics.setFont(font)

    for _, e in ipairs(self.pool) do
        local x = e.textElement.position.x
        local y = e.textElement.position.y

        if (e:has("animateChangeTextElement")) then
            local oldX = e.animateChangeTextElement.oldPosition.x
            local oldY = e.animateChangeTextElement.oldPosition.y

            local time = e.animateChangeTextElement.animationTime
            local duration = e.animateChangeTextElement.animationDuration

            local clampedTime = math.min(time, duration)

            x = outCubic(clampedTime, oldX, x - oldX, duration)
            y = outCubic(clampedTime, oldY, y - oldY, duration)
        end

        if (e:has("selectable")) then
            local width = font:getWidth(e.textElement.content)
            local height = font:getHeight()

            if (e:has("selected")) then
                love.graphics.setColor({0, 0, 0, 0.3})
                love.graphics.rectangle("fill", x, y, width, height)
            end
        end

        local r = e.textElement.color[1]
        local g = e.textElement.color[2]
        local b = e.textElement.color[3]
        local a = e.textElement.color[4]
        if (e:has("animateCreateTextElement")) then
            local time = e.animateCreateTextElement.animationTime
            local duration = e.animateCreateTextElement.animationDuration

            local clampedTime = math.min(time, duration)

            a = linear(clampedTime, 0, a, duration)
        end

        if (e:has("animateChangeTextElement")) then
            local oldR = e.animateChangeTextElement.oldColor[1]
            local oldG = e.animateChangeTextElement.oldColor[2]
            local oldB = e.animateChangeTextElement.oldColor[3]
            local oldA = e.animateChangeTextElement.oldColor[4]

            local time = e.animateChangeTextElement.animationTime
            local duration = e.animateChangeTextElement.animationDuration

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
