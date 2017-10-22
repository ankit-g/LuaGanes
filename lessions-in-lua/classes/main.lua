local ActorClass = require('hello')

hero = ActorClass.new()
villan = ActorClass.new()

print(hero:get_name())
print(villan:get_name())
hero:set_name('Ankit')
villan:set_name('Kopal')
print(hero:get_name())
print(villan:get_name())
