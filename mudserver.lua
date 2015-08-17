local socket = require( "socket" )

local function new( port )
   local server = {}
   server.socket = socket.tcp()
   server.socket:bind( "*", port )
   server.socket:listen()
   server.socket:setoption( "reuseaddr" )
   server.socket:settimeout(0)

   return server;
end

return {
   new = new
}
