local Time = require( "time" )
-- .getMiliseconds()
-- .getMicroSeconds()
-- .getTime()
-- .getDiff()
-- .getSeconds()
local EQ = {}

EQ.consistant = {}
EQ.variable = {}

function EQ.time()
   return ( Time.getMiliseconds() * 100 ) -- return time in tenths of a second
end


return EQ
