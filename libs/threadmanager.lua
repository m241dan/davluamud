-- a general thread manager, not davengine specific but written by Daniel Koris(aka Davenge)

local manager = {}
manager.go = false

-- threads to manage
manager.threads = {}
manager.args = {}

function manager.addThread( priority, thread, ... )
   -- args checks
   if( type( priority ) ~= "number" ) then
      error( "priority must be integer", 2 )
   end
   if( priority ~= 1 and manager.threads[priority-1] == nil ) then
      error( "priority must be in 1-n sequential order. for example: cannot add priority 3 if 2 does not exist.", 2 )
   end 
   if( type( thread ) ~= "thread" ) then
      error( "thread must be of type... thread!", 2 )
   end
 
   -- insert thread into proper table or create table
   if( manager.threads[priority] ~= nil ) then
      table.insert( manager.threads[priority], thread )
      manager.args[priority][thread] = { ... }
   else
      manager.threads[priority] = { thread }
      manager.args[priority] = { [thread] = { ... } }
   end
   return true
end

local function main()
   -- program main loop
   while manager.go == true do
      -- iterate through both thread tables
      for i = 1, #manager.threads do
         for ti, t in pairs( manager.threads[i] ) do
            if( not manager.args[i] or not manager.args[i][t] ) then
               assert( coroutine.resume( t ) )
            else
               assert( coroutine.resume( t, table.unpack( manager.args[i][t] ) ) )
            end
            -- if its complete, remove it
            if( coroutine.status( t ) == "dead" ) then
               print( "removing dead thread." )
               table.remove( manager.threads[i], ti ) --[ti] = nil
               manager.args[i][t] = nil
            end
         end
      end
   end
end

-- run the threads the manager has setup
function manager.run()
   manager.go = true
   main()
end

-- stop the main loop, should probably make the stopping a bit more graceful
function manager.stop()
   manager.go = false
end

return manager
