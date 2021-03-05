Titlescreen=Class{__includes = Basestate}



function Titlescreen:update(dt)
    scrolling=true
    if love.keyboard.wasPressed'enter' or love.keyboard.wasPressed 'return' then
        gStateMachine:change('countdown')
    end
end

function Titlescreen:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf("Flappy Bird",0,44,VIRTUAL_WIDTH,'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf("Press Enter to start",0,VIRTUAL_HEIGHT-54,VIRTUAL_WIDTH,'center')
end

