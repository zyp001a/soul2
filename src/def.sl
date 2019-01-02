funcDefx(defmain, "getEnv", ->(x Arrx, env Cptx)Cptx{
 @return env
}, _, envc)
funcDefx(defmain, "getExec", ->(x Arrx, env Cptx)Cptx{
 @return env.dic["envExec"]
}, _, classc)

funcDefx(defmain, "osCmd", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#p = x[1]
 @return strNewx(osCmd(o.str, p.str))
}, [strc, strc], strc)
funcDefx(defmain, "osArgs", ->(x Arrx, env Cptx)Cptx{
 @if(_osArgs == _){
  #x = &Arrx
  Arr_Str#aa = osArgs()
  @each i v aa{
   @if(i == 0){
    @continue
   }
   x.push(strNewx(v))
  }
  _osArgs = arrNewx(arrstrc, x)
 }
 @return _osArgs
}, _, arrstrc)
funcDefx(defmain, "osEnvGet", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(osEnvGet(o.str))
}, [strc], strc)
funcDefx(defmain, "getArgFlag", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return boolNewx(o.farg)
}, [cptc], boolc)
funcDefx(defmain, "getDefaultFlag", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return boolNewx(o.fdefault)
}, [cptc], boolc)
funcDefx(defmain, "getPropFlag", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return boolNewx(o.fprop)
}, [cptc], boolc)
funcDefx(defmain, "getMidFlag", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return boolNewx(o.fmid)
}, [cptc], boolc)
funcDefx(defmain, "getName", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.name)
}, [cptc], strc)
funcDefx(defmain, "getId", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.id)
}, [cptc], strc)
funcDefx(defmain, "getNote", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.str)
}, [cptc], strc)
funcDefx(defmain, "setIndent", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 _indentx = o.str
 @return nullv
},[strc])

funcDefx(defmain, "methodGet", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#f = x[1]
 @return nullOrx(methodGetx(o, f))
},[classc, funcc], cptc)

funcDefx(defmain, "new", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return defx(o, e.dic)
},[classc, dicc], cptc)
funcDefx(defmain, "as", ->(x Arrx, env Cptx)Cptx{//Cpt to any
 Cptx#o = x[0]
 @return o
},[cptc, cptc], cptc)
funcDefx(defmain, "type", ->(x Arrx, env Cptx)Cptx{//Cpt to any
 @return nullv
},[cptc], cptc)
funcDefx(defmain, "numConvert", ->(x Arrx, env Cptx)Cptx{//int/ convertion
 Cptx#o = x[0]
 Cptx#c = x[1]
 @if((o.type != T##INT && o.type != T##FLOAT) || (c.ctype != T##INT && c.ctype != T##FLOAT)){//int float
  log(strx(o))
  log(strx(c))  
  die("numConvert between float int big")
 }
 @if(o.type == c.ctype){
  o.obj = c
  @return o
 }

 @if(o.type == T##INT){
  @return floatNewx(Float(o.int), c)
 }
 @if(o.type == T##FLOAT){
  @return intNewx(Int(Float(o.val)), c)
 }
 @return nullv
},[cptc, classc], cptc)
funcDefx(defmain, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return nullOrx(getx(o, e.str))
},[cptc, strc], cptc)
funcDefx(defmain, "mustGet", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #r = getx(o, e.str)
 @if(r == _){
  die(e.str + " not found!")
 }
 @return r
},[cptc, strc], cptc)
funcDefx(defmain, "set", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 Cptx#v = x[2] 
 #r = setx(o, e.str, v)
 @if(r != _){
  @return r
 }
 o.fdefault = @false 
 @return nullv 
},[cptc, strc, cptc], cptc)

