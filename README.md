## Progl Grammar 

null: _
int: 123,
str: "abc" 'abc' `abc`
char: @'abc'
dic: {}
arr: []
class:
 @@ ID {}
 @@ ID ID {}
obj: & ID

id: 
 local: #a Num#a
 global: ##a
 get: a (may be local, global or scope)

op:
 = + - * / ...
 
block: {}
func: @{} @()RETURN{} @ID()RETURN{}
tpl: @``
call: a() a.b()
keyword: @return @break @if @for @each

scope
 exec =>ID ID idorblock
 def: block ID ID

## 