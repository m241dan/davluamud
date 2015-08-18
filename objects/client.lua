local client = {}

function client.new( connection )
   local client

   -- setup basic client info
   client.connection = connection
   client.connection:settimeout(0) -- don't block, you either have something or you don't!
   local co = coroutine.create( function( client.connection )
      while client.addr == nil do
         client.addr, client.port, client.netfamily = client.connection:getsocketname()
         coroutine.yield()
      end
      print( "IP Addr = " .. client.addr .. "\n" )
   end )
   ThreadManager.addThread( 1, co )

return client
