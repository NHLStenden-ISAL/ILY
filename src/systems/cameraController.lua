local CameraController = ECS.system({
    pool = {"camera", "position", "scale"}
})

function CameraController:init()
    self.pool.onAdded = function(_, e)
        self:updateFont(e)
    end
end

function CameraController:update(dt)
    for _, e in ipairs(self.pool) do
        local friction = e.camera.scrollFriction
        local ratio = 1 / (1 + (dt * friction));

        e.camera.scrollVelocity = e.camera.scrollVelocity * ratio

        e.position.y = e.position.y + e.camera.scrollVelocity * dt
    end
end

function CameraController:mousemoved(x, y, dx, dy)
    if (love.mouse.isDown(3)) then
        for _, e in ipairs(self.pool) do
            e.position.x = e.position.x + dx
            e.position.y = e.position.y + dy
        end
    end
end

function CameraController:wheelmoved(dx, dy)
    for _, e in ipairs(self.pool) do
        if (love.keyboard.isDown("lctrl")) then
            e.scale.value = math.max(4, e.scale.value + dy)
            self:updateFont(e)

            self:getWorld():emit("transformDataToText")
        else
            e.camera.scrollVelocity = e.camera.scrollVelocity + (dy * e.camera.scrollSensitivity)
        end
    end
end

function CameraController:updateFont(e)
    local font = love.graphics.newFont("assets/FiraCode-Regular.ttf", math.floor(e.scale.value + 0.5))
    self:getWorld().singletons.font = font
end

return CameraController