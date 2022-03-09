ECS.component("animatePosition", function(e, oldPosition, newPosition, animationDuration, tween)
    e.oldPosition = oldPosition
    e.newPosition = newPosition

    e.animationTime = 0
    e.animationDuration = animationDuration

    e.tween = tween
end)