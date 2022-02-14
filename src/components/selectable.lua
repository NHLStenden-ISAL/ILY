ecs.component("selectable", function(e, codeElement, depth)
    e.codeElement = codeElement
    e.depth = depth

    e.up = {}
    e.down = {}
    e.left = nil
    e.right = nil
end)