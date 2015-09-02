EventQueue = require( "libs/eventqueue" )
Event = EventQueue.event;

a = Event:new( nil )
b = Event:new( nil )
c = Event:new( nil )

a.name = "a"
a.execute_at = EventQueue.time() + 100
b.name = "b"
b.execute_at = EventQueue.time() + 300
c.name = "c"
c.execute_at = EventQueue.time() + 200

EventQueue.insert( c )
EventQueue.insert( a )
EventQueue.insert( b )

for i, e in ipairs( EventQueue.queue ) do
   print( i .. " " .. e.name )
end
