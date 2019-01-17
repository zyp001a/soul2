//func
//////ENV/////
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
funcDefx(defmain, "osEnvGet", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(osEnvGet(o.str))
}, [strc], strc)

/////////TPL/////
funcDefx(defmain, "setIndent", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 _indentx = o.str
 @return nullv
},[strc])
funcDefx(defmain, "uid", ->(x Arrx, env Cptx)Cptx{
 @return strNewx(uidx())
}, _, strc)
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
//TODO ???
funcDefx(defmain, "execNative", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return execx(l, env)
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
funcDefx(defmain, "tplCall", ->(x Arrx, env Cptx)Cptx{
 Cptx#f = x[0];
 Cptx#a = x[1];
 Cptx#e = x[2];
 @if(e.fdefault){
  e = env
 }
 @return tplCallx(f, a.arr, e)
}, [functplc, arrc, envc], cptc)

////////CPT//////////
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
funcDefx(defmain, "getStaticFlag", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return boolNewx(o.fstatic)
}, [cptc], boolc)
funcDefx(defmain, "getMidFlag", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return boolNewx(o.fmid)
}, [cptc], boolc)
funcDefx(defmain, "getClass", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return o.class
}, [cptc], classc)
funcDefx(defmain, "getPropName", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.str)
}, [cptc], strc)
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

///TODO rm////
funcDefx(defmain, "parseSend", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return execx(l, env, 1)
}, [cptc], cptc)
funcDefx(defmain, "keys", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return copyx(arrNewx(o.arr, arrstrc))
}, [dicc], arrstrc)
funcDefx(defmain, "sendImpl", ->(x Arrx, env Cptx)Cptx{
 Cptx#s = x[0]
 Cptx#o = x[1] 
 #arr = sendx(s, o.arr)
 @return arrNewx(arr)
},[classc, arrc], arrc)
funcDefx(defmain, "send", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #arr = sendx(defmain, o.arr)
 @each _ v arr{
  Cptx#r = execx(v, env)
  @if(inClassx(classx(r), signalc)){
   @return r
  }
 }
 @return nullv
},[arrc])

//////SYS///////
funcDefx(defmain, "propGet", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#c = x[1]
 Cptx#s = x[2] 
 @return nullOrx(propGetx(o, c, s.str))//TODO modify
},[classc, classc, strc], cptc)
funcDefx(defmain, "new", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return defx(o, e.dic)
},[classc, dicc], cptc)
funcDefx(defmain, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return nullOrx(getx(o, e.str))
},[cptc, strc], cptc)
funcDefx(defmain, "mustGet", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #r = mustGetx(o, e.str)
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
 @return v
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
funcDefx(defmain, "malloc", ->(x Arrx, env Cptx)Cptx{
 Cptx#i = x[0]
 Cptx#c = x[1]
 #arr = malloc(i.int, Cptx)
 @return arrNewx(arr, itemsDefx(staticarrc, c))
},[uintc, classc], staticarrc)
funcDefx(defmain, "call", ->(x Arrx, env Cptx)Cptx{
 Cptx#f = x[0];
 Cptx#a = x[1];
 @if(f == _ || f.id == nullv.id){
  log(strx(a))
  die("call() error");
 }
 @if(!inClassx(classx(f), funcc)){ 
  log(strx(f))
  diex("not func", env)
 }
 @return callx(f, a.arr, env)
}, [funcc, arrc], cptc)

////CONVERT///////
funcDefx(defmain, "as", ->(x Arrx, env Cptx)Cptx{//Cpt to any
 Cptx#o = x[0]
 @return o
},[cptc, cptc], cptc)
funcDefx(defmain, "type", ->(x Arrx, env Cptx)Cptx{//Cpt to any
 @return nullv
},[cptc], cptc)
funcDefx(defmain, "implConvert", ->(x Arrx, env Cptx)Cptx{//int/ convertion
 Cptx#o = x[0]
 @return o  
},[cptc, classc], cptc)
funcDefx(defmain, "strConvert", ->(x Arrx, env Cptx)Cptx{//int/ convertion
 Cptx#o = x[0]
 Cptx#c = x[1]
 @return strNewx(o.str, c)
}, [cptc, classc], cptc)
funcDefx(defmain, "numConvert", ->(x Arrx, env Cptx)Cptx{//int/ convertion
 Cptx#o = x[0]
 Cptx#c = x[1]
 @if((o.type != T##INT && o.type != T##FLOAT) || (c.ctype != T##INT && c.ctype != T##FLOAT)){//int float
  log(strx(o))
  log(strx(c))  
  die("numConvert between float int big")
 }
 @if(o.type == c.ctype){
  @if(inClassx(c, bytec)){
    o.str = byte2strx(o.int)
  }
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
}, [cptc, classc], cptc)

//////////////TYPE///
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

///UTILS common///
funcDefx(defmain, "log", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 log(strx(o))
 @return nullv
}, [cptc])
funcDefx(defmain, "die", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 diex(o.str, env)
 @return nullv
}, [strc])
funcDefx(defmain, "throw", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 diex(o.str, env)
 @return nullv
}, [errorc, strc])

