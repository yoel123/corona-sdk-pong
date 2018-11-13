local composer = require( "composer" )

local yworld =  {}
local yworld_mt = { __index = yworld }
yworld.__index = yworld
function yworld:new()  
   o =  {}
   setmetatable(o, self)
  -- self.__index = self
   
   o.yscene = composer.newScene()
   o.sceneGroup = o.yscene.view
   
   o.cam = {0,50}
   o.mx = 0
   o.my=0
   o.mc = {}
   o.mc_count = 0;
   return o

end--new


local function sz(a,b)
  --print(b)
  return a.z < b.z
end--sz
 
function yworld:sortz()
  
  table.sort(self.mc, sz )
  mc =self.mc 
  for i  = 1,  #mc do

    --print( self.mc[i].z)
    self.mc[i].img:removeSelf()
    self.mc[i]:init()
  end--end for
end--end sortz

-- add()
function yworld:add( entity )
 
  table.insert( self.mc,entity)
  entity.world = self
  
  entity:init()
  self.mc_count = self.mc_count + 1;
  entity.yid = self.mc_count
  entity:yadd()--your remove
end--add



-- remove()
function yworld:remove( entity )
  

  entity.img:removeSelf()--remove image
  if(entity.hit_rect ~= nil)then--remove debug rect
    entity.debug= false
    entity.hit_rect.strokeWidth = 0
    entity.hit_rect:removeSelf();
    display.remove(entity.hit_rect)
    entity.hit_rect=nil
  end
  
  if(entity.s_sheet ~= nil)then--remove imeage sheet
    entity.s_sheet=nil
  end
  
  mc =self.mc 
  for i  = 1,  #mc do

    if(self.mc[i] == entity)then--remove the right one from mc list
      table.remove( self.mc,i)
    end
  end--end for
  
  entity:yremove()--your remove
  entity=nil
  
end--remove

-- update()
function yworld:update( yself )
   --print(yself)
 --print(self.mc_count)
 
 --loop entities
  mc =self.mc 
  for i  = 1,  #mc do

    self.mc[i]:update()
    --print(self.mc[i].yid)
  end--end for

end--update

-- create()
function yworld:create( event )
  

  print("----created world-----")
  
end--create

-- show()
function yworld:show( event )
  
  local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
   -- print(event) 
   
   -- gameLoopTimer = timer.performWithDelay( 500,function () self.update(2);   end , 0 )
    --print("did show")
  end
  
end--show

-- hide()
function yworld:hide( event )


	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

  end

end--hide


-- destroy()
function yworld:destroy( event )


	-- Code here runs prior to the removal of scene's view

end-- destroy

function yworld:touch(e)
  
  
  
    if e.phase == "began" then
      self.mx = e.x
      self.my = e.y
    elseif ( "moved" == e.phase ) then
      self.mx = e.x
      self.my = e.y
    end--if
  
end--touch

function yworld:yinit()
   self.yscene:addEventListener( "create",self)
   self.yscene:addEventListener( "show" ,self)
   self.yscene:addEventListener( "hide",self )
   self.yscene:addEventListener( "destroy",self)
   Runtime:addEventListener("touch",self)
end--yinit

return yworld