funcDefx(defmain, "inClass", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1]; 
 @return boolNewx(inClassx(l, r))
}, [classc, classc], boolc)
funcDefx(defmain, "class", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return classx(l)
}, [cptc], cptc)
funcDefx(defmain, "typepred", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return typepredx(l)
}, [cptc], classc)
funcDefx(defmain, "isCpt", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == T##CPT)
}, [cptc], boolc)
funcDefx(defmain, "isObj", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == T##OBJ)
}, [cptc], boolc)
funcDefx(defmain, "isClass", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == T##CLASS)
}, [cptc], boolc)
funcDefx(defmain, "isInt", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == T##INT)
}, [cptc], boolc)
funcDefx(defmain, "isFloat", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == T##FLOAT)
}, [cptc], boolc)
funcDefx(defmain, "isNumBig", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == T##NUMBIG)
}, [cptc], boolc)
funcDefx(defmain, "isStr", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == T##STR)
}, [cptc], boolc)
funcDefx(defmain, "isArr", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == T##ARR)
}, [cptc], boolc)
funcDefx(defmain, "isDic", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == T##DIC)
}, [cptc], boolc)
funcDefx(defmain, "uid", ->(x Arrx, env Cptx)Cptx{
 @return strNewx(uidx())
}, _, strc)
funcDefx(defmain, "log", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 log(strx(o))
 @return nullv
}, [cptc])
funcDefx(defmain, "die", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 die(o.str)
 @return nullv
}, [strc])
funcDefx(defmain, "print", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 print(o.str)
 @return nullv
}, [strc])
funcDefx(defmain, "appendIfExists", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 Cptx#app = x[1]; 
 @if(o.str == ""){
  @return o
 }
 o.str += app.str
 @return o
}, [strc, strc], strc)
funcDefx(defmain, "ind", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#f = x[1] 
 @return strNewx(indx(o.str, f.int))
}, [strc, intc], strc)
funcDefx(defmain, "exec", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return execx(l, env, 1)
}, [cptc], cptc)
funcDefx(defmain, "blockExec", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return blockExecx(l, env)
}, [blockc], cptc)
funcDefx(defmain, "opp", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#op = x[1]
 Cptx#ret = execx(o, env, 1)
 @if(ret.type != T##STR){
  die("opp: not used in tplCall")
 }
 @if(!inClassx(classx(o), callc)){
  @return ret
 }
 Cptx#f = o.class
 @if(!inClassx(classx(f), opc)){
  @return ret
 }
 Int#sub = getx(f, "opPrecedence").int
 Int#main = getx(op, "opPrecedence").int
 @if(sub > main){
  @return strNewx("(" + ret.str + ")")
 }
 @return ret
},[cptc, opc, envc], strc)
funcDefx(defmain, "call", ->(x Arrx, env Cptx)Cptx{
 Cptx#f = x[0];
 Cptx#a = x[1];
 @if(f == _ || f.id == nullv.id){
  log(strx(a))
  die("call() error");
 }
 @if(!inClassx(classx(f), funcc)){
  log(strx(f))
  die("not func")
 }
 @return callx(f, a.arr, env)
}, [funcc, arrc], cptc)
funcDefx(defmain, "tplCall", ->(x Arrx, env Cptx)Cptx{
 Cptx#f = x[0];
 Cptx#a = x[1];
 Cptx#e = x[2];
 @if(e.fdefault){
  e = env
 }
 @return tplCallx(f, a.arr, e)
}, [functplc, arrc, envc], cptc)
funcDefx(defmain, "keys", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return copyx(arrNewx(arrstrc, o.arr))
}, [dicc], arrstrc)
funcDefx(defmain, "callFunc", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return o.class
}, [callc], funcc)
funcDefx(defmain, "callArgs", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return arrNewx(arrc, o.arr)
}, [callc], arrc)
methodDefx(aliasc, "getClass", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return aliasGetx(o)
}, _, classc)





methodDefx(pathxc, "timeMod", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// Str#p = o.dic["path"].str
 //TODO
 @return nullv
}, _, intc)


methodDefx(pathxc, "timeMod", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// Str#p = o.dic["path"].str
 //TODO
 @return nullv
}, _, intc)
methodDefx(pathxc, "exists", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = Filex(o.dic["path"].str)
 @return boolNewx(p.exists())
}, [strc], boolc)
methodDefx(pathxc, "resolve", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = Pathx(o.dic["path"].str)
 @return strNewx(p.resolve())
}, [strc], strc)

methodDefx(filexc, "write", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#d = x[1]
 #p = Filex(o.dic["path"].str)
 p.write(d.str)
 @return nullv
}, [strc])
methodDefx(filexc, "readAll", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = Filex(o.dic["path"].str) 
 @return strNewx(p.readAll())
}, _, strc)

methodDefx(dirxc, "write", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#d = x[1]
 Str#p = o.dic["path"].str
 dirWritex(p, d.dic) 
 @return nullv
}, [dicc])
methodDefx(dirxc, "writeFile", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#f = x[1]
 Cptx#s = x[2]
 Filex(o.dic["path"].str + f.str).write(s.str)
 @return nullv
}, [strc, strc])
methodDefx(dirxc, "makeAll", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#p = x[1]
 #ps = p.str 
 @if(ps == ""){
  #ps = "0777"
 }
 #pp = Dirx(o.dic["path"].str)
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
methodDefx(strc, "toPathx", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = Pathx(o.str)
 @return objNewx(filexc, {
  path: strNewx(p.resolve())
 })
},_, filexc)
methodDefx(strc, "toFilex", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = Filex(o.str)
 @return objNewx(filexc, {
  path: strNewx(p.resolve())
 })
},_, filexc)
methodDefx(strc, "toDirx", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = Dirx(o.str) 
 @return objNewx(dirxc, {
  path: strNewx(p.resolve() + "/")
 })
},_, dirxc)
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



