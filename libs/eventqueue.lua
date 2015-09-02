local Time = require( "time" )
-- .getMiliseconds()
-- .getMicroSeconds()
-- .getTime()
-- .getDiff()
-- .getSeconds()
local EQ = {}

EQ.queue = {}
EQ.running = false
EQ.default_tick = 250 -- 250 = .25 seconds || 250 milliseconds

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
   return nil -- need to write the tick in as a standard measurement or "next tick" sort of function
end

function EQ.time()
   return ( Time.getMiliseconds() * 1000 )
end

function EQ.main()

   while EQ.running do
      if( not EQ.queue[1] ) then -- should never have an empty queue, but if we do, its time to end
         print( "Program Exiting, nothing in Queue." )
      end

      local CEvent = EQ.queue[1]

      if( CEvent.execute_at <= EQ.time() ) then
         -- non-dead coroutine events should return a time at which to "requeue" in milliseconds
         local requeue_at = assert( coroutine.resume( CEvent.thread ) ) 
         table.remove( EQ.queue, 1 ) 
         if( coroutine.status( CEvent.thread ) == "dead" ) then
            print( "removing event with dead thread." )
         else
            CEvent.execute_at = EQ.time() + requeue_at -- requeue time will be current time in milliseconds + the millseconds returned by the yield
            EQ.insert( CEvent ) 
         end

      else
         
      end
      
      
   end
end 

function EQ.run()
   EQ.running = true;
   EQ.main()
end



return EQ
