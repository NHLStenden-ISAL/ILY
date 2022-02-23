local AnimateTextElementStepper = ecs.system({
    animateCreateTextElement = {"animateCreateTextElement"},
    animateChangeTextElement = {"animateChangeTextElement"}
})

function AnimateTextElementStepper:update(dt)
    for _, e in ipairs(self.animateCreateTextElement) do
        if (e.animateCreateTextElement.animationTime == e.animateCreateTextElement.animationDuration) then
            e:remove("animateCreateTextElement")
        else
            e.animateCreateTextElement.animationTime = math.min(e.animateCreateTextElement.animationDuration, e.animateCreateTextElement.animationTime + dt)
        end
    end

    for _, e in ipairs(self.animateChangeTextElement) do
        if (e.animateChangeTextElement.animationTime == e.animateChangeTextElement.animationDuration) then
            e:remove("animateChangeTextElement")
        else
            e.animateChangeTextElement.animationTime = math.min(e.animateChangeTextElement.animationDuration, e.animateChangeTextElement.animationTime + dt)
        end
    end
end

return AnimateTextElementStepper