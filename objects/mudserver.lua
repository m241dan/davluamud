local socket = require( "socket" )

local S = {}

local function acceptNewConnection( server )
   while true do
      local connection, err = server.socket:accept()
      if( not err ) then
         if( server.accepting == true ) then
            local client = Client:new( connection )
            table.insert( server.connections, #server.connections+1, client )
            connection:send( "You have successfully connected!\n" )
            client.states[1] = { name = "Login", inbuf = {}, outbuf = {}, behaviour = require( "behaviours/login" ) }
            client.state = client.states[1]
            assert( client.state.behaviour.init( client ) )
         else
            connection:close()
         end
      end
      coroutine.yield( EventQueue.default_tick * 4 ) -- every second should be fine
   end
end

local function readFromClients( server )
   while true do
      for index, client in ipairs( server.connections ) do
         local input, err, partial = client.connection:receive( "*l" )
         if( not err ) then
            print( input )
         else
            if( err == 'closed' ) then
               table.remove( server.connections, index )
               client:close()
            end
         end
      end
      coroutine.yield( EventQueue.default_tick ) -- every quarter of a second to read from clients should be fine, can be adjusted if it feels sluggish
   end
end

function S:new( port )
   local server = {}

   setmetatable( server, self )
   self.__index = self;

   server.socket = assert( socket.tcp(), "could not allocate new tcp socket" )
   assert( server.socket:bind( "*", port ), "could not bind to port" )
   server.socket:listen()
   server.socket:setoption( 'reuseaddr', true )
   server.socket:settimeout(0)
   server.connections = {}
   server.accepting = false

   return server;
end

return S
