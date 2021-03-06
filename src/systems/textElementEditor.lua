local CodeElements = require("src.codeElements")

local TextElementEditor = ECS.system({
    pool = {"textElement", "selected", "selectable"},
})

function TextElementEditor:textinput(t)
    for _, e in ipairs(self.pool) do
        local codeElement = e.selectable.codeElement.codeElement.codeElement

        local leftPos = math.min(e.selected.position.start, e.selected.position.stop)
        local rightPos = math.max(e.selected.position.start, e.selected.position.stop)

        local left = string.sub(codeElement.identifier, 0, leftPos)
        local right = string.sub(codeElement.identifier, rightPos + 1)

        codeElement.identifier = left .. t .. right
        e.selected.position.start = leftPos + 1
        e.selected.position.stop = e.selected.position.start

        self:getWorld():emit("codeElementChanged", e)
    end
end

function TextElementEditor:keypressed(key)
    for _, e in ipairs(self.pool) do
        local action = e.selectable.action

        if (action) then
            if (key == action.key) then
                action.action(self:getWorld())
            end
        end
    end

    if (key == "return") then
        for _, e in ipairs(self.pool) do
            local codeElement = e.selectable.codeElement.codeElement.codeElement

            if (love.keyboard.isDown("lctrl")) then
                local parent = e.selectable.codeElement.parent

                local new = ECS.entity(self:getWorld())
                :give("codeElement", CodeElements.new())

                parent:addCodeElement(new, parent:indexOfCodeElement(e.selectable.codeElement))

            elseif (love.keyboard.isDown("lshift")) then
                print("Insert before")
            else
                print("Insert inside")
            end
        end

        return
    end

    if (key == "backspace") then
        for _, e in ipairs(self.pool) do
            local codeElement = e.selectable.codeElement.codeElement.codeElement

            if (e.selected.position.start == e.selected.position.stop) then
                local position = e.selected.position.start
                if (position > 0) then
                    local left = string.sub(codeElement.identifier, 0, position - 1)
                    local right = string.sub(codeElement.identifier, position + 1)

                    codeElement.identifier = left .. right
                    e.selected.position.start = e.selected.position.start - 1
                    e.selected.position.stop = e.selected.position.start

                    self:getWorld():emit("codeElementChanged", e)
                end
            else
                local leftPos = math.min(e.selected.position.start, e.selected.position.stop)
                local rightPos = math.max(e.selected.position.start, e.selected.position.stop)

                local left = string.sub(codeElement.identifier, 0, leftPos)
                local right = string.sub(codeElement.identifier, rightPos + 1)

                codeElement.identifier = left .. right

                e.selected.position.start = leftPos
                e.selected.position.stop = e.selected.position.start

                self:getWorld():emit("codeElementChanged", e)
            end
        end
    end

    if (key == "delete") then
        for _, e in ipairs(self.pool) do
            local codeElement = e.selectable.codeElement.codeElement.codeElement

            if (e.selected.position.start == e.selected.position.stop) then
                local leftPos = math.min(e.selected.position.start, e.selected.position.stop)
                local rightPos = math.max(e.selected.position.start, e.selected.position.stop)

                local left = string.sub(codeElement.identifier, 0, leftPos)
                local right = string.sub(codeElement.identifier, rightPos + 2)

                codeElement.identifier = left .. right
                e.selected.position = e.selected.position

                self:getWorld():emit("codeElementChanged", e)
            else
                local leftPos = math.min(e.selected.position.start, e.selected.position.stop)

                local rightPos = math.max(e.selected.position.start, e.selected.position.stop)

                local left = string.sub(codeElement.identifier, 0, leftPos)
                local right = string.sub(codeElement.identifier, rightPos + 1)

                codeElement.identifier = left .. right

                e.selected.position.start = leftPos
                e.selected.position.stop = e.selected.position.start

                self:getWorld():emit("codeElementChanged", e)
            end
        end
    end
end


return TextElementEditor