local function readfile(filename)
        local f =assert(io.open(filename,'r'))
        local content = f:read('*all')
        -- local content =f:read('*line')
        f:close()
        return content
end

-- print(readfile("catalina.out"))

-- print(readfile("catalina.out","^tbl_"))

-- s_content = readfile("catalina.out")

-- print(string.find(s_content,"tbl_(%l+)"))

-- for word in string.gmatch(readfile("catalina.out"),"tbl_%a*_%a*_%a*_%a*")
   for word in string.gmatch(readfile("catalina.out"),"(tbl_%a*_%a*)")

  do print(word)
  end
