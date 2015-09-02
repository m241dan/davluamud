local EventQueue = require( libs/eventqueue" )
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
   return true -- so as not to fuck up the assert
end

function B.output( state )
   while true do
      for _, output in pairs( state.outbuf ) do
         state.clients[1].connection:send( output )
      end
      coroutine.yield( nil )
   end
end

function B.interp( state, input )
end

function B.msg( state, input )
   table.insert( state.outbuf, #state.outbuf + 1, input )
   if( not state.outbuf_event.is_queued ) then
      state.outbuf_event.execute_at = EQ.time() + EQ.default_tick
      EventQueue.insert( state.outbuf_event )
   end
end

return B
