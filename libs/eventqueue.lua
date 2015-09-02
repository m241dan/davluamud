local socket = require( "socket" )
-- cpath needs to be adjusted if you don't want to install the module directly on the computer
-- and I don't, so, I do
package.cpath = "/home/korisd/davluamud/libs/?.so"
local Time = require( "time" )
-- .getMiliseconds()
-- .getMicroSeconds()
-- .getTime()
-- .getDiff()
-- .getSeconds()

local EQ = {}

----------------------------------------------
-- EventQueue Library Constants and Globals --
-- Written by Daniel R. Koris(aka Davenge)  --
----------------------------------------------

EQ.queue = {}
EQ.running = false
EQ.default_tick = 250 -- 250 = .25 seconds || 250 milliseconds

EQ.event = {}

---------------------------------------------
-- EventQueue.event Methods                --
-- Written by Daniel R. Koris(aka Davenge) --
---------------------------------------------

function EQ.event:new( thread )
   local event = {}

   setmetatable( event, self )
   self.__index = self
   event.routine = thread
   event.execute_at = EQ.time()

   return event
end

function EQ.event:args( ... )
   self.args = { ... }
end

---------------------------------------------
-- EventQueue Library Functions            --
-- Written by Daniel R. Koris(aka Davenge) --
---------------------------------------------

--queue functions

function EQ.tick()
   return nil -- need to write the tick in as a standard measurement or "next tick" sort of function
end

function EQ.time()
   return ( Time.getMiliseconds() * 1000 )
end

-- eventqueuetest_one tests the insert||insertSort code

function EQ.insertSort( event, index )
   local next
   if( index < 1 ) then index = 1; end -- precautionary check

   if( event.execute_at < EQ.queue[index].execute_at ) then
      -- what to do if the current execute time is less than the event at this index
      if( index == 1 ) then
         table.insert( EQ.queue, 1, event ) -- we're at the bottom of the array, insert it
      elseif( event.execute_at >= EQ.queue[index - 1].execute_at ) then
         table.insert( EQ.queue, index, event ) -- this event is less than the index but greater than the index -1, insert it at the index
      else
         next = math.floor( index / 2 )
         return EQ.insertSort( event, next )
      end
   elseif( event.execute_at > EQ.queue[index].execute_at ) then
      -- what to do if the current execute timeis greater than the event at thisindex
      if( not EQ.queue[index + 1] or event.execute_at <= EQ.queue[index + 1].execute_at ) then
         table.insert( EQ.queue, index + 1, event ) -- we're at the top of array, insert it there or we're less than index +1, either way, insert at index+1
      else
         next = math.floor( #EQ.queue - index ) + index
         return EQ.insertSort( event, next )
      end
   else
      table.insert( EQ.queue, index, event ) -- if its to be executed at the same time(which is unlikely) you can just stick it in the same place )
   end
   return true
end

function EQ.insert( event )
   -- if there's nothing in the queue, it's the first, duh!
   if( not EQ.queue[1] ) then
      EQ.queue[1] = event
   else
      EQ.insertSort( event, math.floor( #EQ.queue / 2 ) )
   end
end

-- eventqueuetest_two tests the run and main code

function EQ.main()

   while EQ.running do
      ::mainloop::
      if( not EQ.queue[1] ) then -- should never have an empty queue, but if we do, its time to end
         print( "Program Exiting, nothing in Queue." )
         return false
      end

      local CEvent = EQ.queue[1]

      if( CEvent.execute_at <= EQ.time() ) then
         -- non-dead coroutine events should return a time at which to "requeue" in milliseconds
         local requeue_at
         if( not CEvent.args ) then
            _, requeue_at = assert( coroutine.resume( CEvent.routine ) )
         else
            _, requeue_at = assert( coroutine.resume( CEvent.routine, table.unpack( CEvent.args ) ) )
         end
         table.remove( EQ.queue, 1 ) 
         if( coroutine.status( CEvent.routine ) == "dead" or type( requeue_at ) ~= "number" ) then
            print( "removing event with dead thread." )
         else
            CEvent.execute_at = EQ.time() + requeue_at -- requeue time will be current time in milliseconds + the millseconds returned by the yield
            EQ.insert( CEvent ) 
         end
         goto mainloop
      else
         socket.sleep( ( EQ.queue[1].execute_at - EQ.time() ) / 1000 )
      end
   end
end 

function EQ.run()
   EQ.running = true;
   EQ.main()
end



return EQ
