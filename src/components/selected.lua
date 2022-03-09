ECS.component("selected", function(e, preferredDepth, position)
    e.preferredDepth = preferredDepth
    e.position = {
        start = position,
        stop = position,
    }
    e.timeSinceLastMove = 0
end)