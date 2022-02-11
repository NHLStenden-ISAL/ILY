local Cursor = ecs.system({
    selected = {"textElement", "selected", "selectable"},
    selectable = {"textElement", "selectable"},
})

function Cursor:keypressed(key)
    if (key == "up") then
        for _, e in ipairs(self.selected) do
            local previous = e.selectable.previous

            if (love.keyboard.isDown("lctrl")) then
                previous = self:findPreviousOnDepth(e, e.selectable.depth)
            end

            if (previous) then
                e:remove("selected")
                previous:give("selected")
            end
        end
    end

    if (key == "down") then
        if (#self.selected == 0) then
            self.selectable:get(1):give("selected")
        end


        for _, e in ipairs(self.selected) do
            local next = e.selectable.next

            if (love.keyboard.isDown("lctrl")) then
                next = self:findNextOnDepth(e, e.selectable.depth)
            end

            if (next) then
                e:remove("selected")
                next:give("selected")
            end
        end
    end
end

function Cursor:findPreviousOnDepth(e, depth)
    e = e.selectable.previous

    if (e == nil) then
        return nil
    end

    while (e.selectable.depth > depth) do
        next = e.selectable.previous

        print(next)
        if (next == nil) then
            return e
        end

        e = next
    end

    return e
end

function Cursor:findNextOnDepth(e, depth)
    e = e.selectable.next

    if (e == nil) then
        return nil
    end
    
    while (e.selectable.depth > depth) do
        next = e.selectable.next

        print(next)
        if (next == nil) then
            return e
        end

        e = next
    end

    return e
end

return Cursor