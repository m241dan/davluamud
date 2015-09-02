local EventQueue = require( "libs/eventqueue" )
local B = {}

function B.init( state )
   B.msg( state, [[

  _____                              _
 |  __ \                            (_)
 | |  | | __ ___   _____ _ __   __ _ _ _ __   ___
 | |  | |/ _` \ \ / / _ \ '_ \ / _` | | '_ \ / _ \
 | |__| | (_| |\ V /  __/ | | | (_| | | | | |  __/
 |_____/ \__,_| \_/ \___|_| |_|\__, |_|_| |_|\___|
                                __/ |
                               |___/

                "Remember that you will die."
What is your name? ]] )
   print( state.outbuf[1] )
   return true -- so as not to fuck up the assert
end

function B.output( state )
   while true do
      for _, output in pairs( state.outbuf ) do
         print( "What the heck???" )
         assert( state.clients[1].connection:send( output ) )
         print( "Somethign is wrong." )
      end
      coroutine.yield( nil )
   end
end

function B.interp( state, input )
   while true do
      coroutine.yield()
   end
end

function B.msg( state, input )
   table.insert( state.outbuf, #state.outbuf + 1, input )
   if( not state.outbuf_event.is_queued ) then
      print( "queueing the outbuf event @ " .. EventQueue.time() .. " for " .. EventQueue.time() + EventQueue.default_tick )
    
      state.outbuf_event.execute_at = EventQueue.time() + EventQueue.default_tick
      EventQueue.insert( state.outbuf_event )
      print( "Event Queue size = " .. #EventQueue.queue )
   end
end

return B
