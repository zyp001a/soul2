#a = {
 a: "009"
}

log("#1")
@each k v a{
 log(k)
 log(v) 
}
log("#2")
@each _ v a{
 log(v)
}
log("#3")
@each k _ a{
 log(k)
}
#b = [1,2]
@each i v b{
 log(i)
 @continue; 
 log(v)
}
@each _ v b{
 log(v)
 @break;
}
@for #i=0; i<2; i++ {
 log(i)
}
#i = 0
@for i<2 {
 log(i)
 @break
}