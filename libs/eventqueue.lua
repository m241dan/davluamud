local Time = require( "time" )
-- .getMiliseconds()
-- .getMicroSeconds()
-- .getTime()
-- .getDiff()
-- .getSeconds()
local EQ = {}

EQ.queue = {}
EQ.running = false
EQ.default_wait = 250 -- 250 = .25 seconds || 250 milliseconds

EQ.event = {}

--event functions
function EQ.event:new( thread )
   local event = {}

   setmetatable( event, self )
   self.__index = self
   event.routine = thread
   event.execute_at = EQ.time()

   return event
end

--queue functions

function EQ.tick()
   return ( Time.getMiliseconds() * 100 ) -- return time in tenths of a second
end

function EQ.time()
   return Time.getMiliseconds()
end

--[[ function EQ.main()
   while EQ.running do
      if( not EQ.queue[1] ) then -- should never have an empty queue, but if we do, its time to end
         print( "Program Exiting, nothing in Queue." )
      end

      if( EQ.queue[1].execute_at <= EQ.time() ) then
      else
         
      end
      
      
   end
end --]]

function EQ.run()
   EQ.running = true;
--   EQ.main()
end



return EQ
