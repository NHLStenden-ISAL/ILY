local id = 0

ecs.component("codeElement", function(e, identifier)
    e.identifier = identifier
    e.id = id

    id = id + 1
end)