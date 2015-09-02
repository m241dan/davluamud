
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
local EventQueue = require( "libs/eventqueue" )
local MudServer = require( "objects/server" )

print( "Program starting.\n" )

-- create threads
local server = MudServer:new( 6500 )
local event_server_accepting = EventQueue.event:new( server:start() )

event_server_accepting:args( server )
EventQueue.insert( event_server_accepting )

-- start the EventQueue, which starts the program
EventQueue.run()

-- gracefully exit?
print( "Program exiting.\n" )
