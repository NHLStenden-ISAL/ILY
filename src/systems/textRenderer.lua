local TextRenderer = ecs.system({

})

function TextRenderer:draw()
    love.graphics.push("all")
    love.graphics.translate(self:getWorld().singletons.camera.x, self:getWorld().singletons.camera.y)
    love.graphics.scale(self:getWorld().singletons.camera.scale, self:getWorld().singletons.camera.scale)

    for _, textTransform in ipairs(self:getWorld().singletons.textOutput) do
        love.graphics.setColor(textTransform.color)
        love.graphics.print(textTransform.content, textTransform.position.x, textTransform.position.y)
    end

    love.graphics.pop()
end

return TextRenderer