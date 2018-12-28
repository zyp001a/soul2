b ->(a Str){
 a += "1"
 log(a)
}
log("#1")
x = "0"
log(x)
b(x)
log(x)
b(x)
log(x)
c ->(a Str){
 a = a + "1"
 log(a)
}
x = "0"
log("#2")
log(x)
c(x)
log(x)
c(x)
log(x)
