local CodeInserter = ecs.system({

})

function CodeInserter:keypressed(key)
    local last = self:getLastVisible()

    if (key == "f") then
        local e = ecs.entity()
        e:give("codeElement", "anon("..love.timer.getTime()..")")
        e:give("functionData")
        e:give("visible")

        local relation = {
            prev = last,
            next = e
        }
        if (last) then
            last.codeElement.next = relation
        end
        e.codeElement.prev = relation
        e.codeElement.next = {prev = e, next = nil}

        self:getWorld():addEntity(e)
    end

    if (key == "s") then
        local e = ecs.entity()
        e:give("codeElement", "anon("..love.timer.getTime()..")")
        e:give("structData", {})
        e:give("visible")

        local relation = {
            prev = last,
            next = e
        }
        if (last) then
            last.codeElement.next = relation
        end
        e.codeElement.prev = relation
        e.codeElement.next = {prev = e, next = nil}

        self:getWorld():addEntity(e)
    end
end

function CodeInserter:getLastVisible()
    local sequence = self:getWorld().singletons.codeElementsSequence
    local last = sequence.root

    if (last == nil) then
        return nil
    end

    while (last) do
        local next = sequence[last]
        if (next == nil) then
            return last
        end
        last = next
    end
end

return CodeInserter