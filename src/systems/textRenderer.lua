local TextRenderer = ecs.system({pool = {"textElement"}})

local function lerp(a, b, t)
	return a + (b - a) * t
end

local function outCubic(t, b, c, d) return c * (math.pow(t / d - 1, 3) + 1) + b end

local function clamp(v, min, max)
    if (min > max) then
        local temp = min
        min = max
        max = min
    end


    return math.max(min, math.min(max, v))
end

function TextRenderer:draw()
    love.graphics.push("all")
    love.graphics.translate(self:getWorld().singletons.camera.x,
                            self:getWorld().singletons.camera.y)

    local font = love.graphics.getFont()

    -- for _, textTransform in ipairs(self:getWorld().singletons.textOutput) do
    --     local x = textTransform.position.x
    --     local y = textTransform.position.y

    --     love.graphics.setColor(textTransform.color)
    --     love.graphics.print(textTransform.content, x, y)

    --     if (textTransform.selectable) then
    --         local width = font:getWidth(textTransform.content)
    --         local height = font:getHeight()

    --         love.graphics.line(x, y + height - 2, x + width, y + height - 2)
    --     end
    -- end

    for _, e in ipairs(self.pool) do
        local oldx = e.textElement.oldPosition.x
        local oldy = e.textElement.oldPosition.y
        local newx = e.textElement.position.x
        local newy = e.textElement.position.y

        -- local t = math.min(1, self:getWorld().singletons.animationTimer.timer / 0.2)

        local t = self:getWorld().singletons.animationTimer.timer
        local maxt = 0.3
        -- local x = lerp(oldx, newx, t)
        -- local y = lerp(oldy, newy, t)
        local x = outCubic(math.min(t, maxt), oldx, newx - oldx, maxt)
        local y = outCubic(math.min(t, maxt), oldy, newy - oldy, maxt)

        if (e:has("selectable")) then
            local width = font:getWidth(e.textElement.content)
            local height = font:getHeight()
            
            if (e:has("selected")) then
                love.graphics.setColor({0.3, 0.3, 0.3, 1})
                love.graphics.rectangle("fill", x, y, width, height)
            end
            
            love.graphics.setColor({1, 1, 1, 1})
            -- love.graphics.line(x, y + height - 2, x + width, y + height - 2)
        end
        
        local a = e.textElement.color[4]
        if (e.textElement.new) then
            a = outCubic(math.min(t, maxt), 0, e.textElement.color[4], maxt)

            if (t >= maxt) then
                e.textElement.new = false
            end
        end
        love.graphics.setColor(e.textElement.color[1], e.textElement.color[2], e.textElement.color[3], a)
        love.graphics.print(e.textElement.content, x, y)

    end

    love.graphics.pop()
end

return TextRenderer
