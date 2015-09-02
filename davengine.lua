
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
package.cpath = "/home/korisd/davluamud/libs/?.so"
EventQueue = require( "libs/eventqueue" )

print( os.time() )
milliseconds = EventQueue.time()
print( milliseconds )
print( milliseconds % 1000 )

MudServer = require( "libs/mudserver" )
Client = require( "objects/client" )

print( "Program starting.\n" )

-- create threads

-- start the manager, which starts the program

-- gracefully exit?
print( "Program exiting.\n" )
