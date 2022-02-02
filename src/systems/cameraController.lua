local CameraController = ecs.system({

})

function CameraController:mousemoved(x, y, dx, dy)
    if (love.mouse.isDown(3)) then
        self:getWorld().singletons.camera.x = self:getWorld().singletons.camera.x + dx
        self:getWorld().singletons.camera.y = self:getWorld().singletons.camera.y + dy
    end
end

function CameraController:wheelmoved(dx, dy)
    if (love.keyboard.isDown("lctrl")) then
        self:getWorld().singletons.camera.scale = math.max(0.25, self:getWorld().singletons.camera.scale + dy / 10)
    else
        self:getWorld().singletons.camera.y = self:getWorld().singletons.camera.y + (dy * 30)
    end
end

return CameraController