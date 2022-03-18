local TextRenderer = ECS.system({
    camera = {"camera", "position"},
    pool = {"textElement", "position", "color"},
})

function TextRenderer:draw()
    love.graphics.push("all")
    love.graphics.translate(self.camera[1].position.x, self.camera[1].position.y)

    local font = self:getWorld().singletons.font
    love.graphics.setFont(font)

    for _, e in ipairs(self.pool) do
        local x = e.position.x
        local y = e.position.y

        if (e:has("selected")) then
            local width = font:getWidth(e.textElement.content)
            local height = font:getHeight()

            love.graphics.setColor({0, 0, 0, 0.3})
            love.graphics.rectangle("fill", x, y, width, height)
        end

        love.graphics.setColor(e.color.value)
        love.graphics.print(e.textElement.content, x, y)
    end

    love.graphics.pop()
end

return TextRenderer
