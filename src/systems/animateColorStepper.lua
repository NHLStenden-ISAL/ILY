local Tween = require("lib.tween")

local AnimateColorStepper = ECS.system({
    pool = {"color", "animateColor"},
})

function AnimateColorStepper:update(dt)
    for _, e in ipairs(self.pool) do
        e.animateColor.animationTime = math.min(e.animateColor.animationDuration, e.animateColor.animationTime + dt)

        local tween = Tween.easing[e.animateColor.tween]

        for i = 1, 4 do
            e.color.value[i] = tween(
                e.animateColor.animationTime,
                e.animateColor.oldColor[i],
                e.animateColor.newColor[i] - e.animateColor.oldColor[i],
                e.animateColor.animationDuration
            )
        end

        if (e.animateColor.animationTime == e.animateColor.animationDuration) then
            e:remove("animateColor")
        end
    end
end

return AnimateColorStepper