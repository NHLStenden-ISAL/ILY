local fontSmall = love.graphics.newFont("assets/FiraCode-Regular.ttf", 12)

local DebugRenderer = ECS.system({

})

function DebugRenderer:draw()
    local fps = love.timer.getFPS()
    local averageDeltatime = love.timer.getAverageDelta()
    local memoryUsage = collectgarbage("count")
    local stats = love.graphics.getStats()
    local name, version, vendor, device = love.graphics.getRendererInfo()

    local info = string.format([[
FPS: %u
Deltatime: %.4f

Memory usage: %u Kb

Draw calls: %u
Canvas switches: %u
Texture memory: %u Kb
Images: %u
Canvases: %u
Fonts: %u
Shader switches: %u
Draw calls batched: %u

Renderer name: %s
Renderer version: %s
Graphics card vendor: %s
Graphics card: %s
    ]], 
    fps,
    averageDeltatime,
    memoryUsage,
    stats.drawcalls, 
    stats.canvasswitches, 
    stats.texturememory / 1024,
    stats.images,
    stats.canvases,
    stats.fonts,
    stats.shaderswitches,
    stats.drawcallsbatched,
    name,
    version,
    vendor,
    device
)

    love.graphics.setColor(0.6, 0.6, 0.6, 1)
    love.graphics.setFont(fontSmall)
    love.graphics.print(info, 10, 10)
end

return DebugRenderer