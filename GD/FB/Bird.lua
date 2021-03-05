Bird=Class{}

GRAVITY=20

function Bird:init()
    self.image=love.graphics.newImage('textures/bird.png')
    self.width=self.image:getWidth()
    self.height=self.image:getHeight()
    
    self.x=VIRTUAL_WIDTH/2-self.width/2
    self.y=VIRTUAL_HEIGHT/2-self.height/2
    self.dy=0
end

function Bird:update(dt)
    self.dy=self.dy+GRAVITY*dt
    
    if love.keyboard.wasPressed('space') then
        self.dy=-5
        sounds["jump"]:play()
    end
    
    self.y=self.y+self.dy
end

function Bird:collision(pipe)
    if self.x+self.width-4>=pipe.x+2 and self.x+4<=pipe.x+pipe.width-2 then
        if self.y+3<=pipe.y-3 and pipe.orientation=='top' or self.y+2+self.height-4>=pipe.y+2 and pipe.orientation=='bottom' then
            return true
        end
    end
    return false

end


function Bird:render()
    love.graphics.draw(self.image,self.x,self.y)
end

