local CodeInserter = ecs.system({

})

function CodeInserter:keypressed(key)
    if (key == "f") then
        local e = ecs.entity()
        e:give("codeElement", "anon("..love.timer.getTime()..")")
        e:give("function")
        e:give("visible")

        self:getWorld():addEntity(e)
    end

    if (key == "s") then
        local e = ecs.entity()
        e:give("codeElement", "anon("..love.timer.getTime()..")")
        e:give("struct", {})
        e:give("visible")

        self:getWorld():addEntity(e)
    end
end

return CodeInserter