//TODO change
funcDefx(defmain, "print", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 print(o.str)
 @return nullv
}, [strc])
funcDefx(defmain, "lg", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 print(o.str)
 @return nullv
}, [strc])

/////get struct INTERNAL/////
funcDefx(defmain, "callFunc", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return o.class
}, [callc], funcc)
funcDefx(defmain, "callArgs", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return arrNewx(o.arr)
}, [callc], arrc)

funcDefx(defmain, "idStr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.str)
}, [callc], strc)
funcDefx(defmain, "idState", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return o.class
}, [callc], cptc)
funcDefx(defmain, "idVal", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return o.class
}, [callc], cptc)




////METHOD BASIC///////////////////
//method cptc
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

//method classc
methodDefx(classc, "schema", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #arrx = &Arrx
 @each _ k keys(o.dic).sort(){
  arrx.push(strNewx(k))
 }
 @return dicNewx(o.dic, arrx)
}, _, dicc)
methodDefx(classc, "parents", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return arrNewx(arrCopyx(o.arr), arrclassc)
}, _, arrc)

///aliasc
methodDefx(aliasc, "getClass", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return aliasGetx(o)
}, _, classc)


///objc
methodDefx(objc, "toDic", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #arrx = &Arrx
 @each _ k keys(o.dic).sort(){
  arrx.push(strNewx(k))
 }
 @return dicNewx(o.dic, arrx)
}, _, dicc)

////METHOD NUM///////////////////
///numc
methodDefx(intc, "toStr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(Str(o.int))
},[intc], strc)
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

methodDefx(floatc, "toStr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(Str(Float(o.val)))
},[intc], strc)

methodDefx(bytec, "toStr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.str)
}, _, strc)


////METHOD STR////////////
///strc
methodDefx(strc, "len", ->(x Arrx, env Cptx)Cptx{
 Cptx#s = x[0];
 @return intNewx(s.str.len(), uintc)
}, _, uintc)
methodDefx(strc, "toBytes", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return bytesNewx(o.str)
}, _, bytesc)
methodDefx(strc, "split", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#sep = x[1] 
 Arr_Str#xx = o.str.split(sep.str)
 Arrx#y = &Arrx
 @each _ v xx{
  y.push(strNewx(v))
 }
 @return arrNewx(y, arrstrc)
},[strc, strc], arrstrc)
methodDefx(strc, "replace", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#fr = x[1]
 Cptx#to = x[2]
 @return strNewx(o.str.replace(fr.str, to.str))
},[strc, strc], strc)

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
}, [strc], strc)
methodDefx(strc, "isInt", ->(x Arrx, env Cptx)Cptx{
 Str#s = x[0].str
 @return boolNewx(s.isInt())
}, [strc], boolc)
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
//TODO change
/*
opDefx(strc, "concat", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 l.str += r.str
 @return l
}, strc, strc, opconcatc)
*/