methodDefx(fsc, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#s = x[1]
 //TODO
 @return objNewx(filec, {
  handlerRouter: o
  handlerPath: s
 })
}, [strc], filec)
methodDefx(filec, "write", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#d = x[1]
 #p = Filex(o.dic["handlerPath"].str)
 p.write(d.str)
 @return nullv
}, [bytesc])
methodDefx(filec, "read", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = Filex(o.dic["handlerPath"].str) 
 @return strNewx(p.readAll(), bytesc)
}, _, bytesc)
methodDefx(filec, "rm", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #p = o.dic["handlerPath"].str
 @fs[p].rm()
 @return nullv
})




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
 o.arr[i.int] = copyCptFromAstx(v)
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
 o.dic[i.str] = copyCptFromAstx(v)
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
opDefx(arrc, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return o.arr[e.int]
},intc, cptc, opgetc)
opDefx(dicc, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #r = o.dic[e.str]
 @return nullOrx(r)
},strc, cptc, opgetc)
opDefx(jsonc, "get", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// Cptx#e = x[1]
 //TODO
 @return nullv
},strc, cptc, opgetc)

opDefx(idlocalc, "assign", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];

 #v = execx(r, env)
 Cptx#local = env.dic["envLocal"]
 #str = l.dic["idStr"]
 local.dic[str.str] = copyCptFromAstx(v)
 @return v
}, cptc, cptc, opassignc)

opDefx(idstatec, "assign", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 #v = execx(r, env)
 Str#k = l.dic["idStr"].str
 Cptx#o = l.dic["idState"].obj
 o.dic[k] = copyCptFromAstx(v)
 @return v
}, cptc, cptc, opassignc)

opDefx(strc, "add", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return strNewx(l.str + r.str)
}, strc, strc, opaddc)
opDefx(strc, "eq", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.str == r.str)
}, strc, boolc, opeqc)
opDefx(strc, "ne", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.str != r.str)
}, strc, boolc, opnec)
opDefx(strc, "concat", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 l.str += r.str
 @return l
}, strc, strc, opconcatc)

opDefx(intc, "add", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int + r.int)
}, intc, intc, opaddc)
opDefx(intc, "subtract", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int - r.int)
}, intc, intc, opsubtractc)

opDefx(intc, "multiply", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int * r.int)
}, intc, intc, opmultiplyc)

opDefx(intc, "divide", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int / r.int)
}, intc, intc, opdividec)
opDefx(intc, "mod", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int % r.int)
}, intc, intc, opmodc)
opDefx(intc, "eq", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int == r.int)
}, intc, boolc, opeqc)
opDefx(intc, "ne", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int != r.int)
}, intc, boolc, opnec)
opDefx(intc, "lt", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int < r.int)
}, intc, boolc, opltc)
opDefx(intc, "gt", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int > r.int)
}, intc, boolc, opgtc)
opDefx(intc, "le", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int <= r.int)
}, intc, boolc, oplec)
opDefx(intc, "ge", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int >= r.int)
}, intc, boolc, opgec)

opDefx(boolc, "and", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int != 0 && r.int != 0)
}, boolc, boolc, opandc)
opDefx(boolc, "or", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int !=0 || r.int != 0)
}, boolc, boolc, oporc)

