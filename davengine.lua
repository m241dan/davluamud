
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
ThreadManager = require( "libs/threadmanager" )
MudServer = require( "objects/mudserver" )
Client = require( "objects/client" )

print( "Program starting.\n" )

-- create threads
server = MudServer.new( 6500 )
server.accepting = true

-- start the manager, which starts the program
ThreadManager.run()

-- gracefully exit?
print( "Program exiting.\n" )
