local C = {}

function C.new( connect )
   local client = {}
   -- setup basic client info
   client.name = "test"
   client.connection = connect
   client.connection:settimeout(0) -- don't block, you either have something or you don't!
   local co = coroutine.create( function( client )
      print( "being executed" )
      while client.addr == nil do
         print( "in the loop " .. client.name )
         client.addr, client.port, client.famnet = client.connection:getsockname()
         print( "yielding..." )
         coroutine.yield()
         print( "resuming..." )
      end
      print( "test\n" )
      print( "IP Addr = " .. client.addr .. client.port .. client.famnet )
   end )
   ThreadManager.addThread( 1, co, client )
   print( "new client finished" )
end

return C
