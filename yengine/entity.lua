ytimer = require("yengine.timer")
local yentity =  {}
local yentity_mt = { __index = yentity }
yentity.__index = yentity
function yentity:new(x2,y2,img2)  
   o =  {}
   setmetatable(o, yentity_mt)
  -- self.__index = self
   o.type = "entity"
   o.x =x2
   o.y = y2
   o.z=0 --zdepth
   o.speed=1
   o.width = 30
   o.height = 30
   o.hit_width = 30
   o.hit_height = 30
   o.hit_rect=nil
   o.img_s = img2
   o.img_type = "img"
   --spritesheet--
   o.s_sheet=nil--sprite sheet
   o.s_frames=0
   o.sw = 0--width anh height of spritesheet
   o.sh = 0
   o.cf=1--sprite current frame
   o.anims = {}
   o.anim_timers = {}
   o.anim_frame = {}
   
   o.no_cam = false
   o.yid = 0
   o.ytouch = false
   o.ytap = false
   o.debug = false
   o.world = nil
  
  -- self.o = o
 -- self:addEventListener( "collision" ,self)
   return o

end--new yentity


function yentity:init()
  --print("init "..self.type)
  if (  self.img_type == "img" ) then
    self.img = display.newImageRect( self.img_s ,self.width,self.height )
  end--if
  
  if (  self.img_type == "sprite" ) then
    self:sprite_init()
    --self.img = display.newImage( self.s_sheet,self.cf )
    self:schange_frame(self.cf)
  end--if
  
  
  --if img is not nil
  if( self.img ~= nil) then
  self.img.x = self.x
  self.img.y = self.y
  self.img:addEventListener( "tap", self )
  self.img:addEventListener( "touch", self )
  end --if
 -- print(123)
  self:yinit()
end--init

 function yentity:yinit()
  end

function yentity:sprite_init()

  local options =
  {
      width = self.width,
      height = self.height,
      numFrames = self.s_frames,
      sheetContentWidth = self.sw,  --width of original 1x size of entire sheet
      sheetContentHeight = self.sh  --height of original 1x size of entire sheet
  }
  self.s_sheet = graphics.newImageSheet( self.img_s, options )

end--sprite_init

function yentity:schange_frame(n)
  if(self.s_sheet ==nil)then
    return nil
  end
  display.remove(self.img)
  self.img = display.newImage( self.s_sheet,n )
  self:u_xy()--set pos to xy right away dont wait for update
    self.img:addEventListener( "tap", self )
  self.img:addEventListener( "touch", self )
end--schange_frame (sprite change frame)

function yentity:create_anim(name,r,dur)

  -- o.anims = {}
   --o.anim_timers
   self.anims[name] = r 
   self.anim_timers[name] = ytimer:new(dur)
   self.anim_frame[name] = 1
end--create_anim



function yentity:update_anim(name)

  if(self.anim_timers[name]:is_done())then
    self.anim_frame[name] = self.anim_frame[name]+1
    
    if(self.anim_frame[name] > #self.anims[name])then
        self.anim_frame[name] = 1
    end
    
    frame_num = self.anim_frame[name]

    curent_frame = self.anims[name][frame_num]
    
    self:schange_frame(curent_frame)
    self.anim_timers[name]:reset()
  end--if

end--update_anim

function yentity:set_w_h(w,h)
  
   self.width = w
   self.height = h
   self.hit_width = w
   self.hit_height = h
  
end--set_w_h

function yentity:set_w_hs(w,h)
  
   self.sw = w
   self.sh = h
  
end--set_w_h
function yentity:alpha(a)
  self.img.alpha = a
end--end alpha


function yentity:yupdate()--update xy
end

function yentity:u_xy()--update xy
  
  if( self.img ~= nil and not self.no_cam) then
    self.img.x = self.x+self.world.cam[1]
    self.img.y = self.y+self.world.cam[2]
  elseif( self.img ~= nil)then
    self.img.x = self.x
    self.img.y = self.y
  end --if
  
end--u_xy 

function yentity:update()
  
 -- self.x = self.x+1--remove line
  self:u_xy()
  --self:move_by(0.3,0)
  --print(self:is_tap())
   --[[if(self.ytap)then
     print("clk")
    end
    self.ytap =false]]--
   --print(self.world.mx)
  self:yupdate()
end --update

function yentity:move_by(x2,y2)
   self.x = self.x+x2
   self.y = self.y+y2
end --update


function yentity:collide(yx,yy ,type )
  
  ret = {}
  es = self:get_by_type(type)
  e=nil
  x = self.x+yx or self.x
  y = self.y+yy or self.x
   --s print(x.." "..y)
  w = self.hit_width
  h = self.hit_height
  
  self:collide_box(x, y, w,h )
  
  for i  = 1,  #es do
    e=es[i]
    --print ("type "..es[i ].type)
    --print(x.." "..e.x)
    if(e~=self and
      x+w > e.x and
      y+h > e.y and
      e.x+e.hit_width > x and
      e.y+e.hit_height>y
      )then
      --print("hit "..e.yid)
     table.insert( ret, e)
    end--if
    
  end--end for
  return ret
end --collide



function yentity:get_by_type(type)
   ret={}
   --loop entities
  mc =self.world.mc 
  for i  = 1,  #mc do
    e=mc[i]
   -- print(type .."==".. e.type)
    if(type == e.type)then
      table.insert( ret, e)
    end--if

  end--end for
-- print(ret[1].type.." here")
  return ret
end --get_by_type

function yentity:collide_box(zx, zy, zw,zh )
  
  if (not self.debug) then
    return nil
  end--if
  if(self.hit_rect ==nil)then
    self.hit_rect = display.newRect( zx, zy, zw,zh )
  end
  self.hit_rect:setFillColor(255,255,255,0)
  self.hit_rect.strokeWidth = 1
  self.hit_rect:setStrokeColor( 1, 0, 0 )
  self.hit_rect.x = self.x
  self.hit_rect.y = self.y
  
  if( not self.no_cam) then
    self.hit_rect.x = self.x+self.world.cam[1]
    self.hit_rect.y = self.y+self.world.cam[2]
  else
    self.hit_rect.x = self.x
    self.hit_rect.y = self.y
  end --if
  
end --collide_box

function yentity:tap(e)
 --print("blam")
  self.ytap = true
end --tap

function yentity:is_tap()
  
  if(self.tap)then
    self.ytap = false
    return true
  end
  
  return false
  
end --is_tap

function yentity:touch(e)
  --print("bam")--oh blabk betty
  
  if ( e.phase == "began" ) then
       -- print( "Touch event began on: "  )
        self.ytouch = true
  elseif ( e.phase == "ended" ) then
      --  print( "Touch event ended on: ")
        self.ytouch = false
    end
  
end --touch

function yentity:go_to(tx,ty)
  x = self.x
  y = self.y
  speed = self.speed
  
  if(x<tx)then
    x=x+speed
  end--if
  if(x>tx)then
    x=x-speed
  end--if
   if(y<ty)then
    y=y+speed
  end--if
  if(y>ty)then
    y=y-speed
  end--if
  self.x=x
  self.y=y
  print("in")
end --go_to

function yentity:yremove( )
end
function yentity:yadd( )
end

return yentity
