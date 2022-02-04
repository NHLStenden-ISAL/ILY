ecs.component("codeElement", function(e, identifier, prev, next)
    e.identifier = identifier
    e.prev = prev
    e.next = next
end)