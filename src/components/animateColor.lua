ECS.component("animateColor", function(e, oldColor, newColor, animationDuration, tween)
    e.oldColor = oldColor
    e.newColor = newColor

    e.animationTime = 0
    e.animationDuration = animationDuration

    e.tween = tween or "linear"
end)