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
 Cptx#c = x[0]
 @if(o.type != c.ctype){//int to int
  die("numConvert between float int big")
 }
 o.obj = c
 @return o
},[cptc, cptc], cptc)
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
 @return nullOrx(typepredx(l))
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
funcDefx(defmain, "isNull", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == T##NULL)
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
