ECS.component("selectable", function(e, codeElement, depth, action)
    e.codeElement = codeElement
    e.depth = depth

    e.up = {}
    e.down = {}
    e.left = nil
    e.right = nil

    e.action = action
end)