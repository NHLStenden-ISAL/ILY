local id = 0

ECS.component("codeElement", function(e, codeElement)
    e.codeElement = codeElement
    e.id = id

    id = id + 1
end)