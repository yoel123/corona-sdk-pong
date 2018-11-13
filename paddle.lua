entity = require("yengine.entity")
local ypaddle=  {}
ypaddle.__index = ypaddle
setmetatable(ypaddle,{__index = entity})

function ypaddle:new(x2,y2)  

	o =  entity:new(x2,y2,"")
	setmetatable(o,self)
	o.type = "ypaddle"
  o.is_ai = true
  o.speed = 5
  o.hit_width = 10
  o.hit_height = 80
  o.height = 80
	return o

end--new

function ypaddle:yinit()  
  self.img = ye:rect( self.x, self.y, 10,80)
end--init

function ypaddle:yupdate()  
  self:move()
  self:hit()
end--update


function ypaddle:move() 
  
  if(self.is_ai)then
    self:move_ai()
    return
  end
  self:move_player()
end--update

function ypaddle:move_player()

  x = self.x
  y = self.y
  wx=self.world.x
  wy=self.world.my
  if(wy==0)then
    return
  end
  
  if(y<wy)then
    self:move_by(0,self.speed)
  end
  
   if( (y+self.height) > wy)then
    self:move_by(0,-self.speed)
  end
  

end--move_player

function ypaddle:move_ai()  
  get_ball = self:get_by_type("yball")
  ball = get_ball[1]
  h = self.y+self.height
  --print(ball.y)
  
  if(ball.y>h-20)then
    self:move_by(0,self.speed)
  end
  
   if(ball.y<self.y)then
    self:move_by(0,-self.speed)
  end
  
end--move_ai

function ypaddle:hit()  

  local get_ball = self:collide(0,0,"yball")
  local ball = get_ball[1]
  
  if(#get_ball >1)then

    ball.speed_vec[1] = ball.speed_vec[1] *-1--reverse x dir of ball
  
    rand =math.random(1,2)
    
    if(rand>1)then--rand y dir
      ball.speed_vec[2] = ball.speed_vec[2] *-1
    end
    
  end

  
end

return ypaddle