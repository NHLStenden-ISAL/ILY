local Cursor = ecs.system({
    selected = {"textElement", "selected", "selectable"},
    selectable = {"textElement", "selectable"},
})

function Cursor:keypressed(key)
    if (key == "up") then
        for _, e in ipairs(self.selected) do
            local up = e.selectable.up and e.selectable.up[1]

            if (up) then
                e:remove("selected")
                up:give("selected")
            end
        end
    end

    if (key == "down") then
        if (#self.selected == 0) then
            self.selectable:get(1):give("selected")
        end

        for _, e in ipairs(self.selected) do
            self:tryMoveDown(e)
        end
    end

    if (key == "right") then
        for _, e in ipairs(self.selected) do
            self:tryMoveRight(e)
        end
    end

    if (key == "left") then
        for _, e in ipairs(self.selected) do
            local left = e.selectable.left

            if (left) then
                e:remove("selected")
                left:give("selected")
            end
        end
    end
end

function Cursor:tryMoveRight(e)
    local right = e.selectable.right

    if (right) then
        self:getWorld().singletons.preferredDepth = self:getWorld().singletons.cursor.preferredDepth + 1

        e:remove("selected")
        right:give("selected")
    else
        self:tryMoveDown(e)
    end
end

function Cursor:tryMoveDown(e)
    local down = nil
    local depth = math.huge

    for _, selectable in ipairs(e.selectable.down) do
        print(selectable.selectable.depth)
        print(self:getWorld().singletons.cursor.preferredDepth)
        print(depth)


        if (selectable.selectable.depth <= self:getWorld().singletons.cursor.preferredDepth and selectable.selectable.depth < depth) then
            down = selectable
            depth = selectable.selectable.depth
        end
    end

    if (down) then
        e:remove("selected")
        down:give("selected")
    end
end

return Cursor