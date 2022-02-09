local Cursor = ecs.system({
    selected = {"textElement", "selected", "selectable"},
})

function Cursor:keypressed(key)
    if (key == "up") then
        for _, e in ipairs(self.selected) do
            local previous = e.selectable.previous

            if (previous) then
                e:remove("selected")
                previous:give("selected")
            end
        end
    end

    if (key == "down") then
        for _, e in ipairs(self.selected) do
            local next = e.selectable.next

            if (next) then
                e:remove("selected")
                next:give("selected")
            end
        end
    end
end

return Cursor