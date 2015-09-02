local Buffer = require( "objects/dbuffer" )

local C = {}

local function getClientIP( client )
   while client.addr == nil do
      client.addr, client.port, client.net = client.connection:getsockname()
      coroutine.yield()
   end
end

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

function C:addState( name, behaviour )
   local state = {}
   state.name = name
   state.behaviour = require( behaviour )
   state.inbuf = {}
   state.outbuf = { Buffer:new( 70 ) }
   assert( state.behaviour.init( client, state ) )
   table.insert( self.states, #self.states + 1, state )
   return #self.states + 1
end

function 

C.location = "objects/client"

return C
