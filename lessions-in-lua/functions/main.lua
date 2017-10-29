function foo(x)
	print((2+x))
end

foo(-1)

function exe_once(func)
	local once = true

	return function(...)
		if once == true then func(unpack({...})) end
		once = false
	end
end

function print_hello(...)
	print(unpack({...}))
end
function print_something()
	print('hello something')
end

hello = exe_once(print_hello)
something = exe_once(print_something)

hello()
something()
hello(1,2,3)
something()
hello(1,2,3)
something()
