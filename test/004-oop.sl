xx ->()Str{
 @return "4"
}
A => {
 a: Str
 b: Str
}
o = &A{
 a: "004"
 b: xx()
}
log(o.a)
log(o.b)