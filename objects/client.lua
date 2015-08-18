local C = {}

local function getClientIP( client )
   while client.addr == nil do
      client.addr, client.port, client.net = client.connection:getsockname()
      coroutine.yield()
   end
end

function C.new( connect )
   local client = {}
   -- setup basic client info
   client.connection = connect
   client.connection:settimeout(0) -- don't block, you either have something or you don't!
   client.states = {}
   ThreadManager.addThread( 1, coroutine.create( getClientIP ), client )
end

return C