opDefx(cptc, "add", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @if(l.type != r.type){
  log(strx(l)) 
  die("add: wrong type")
 }
 @if(l.type == T##INT){ 
  @return intNewx(l.int + r.int)
 }
 @if(l.type == T##FLOAT){ 
  @return floatNewx(Float(l.val) + Float(r.val))
 }
 @if(l.type == T##STR){ 
  @return strNewx(l.str + r.str)
 }
 log(strx(l))
 die("cannot add")
 @return nullv
}, cptc, cptc, opaddc)
opDefx(cptc, "not", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @if(l.type != T##INT){
  log(strx(l)) 
  die("not wrong type")
 }
 @return boolNewx(l.int == 0)
}, _, boolc, opnotc)
opDefx(cptc, "ne", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(!eqx(l, r))
}, cptc, boolc, opnec)
opDefx(cptc, "eq", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(eqx(l, r))
}, cptc, boolc, opeqc)
execDefx("Env", ->(x Arrx, env Cptx)Cptx{
 Cptx#nenv = x[0]
 _indentx = " "
 @if(nenv.int == 1){
  @return nenv
 }
 //if not active, start
 nenv.int = 1
 @if(nenv.dic["envExec"].id == execmain.id){
  @return blockExecx(nenv.dic["envBlock"], nenv)
 }
 @return execx(nenv, nenv, 1)
})
execDefx("Call", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#f = execx(c.class, env)
 Arrx#args = c.arr
 @if(f == _ || f.id == nullv.id){
  log(strx(c))
  die("Call: empty func")
 }
 #argsx = prepareArgsx(args, f, env)
 @return callx(f, argsx, env)
})
execDefx("Arr_Call", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 @return subBlockExecx(c.arr, env)
})
execDefx("CallPassRef", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#f = c.class//TODO exec
 Arrx#args = c.arr
 #argsx = prepareArgsRefx(args, f, env) 
 @return callx(c.class, argsx, env)
})
execDefx("CallRaw", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.arr
 @return callx(c.class, args, env)
})
execDefx("Null", ->(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Obj", ->(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Class", ->(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Val", ->(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Dic", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @if(inClassx(classx(o), midc)){
  #it = getx(o, "itemsType")
  @if(it == _){
   it = cptv
  } 
  #d = &Dicx
  @each k v o.dic{
   d[k] = execx(v, env)
  }
  #c = itemDefx(dicc, classx(it))
  @return dicNewx(c, d, arrCopyx(o.arr))
 }
 @return o
})
execDefx("Arr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @if(inClassx(classx(o), midc)){
  #it = getx(o, "itemsType")
  @if(it == _){
   it = cptv
  } 
  #a = &Arrx
  @each i v o.arr{
   a.push(execx(v, env))
  }
  #c = itemDefx(arrc, classx(it))
  @return arrNewx(c, a)
 }
 @return o
})

execDefx("CtrlReturn", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 #f = execx(c.dic["ctrlArg"], env)
 @return defx(returnc, {
  return: f
 })
})
execDefx("CtrlBreak", ->(x Arrx, env Cptx)Cptx{
 @return objNewx(breakc)
})
execDefx("CtrlContinue", ->(x Arrx, env Cptx)Cptx{
 @return objNewx(continuec)
})
execDefx("CtrlIf", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["ctrlArgs"].arr
 Int#l = args.len()
 @for Int#i=0;i<l-1;i+=2 {
  #r = execx(args[i], env)
  @if(ifcheckx(r)){
   @return blockExecx(args[i+1], env)
  }
 }
 @if(l%2 == 1){
  @return blockExecx(args[l-1], env)
 }
 @return nullv
})
execDefx("CtrlFor", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["ctrlArgs"].arr
 execx(args[0], env)
 @for 1 {
  Cptx#c = execx(args[1], env)
  @if(!ifcheckx(c)){
   @break
  }
  #r = blockExecx(args[3], env)
  @if(inClassx(classx(r), signalc)){
   @if(r.obj.id == breakc.id){
    @break;
   }
   @if(r.obj.id == continuec.id){
    @continue;
   }
   @return r    
  }
  execx(args[2], env)
 }
 @return nullv
})
execDefx("CtrlEach", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["ctrlArgs"].arr
 Cptx#da = execx(args[2], env)
 Str#key = args[0].str
 Str#val = args[1].str
 Dicx#local =  env.dic["envLocal"].dic
 @if(da.type == T##DIC){
  @each _ kc da.arr{
   Str#k = kc.str
   Cptx#v = da.dic[k]
   @if(key != ""){
    local[key] = strNewx(k)
   }
   @if(val != ""){
    local[val] = v
   }
   #r = blockExecx(args[3], env)
   @if(inClassx(classx(r), signalc)){
    @if(r.obj.id == breakc.id){
     @break;
    }
    @if(r.obj.id == continuec.id){
     @continue;
    }
    @return r    
   }
  }
 }@elif(da.type == T##ARR){
  @each i v da.arr{
   @if(key != ""){
    local[key] = intNewx(Int(i), uintc)
   }
   @if(val != ""){
    local[val] = v   
   }
   #r = blockExecx(args[3], env)
   @if(inClassx(classx(r), signalc)){
    @if(r.obj.id == breakc.id){
     @break;
    }
    @if(r.obj.id == continuec.id){
     @continue;
    }
    @return r    
   }
  }
 //TODO str...
 }@elif(da.id == nullv.id){
  @return nullv
 }@else{
  log(strx(da))
  log(da.type)
  log(classx(da).ctype)    
  die("CtrlEach: type not defined");
 }
 @return nullv
})
execDefx("IdClass", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 @return getx(c, "idVal")
})
execDefx("IdLocal", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#l = env.dic["envLocal"]
 Str#k = c.dic["idStr"].str
 #r = getx(l, k)
 @if(r == _){
  @return nullv
 }
 @return r;
})
execDefx("IdState", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Str#k = c.dic["idStr"].str
 Cptx#o = c.dic["idState"].obj
 #r = o.dic[k]
 @if(r == _){
  @return nullv
 }
 @return r;
})
