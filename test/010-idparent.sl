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