a -->{
 log(#0)
}
b ->(x Int){
 log(#0)
}
C ->(Int)
c --> C{
 log(#0)
}
a("029")
b(1)
c(1)