local TextTransformer = ecs.system({
    pool = {"codeElement", "visible"},
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

local function textTransform(content, position, color)
    return {
        content = content,
        position = position,
        color = color or colors.text,
    }
end

function TextTransformer:init()
    self.pool.onAdded = function(pool, e)
        self:transformDataToText()
    end

    self.pool.onRemoved = function(pool, e)
        self:transformDataToText()
    end

    self.cursor = {x = 0, y = 0}
    self.output = { }
end

function TextTransformer:print(text, color)
    local font = love.graphics.getFont()

    table.insert(self.output, textTransform(text, {
        x = self.cursor.x,
        y = self.cursor.y,
    }, color))

    self.cursor.x = self.cursor.x + font:getWidth(text)
end

function TextTransformer:space()
    local font = love.graphics.getFont()
    self.cursor.x = self.cursor.x + font:getWidth(" ")
end

function TextTransformer:indent()
    self.cursor.x = self.cursor.x + self:getWorld().singletons.indentDepth
end

function TextTransformer:newLine()
    local font = love.graphics.getFont()
    self.cursor.x = 0
    self.cursor.y = self.cursor.y + font:getHeight()
end

function TextTransformer:reset()
    self.cursor.x = 0
    self.cursor.y = 0

    self.output = {}
end

function TextTransformer:transformDataToText()
    self:reset()


    for _, e in ipairs(self.pool) do
        if (e:has("structData")) then
            self:__transformStruct(e)
        end

        if (e:has("functionData")) then
            self:__transformFunction(e)
        end
    end

    self:getWorld().singletons.textOutput = self.output
end

function TextTransformer:__transformStruct(e)
    self:print("struct", colors.keywordStruct)
    self:space()
    self:print(e.codeElement.identifier)

    if self:getWorld().singletons.detail == "part" or self:getWorld().singletons.detail == "full" then
        self:space()
        self:print("{")
        self:newLine()

        local maxChars = 0
        for _, field in ipairs(e.structData.fields) do
            maxChars = math.max(maxChars, #field.name)
        end

        for _, field in ipairs(e.structData.fields) do
            if self:getWorld().singletons.detail == "full" then
                self:indent()
                self:print(field.name, colors.field)
                for i = 0, (maxChars - #field.name) do
                    self:space()
                end
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

function TextTransformer:__transformFunction(e)
    self:print("fn", colors.keywordStruct)
    self:space()
    self:print(e.codeElement.identifier)
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

return TextTransformer