Pipes=Class{}

PIPE_IMAGE=love.graphics.newImage('textures/pipe.png')
PIPE_HEIGHT=288
PIPE_WIDTH=70


function Pipes:init(orientation,y)
    self.x=VIRTUAL_WIDTH
    self.y=y
    self.orientation=orientation
    self.width=PIPE_WIDTH
    self.height=PIPE_HEIGHT

end

function Pipes:update(dt)

end

function Pipes:render()
    love.graphics.draw(PIPE_IMAGE,self.x,self.y,0,1,self.orientation=='bottom' and 1 or-1 )
end

    
