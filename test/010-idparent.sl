#a = "010"
b = @(){
 log(a)
}
b()
a = "10"
b()
c = @(){
 a = "11"
}
c()
b()
d = @(){
 #a = "010-1"
 b()
 log(a)
}
d()