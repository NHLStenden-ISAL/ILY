local TextRenderer = ecs.system({
    structs = {"identifier", "structData"},
    functions = {"identifier", "functionData"}
})

local cursor = {
    x = 0,
    y = 0,
}

local colors = {
    text = {1.0, 1.0, 1.0, 1.0},
    keywordStruct = {115/255, 170/255, 213/255, 1.0},
    field = {156/255, 196/255, 124/255, 1.0},
    type = {236/255, 92/255, 100/255, 1.0}
}

function TextRenderer:print(text, color)
    local font = love.graphics.getFont()
    love.graphics.setColor(color or colors.text)
    love.graphics.print(text, cursor.x, cursor.y)
    cursor.x = cursor.x + font:getWidth(text)
end

function TextRenderer:space()
    local font = love.graphics.getFont()
    cursor.x = cursor.x + font:getWidth(" ")
end

function TextRenderer:indent()
    cursor.x = cursor.x + self:getWorld().singletons.indentDepth
end

function TextRenderer:newLine()
    local font = love.graphics.getFont()
    cursor.x = 0
    cursor.y = cursor.y + font:getHeight()
end

function TextRenderer:reset()
    cursor.x = 0
    cursor.y = 0
end

function TextRenderer:draw()
    love.graphics.push("all")
    love.graphics.translate(self:getWorld().singletons.camera.x, self:getWorld().singletons.camera.y)
    love.graphics.scale(self:getWorld().singletons.camera.scale, self:getWorld().singletons.camera.scale)

    self:reset()

    for _, e in ipairs(self.structs) do
        self:print("struct", colors.keywordStruct)
        self:space()
        self:print(e.identifier.value)

        if self:getWorld().singletons.detail == "part" or self:getWorld().singletons.detail == "full" then
            self:space()
            self:print("{")
            self:newLine()

            for _, field in ipairs(e.structData.fields) do
                if self:getWorld().singletons.detail == "full" then
                    self:indent()
                    self:print(field.name, colors.field)
                    self:space()
                    self:print(":")
                    self:space()
                    self:print(field.type, colors.type)
                    self:print(";")
                    self:newLine()
                else
                    self:indent()
                    self:print("...", colors.field)
                    self:newLine()
                end
            end
            self:print("}")
        end

        self:newLine()
        self:newLine()
    end

    for _, e in ipairs(self.functions) do
        self:print("fn", colors.keywordStruct)
        self:space()
        self:print(e.identifier.value)
        self:print("(")
        self:print(")")
        self:space()
        self:print("{")
        self:newLine()
        self:newLine()
        self:print("}")
        self:newLine()
        self:newLine()
    end

    love.graphics.pop()
end

return TextRenderer