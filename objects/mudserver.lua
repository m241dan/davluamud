local socket = require( "socket" )

local function new( port )
   local server = {}
   server.socket = socket.tcp()
   server.socket:bind( "*", port )
   server.socket:listen()
   server.socket:setoption( 'reuseaddr', true )
   server.socket:settimeout(0)
   server.connections = {}
   server.accepting = false

   server.thread = coroutine.create( function()
      while true do
         local connection = server.socket:accept()
         if( connection ~= nil ) then
            if( server.accepting == true ) then
               server.connections[#server.connections+1] = Client.new( connection )
               connection:send( "You have successfully connected!\n" )
            else
               connection:close()
            end
         end
         coroutine.yield()
      end
   end )

   return server;
end

return {
   new = new
}
