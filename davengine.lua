
--[[ boot thread manager
   The thread manager is the main loop of the program. It processes the data
   from the mud server first. Looking first at new connection threads. Next,
   it runs all the connection threads looking for new sent data. After that,
   game server is run, processing the new data sent by the client and
   returning any output needed. The database is updated on demand since
   there is no chance of concurrency issues.
--]]
-- boot mud server
-- boot database
-- boot game server(game logic)

print( "Program starting.\n" )

ThreadManager = require( "threadmanager" )
MudServer = require( "mudserver" )

server = MudServer.new( 6500 )
print( "Creating new server.\n" )
server.accepting = true

print( "adding thread\n" )

local res, errmsg = ThreadManager.addThread( 1, server.thread )
if not res then
   print( errmsg .. "\n" )
   return
end

print( "thread added.\n" )
ThreadManager.run()

print( "Program exiting.\n" )
