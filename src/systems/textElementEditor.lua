local TextElementEditor = ecs.system({
    pool = {"textElement", "selected", "selectable"},
})

function TextElementEditor:textinput(t)
    for _, e in ipairs(self.pool) do
        local codeElement = e.selectable.codeElement.codeElement
        codeElement.identifier = codeElement.identifier .. t
        self:getWorld():emit("codeElementChanged", e)
    end
end

function TextElementEditor:keypressed(key)
    if (key == "backspace") then
        for _, e in ipairs(self.pool) do
            local codeElement = e.selectable.codeElement.codeElement
            codeElement.identifier = string.sub(codeElement.identifier, 0, #codeElement.identifier - 1)
            self:getWorld():emit("codeElementChanged", e)
        end

        
    end
end


return TextElementEditor