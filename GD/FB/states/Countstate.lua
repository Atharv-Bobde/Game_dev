Countstate=Class{__includes=Basestate}

function Countstate:init()
    self.timer=0
    self.counter=3
end

function Countstate:update(dt)
    if self.counter==3 and self.timer==0 then
        sounds["count"]:play()
    end
    
    self.timer=self.timer+dt

    if  self.timer>=0.85 then
        self.counter=self.counter-1
        
        if self.counter==0 then
            sounds["go"]:play()
        elseif self.counter>0 then
            sounds["count"]:play()
        end
        
        self.timer=0
    end

    if self.counter==-1 then
        gStateMachine:change('play')
    end
end

function Countstate:render()
    love.graphics.setFont(hugeFont)
    if self.counter==0 then
        love.graphics.printf("GO!",0,VIRTUAL_HEIGHT/2-30,VIRTUAL_WIDTH,'center')
    else
        love.graphics.printf(tostring(self.counter),0,VIRTUAL_HEIGHT/2-30,VIRTUAL_WIDTH,'center')
    end

    love.graphics.setFont(flappyFont)
end


