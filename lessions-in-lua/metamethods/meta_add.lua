local vt = {val = 23}
local mt = {}
mt.__add = function (lhs, rhs)
	val = lhs.val + rhs.val
	return val
	end
local bakwas = setmetatable(vt, mt)
local y = vt + vt
print (y..' '..type(y))
print (bakwas.val)


local t1 = {23,4,234}
local save = setmetatable(t1, {__index = function (tbl, key) print ('key '..key) return ('bakwas') end})
print(t1[234])
print(t1[11])
print(t1[33])

local new = setmetatable({1,2,3,4}, {__index = save})
print(new[1])
print(new[2])
print(new[3])
print(new[43])
