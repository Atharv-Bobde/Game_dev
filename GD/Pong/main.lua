VIRTUAL_HEIGHT=216
VIRTUAL_WIDTH=384
WINDOW_HEIGHT=600
WINDOW_WIDTH=1024

PADDEL_WIDTH=8
PADDEL_HEIGHT=32
PADDEL_SPEED=140

BALL_SIZE=5

LARGE_FONT=love.graphics.newFont('font.ttf',28)
SMALL_FONT=love.graphics.newFont('font.ttf',14)

GAME_STATE='menu'

push= require 'push'

player1={
    x=10,y=10,
    score=0
}
player2={
    x=VIRTUAL_WIDTH-PADDEL_WIDTH-10,
    y=VIRTUAL_HEIGHT-PADDEL_HEIGHT-10,
    score=0
}

ball={
    x=VIRTUAL_WIDTH/2-BALL_SIZE/2,
    y=VIRTUAL_HEIGHT/2-BALL_SIZE/2,
    dx=0,
    dy=0
}
serve="Player1"

hit=love.audio.newSource('Hit.wav','stream')
wall=love.audio.newSource('Blip.wav','stream')
point=love.audio.newSource('score.wav','stream')

function love.load()
    love.window.setTitle('PONG')
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest','nearest')
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT)
    reset_ball()
end

function love.update(dt)
    if love.keyboard.isDown('w') then 
        if player1.y>5 then
            player1.y=player1.y-PADDEL_SPEED*dt
        end
    elseif love.keyboard.isDown('s') then
        if player1.y<VIRTUAL_HEIGHT-PADDEL_HEIGHT-5 then
            player1.y=player1.y+PADDEL_SPEED*dt
        end
    end
    --[[if love.keyboard.isDown('up') then
        if player2.y>5 then
            player2.y=player2.y-PADDEL_SPEED*dt
        end
    elseif love.keyboard.isDown('down') then
        if player2.y<VIRTUAL_HEIGHT-PADDEL_HEIGHT-5 then
            player2.y=player2.y+PADDEL_SPEED*dt
        end
    end]]--
    
    if ball.dx>0 and ball.x>=VIRTUAL_WIDTH/2 and GAME_STATE=='play' then
        if(player2.y+4>ball.y) then
            player2.y=player2.y-PADDEL_SPEED*dt
        elseif(player2.y+PADDEL_HEIGHT-4<ball.y+BALL_SIZE) then
            player2.y=player2.y+PADDEL_SPEED*dt
        end

    end

    if GAME_STATE=='play' then
        ball.x=ball.x+ball.dx*dt
        ball.y=ball.y+ball.dy*dt

        if ball.x<=5 then
            player2.score=player2.score+1
            point:play()
            serve="Player1"
            reset_ball()

            if player2.score>=3 then
                GAME_STATE='win'
            else
                GAME_STATE='serve'
            end

        elseif ball.x>=VIRTUAL_WIDTH-BALL_SIZE-5 then
            player1.score=player1.score+1
            point:play()
            serve="Player2"
            reset_ball()

            if player1.score>=3 then
                GAME_STATE='win'
            else
                GAME_STATE='serve'
            end

        elseif ball.x<=player1.x+PADDEL_WIDTH and ball.y<=player1.y+PADDEL_HEIGHT and ball.y+BALL_SIZE>=player1.y then
            ball.dx=-ball.dx*1.05
            ball.x=player1.x+PADDEL_WIDTH
            hit:play()

        elseif ball.x+BALL_SIZE>=player2.x and ball.y<=player2.y+PADDEL_HEIGHT and ball.y+BALL_SIZE>=player2.y  then
            ball.dx=-ball.dx*1.05
            ball.x=player2.x-BALL_SIZE
            hit:play()
        end

        if ball.y<=0 then
            ball.dy=-ball.dy*1.03
            wall:play()

        
        elseif ball.y>=VIRTUAL_HEIGHT-BALL_SIZE then
            ball.dy=-ball.dy*1.03
            wall:play()
        end



    end
end

function love.keypressed(key)
    if key=='escape' then
        love.event.quit()
    end
    
    if key=='enter' or key=='return' then
        if GAME_STATE=='serve' then
            GAME_STATE='play'
        elseif GAME_STATE=='menu' then
            GAME_STATE='serve'
        elseif GAME_STATE=='win' then
            player1.score=0
            player2.score=0
            GAME_STATE='serve'
        end

    end
end
function love.draw()
    push:start()
    love.graphics.clear(45/255,45/255,100/255,1)


    if GAME_STATE=='menu' then
        love.graphics.setFont(LARGE_FONT)
        love.graphics.printf('PONG',0,4,VIRTUAL_WIDTH,'center')
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press ENTER to start',0,VIRTUAL_HEIGHT-32,VIRTUAL_WIDTH,'center')
    end
    
    if GAME_STATE=='serve' then
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf(serve..' Press ENTER to serve',0,4,VIRTUAL_WIDTH,'center')
    end

    love.graphics.rectangle('fill',player1.x,player1.y,PADDEL_WIDTH,PADDEL_HEIGHT)
    love.graphics.rectangle('fill',player2.x,player2.y,PADDEL_WIDTH,PADDEL_HEIGHT)
    love.graphics.rectangle('fill',ball.x,ball.y,BALL_SIZE,BALL_SIZE)

    love.graphics.setNewFont(32)
    love.graphics.print(player1.score,VIRTUAL_WIDTH/2-36,VIRTUAL_HEIGHT/2-16)
    love.graphics.print(player2.score,VIRTUAL_WIDTH/2+16,VIRTUAL_HEIGHT/2-16)
    love.graphics.setFont(SMALL_FONT)

    if GAME_STATE=='win' then
        local winner= player1.score>=3 and '1' or '2'
        love.graphics.setFont(LARGE_FONT)
        love.graphics.printf("Player "..winner.." Wins!!",0,4,VIRTUAL_WIDTH,'center')
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press ENTER to play again',0,VIRTUAL_HEIGHT-32,VIRTUAL_WIDTH,'center')
    end
    push:finish()
end

function reset_ball()
    ball.dx=60+math.random(60)
    if serve=="Player2" then
        ball.dx=-ball.dx
    end

    ball.dy=40+math.random(60)
    if math.random(2)== 1 then
        ball.dy=-ball.dy
    end

    ball.x=VIRTUAL_WIDTH/2-BALL_SIZE/2
    ball.y=VIRTUAL_HEIGHT/2-BALL_SIZE/2
end
