ecs.component("textElement", function(e, content, position, color)
    e.content = content
    e.position = position
    e.oldPosition = position
    e.color = color
    e.new = false
end)