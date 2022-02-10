local CameraController = ecs.system({

})

function CameraController:init()
    self:updateFont()
end

function CameraController:mousemoved(x, y, dx, dy)
    if (love.mouse.isDown(3)) then
        self:getWorld().singletons.camera.x = self:getWorld().singletons.camera.x + dx
        self:getWorld().singletons.camera.y = self:getWorld().singletons.camera.y + dy
    end
end

function CameraController:wheelmoved(dx, dy)
    if (love.keyboard.isDown("lctrl")) then
        self:getWorld().singletons.camera.scale = math.max(4, self:getWorld().singletons.camera.scale + dy)
        self:updateFont()

        self:getWorld():emit("transformDataToText")
    else
        self:getWorld().singletons.camera.y = self:getWorld().singletons.camera.y + (dy * 30)
    end
end

function CameraController:updateFont()
    love.graphics.setNewFont("assets/FiraCode-Regular.ttf", math.floor(self:getWorld().singletons.camera.scale + 0.5))
end

return CameraController