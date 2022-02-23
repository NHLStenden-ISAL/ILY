ecs.component("animateChangeTextElement", function(e, oldContent, oldPosition, oldColor, animationDuration)
    e.oldContent = oldContent
    e.oldPosition = oldPosition
    e.oldColor = oldColor

    e.animationTime = 0
    e.animationDuration = animationDuration
end)