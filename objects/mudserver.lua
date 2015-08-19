local cqueues = require( "cqueues" )
local socket = require( "cqueues.socket" )

local function acceptNewConnection( server )
   while true do
      local connection, err = server.socket:accept()
      if( not err ) then
         if( server.accepting == true ) then
            table.insert( server.connections, #server.connections+1, Client.new( connection ) )
            connection:send( "You have successfully connected!\n", 1, 33 )
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
         local input, err = client.connection:read( "*l" )
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

local function new( portarg )
   local server = {}
   server.socket = socket.listen{ host="localhost", port=portarg, family=AF_INET, type=SOCK_STEAM, reuseaddr=true }
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
