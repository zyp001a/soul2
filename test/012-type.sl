B := @type Str
C := @type Dic Int
D := @type -> (Int)Int
B#a = "1"
a += "2"
log(a)

b -> (dic C){
 log(dic["a"])
}
b({
 a: 1
})

