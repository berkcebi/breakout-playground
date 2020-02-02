windfield = require "external.windfield.windfield"

PADDLE_WIDTH = 100
PADDLE_HEIGHT = 10
PADDLE_MARGIN = 20
PADDLE_SPEED = 400

BALL_RADIUS = 10
BALL_POSITION = {x=40, y=40}
BALL_VELOCITY = {x=360, y=360}

function love.load()
    love.window.setTitle("Playground")

    world = windfield.newWorld(0, 0, true)

    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    local wall_left = world:newRectangleCollider(-1, 0, 1, height)
    wall_left:setType("static")

    local wall_right = world:newRectangleCollider(width, 0, 1, height)
    wall_right:setType("static")

    local wall_top = world:newRectangleCollider(0, -1, width, 1)
    wall_top:setType("static")

    local paddleX = (width - PADDLE_WIDTH) / 2
    local paddleY = height - PADDLE_MARGIN - PADDLE_HEIGHT
    paddle = world:newRectangleCollider(paddleX, paddleY, PADDLE_WIDTH, PADDLE_HEIGHT)
    paddle:setType("static")

    ball = world:newCircleCollider(BALL_POSITION.x, BALL_POSITION.y, BALL_RADIUS)
    ball:setDensity(1) -- @todos: Investigate.
    ball:setRestitution(1)
    ball:setFriction(0)
    ball:setLinearVelocity(BALL_VELOCITY.x, BALL_VELOCITY.y)
end

function love.update(dt)
    world:update(dt)

    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    -- Move paddle.
    local paddleSpeed = PADDLE_SPEED
    if love.keyboard.isDown("space") then
        paddleSpeed = paddleSpeed * 4
    end

    local pedalXTranslation = 0
    if love.keyboard.isDown("left") then
        pedalXTranslation = paddleSpeed * dt * -1
    elseif love.keyboard.isDown("right") then
        pedalXTranslation = paddleSpeed * dt
    end

    local pedalX, pedalY = paddle:getPosition()
    pedalX = math.max(math.min(pedalX + pedalXTranslation, width - PADDLE_WIDTH / 2), PADDLE_WIDTH / 2)
    paddle:setPosition(pedalX, pedalY)

    -- Reset ball.
    local _, ballY = ball:getPosition()
    if ballY > height + BALL_RADIUS then
        ball:setPosition(60, 60)
        ball:setLinearVelocity(BALL_VELOCITY.x, BALL_VELOCITY.y)
    end
end

function love.draw()
    -- Draw colliders.
    -- world:draw()

    love.graphics.setColor(1, 1, 1, 0.25)

    local ballX, ballY = ball:getPosition()
    love.graphics.circle("fill", ballX, ballY, BALL_RADIUS)

    local paddleX, paddleY = paddle:getPosition()
    love.graphics.rectangle("fill", paddleX - PADDLE_WIDTH / 2, paddleY - PADDLE_HEIGHT / 2, PADDLE_WIDTH, PADDLE_HEIGHT)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
 end
