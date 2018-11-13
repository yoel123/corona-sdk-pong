entity = require("yengine.entity")
ye = require("yengine.ye")
local yball=  {}
yball.__index = yball
setmetatable(yball,{__index = entity})

function yball:new(x2,y2)  

	o =  entity:new(x2,y2,"")
	setmetatable(o,self)
	o.type = "yball"
  o.speed_vec  = {1,1}
  o.speed = 3
	return o

end--new

function yball:yinit() 
  self.img = ye:circle( self.x, self.y, 10)
end--init

function yball:yupdate() 
  
  self:move()
  self:bounds()
end--update

function yball:move() 
  
  if(self.y<0 or self.y>250)then
    self.speed_vec[2] = self.speed_vec[2] *-1
  end
  sy = self.speed*self.speed_vec[2] --speed y
  sx = self.speed*self.speed_vec[1]--speed x
  self:move_by(sx,sy)
end--move

function yball:bounds()
  
  if(self.x>500 or self.x<0)then
    self.x=150
  end

end --bounds

return yball