local B = {}

TOP_FAVOR = 1
BOT_FAVOR = 2
MID_FAVOR = 3

function B:new( width )
   local buffer = {}
   setmetatable( buffer, self )
   self.__index = self
   buffer.width = width;
   buffer.lines = {}
   buffer.favor = TOP_FAVOR
   return buffer
end

function B:parse( string )
   -- i imaginary index, ri real index, ts temp string
   -- use imaginary to deal with color codes, we don't want them counting towards line width
   local color, s, i, ri, t = false, 1, 1, 1, {}
   str:gsub(".", function( c ) table.insert( t, c ) end ) -- parse each character into a table

   while ri <= #string do
      ::start::
      ri = ri + 1
      if( t[ri] == '#' and not color ) then
         color = true
         ts = ts .. t[ri]
         goto start
      elseif( t[ri] == '#' and color ) then
         color = false
         ts = ts .. t[ri]
         goto start
      elseif( t[ri] == '\r' or t[ri] == '\n' ) then
         if( t[ri-1] == " " ) then
            repeat
               ri = ri - 1
            until t[ri] ~= " " or ri == 1
         end
         self.lines[#self.lines+1] = string.sub( string, s, ri )
         repeat
            ri = ri + 1
         until t[ri] ~= '\r' or t[ri] ~= '\n' or t[ri] ~= " " or ri == #string
         s = ri
         ts = ""
         i = s
         goto start
      end
      i = i + 1
      ts = ts .. t[ri]
   end
end

function B:length()
   local length
   for _,line in ipairs( self ) do
      length = length + #line
   end
   return length
end

function B:clear()
   self.lines = {}
end

B.__tostring = function ( buffer )
   return table.concat( buffer.lines, "\n" )
end

function B.buffers_to_string( ... )
   local output = {}
   return nil   
end

return B

