local TextRenderer = ECS.system({
    camera = {"camera", "position"},
    pool = {"textElement", "position", "color"},
})

local function linear(t, b, c, d) return c * t / d + b end
local function outCubic(t, b, c, d) return c * (math.pow(t / d - 1, 3) + 1) + b end

function TextRenderer:draw()
    love.graphics.push("all")
    love.graphics.translate(self.camera[1].position.x, self.camera[1].position.y)

    local font = self:getWorld().singletons.font
    love.graphics.setFont(font)

    for _, e in ipairs(self.pool) do
        local x = e.position.x
        local y = e.position.y

        -- if (e:has("selectable")) then
            local width = font:getWidth(e.textElement.content)
            local height = font:getHeight()

            if (e:has("selected")) then
                love.graphics.setColor({0, 0, 0, 0.3})
                love.graphics.rectangle("fill", x, y, width, height)
            end
        -- end

        love.graphics.setColor(e.color.value)
        love.graphics.print(e.textElement.content, x, y)
    end

    love.graphics.pop()
end

return TextRenderer
