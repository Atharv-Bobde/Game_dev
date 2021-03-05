Pipepairs= Class{}

PIPE_SCROLL=-60


function Pipepairs:init(y,GAP)
    self.y=y
    self.x=VIRTUAL_WIDTH
    self.gap=GAP
    self.pipes=
    {
        ['upper']=Pipes('top',self.y-self.gap),
        ['lower']=Pipes('bottom',self.y)
    }
    self.remove=false
    self.scored=false
end

function Pipepairs:update(dt)
    if self.x<-PIPE_WIDTH then
        self.remove=true
    else
        self.x=self.x+PIPE_SCROLL*dt
        self.pipes['upper'].x=self.x
        self.pipes['lower'].x=self.x
    end
end

function Pipepairs:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end

