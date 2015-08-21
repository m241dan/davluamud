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

function B:parse( str )
   local substr
   local t = {}

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


-- get substring at desired length, take into account colors and expand until we get the false length created by the color tags
local function getsubstr_color( str, length, ecc ) -- ecc expected color count
   local substr = str:sub( 1, length )
   local _ ,cc = substr:gsub( "#.", "" )

   if( cc ~= ecc ) then
      return getsubstr_color( str, length + cc * 2, cc )
   end
   return substr
end

return B

