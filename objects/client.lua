local Buffer = require( "objects/dbuffer" )

local C = {}

---------------------------------------------
-- Client Constants and Globals            --
-- Written by Daniel R. Koris(aka Davenge) --
---------------------------------------------

C.location = "objects/client"
C.flush_rate = 1000 -- 1000 milliseconds or... one second :P if this feels sluggish, can easilly increase

---------------------------------------------
-- Client Coroutines                       --
-- Written by Daniel R. Koris(aka Davenge) --
---------------------------------------------

local function getClientIP( client )
   while client.addr == nil do
      client.addr, client.port, client.net = client.connection:getsockname()
      coroutine.yield()
   end
end

----------------------------------------------
-- Client methods                           --
-- Written by Daniel R. Koris(aka Davenge)  --
----------------------------------------------

function C:new( connect )
   local client = {}

   setmetatable( client, self )
   self.__index = self

   -- setup basic client info
   client.connection = connect
   client.connection:settimeout(0) -- don't block, you either have something or you don't!
   client.states = {}
   event = EventQueue.event:new( coroutine.create( getClientIP ) )
   event:args( client )
   EventQueue.insert( event )
   return client;
end

function C:addState( state )
   table.insert( self.states, #self.states + 1, state )
   return #self.states + 1
end

function C:setState( sori )
   if( type( sori ) == "number" ) then
      if( not self.states[sori] ) then
         error( "attempting to set client state to a nil index.", 2 )
      end
   else
      if( getmetatable( sori ) ~= C.state ) then
         error( "attemptingto set state using object with non-state metatable", 2 )
      end
      for i, s in ipairs( self.states ) do
         if( sori == s ) then
            sori = i
            break
         end
      end
   end

   self.current_state = self.states[sori]
   return true
end

---------------------------------------------
-- Client.state Methods                    --
-- Written by Daniel R. Koris(aka Davenge) --
---------------------------------------------

function C.state:new( name, behaviour )
   local state = {}

   setmetatable( state, self )
   self.__index = self

   state.name = name
   state.behaviour = require( behaviour )
   state.inbuf = {}
   state.outbuf = { Buffer:new( 70 ) }
   assert( state.behaviour.init( client, state ) )
end


return C
