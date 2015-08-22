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

-- get substring at desired length, take into account colors and expand until we get the false length created by the color tags
local function getsubstr_color( str, length, ecc ) -- ecc expected color count
   local substr = str:sub( 1, length )
   local _ ,cc = substr:gsub( "#.", "" )
   print( string.format( "str = %s expectation = %d",substr, ecc ) )
   if( cc ~= ecc ) then
      return getsubstr_color( str, ( length + cc * 2 ) - 1, cc )
   end
   return substr
end

function B:parse( str )
   local str = str:gsub( '\r\n', '\n' )
   local str = str:gsub( '\n\r', '\n' )
   local substr
   local t = {}
   str:gsub( ".", function( c ) table.insert( t, #t+1, c ); end )
   local s, i, e, nl = 1, nil, nil, false

   substr = getsubstr_color( str:sub( s ), self.width, 0 ) -- get the length of a str with color codes
   e = #substr
   repeat
      print( "substr " .. substr )
      i = s
      repeat
         i = i + 1
      until( t[i] == '/n' or i == e or t[i] == nil ) -- iterate until we find a nl or the end

      if( t[i] == nil ) then
         goto test
      end


      e = i -- set new "ending"
      print( "t[i] " .. t[i] )
      if( t[i] ~= ' ' and t[i] ~= '\n' ) then -- back up until we hit a character
         repeat
            i = i - 1
         until t[i] == ' ' or i == s
         if( t == s ) then
           i = e 
         end
      end
      ::test::
      local insertstr = str:sub( s, i ):gsub( "\n", "" )
      print( insertstr )
      table.insert( self.lines, #self.lines+1, insertstr )
      i = i + 1
      s = i
      substr = getsubstr_color( str:sub( s ), self.width, 0 ) -- get the length of a str with color codes
      e = #substr + s
   until t[s] == nil
   return true
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

