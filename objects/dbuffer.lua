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
   --simplify these into \r\n into one character, much easier to work with
   local str = str:gsub( '\r\n', '\n' )
   local str = str:gsub( '\n\r', '\n' )
   local i, c, aw, lastspace = 1, 0, self.width, 0
   local t = {}
   str:gsub( ".", function( c ) table.insert( t, #t+1, c ); end )

   repeat
      ::parsestart::
      if( t[i] == '#' ) then -- test for color, if color expand c by two but also expand our artificial width by two, inc by two
         i = i + 2
         aw = aw + 2 
         c = c + 2
         goto parsestart
      elseif( t[i] == '\n' ) then -- if nl, reset our count and aw to start,inc by 1
         c = 0
         aw = self.width
         i = i + 1
         goto parsestart
      end

      if( t[i] == ' ' ) then -- record where our last space was, for when we have to back it up to prevent line truncation
         lastspace = i
      end
      i = i + 1
      c = c + 1

      if( c == aw ) then
         if( t[i] == ' ' ) then
            t[i] = '\n'
            c = 0
            goto parsestart
         else
            if( lastspace > i - aw ) then
               t[lastspace] = '\n'
               i = lastspace + 1
            else
               table.insert( t, i+1, '\n' )
               i = i + 2
            end
            c = 1
            aw = self.width
            lastspace = 0
         end
      end
   until not t[i]

   if( t[i-1] ~= '\n') then
      t[i] = '\n'
   end

   
   local newstr = table.concat( t, "" )
   newstr:gsub( "(.*)\n", function( ln ) table.insert( self.lines, #self.lines+1, ln ); end )
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