/////////////METHOD ARR////////////
///arrc
methodDefx(arrc, "len", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return intNewx(o.arr.len(), uintc)
},_, uintc)
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
opDefx(arrc, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #r = o.arr[e.int]
 @if(r == _){
  #ct = classx(getx(o, "itemsType")) 
  r = defaultx(ct)
 }
 @return r
},intc, cptc, opgetc)
methodDefx(arrc, "toStaticArr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #no = arrNewx(o.arr, o.obj)
 itemsChangeBasicx(no, arrc) 
 @return no
},_, arrc)
opDefx(arrc, "add", ->(x Arrx, env Cptx)Cptx{
 @return nullv
}, arrc, arrc, opaddc)
methodDefx(arrc, "push", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1] 
 o.arr.push(e)
 @return nullv
}, [cptc])
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

///arrstrc
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
}, [strc], strc)

///staticarr
methodDefx(staticarrc, "toArr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #no = arrNewx(o.arr, o.obj)
 itemsChangeBasicx(no, staticarrc) 
 @return no
},_, staticarrc)

///////BYTESC/////////////////
///bytesc
methodDefx(bytesc, "toStr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.bytes)
}, _, strc)
methodDefx(bytesc, "set", ->(x Arrx, env Cptx)Cptx{
/*
 Cptx#o = x[0]
 Cptx#i = x[1]
 Cptx#v = x[2]
 v = copyCptFromAstx(v)
 o.bytes[i.int] = v
 o.fdefault = @false
 */
 @return nullv
}, [strc, bytec], bytec)
opDefx(bytesc, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #b = o.bytes[e.int]
 #r = intNewx(b, bytec)
 r.str = byte2strx(b)
 @return r
}, intc, cptc, opgetc)


/////////////METHOD DIC///////
methodDefx(dicc, "len", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return intNewx(o.arr.len(), uintc)
},_, uintc)
opDefx(dicc, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #r = o.dic[e.str]
 @return nullOrx(r)
},strc, cptc, opgetc)
methodDefx(dicc, "set", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#i = x[1]
 Cptx#v = x[2]
 @if(o.dic[i.str] == _){
  o.arr.push(i)
 }
 v = copyCptFromAstx(v)
 o.dic[i.str] = v
 o.fdefault = @false 
 @return v
}, [strc, cptc], cptc)
methodDefx(dicc, "has", ->(x Arrx, env Cptx)Cptx{
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
methodDefx(dicstrc, "values", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return valuesx(o)
}, _, arrstrc)

//////DIR/////////////
///dirc
methodDefx(dirc, "len", ->(x Arrx, env Cptx)Cptx{
 @return nullv
}, [strc], uintc)
methodDefx(dirc, "has", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// Cptx#i = x[1]
 @return falsev
}, [strc], boolc)
opDefx(dirc, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#s = x[1]
 @return bytesNewx(@fs[o.dic["routerPath"].str + s.str])
}, strc, bytesc, opgetc)
methodDefx(dirc, "set", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#s = x[1]
 Cptx#v = x[2] 
 @fs[o.dic["routerPath"].str + s.str] = v.bytes
 @return v
}, [strc, bytesc], bytesc)
methodDefx(dirc, "sub", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #d = o.dic["routerPath"].str
 Cptx#s = x[1]
 @if(Bytes(s.str)[s.str.len() - 1] != @'/'){
  s.str += "/"
 }
 #np = strNewx(d + s.str); 
 @fs.sub(np.str)
 s.obj = pathfsc
 @return objNewx(dirc, {
  routerRoot: o
  routerPath: np
 })
}, [strc], dirc)
methodDefx(dirc, "rm", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #d = o.dic["routerPath"].str
 Cptx#s = x[1]
 @fs.rm(d+s.str)
 @return nullv
}, [strc])
methodDefx(dirc, "open", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// #p = Filex(o.dic["handlerPath"].str) 
// @return strNewx(p.readAll(), bytesc)
 @return nullv
}, [strc, strc], streamc)
methodDefx(dirc, "stat", ->(x Arrx, env Cptx)Cptx{
 @return nullv
}, [strc], dicuintc)
methodDefx(dirc, "timeMod", ->(x Arrx, env Cptx)Cptx{
 @return nullv
}, [strc], timec)


