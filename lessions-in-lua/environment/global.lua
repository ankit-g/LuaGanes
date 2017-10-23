-- this is a comment

local gbl_tbl = _G

for k,v in pairs(gbl_tbl) do
	print (tostring(k)..' '..tostring(v))
end

collectgarbage()
