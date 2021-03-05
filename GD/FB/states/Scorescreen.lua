Scorescreen=Class{__includes = Playstate}



function Scorescreen:enter(params)
    self.score=params.score
    self.bird=params.bird
    self.pipepairs=params.pipepairs
end


function Scorescreen:update(dt)
    scrolling=false
    if love.keyboard.wasPressed'enter' or love.keyboard.wasPressed 'return' then
        gStateMachine:change('title')
    end
end



function Scorescreen:render()
    
    self.bird:render()
    for k,pipe in pairs(self.pipepairs) do
        pipe:render()
    end
    love.graphics.setFont(hugeFont)
    love.graphics.printf('Game Over',0,VIRTUAL_HEIGHT/2-56,VIRTUAL_WIDTH,'center')
    love.graphics.setFont(flappyFont)
    love.graphics.printf('score: ' .. tostring(self.score),0,VIRTUAL_HEIGHT/2,VIRTUAL_WIDTH,'center')
end