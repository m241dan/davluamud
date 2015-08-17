-- a general thread manager, not davengine specific but written by Daniel Koris(aka Davenge)

local manager = {}

-- threads to manage
manager.threads = {}

function manager.addThread( priority, thread )
   -- args checks
   if( type( priority ) ~= "number" ) then
      return nil, "priority must be integer"
   end
   if( priority ~= 1 or manager.threads[priority-1] == nil ) then
      return nil, "priority must be in 1-n sequential order. for example: cannot add priority 3 if 2 does not exist."
   end 
   if( type( thread ) ~= "thread" ) then
      return nil, "thread must be of type... thread!"
   end

   if( manager.threads[priority] not nil ) then
      table.insert( manager.threads[priority], thread )
   else
      manager.threads[priority] = { thread }
   end
end

