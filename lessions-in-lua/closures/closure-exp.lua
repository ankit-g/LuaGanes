function master()
	local variable = 23
	local function get() return variable end
	local function set(x) variable = x end
	return {get = get, set = set}
end

func_foo = master()
func_bar = master()

print(func_foo.get())
print(func_bar.get())

func_bar.set(89)
func_foo.set(234)

print(func_foo.get())
print(func_bar.get())
