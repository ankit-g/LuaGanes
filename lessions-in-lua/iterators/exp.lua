function square(state,n) print ('state '..state..' n '..n) if n<state then n=n+1 return n,n*n end end
for i,n in square,10,2 do print(i,n) end

function my_iter(state, number)
	if number < state then
		number = number + 1
		return number
	end
end

for num in my_iter,10, 1 do
	print(num)
end
