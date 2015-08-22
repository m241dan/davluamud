Buffer = require( "objects/dbuffer" )

width = 25
astring = "this #rjust has \r\nto be a #nlong string, eeeeeeeeeeeeee#neeeeeeeeeeee#r#beeeeeeeeeeeeeeeeeeeeeeeee#deeeeeeeeeeeeeeeeeeeeeeeeeeeeee prefer#dably\r\n one t#nhat is about... oh I #n#r#zdunno, 30+ char#na#tcters long."

a = Buffer:new( width )
assert( a:parse( astring ) )
print( tostring( a ) )

bstring = "this just has \r\nto be a long string, eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee preferably\r\n one that is about... oh I dunno, 30+ characters long."

b = Buffer:new( width )
assert( b:parse( bstring ) )
print( tostring( b ) )
