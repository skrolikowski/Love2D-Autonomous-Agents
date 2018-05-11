package.path = "../?.lua;" .. package.path

function love.conf(t)
    io.stdout:setvbuf('no')

    t.identity = 'autonomous-agents'
    t.version  = '0.10.2'
    t.console  = false

    t.window.title      = 'Autonomous Agents'
    -- t.window.icon       = 'assets/ui/cursor_pointer3D.png'
    t.window.x          = 25
    t.window.y          = 25
    t.window.width      = 800
    t.window.height     = 800
    t.window.fullscreen = false
    t.window.highdpi    = true
    t.window.vsync      = true

    t.modules.physics = false
    t.modules.touch   = false
    t.modules.video   = false
end
