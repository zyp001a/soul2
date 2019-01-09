A => {
 b: Int
}
Uint#b = 1
a = &A
a.b = b
log(a.b)

x = {
 y: 1
}
x["y"] = b
log(x["y"])
aa ->(b){
 log("0"+Str(b))
 log(b)
}
aa("20")