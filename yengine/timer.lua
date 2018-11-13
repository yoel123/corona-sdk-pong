local ytimer =  {}
local ytimer_mt = { __index = ytimer }
ytimer.__index = ytimer
function ytimer:new(duratiun) 
   o =  {}
   setmetatable(o, self)
   
   o.count=0
   o.dur = duratiun
   
   return o
end--new

function ytimer:update() 
  self.count = self.count+1
end--update

function ytimer:is_done() 
 
 if(self.count>self.dur)then
    return true
  end--if
  self:update();
  return false
end--is_done

function ytimer:reset() 
  self.count=0
end--reset

return ytimer

