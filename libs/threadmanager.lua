-- a general thread manager, not davengine specific but written by Daniel Koris(aka Davenge)

local manager = {}
manager.go = false

-- threads to manage
manager.threads = {}

function manager.addThread( priority, thread )
   -- args checks
   if( type( priority ) ~= "number" ) then
      return nil, "priority must be integer"
   end
   if( priority ~= 1 and manager.threads[priority-1] == nil ) then
      return nil, "priority must be in 1-n sequential order. for example: cannot add priority 3 if 2 does not exist."
   end 
   if( type( thread ) ~= "thread" ) then
      return nil, "thread must be of type... thread!"
   end

   -- insert thread into proper table or create table
   if( manager.threads[priority] ~= nil ) then
      table.insert( manager.threads[priority], thread )
   else
      print( "thread added to table.\n" )
      manager.threads[priority] = { thread }
   end
   return true
end

local function main()
   -- program main loop
   while manager.go == true do
      -- iterate through both thread tables
      for i, p in ipairs( manager.threads ) do
         for ti, t in pairs( manager.threads[i] ) do
            coroutine.resume( t )
            -- if its complete, remove it
            if( coroutine.status( t ) == "dead" ) then
               table.remove( manager.threads[i], ti )
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
