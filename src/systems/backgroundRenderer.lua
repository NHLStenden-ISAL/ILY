local BackgroundRenderer = ECS.system({
    pool = {"background", "color"},
})

function BackgroundRenderer:draw(dt)
    for _, e in ipairs(self.pool) do
        love.graphics.clear(e.color.value)
    end
end

return BackgroundRenderer