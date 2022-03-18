local Cursor = ECS.system({
    camera = {"camera", "position"},
    selected = {"textElement", "position", "selected", "selectable"},
})

function Cursor:draw()
    love.graphics.push("all")
    love.graphics.translate(self.camera[1].position.x, self.camera[1].position.y)

    local font = self:getWorld().singletons.font
    love.graphics.setFont(font)

    for _, e in ipairs(self.selected) do
        local x = e.position.x
        local y = e.position.y

        do
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