local Cursor = ecs.system({
    selected = {"textElement", "selected", "selectable"},
    selectable = {"textElement", "selectable"},
})

function Cursor:init()
    self.selected.onRemoved = function()
        if (#self.selected == 0) then
            self:trySelectFirstSelectable()
        end
    end

    self.selectable.onAdded = function()
        if (#self.selected == 0) then
            self:trySelectFirstSelectable()
        end
    end
end

function Cursor:trySelectFirstSelectable()
    if (#self.selectable ~= 0) then
        self.selectable:get(1):give("selected")
    end
end

function Cursor:selectOther(from, to)
    to:give("selected")
    from:remove("selected")
end

function Cursor:keypressed(key)
    for _, e in ipairs(self.selected) do
        if (key == "up") then self:tryMoveUp(e) end
        if (key == "down") then self:tryMoveDown(e) end
        if (key == "left") then self:tryMoveLeft(e) end
        if (key == "right") then self:tryMoveRight(e) end
    end
end

function Cursor:tryMoveLeft(e)
    local left = e.selectable.left

    if (left) then
        self:getWorld().singletons.cursor.preferredDepth = left.selectable.depth

        self:selectOther(e, left)
    else
        local up = nil
        local depth = 0

        for _, selectable in ipairs(e.selectable.up) do
            if (selectable.selectable.depth > depth) then
                up = selectable
                depth = selectable.selectable.depth
            end
        end

        if up then
            self:selectOther(e, up)

            self:getWorld().singletons.cursor.preferredDepth = up.selectable.depth
        end
    end
end

function Cursor:tryMoveRight(e)
    local right = e.selectable.right

    if (right) then
        self:selectOther(e, right)

        self:getWorld().singletons.cursor.preferredDepth = right.selectable.depth
    else
        local down = nil
        local depth = math.huge

        for _, selectable in ipairs(e.selectable.down) do
            if (selectable.selectable.depth < depth) then
                down = selectable
                depth = selectable.selectable.depth
            end
        end

        if down then
            self:selectOther(e, down)

            self:getWorld().singletons.cursor.preferredDepth = down.selectable.depth
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
        self:selectOther(e, down)

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
        self:selectOther(e, up)

        return depth
    end
end

return Cursor