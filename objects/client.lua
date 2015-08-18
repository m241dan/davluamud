local C = {}

function C.new( connect )
   local client = {}
   -- setup basic client info
   client.name = "test"
   client.connection = connect
   client.connection:settimeout(0) -- don't block, you either have something or you don't!
   local co = coroutine.create( function( client )
      while client.addr == nil do
         client.addr, client.port, client.famnet = client.connection:getsockname()
         coroutine.yield()
      end
   end )
   ThreadManager.addThread( 1, co, client )
end

return C
