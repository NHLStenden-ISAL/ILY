local AnimateTextElementStepper = ecs.system({
    animatePosition = {"animatePosition"},
    animateColor = {"animateColor"}
})

function AnimateTextElementStepper:update(dt)
    for _, e in ipairs(self.animatePosition) do
        if (e.animatePosition.animationTime == e.animatePosition.animationDuration) then
            e:remove("animatePosition")
        else
            e.animatePosition.animationTime = math.min(e.animatePosition.animationDuration, e.animatePosition.animationTime + dt)
        end
    end

    for _, e in ipairs(self.animateColor) do
        if (e.animateColor.animationTime == e.animateColor.animationDuration) then
            e:remove("animateColor")
        else
            e.animateColor.animationTime = math.min(e.animateColor.animationDuration, e.animateColor.animationTime + dt)
        end
    end
end

return AnimateTextElementStepper