b ->(a Str){
 a += "1"
}
x = "0"
log("#1")
log(x)
b(x)
log(x)
b(x)
log(x)
c ->(a Str){
 a = a + "1"
}
x = "0"
log("#2")
log(x)
c(x)
log(x)
c(x)
log(x)
