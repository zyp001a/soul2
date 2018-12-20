a()
a -> (){
 b()
}
b -> (){
 log("017")
}
#i = 0
c -> (){
 i++
 @if(i > 3){
  @return
 }
 log(i)
 c()
}
c()
D => {
 a: &D
 b: &Str
}
d = &D{
 b: "123"
}
log(d.b)