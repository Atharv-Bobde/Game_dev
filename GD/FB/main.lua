VIRTUAL_WIDTH=512
VIRTUAL_HEIGHT=288
WINDOW_WIDTH=1024
WINDOW_HEIGHT=600

push=require 'push'
Class= require 'class'
require 'Bird'
require 'Pipes'
require 'Pipepairs'

require 'StateMachine'
require 'states/BaseState'
require 'states/Playstate'
require 'states/Titlescreen'
require 'states/Scorescreen'
require 'states/Countstate'

background=love.graphics.newImage('textures/background.png')
background_scroll=0
BACKGROUND_SPEED=30
BACKGROUND_LOOP_POINT=413

ground=love.graphics.newImage('textures/ground.png')
ground_scroll=0
GROUND_SPEED=60

sounds={
    ["score"]=love.audio.newSource('sounds/score.wav','static'),
    ["hurt"]=love.audio.newSource('sounds/hurt.wav','static'),
    ["explosion"]=love.audio.newSource('sounds/explosion.wav','static'),
    ["music"]=love.audio.newSource('sounds/marios_way.mp3','static'),
    ["jump"]=love.audio.newSource('sounds/jump.wav','static'),
    ["go"]=love.audio.newSource('sounds/go.wav','static'),
    ["count"]=love.audio.newSource('sounds/count.wav','static')
}

scrolling=true

love.keyboard.keypressed={}



function love.load()
    love.math.getRandomSeed(os)
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT)
    love.window.setTitle("Flappy Bird")
 
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds["music"]:setLooping(true)
    sounds["music"]:play()

    sounds["music"]:setVolume(0.4)
    sounds["jump"]:setVolume(0.3)
    sounds["explosion"]:setVolume(0.4)
    sounds["hurt"]:setVolume(0.4)

    gStateMachine =StateMachine {
        ['title']=function() return Titlescreen() end,
        ['play']=function() return Playstate() end,
        ['score']=function() return Scorescreen() end,
        ['countdown']=function() return Countstate() end
    }
    gStateMachine:change('title')
end

function love.update(dt)
    if scrolling then 
        background_scroll=(background_scroll+BACKGROUND_SPEED*dt)%BACKGROUND_LOOP_POINT
        ground_scroll=(ground_scroll+GROUND_SPEED*dt)%VIRTUAL_WIDTH
    end
    gStateMachine:update(dt)
    love.keyboard.keypressed={}

end

function love.keypressed(key)
    love.keyboard.keypressed[key]=true
    if key=='escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    
    love.graphics.draw(background,-background_scroll,0)
    gStateMachine:render()
    love.graphics.draw(ground,-ground_scroll,VIRTUAL_HEIGHT-16)
    push:finish()
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keypressed[key]
end

