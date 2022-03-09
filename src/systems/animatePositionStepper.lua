local Tween = require("lib.tween")

local AnimatePositionStepper = ECS.system({
    pool = {"position", "animatePosition"},
})

function AnimatePositionStepper:update(dt)
    for _, e in ipairs(self.pool) do
        e.animatePosition.animationTime = math.min(e.animatePosition.animationDuration, e.animatePosition.animationTime + dt)

        local tween = Tween.easing[e.animatePosition.tween]

        for _, k in ipairs({"x", "y"}) do
            e.position[k] = tween(
                e.animatePosition.animationTime,
                e.animatePosition.oldPosition[k],
                e.animatePosition.newPosition[k] - e.animatePosition.oldPosition[k],
                e.animatePosition.animationDuration
            )
        end

        if (e.animatePosition.animationTime == e.animatePosition.animationDuration) then
            e:remove("animatePosition")
        end
    end
end

return AnimatePositionStepper