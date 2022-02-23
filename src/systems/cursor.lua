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

function Cursor:update(dt)
    for _, e in ipairs(self.selected) do
        e.selected.timeSinceLastMove = e.selected.timeSinceLastMove + dt
    end
end

function Cursor:trySelectFirstSelectable()
    if (#self.selectable ~= 0) then
        local e = self.selectable:get(1)
        e:give("selected", e.selectable.depth, #e.textElement.content)
    end
end

function Cursor:selectOther(from, to, preferOtherDepth, toEnd)
    local preferredDepth = preferOtherDepth and to.selectable.depth or from.selected.preferredDepth
    to:give("selected", preferredDepth, toEnd and #to.textElement.content or 0)
    from:remove("selected")
end

function Cursor:keypressed(key)
    if (key == "tab") then
        if (self:getWorld().singletons.textNavigationMode == "global") then
            self:getWorld().singletons.textNavigationMode = "local"
        else
            self:getWorld().singletons.textNavigationMode = "global"
        end
    end

    for _, e in ipairs(self.selected) do
        if (love.keyboard.isDown("lctrl")) then
            if (key == "left") then
                local text = e.textElement.content

                local positions = {}
                local start = 1
                while true do
                    local position = text:find(" ", start, true)
                    if position == nil then
                        break
                    end
                    table.insert(positions, position)
                    start = position + 1
                end

                local best = 0
                for _, position in ipairs(positions) do
                    if position > best and position < e.selected.position.start then
                        best = position
                    end
                end

                if (love.keyboard.isDown("lshift")) then
                    e.selected.position.start = best
                    e.selected.timeSinceLastMove = 0
                else
                    if (best == e.selected.position.start) then
                        self:tryMoveLeft(e)
                    else
                        e.selected.position.start = best
                        e.selected.position.stop = e.selected.position.start
                        e.selected.timeSinceLastMove = 0
                    end
                end
            end

            if (key == "right") then
                local text = e.textElement.content

                local positions = {}
                local start = 1
                while true do
                    local position = text:find(" ", start, true)
                    if position == nil then
                        break
                    end
                    table.insert(positions, position - 1)
                    start = position + 1
                end

                local best = #e.textElement.content
                for _, position in ipairs(positions) do
                    if position < best and position > e.selected.position.start then
                        best = position
                    end
                end

                if (love.keyboard.isDown("lshift")) then
                    e.selected.position.start = best
                    e.selected.timeSinceLastMove = 0
                else
                    if (best == e.selected.position.start) then
                        self:tryMoveRight(e)
                    else
                        e.selected.position.start = best
                        e.selected.position.stop = e.selected.position.start
                        e.selected.timeSinceLastMove = 0
                    end
                end
            end
        else
            if (key == "up") then self:tryMoveUp(e) end
            if (key == "down") then self:tryMoveDown(e) end

            if (key == "left") then
                if (e.selected.position.start == 0) then
                    if (key == "left") then self:tryMoveLeft(e) end
                else
                    e.selected.position.start = math.max(0, e.selected.position.start - 1)

                    if (not love.keyboard.isDown("lshift")) then
                        e.selected.position.stop = e.selected.position.start
                    end

                    e.selected.timeSinceLastMove = 0
                end
            end

            if (key == "right") then
                if (e.selected.position.start == #e.textElement.content) then
                    self:tryMoveRight(e)
                else
                    e.selected.position.start = math.min(#e.textElement.content, e.selected.position.start + 1)

                    if (not love.keyboard.isDown("lshift")) then
                        e.selected.position.stop = e.selected.position.start
                    end

                    e.selected.timeSinceLastMove = 0
                end
            end

            if (key == "home") then
                e.selected.position.start = 0

                if (not love.keyboard.isDown("lshift")) then
                    e.selected.position.stop = 0
                end

                e.selected.timeSinceLastMove = 0
            end

            if (key == "end") then
                e.selected.position.start = #e.textElement.content

                if (not love.keyboard.isDown("lshift")) then
                    e.selected.position.stop = e.selected.position.start
                end

                e.selected.timeSinceLastMove = 0
            end
        end
    end
end

function Cursor:tryMoveLeft(e)
    local left = e.selectable.left

    if (left) then
        self:selectOther(e, left, false, true)
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
            self:selectOther(e, up, false, true)
        end
    end
end

function Cursor:tryMoveRight(e)
    local right = e.selectable.right

    if (right) then
        self:selectOther(e, right, false, false)
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
            self:selectOther(e, down, false, false)
        end
    end
end

function Cursor:tryMoveDown(e)
    local down = nil
    local depth = 0

    for _, oe in ipairs(e.selectable.down) do
        if (oe.selectable.depth <= e.selectable.depth and oe.selectable.depth > depth) then
            down = oe
            depth = oe.selectable.depth
        end
    end

    if (down) then
        self:selectOther(e, down, false)

        return depth
    end
end

function Cursor:tryMoveUp(e)
    local up = nil
    local depth = 0

    for _, oe in ipairs(e.selectable.up) do
        if (oe.selectable.depth <= e.selectable.depth and oe.selectable.depth > depth) then
            up = oe
            depth = oe.selectable.depth
        end
    end

    if (up) then
        self:selectOther(e, up, false)

        return depth
    end
end

return Cursor