////////////METHOD JSON/////
methodDefx(jsonc, "len", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 //TODO
 @return intNewx(o.arr.len(), uintc)
},_, uintc)
opDefx(jsonc, "get", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// Cptx#e = x[1]
 //TODO
 @return nullv
}, strc, cptc, opgetc)


////METHOD STREAM
///streamc
methodDefx(streamc, "readAll", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// @return bytesNewx(@fs[o.str].readAll())
 @return nullv
}, _, bytesc)
methodDefx(streamc, "write", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// Cptx#s = x[1]
// @fs[o.str].write(s.bytes)
 @return nullv
}, [bytesc])

methodDefx(bufferc, "readAll", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return bytesNewx(Buffer(o.val).readAll())
}, _, bytesc)
methodDefx(bufferc, "write", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#s = x[1]
 Buffer(o.val).write(s.bytes)
 @return nullv
}, [bytesc])
methodDefx(bufferc, "writeStr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#s = x[1]
 Buffer(o.val).writeStr(s.str)
 @return nullv
}, [strc])
methodDefx(bufferc, "clear", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// Cptx#s = x[1]
// Buffer(o.val).clear(s.str)
 @return nullv
})
methodDefx(bufferc, "new", ->(x Arrx, env Cptx)Cptx{
 #r = objNewx(bufferc)
 r.val = &Buffer
 @return r
}, _, bufferc)


////METHOD ID
#assignf = opDefx(idlocalc, "assign", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];

 #v = execx(r, env)
 Cptx#local = env.dic["envLocal"]
 #str = l.str
 v = copyCptFromAstx(v)
 local.dic[str] = v
 @return v
}, cptc, cptc, opassignc)
assignf.fraw = @true
#idstateassignf = opDefx(idstatec, "assign", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 #v = execx(r, env)
 Str#k = l.str
 Cptx#o = l.class.obj
 v = copyCptFromAstx(v) 
 o.dic[k] = v
 @return v
}, cptc, cptc, opassignc)
idstateassignf.fraw = @true


////METHOD BOOL////
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


//////METHOD SOUL/////
methodDefx(soulc, "getCmdArgs", ->(x Arrx, env Cptx)Cptx{
 @if(_osArgs == _){
  #x = &Arrx
  Arr_Str#aa = @soul.getCmdArgs()
  @each i v aa{
   @if(i == 0){
    @continue
   }
   x.push(strNewx(v))
  }
  _osArgs = arrNewx(x, arrstrc)
 }
 @return nullv
}, _, arrstrc)
methodDefx(soulc, "exit", ->(x Arrx, env Cptx)Cptx{
 @return nullv
}, [intc])

///execDefx
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
 @each _ v c.arr{
  Cptx#r = execx(v, env)
  @if(inClassx(classx(r), signalc)){
   @return r
  }
 }
 @return nullv 
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
execDefx("Str", ->(x Arrx, env Cptx)Cptx{
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
  #c = itemsDefx(dicc, classx(it))
  @return dicNewx(d, arrCopyx(o.arr), c)
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
  #c = itemsDefx(arrc, classx(it))
  @return arrNewx(a, c)
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
 #l = Int(args.len())
 @for #i=0;i<l - 1;i+=2 {
  #r = execx(args[i], env)
  @if(ifcheckx(r)){
   @return blockExecx(args[i+1], env)
  }
 }
 @if(l%2 == 1){
  @return blockExecx(args[l - 1], env)
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
  #ct = classx(getx(da, "itemsType"))
  @for #i=0; i<da.arr.len(); i++{
   #v = da.arr[i]
   @if(v == _){
    v = defaultx(ct)
   }
   @if(key != ""){
    local[key] = intNewx(i, uintc)
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
execDefx("IdCond", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#l = env.dic["envLocal"]
 Str#k = "@" + c.str
 #r = l.dic[k]
 @return nullOrx(r);
})
execDefx("IdClass", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 @return c.class
})
execDefx("IdLocal", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#l = env.dic["envLocal"]
 Str#k = c.str
 #r = getx(l, k)
 @return nullOrx(r);
})
execDefx("IdState", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Str#k = c.str
 Cptx#o = c.class.obj
 #r = o.dic[k]
 @if(r == _){
  @return nullv
 }
 @return r;
})
