methodDefx(aliasc, "getClass", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return aliasGetx(o)
}, _, classc)


methodDefx(pathc, "timeMod", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// Str#p = o.dic["path"].str
 //TODO
 @return nullv
}, _, intc)
methodDefx(pathc, "exists", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = File(o.dic["path"].str)
 @return boolNewx(p.exists())
}, [strc], boolc)
methodDefx(pathc, "resolve", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = Path(o.dic["path"].str)
 @return strNewx(p.resolve())
}, [strc], strc)

methodDefx(filec, "write", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#d = x[1]
 #p = File(o.dic["path"].str)
 p.write(d.str)
 @return nullv
}, [strc])
methodDefx(filec, "readAll", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = File(o.dic["path"].str) 
 @return strNewx(p.readAll())
}, _, strc)

methodDefx(dirc, "write", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#d = x[1]
 Str#p = o.dic["path"].str
 dirWritex(p, d.dic) 
 @return nullv
}, [dicc])
methodDefx(dirc, "writeFile", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#f = x[1]
 Cptx#s = x[2]
 File(o.dic["path"].str + f.str).write(s.str)
 @return nullv
}, [strc, strc])
methodDefx(dirc, "makeAll", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#p = x[1]
 #ps = p.str 
 @if(ps == ""){
  #ps = "0777"
 }
 #pp = Dir(o.dic["path"].str)
 pp.makeAll(ps)
 @return nullv
}, [strc, strc])

methodDefx(objc, "toDic", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #arrx = &Arrx
 @each _ k keys(o.dic).sort(){
  arrx.push(strNewx(k))
 }
 @return dicNewx(dicc, o.dic, arrx)
}, _, dicc)

methodDefx(classc, "schema", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #arrx = &Arrx
 @each _ k keys(o.dic).sort(){
  arrx.push(strNewx(k))
 }
 @return dicNewx(dicc, o.dic, arrx)
}, _, dicc)
methodDefx(classc, "parents", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return arrNewx(arrclassc, arrCopyx(o.arr))
}, _, arrc)

methodDefx(intc, "toStr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(Str(o.int))
},[intc], strc)

methodDefx(floatc, "toStr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(Str(Float(o.val)))
},[intc], strc)

methodDefx(strc, "split", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#sep = x[1] 
 Arr_Str#xx = o.str.split(sep.str)
 Arrx#y = &Arrx
 @each _ v xx{
  y.push(strNewx(v))
 }
 @return arrNewx(arrstrc, y)
},[strc, strc], arrstrc)
methodDefx(strc, "replace", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#fr = x[1]
 Cptx#to = x[2]
 @return strNewx(o.str.replace(fr.str, to.str))
},[strc, strc], strc)
methodDefx(strc, "toPath", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = Path(o.str)
 @return objNewx(filec, {
  path: strNewx(p.resolve())
 })
},_, filec)
methodDefx(strc, "toFile", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = File(o.str)
 @return objNewx(filec, {
  path: strNewx(p.resolve())
 })
},_, filec)
methodDefx(strc, "toDir", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = Dir(o.str) 
 @return objNewx(dirc, {
  path: strNewx(p.resolve() + "/")
 })
},_, dirc)
methodDefx(strc, "toJsonArr", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
 //TODO
 @return nullv
},_, jsonarrc)
methodDefx(strc, "toJson", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
 //TODO
 @return nullv
},_, jsonc)
methodDefx(strc, "toInt", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return intNewx(Int(o.str))
},_, intc)
methodDefx(strc, "toFloat", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return floatNewx(Float(o.str))
},_, floatc)
methodDefx(strc, "escape", ->(x Arrx, env Cptx)Cptx{
 Str#s = x[0].str
 @return strNewx(escapex(s))//TODO replace 
},[strc], strc)
methodDefx(strc, "isInt", ->(x Arrx, env Cptx)Cptx{
 Str#s = x[0].str
 @return boolNewx(s.isInt())
},[strc], boolc)

methodDefx(arrc, "push", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1] 
 o.arr.push(e)
 @return nullv
},[cptc])
methodDefx(arrc, "pop", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 o.arr.pop()
 @return nullv
})
methodDefx(arrc, "unshift", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1] 
 o.arr.unshift(e)
 @return nullv
},[cptc])
methodDefx(arrc, "len", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return intNewx(o.arr.len())
},_, intc)
methodDefx(arrc, "set", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#i = x[1]
 Cptx#v = x[2]
 @if(o.arr.len() <= i.int){
  log(arr2strx(o.arr))
  log(i.int)
  die("arrset: index out of range")
 }
 o.arr[i.int] = dynEnsure(v)
 o.fdefault = @false
 @return v
}, [uintc, cptc], cptc)
methodDefx(arrstrc, "sort", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
 //TODO
 @return nullv
},_, arrstrc)

methodDefx(arrstrc, "join", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#sep = x[1]
 #s = ""
 @each i v o.arr{
  @if(i != 0){
   s += sep.str
  }
  s += v.str
 }
 @return strNewx(s)
},[strc], strc)

methodDefx(jsonc, "len", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 //TODO
 @return intNewx(o.arr.len())
},_, intc)


methodDefx(dicc, "len", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return intNewx(o.arr.len())
},_, intc)
methodDefx(dicc, "set", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#i = x[1]
 Cptx#v = x[2]
 @if(o.dic[i.str] == _){
  o.arr.push(i)
 }
 o.dic[i.str] = dynEnsure(v)
 o.fdefault = @false 
 @return v
}, [strc, cptc], cptc)
methodDefx(dicc, "hasKey", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#i = x[1]
 @if(o.dic[i.str] != _){
  @return truev
 }
 @return falsev
}, [strc], boolc)
methodDefx(dicc, "appendClass", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#c = x[1]
 appendClassx(o, c)
 @return o
}, [classc], dicc)
//TODO to func
methodDefx(dicc, "values", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return valuesx(o)
}, _, arrc)
methodDefx(dicstrc, "values", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return valuesx(o)
}, _, arrstrc)
