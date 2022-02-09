ecs.component("selectable", function(e, codeElement, previous, next, depth)
    e.codeElement = codeElement

    e.previous = previous
    e.next = next
    e.depth = depth
end)