Playstate=Class{__includes = Basestate}



function Playstate:init()
    self.timer=0
    self.bird=Bird()
    self.pipepairs={}
    self.score=0
    self.interval=math.random()
    self.gap=math.random(65,90)
    self.last_y=math.random(self.gap+45,VIRTUAL_HEIGHT-45)
end


function Playstate:update(dt)
    scrolling=true
    self.bird:update(dt)
    if self.bird.y+self.bird.height/2 < 0 or self.bird.y+self.bird.height/2>VIRTUAL_HEIGHT-16 then
        sounds["explosion"]:play()
        sounds["hurt"]:play()

        gStateMachine:change('score',{score=self.score,bird=self.bird,pipepairs=self.pipepairs})
    end

    self.timer=self.timer+dt
    if self.timer>=2+self.interval then
        y=math.max(self.gap+45,math.min(self.last_y+math.random(-20,20),VIRTUAL_HEIGHT-45))
        self.last_y=y
        self.gap=math.random(65,90)
        table.insert(self.pipepairs,Pipepairs(y,self.gap))
        self.interval=math.random()
        self.timer=0
    end

    for k,pipepair in pairs(self.pipepairs) do
        pipepair:update(dt)
        
        for j,pipe in pairs(pipepair.pipes) do
            if self.bird:collision(pipe) then
                sounds["explosion"]:play()
                sounds["hurt"]:play()
                gStateMachine:change('score',{score=self.score,bird=self.bird,pipepairs=self.pipepairs})
            end
        end

        if self.bird.x>pipepair.x+PIPE_WIDTH and pipepair.scored==false then
            self.score=self.score+1
            sounds["score"]:play()
            pipepair.scored=true
        end
    end

    for k, pair in pairs(self.pipepairs) do
        if pair.remove then
            table.remove(self.pipepairs, k)
        end
    end


end

function Playstate:render()
    
    self.bird:render()
    for k,pipe in pairs(self.pipepairs) do
        pipe:render()
    end
    
    love.graphics.setFont(mediumFont)
    love.graphics.print('score: ' .. tostring(self.score),5,1)
end

