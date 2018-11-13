yworld = require("yengine.world")
ytimer = require("yengine.timer")
yball = require("ball")
ypaddle = require("paddle")


game_world = yworld:new()

function game_world:create( event )
  yworld:create()
  ball = yball:new(50,50)
  player = ypaddle:new(10,50)
  player.is_ai=false
  ai = ypaddle:new(480,150)
  
  self:add(ball)
  self:add(player)
  self:add(ai)
  
end--create

game_world:yinit()

function gameLoop( event )

game_world:update()

end--create

gameLoopTimer = timer.performWithDelay( 16,gameLoop , 0 )

return game_world.yscene