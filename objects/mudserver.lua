local socket = require( "socket" )

local function acceptNewConnection( server )
   while true do
      local connection, err = server.socket:accept()
      if( not err ) then
         if( server.accepting == true ) then
            local client = Client.new( connection )
            server.connections[(#server.connections)+1] = client
            connection:send( "You have successfully connected!\n" .. #server.connections )
         else
            connection:close()
         end
      end
      coroutine.yield()
   end
end

local function readFromClients( server )
   while true do
      for index, client in ipairs( server.connections ) do
         print( "trying to read from X client" )
         local input, err = client.connection:receive( '*l' )
         if( not err ) then
            print( input )
         else
            if( err == 'closed' ) then
               table.remove( server.connections, index )
               client:close()
            end
         end
      end
      coroutine.yield()
   end
end

local function new( port )
   local server = {}
   server.socket = assert( socket.tcp(), "could not allocate new tcp socket" )
   assert( server.socket:bind( "*", port ), "could not bind to port" )
   server.socket:listen()
   server.socket:setoption( 'reuseaddr', true )
   server.socket:settimeout(0)
   server.connections = {}
   server.accepting = false

   ThreadManager.addThread( 1, coroutine.create( acceptNewConnection ), server )
   ThreadManager.addThread( 2, coroutine.create( readFromClients ), server )
   return server;
end

return {
   new = new
}
