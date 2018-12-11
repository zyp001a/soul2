A = @class {
 a: &Str
}
o = &A{
 a: "004"
}
log(o.a)