## Stream programming
>> normal pass, if tmp/mid stream, auto close
>>> append to

Stream


Handler: Func
fh ->> {
 @susp
 @play
 @stop

 @ack
 
 @err
 @ok
 @redirect
 @cached
 @notfound 
}
Flow:
File => Flow
End => Flow

f := @flow File ->>{}
f := @flow fh
f := @flow
f.bind(fh)

flowset := {
 "/": f
}
@fs := &End

@stdin.use(->>{
})
@stdout
Path => Str
Msg
send >>
"" >> @stdout
@fs["a"] >> #a
## cmd basics
Context => {
 mindmap: Dic_Cpt
 history: Arr_Cmd
}
DecTree => {
}
Cmd => {
 expect: Tree
 receive: Cmd
}
fillexpect->{
 expect get candicate dis 0/1/2
 receive
 0/1/2 -? scope
 unknown
}
init context
 cmd -> fill-expect? ->
		

## 