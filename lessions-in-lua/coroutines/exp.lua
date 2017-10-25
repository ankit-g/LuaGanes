function print_hello()
	for i = 1, 10 do
		print('form '..i)
		if i == 10 then
			return i 
		end
		coroutine.yield(i)
	end
end

co = coroutine.create(print_hello)
--repeat
--	_, two, three = coroutine.resume(co)
--	print(_, two)
--until coroutine.status(co) == 'dead'

--while coroutine.status(co) ~= 'dead' do
--	_, two = coroutine.resume(co)
--	print(_, two)
--end
	_, two = coroutine.resume(co)
	print(_, two)
	print(coroutine.status(co))
for i=1, 10 do
	print(i)
	if i == 5 then break end
end	
