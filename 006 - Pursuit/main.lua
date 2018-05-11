--=======================================
-- filename:    main.lua
-- author:      Shane Krolikowski
-- created:     Mar, 2018
-- description: Bootstrapper.
--=======================================

Vec2     = require 'tools.vec2'
UMath    = require 'tools.utils.math'
Steering = require 'tools.algorithms.steering'
Vehicle  = require 'entities.vehicle'

WORLD = {
    width  = love.graphics.getWidth(),
    height = love.graphics.getHeight()
}

GAME = {
    debug = false
}

love.graphics.setBackgroundColor(255,255,255,255)

local runner, pursuer, seeker

function love.load()
    runner = Vehicle(300, 10)
    runner.maxSpeed = 5
    runner.vel = Vec2():toAngle(math.pi / 2, runner.maxSpeed)

    createChasers()
end

function createChasers()
    seeker   = Vehicle(10, 200)
    seeker.color = {0,255,0,255}
    pursuer  = Vehicle(590, 200)
    pursuer.color = {255,0,255,255}
end

function love.update(dt)
    local seek    = Steering:seek(seeker, runner.pos)
    local pursuit = Steering:pursuit(pursuer, runner)

    seeker:applyForce(seek)
    pursuer:applyForce(pursuit)

    runner:update(dt)
    seeker:update(dt)
    pursuer:update(dt)

    if not runner:inBounds() then
        createChasers()
    end
end

function love.draw()
    runner:draw()
    seeker:draw()
    pursuer:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
