local CodeInserter = ecs.system({

})

function CodeInserter:keypressed(key)
    if (key == "f") then
        local e = ecs.entity()
        e:give("identifier", "anon("..love.timer.getTime()..")")
        e:give("functionData")

        self:getWorld():addEntity(e)
    end

    if (key == "s") then
        local e = ecs.entity()
        e:give("identifier", "anon("..love.timer.getTime()..")")
        e:give("structData", {})

        self:getWorld():addEntity(e)
    end
end

return CodeInserter