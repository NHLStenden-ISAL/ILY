local Cursor = ecs.system({
    selected = {"textElement", "selected", "selectable"},
    selectable = {"textElement", "selectable"},
})

function Cursor:keypressed(key)
    if (key == "up") then
        for _, e in ipairs(self.selected) do
            self:tryMoveUp(e)
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
            self:tryMoveLeft(e)
        end
    end
end

function Cursor:tryMoveLeft(e)
    local left = e.selectable.left

    if (left) then
        self:getWorld().singletons.cursor.preferredDepth = left.selectable.depth

        e:remove("selected")
        left:give("selected")
    else
        local depth = self:tryMoveUp(e)
        if (depth) then
            self:getWorld().singletons.cursor.preferredDepth = depth
        end
    end
end

function Cursor:tryMoveRight(e)
    local right = e.selectable.right

    if (right) then
        self:getWorld().singletons.cursor.preferredDepth = right.selectable.depth

        e:remove("selected")
        right:give("selected")
    else
        local depth = self:tryMoveDown(e)
        if (depth) then
            self:getWorld().singletons.cursor.preferredDepth = depth
        end
    end
end

function Cursor:tryMoveDown(e)
    local down = nil
    local depth = 0

    for _, selectable in ipairs(e.selectable.down) do
        if (selectable.selectable.depth <= self:getWorld().singletons.cursor.preferredDepth and selectable.selectable.depth > depth) then
            down = selectable
            depth = selectable.selectable.depth
        end
    end

    if (down) then
        e:remove("selected")
        down:give("selected")

        return depth
    end
end

function Cursor:tryMoveUp(e)
    local up = nil
    local depth = 0

    for _, selectable in ipairs(e.selectable.up) do
        if (selectable.selectable.depth <= self:getWorld().singletons.cursor.preferredDepth and selectable.selectable.depth > depth) then
            up = selectable
            depth = selectable.selectable.depth
        end
    end

    if (up) then
        e:remove("selected")
        up:give("selected")

        return depth
    end
end

return Cursor