uidx ->()Str{
 Str#r = Str(uidi)
 uidi += 1
 @return r;
}
dicOrx ->(x Dicx)Dicx{
 @if(!x){
  @return &Dicx
 }@else{
  @return x
 }
}
arrOrx ->(x Arrx)Arrx{
 @if(!x){
  @return &Arrx
 }@else{
  @return x
 }
}
arrCopyx ->(o Arrx)Arrx{
 @if(o == _){ @return }
 #n = &Arrx
 @each _ e o{
  n.push(e)
 }
 @return n;
}
dicCopyx ->(o Dicx)Dicx{
 @if(o == _){ @return }
 #n = &Dicx
 @each k v o{
  n[k] = v
 }
 @return n
}
indx ->(s Str, first Int)Str{
 @if(s == ""){
  @return s
 }
 Arr_Str#arr = s.split("\n")
 #r = ""
 @if(first == 0){
  #r += _indentx
 }
 @each i x arr{
  @if(i != 0 && x != ""){
   r += "\n"
   r += _indentx
  }
  r += x
 }
 @return r
}
copyCptFromAstx ->(v Cptx)Cptx{
 @if(v.fast){
  #x = copyx(v)
  x.fast = @false
  @return x
 }
 @return v
}
escapex ->(s Str)Str{
 @return s.replace("\\", "\\\\").replace("\n", "\\n").replace("\t", "\\t").replace("\r", "\\r").replace("\"", "\\\"")
}
//TODO no recursive dirWritex
dirWritex ->(d Str, dic Dicx){
 @each k v dic{
  @if(v.type == T##STR){
   #x = File(d + k)
   x.write(v.str)
  }@else{
   log(dic2strx(dic))
   die("wrong dic for dirWrite")
  }
 } 
}
appendClassx ->(o Cptx, c Cptx){
 @each _ k keys(c.dic).sort(){
  @if(o.dic[k] == _){
   o.arr.push(strNewx(k))
   o.dic[k] = c.dic[k]   
  }
 }
 @each _ v c.arr{
  appendClassx(o, v)
 }
}
ifcheckx ->(r Cptx)Bool{
 @if(r.type == T##INT){
  @return r.int != 0
 }
 @return r.type != T##NULL
}
parentMakex ->(o Cptx, parentarr Arrx){
 @if parentarr != _ {
  T#ctype = o.ctype
  @each _ e parentarr{
   //TODO reduce
   @if(e.id == ""){
    die("no id")
   }
   @if(e.ctype > ctype){
    ctype = e.ctype
   }
  }
  o.arr = parentarr
  o.ctype = ctype
 }@else{
  @if(o.arr == _){
   o.arr = &Arrx
  }
 }
}
routex ->(o Cptx, scope Cptx, name Str)Cptx{
 //TODO route name should not contain $
 #dic = scope.dic;
 dic[name] = o 
 o.name = name;
 o.class = scope
 @return o
}
passx ->(v Cptx)Cptx{
 @if(inClassx(classx(v), valc)){
  @return copyx(v)
 }
 @return v
}
nullOrx ->(x Cptx)Cptx{
 @if(x == _){
  @return nullv
 }
 @return x
}
aliasGetx ->(c Cptx)Cptx{
 @if(c.arr == _){
  log(strx(c))
  die("wrong cpt")
 }
 @if(c.arr.len() > 1){
  @if(c.arr[0].id == aliasc.id){  
   @return aliasGetx(c.arr[1])
  }
 }
 @return c
}

funcSetClosurex ->(func Cptx){
 func.obj.arr[1] = funcclosurec
}
funcSetOpx ->(func Cptx, op Cptx){
 func.obj.arr.push(op)
}
checkid ->(id Str, local Cptx, func Cptx)Cptx{
 #r = getx(local, id)
 @if(r != _){
  #r = local.dic[id]
  @if(r == _){
   die("checkid: "+id + " used in parent block");
  }
  @return r
 }
 @return _
}
valuesx ->(o Cptx)Cptx{
 #arr = &Arrx
 @each _ k o.arr{
  Cptx#v = o.dic[k.str]
  arr.push(v)
 }
 #it = getx(o, "itemsType");
 @if(it == _){
  #c = arrc
 }@else{
  #c = itemDefx(arrc, classx(it))
 }
 @return arrNewx(c, arr) 
}
prepareArgsx ->(args Arrx, f Cptx, env Cptx)Arrx{
 #argsx = &Arrx
 @if(!inClassx(classx(f), functplc)){ //fill args
  Arrx#vartypes = getx(f, "funcVarTypes").arr
  @each i argdef vartypes{
   @if(Int(i) < args.len()){
    #t = passx(execx(args[i], env))
   }@else{
    t = copyx(argdef)
   }
   argsx.push(t)
  }
 }@else{
  @each _ arg args{
   #x = passx(execx(arg, env))
   argsx.push(x)
  }
 }
 @return argsx
}
prepareArgsRefx ->(args Arrx, f Cptx, env Cptx)Arrx{
 #argsx = &Arrx
 @if(!inClassx(classx(f), functplc)){ //fill args
  Arrx#vartypes = getx(f, "funcVarTypes").arr
  @each i argdef vartypes{
   @if(Int(i) < args.len()){
    #t = execx(args[i], env)
   }@else{
    t = argdef
   }
   argsx.push(t)
  }
 }@else{
  @each _ arg args{
   #x = passx(execx(arg, env))
   argsx.push(x)
  }
 }
 @return argsx
}
classNewx ->(arr Arrx, dic Dicx)Cptx{
 #r = &Cptx{
  type: T##CLASS
  ctype: T##OBJ
  fstatic: @true
  id: uidx() 
 }
 r.dic = dicOrx(dic)
 parentMakex(r, arr)
 @return r;
}

strNewx ->(x Str)Cptx{
 @return &Cptx{
  type: T##STR
  str: x
 }
}
intNewx ->(x Int)Cptx{
 @return &Cptx{
  type: T##INT
  int: x
 }
}
arrNewx ->(class Cptx, val Arrx)Cptx{
 #x = &Cptx{
  type: T##ARR
  id: uidx()  
  obj: class
 }
 @if(val != _){
  x.arr = val
 }@else{
  x.arr = &Arrx
 }
 @return x
}
dicNewx ->(class Cptx, dic Dicx, arr Arrx)Cptx{
 #r = &Cptx{
  type: T##DIC
  obj: class
  id: uidx()
  dic: dicOrx(dic)
  arr: arrOrx(arr)
 }
 @if(arr == _){ 
  @if(dic != _){   
   @each k _ dic{
    r.arr.push(strNewx(k))
   }
  }@else{
   r.arr = &Arrx
  }
 }@else{
  r.arr = arr
 }
 @return r
}

nsNewx ->(name Str)Cptx{
 Cptx#x = dicNewx()
 x.name = "Ns_" + name
 x.str = name
 @return x;
}
scopeNewx ->(ns Cptx, name Str)Cptx{
 Cptx#x = classNewx()
 x.name = "Scope_" + ns.str + "_" + name
 x.str = ns.str + "/" + name
 @if(ns.dic[name] == _){
  ns.arr.push(strNewx(name))
 }
 ns.dic[name] = x
 @return x;
}
objNewx ->(class Cptx, dic Dicx)Cptx{
 @if(class.ctype != T##OBJ){
  die("objNew error, should use def")
 }
 #x = &Cptx{
  type: T##OBJ
  id: uidx()
  dic: dicOrx(dic)
  obj: class
 }
 @if(dic == _ || dic.len() == 0){
  x.fdefault = @true
 } 
 class.obj = x
 @return x;
}
tobjNewx ->(class Cptx)Cptx{
 #x = &Cptx{
  type: T##TOBJ
  id: uidx()
  obj: class
 }
 @return x
}
scopeObjNewx ->(class Cptx)Cptx{
 @if(class.obj != _){
  @return class.obj
 }
 @return objNewx(class)
}
floatNewx ->(x Float)Cptx{
 @return &Cptx{
  type: T##FLOAT
  val: x
 }
}
nativeNewx ->(f Funcx)Cptx{
 @return &Cptx{
  type: T##NATIVE
  id: uidx()    
  val: f
 } 
}
callNewx ->(func Cptx, args Arrx, obj Cptx)Cptx{
 @return &Cptx{
  type: T##CALL
  id: uidx()
  fmid: @true
  obj: obj  
  class: func
  arr: arrOrx(args)
 }
}
funcNewx ->(val Funcx, argtypes Arrx, return Cptx)Cptx{
 @if(return == _){
  return = emptyreturnc
 }
 Arrx#arr = &Arrx
 @each _ v argtypes{
  arr.push(defx(v))
 } 
 #fp = fpDefx(arr, return)
 @if(val != _){
  Cptx#x = classNewx([fp, funcnativec])
  x.dic["funcNative"] = nativeNewx(val)  
 }@else{
  #x = classNewx([fp])
 }
 @return objNewx(x)
}
uintNewx ->(x Int)Cptx{
 @return &Cptx{
  type: T##INT
  obj: uintc
  int: x
 }
}
boolNewx ->(x Bool)Cptx{
 @if(x){
  @return truev
 }
 @return falsev;
}
classDefx ->(scope Cptx, name Str, parents Arrx, schema Dicx)Cptx{
 Cptx#x = classNewx(parents)
 @each k v schema{
  @if(v == _){
   log(name)
   die(k)
  }
  x.dic[k] = defx(v)
 }
 routex(x, scope, name)
 @return x
}
curryDefx ->(scope Cptx, name Str, class Cptx, schema Dicx)Cptx{
 #x = classNewx([class], schema)
 routex(x, scope, name)
 @return x
}

itemDefx ->(class Cptx, type Cptx, mid Bool)Cptx{
 @if(!class.fbitems){
  die("item def first arg error")
 }
 @if(type != _ && type.id != cptc.id){
  type = aliasGetx(type)
  Str#n = class.name+"_"+type.name
  @if(n == "Arr_Byte"){
   n = "Bytes"
  }
  Cptx#r = classGetx(defmain, n)
  @if(r == _){
   #r = classDefx(defmain, n, [class], {itemsType: type})  
  }
 }@else{
  r = class
 }
 @if(mid){
  @return classDefx(defmain, n, [r, midc])
 }
 @return r;
}
fpDefx ->(types Arrx, return Cptx)Cptx{
 #n = "FuncProto"
 @each _ v types{
  #n += "_" + aliasGetx(classx(v)).name
 }
 #n += "__"+return.name
 #x = classGetx(defmain, n);
 @if(x == _){
  #x = curryDefx(defmain, n, funcprotoc, {
   funcVarTypes: arrNewx(arrc, types)
   funcReturn: return
  })
 }
 @return x
}

aliasDefx ->(scope Cptx, key Str, class Cptx)Cptx{
 #x = classDefx(scope, key, [aliasc, class])
 @return x
}

funcDefx ->(scope Cptx, name Str, val Funcx, argtypes Arrx, return Cptx)Cptx{
//FuncNative new
 #fn = funcNewx(val, arrOrx(argtypes), return)
 routex(fn, scope, name);
 @return fn
}
methodDefx ->(class Cptx, name Str, val Funcx, argtypes Arrx, return Cptx)Cptx{//FuncNative new
 @if(argtypes != _){
  argtypes.unshift(class)
 }@else{
  argtypes = [class]
 }
 #fn = funcNewx(val, argtypes, return)
 fn.fprop = @true
 class.dic[name] = fn;
 fn.name = class.name + "_" + name
 fn.str = name
 @return fn
}
opDefx ->(class Cptx, name Str, val Funcx, arg Cptx, return Cptx, op Cptx)Cptx{
 #argt = &Arrx
 @if(arg != _){
  argt.push(arg)
 }
 #func = methodDefx(class, name, val, argt, return)
 funcSetOpx(func, op)
 @return func;
}
execDefx ->(name Str, f Funcx)Cptx{
 #fn = funcNewx(f, [cptc], cptc)
 routex(fn, execmain, name);
 @return fn
}
nsGetx ->(ns Cptx, key Str)Cptx{
 #s = ns.dic[key];
 @if(s != _){
  @return s;
 }
 #s = scopeNewx(ns, key)
 #f = File(osEnvGet("HOME")+"/soul2/db/"+ns.str+"/"+key+".slp")
 @if(f.exists()){
  Str#fc = f.readAll()
  Arr_Str#arr = fc.split(" ")
  @each _ v arr{
   s.arr.push(nsGetx(ns, v))
  }
 }
 @return s;
}
dbGetx ->(scope Cptx, key Str)Cptx{
 #fstr = osEnvGet("HOME")+"/soul2/db/"+scope.str + "/" + key + ".sl" 
 #f = File(fstr)
 #f2 = File(fstr+"t")
 #fcache = File(fstr+".cache")
 #f2cache = File(fstr+"t.cache")  
 
 @if(f.exists()){
  Str#str = f.readAll()
  @if(f.timeMod() > fcache.timeMod()){
   Str#jstr = osCmd("./sl-reader", key + " := "+str)
   fcache.write(jstr)
  }@else{
   Str#jstr = fcache.readAll()
  }
 }@elif(f2.exists()){
  str = "@`"+f2.readAll()+"` '"+fstr+"t'";
  @if(f2.timeMod() > f2cache.timeMod()){
   Str#jstr = osCmd("./sl-reader", key + " := "+str)
   f2cache.write(jstr)
  }@else{
   Str#jstr = f2cache.readAll()
  }
 }@else{
  @return _
 }
 Astx#ast = JsonArr(jstr)
 @if(ast.len() == 0){
  die("dbGetx: wrong grammar")
 }
 Cptx#r = ast2cptx(ast, scope, classNewx())
 @return r
}
subClassGetx ->(scope Cptx, key Str, cache Dic)Cptx{
 #r = scope.dic[key]
 @if(r != _){ 
  @return r
 }
 @if(scope.str != ""){
  #r = dbGetx(scope, key);
  @if(r != _){
   scope.dic[key] = r
   @return r;
  }
 }

 @each _ v scope.arr {
  Str#k = v.id
  @if(cache[k] != _){ @continue };
  cache[k] = 1;
  r = subClassGetx(v, key, cache)
  @if(r != _){
   @return r;
  }
 }
 @return _
}
propDefx ->(scope Cptx, key Str, r Cptx)Cptx{
 Cptx#o = copyx(r)
 o.class = scope
 o.name = scope.name + "_" + key
 @return o;
}
classGetx ->(scope Cptx, key Str)Cptx{
 Cptx#r = subClassGetx(scope, key, {})
 @if(r == _){
  @if(scope.str != ""){//if class is scope
   scope.dic[key] = emptyclassgetv
  }
  @return _
 }@elif(r.id == emptyclassgetv.id){
  @return _
 }
 @if(r.fprop){
  @return propDefx(scope, key, r)
 }
 @return r;
}

subMethodGetx ->(scope Cptx, v Cptx, key Str)Cptx{
 #r = classGetx(scope, v.name + "_" + key);
 @if(r != _){
  @return r
 }
 @each _ vv v.arr{
  r = subMethodGetx(scope, vv, key)
  @if(r != _){
   @return r
  }
 }
 @return r
}
methodGetx ->(scope Cptx, func Cptx)Cptx{
 Cptx#r = classGetx(scope, func.name);
 @if(r != _){
  @return r  
 }

 Cptx#o = func.class
 Arrx#p = o.arr
 @each _ v p{
  r = subMethodGetx(scope, v, func.str)
  @if(r != _){
   @return r
  }
 }

 r = subMethodGetx(scope, classc, func.str)
 @if(r != _){
  @return r
 }  

 r = subMethodGetx(scope, cptc, func.str)
 @if(r != _){
  @return r
 }   
 @return _
}
classRawx ->(t T)Cptx{
 @if(t == T##CPT){
  @return cptc
 }@elif(t == T##OBJ){
  @return objc
 }@elif(t == T##CLASS){
  @return classc
 }@elif(t == T##NULL){
  @return nullc
 }@elif(t == T##INT){
  @return intc
 }@elif(t == T##FLOAT){
  @return floatc  
 }@elif(t == T##NUMBIG){
  @return numbigc
 }@elif(t == T##STR){
  @return strc
 }@elif(t == T##DIC){
  @return dicc
 }@elif(t == T##ARR){
  @return arrc
 }@elif(t == T##NATIVE){
  @return nativec
 }@elif(t == T##CALL){
  @return callc
 }@elif(t == T##FUNC){
  @return funcc
 }@elif(t == T##BLOCK){
  @return blockc
 }@else{
  die("NOTYPE")
 }
 @return _
}
inClassx ->(c Cptx, t Cptx, cache Dic)Bool{
 @if(c.type != T##CLASS){
  log(strx(c) )
  die("inClass: left not class")
 }
 @if(t.type != T##CLASS){
  log(strx(t) )
  die("inClass: right not class")
 }
 @if(t.id == cptc.id){//everything is cpt
  @return @true
 }
 @if(t.id == objc.id && c.ctype == T##OBJ){
  @return @true
 }
 @if(c.id != "" && c.id == t.id){
  @return @true
 }
 #key = c.id + "_" + t.id
 #r = inClassCache[key]
 @if(r == 1){
  @return @true
 }
 @if(r == 2){
  @return @false
 }
 @if(!cache){
  cache = {}
 }
 @each _ v c.arr{
  @if(cache[v.id] != _){
   @continue
  }
  cache[v.id] = 1
  @if(inClassx(v, t, cache)){
   inClassCache[key] = 1
   @return @true
  }
 }
 inClassCache[key] = 2
 @return @false
}
parentClassGetx ->(o Cptx, key Str)Cptx{
 @if(o.arr == _){
  @return _
 }
 @each _ v o.arr{
  Dicx#d = v.dic
  Cptx#r = d[key]
  @if(r != _){
   @return v
  }
  r = parentClassGetx(v, key)
  @if(r != _){
   @return r
  }
 }
 @return _;
}
classx ->(o Cptx)Cptx{
 @if(o.type == T##CLASS){
  @return o
 }
 @if(o.obj != _){
  @return o.obj
 }
 @return classRawx(o.type)
}
defaultx ->(t Cptx)Cptx{
 @if(t.ctype == T##INT){
  #tar = intNewx(0)
 }@elif(t.ctype == T##FLOAT){
  #tar = floatNewx(0.0)
 }@elif(t.ctype == T##NUMBIG){   
 }@elif(t.ctype == T##STR){
  #tar = strNewx("")
 }@else{
  #tar = nullv
 }
 @return tar
}
defx ->(class Cptx, dic Dicx)Cptx{
 @if(class.ctype == T##CPT){
  @return cptv
 }@elif(class.ctype == T##OBJ){
  @if(dic != _){
   @each k v dic{
    Cptx#t = classGetx(class, k)
    @if(t == _){
     die("defx: not in "+ class.name + " "+k)
    }
    @if(v == _){
     log(k)
     die("defx: dic val null")     
    }
    Cptx#pt = typepredx(v);
    @if(pt == _ || pt.id == cptc.id){
     @continue;
    }
    @if(!inClassx(pt, classx(t))){
     log(class.name)    
     log(k)
     log(strx(v))
     log(strx(pt))     
     log(strx(t))
     die("defx: type error")
    }
   }
   Cptx#r = objNewx(class, dic)
   @if(dic.len() != 0){
    r.fdefault = @false
   }
  }@else{
   Cptx#r = objNewx(class)
  }
  @if(midc != _){
   @if(inClassx(class, midc) ){//TODO speed up
    r.fmid = @true
   }
  }
  @return r
 }@elif(class.ctype == T##CLASS){
  @return cptc
 }@elif(class.ctype == T##NULL){
  @return nullv
 }@elif(class.ctype == T##INT){
  Cptx#x = intNewx(0)
  @if(class.name != "Int"){
   x.obj = class
  }
 }@elif(class.ctype == T##FLOAT){
  Cptx#x = floatNewx(0.0)
  @if(class.name != "Float"){
   x.obj = class
  }
 }@elif(class.ctype == T##NUMBIG){
  Cptx#x = nullv//TODO
 }@elif(class.ctype == T##STR){
  Cptx#x = strNewx("")
  @if(class.name != "Str"){
   x.obj = class
  }
 }@elif(class.ctype == T##NATIVE){
  Cptx#x = nativeNewx()
 }@elif(class.ctype == T##CALL){
  Cptx#x = callNewx()
  x.fdefault = @true     
 }@elif(class.ctype == T##FUNC){
  Cptx#x = nullv//TODO
 }@elif(class.ctype == T##BLOCK){
  Cptx#x = nullv//TODO
 }@elif(class.ctype == T##DIC){
  #x = dicNewx(class)
  x.fdefault = @true     
 }@elif(class.ctype == T##ARR){
  #x = arrNewx(class)
  x.fdefault = @true     
 }@else{
  die("unknown class type")
  @return
 }
 @return x
}

copyx ->(o Cptx)Cptx{
 @if(o.type == T##CPT){
  @return o
 }
 @if(o.type == T##NULL){
  @return o
 }
 @if(o.type == T##CLASS){
  @return o
 }
 #x = &Cptx{
  type: o.type
  ctype: o.ctype  
  fmid: o.fmid
  fdefault: o.fdefault
  fprop: o.fprop
  fast: o.fast
  farg: o.farg
  fbitems: o.fbitems

  name: o.name
  id: uidx()
  class: o.class
  
  obj: o.obj
  
  dic: dicCopyx(o.dic)
  arr: arrCopyx(o.arr)
  str: o.str
  int: o.int
  val: o.val
 }
 @return x
}

eqx ->(l Cptx, r Cptx)Bool{
 @if(l.type != r.type){
  @return @false
 }
 #t = l.type
 @if(t == T##CPT){
  @return @true
 }@elif(t == T##NULL){
  @return @true  
 }@elif(t == T##OBJ){
  @return l.id == r.id  
 }@elif(t == T##CLASS){
  @return l.id == r.id
 }@elif(t == T##DIC){
  @return l.id == r.id
 }@elif(t == T##ARR){
  @return l.id == r.id
 }@elif(t == T##NATIVE){
  @return l.id == r.id  
 }@elif(t == T##CALL){
  @return l.id == r.id  
 }@elif(t == T##FUNC){
  @return l.id == r.id
 }@elif(t == T##BLOCK){
  @return l.id == r.id    
 }@elif(t == T##INT){
  @return l.int == r.int
 }@elif(t == T##FLOAT){
  @return Float(l.val) == Float(r.val)
 }@elif(t == T##NUMBIG){
  @return @true //TODO
 }@elif(t == T##STR){
  @return l.str == r.str
 }@else{
  log(t)
  die("wrong type")
  @return @false
 } 
}
getx ->(o Cptx, key Str)Cptx{
 @if(o.type == T##CLASS){
  #r = classGetx(o, key)
  @if(r != _){
   @return r
  }
  r = classGetx(classc, key) 
  @if(r != _){
   @return r
  }
 }@elif(o.type == T##OBJ){
  #r = o.dic[key] //getlocal1
  @if(r != _){
   @return r
  }
  r = classGetx(o.obj, key) //getlocal2
  @if(r != _){
   @return r
  }
  r = classGetx(objc, key)  //getobjc
  @if(r != _){
   @return r
  }  
 }@else{
  r = classGetx(classx(o), key)
  @if(r != _){
   @return r
  }
 }
 @return classGetx(cptc, key)
}
setx ->(o Cptx, key Str, val Cptx)Cptx{
 //TODO objSet
 @return copyCptFromAstx(val)
}

typepredx ->(o Cptx)Cptx{
 #t = o.type
 @if(t == T##CALL){
  Cptx#f = o.class
  #args = o.arr
  @if(f == _){
   @return callc
  }
  @if(f.id == defmain.dic["new"].id){
   Cptx#arg0 = args[0]
   @return arg0
  }
  @if(f.id == defmain.dic["as"].id){
   Cptx#arg1 = args[1]
   @return arg1
  }
  @if(f.id == defmain.dic["numConvert"].id){
   Cptx#arg1 = args[1]
   @return arg1
  }
  @if(f.id == defmain.dic["type"].id){
   Cptx#arg0 = args[0]
   @return arg0
  }    
  //if is itemGet    
  @if(f.id == defmain.dic["get"].id){
   Cptx#arg0 = args[0]     
   Cptx#arg1 = args[1]
   Cptx#at0 = typepredx(arg0)
   @if(at0 == _ || at0.id == cptv.id){
    @return _
   }
   #cg = getx(at0, arg1.str)
   @if(cg == _){
    @return _;
    log(strx(arg0))
    log(strx(at0))
    die("typepred: cannot pred obj get, key is "+arg1.str)
   }
   @return classx(cg)
  }
    //if is opGet
  @if(inClassx(f.obj, opgetc)){
   Cptx#arg0 = args[0]
   Cptx#at0 = typepredx(arg0)     
   #r = getx(at0, "itemsType")
   @if(r != _){
    @return classx(r)
   }@else{
    @return cptc
   }
  }
    
  @if(inClassx(f.obj, functplc)){
   @return strc
  }

  @if(inClassx(f.obj, funcc)){
   //TODO if is dynamic funcReturn, like values, to,
   #ret = getx(f, "funcReturn")
   @if(ret == _){
    log(strx(f))
    die("no return")
   }
   @if(ret.id == emptyreturnc.id){
    @return cptc;
   }
   @return ret
  }
  @if(inClassx(f.obj, midc)){
   //TODO predict return func call
   @return _
  }
  @return _
 }@elif(t == T##OBJ){
  //if is idstate
  @if(inClassx(o.obj, idstatec)){
   Str#id = o.dic["idStr"].str
   @if(id.isInt()){
    @return cptc
   }
   Cptx#s = o.dic["idState"]
   #r = getx(s, id)
   @if(r == _){
    log(strx(s)) 
    log(id)
    die("not defined in idstate, may use #1 #2 like")
    @return r
   }
   @return typepredx(r)
  }
   //if is idscope
  @if(inClassx(o.obj, idclassc)){
   Cptx#s = o.dic["idVal"]
   @return typepredx(s)
  }
  @return o.obj
 }@else{
  @return classx(o) 
 }
}
dic2strx ->(d Dicx, i Int)Str{
 #s = "{\n"
 @each k v d{  
  s += indx(k + ":" + strx(v, i+1)) + "\n"
 }
 @return s + "}"
}

arr2strx ->(a Arrx, i Int)Str{
 #s = "["
 @if(a.len() > 1){
  s+="\n"
  @each _ v a{
   s+=indx(strx(v, i+1))+"\n"
  }
 }@else{
  @each _ v a{
   s += strx(v, i+1)
  }
 }
 @return s + "]"
}


parent2strx ->(d Arrx)Str{
 #s = ""
 @each _ v d{
  @if(v.name != ""){
   s+= v.name + " "
  }@else{
   s+= "~" + v.id + " "  
  }
 }
 @return s
}

strx ->(o Cptx, i Int)Str{
 @if(i > 3 && o.id != ""){
  @return "~"+o.id
 }
 T#t = o.type
 @if(t == T##CPT){
  @return "&Cpt"
 }@elif(t == T##OBJ){
  Str#s = "" 
  @if(o.name != ""){
   #s += o.name + " = "
  }@else{
   s += "~" + o.id + " = "
  }

  @if(o.obj.name != ""){
   s += "&"+o.obj.name
  }@else{
   s += "&~" + o.obj.id
  }
//  @if(!o.fdefault){//TODO check fdefault!!!!!!
   s += dic2strx(o.dic, i)
//  }
  @return s
 }@elif(t == T##CLASS){
  Str#s = "" 
  @if(o.name != ""){
   #s += o.name + " = "
  }@else{
   #s += "~"+o.id + " = "  
  }
  s+="@class "+ parent2strx(o.arr)+" "+dic2strx(o.dic, i)  
  @return s
 }@elif(t == T##NULL){
  @return "_"
 }@elif(t == T##INT){
  @return Str(o.int)
 }@elif(t == T##FLOAT){
  @return Str(Float(o.val))
 }@elif(t == T##STR){
  @return '"'+ escapex(o.str) + '"'
 }@elif(t == T##NATIVE){
  @return "&Native"
 }@elif(t == T##CALL){
  @return "CALL"
 }@elif(t == T##FUNC){
  @return "&ValFunc"
 }@elif(t == T##BLOCK){
  @return "&ValFunc"
 }@elif(t == T##DIC){
  @return dic2strx(o.dic, i)
 }@elif(t == T##ARR){
  @return arr2strx(o.arr, i)
 }@else{
  log(o.obj)
  log(o)
  die("cpt2str unknown")
  @return ""
 }
}
tplCallx ->(func Cptx, args Arrx, env Cptx)Cptx{
// log(func.dic["funcTplPath"].str)
 #b = func.dic["funcTplBlock"]
 @if(b == _){
  @return strNewx("")
 }

 #localx = b.dic["blockStateDef"]
 #nstate = objNewx(localx)
 nstate.fdefault = @false
 nstate.int = 2
 @each i v args{
  nstate.dic[Str(i)] = v;
 }
 
 Arrx#stack = env.dic["envStack"].arr;
 #ostate = env.dic["envLocal"]
 stack.push(ostate)
 env.dic["envLocal"]  = nstate
 blockExecx(b, env)
 env.dic["envLocal"] = stack[stack.len()-1]
 stack.pop()

 @return nstate.dic["$str"]
}

callx ->(func Cptx, args Arrx, env Cptx)Cptx{
 @if(func == _ || func.obj == _){
  log(arr2strx(args))
  log(strx(func))  
  die("func not defined")
 }
 @if(inClassx(func.obj, funcnativec)){
  @return call(Funcx(getx(func, "funcNative").val), [args, env]);
 }
 @if(inClassx(func.obj, functplc)){ 
  @return tplCallx(func, args, env)
 }
 @if(inClassx(func.obj, funcblockc)){
  Cptx#block = func.dic["funcBlock"]
  #nstate = objNewx(block.dic["blockStateDef"])
  nstate.fdefault = @false  
  nstate.int = 2  
  Arrx#stack = env.dic["envStack"].arr;
  #ostate = env.dic["envLocal"]
  stack.push(ostate)
  env.dic["envLocal"]  = nstate
  Arrx#vars = func.dic["funcVars"].arr
  @each i arg args{
   nstate.dic[vars[i].str] = arg   
  }
  Cptx#r = blockExecx(block, env)
  env.dic["envLocal"] = stack[stack.len()-1]
  stack.pop()

  @if(inClassx(classx(r), signalc)){
   @if(r.obj.id == returnc.id){
    @return r.dic["return"]
   }  
   @if(r.obj.id == errorc.id){
    //TODO pass to blockpost or up
   }  
   @if(r.obj.id == breakc.id){
    die("break in function!")
   }
   @if(r.obj.id == continuec.id){
    die("continue in function!")
   }
  }
  @return r;
 }
 log(strx(func.obj))
 die("callx: unknown func")
 @return nullv;
}
classExecGetx ->(c Cptx, execsp Cptx, cache Dic)Cptx{
 @if(c.id == ""){
  log(strx(c))
  die("no id")
 }
 #r = execsp.dic[c.id]
 @if(r != _){
  @return r;
 }
 @if(c.name != ""){
  #exect = classGetx(execsp, c.name)
  @if(exect != _){
   execsp.dic[c.id] = exect;  
   @return exect
  }
 }
 @if(c.arr != _){
  @each _ v c.arr{
   @if(cache[v.id] != _){ @return; }
   cache[v.id] = 1;
   Cptx#exect = classExecGetx(v, execsp, cache);
   @if(exect != _){
    @return exect;
   }
  }
 }
 @return _
}
execGetx ->(c Cptx, execsp Cptx)Cptx{
 @if(c.type == T##CLASS){
  Cptx#exect = classExecGetx(classc, execsp, {});
  @if(exect != _){
   @return exect;
  }
 }@else{
  Cptx#t = classx(c)
  Cptx#exect = classExecGetx(t, execsp, {});
  @if(exect != _){
   @return exect;
  }
  @if(c.type == T##OBJ){
   Cptx#exect = classExecGetx(objc, execsp, {});
   @if(exect != _){
    @return exect;
   }
  }
 }
 //Cpt no need
 @return _
}
blockExecx ->(o Cptx, env Cptx, stt Uint)Cptx{
 Cptx#b = o.dic["blockVal"]
 @each i v b.arr{
  @if(stt != 0 && stt < i){
   @continue
  }
  Cptx#r = execx(v, env)
  @if(inClassx(classx(r), signalc)){
   @return r
  }
 }
 @return nullv
}
preExecx ->(o Cptx)Cptx{
//TODO pre exec 1+1 =2 like
//pre exec idClass.idVal
 @if(inClassx(classx(o), idclassc)){
  @return o.dic["idVal"]
 }
 @return o
}
execx ->(o Cptx, env Cptx, flag Int)Cptx{
 #l = env.dic["envLocal"]
 @if(flag == 1){
  #sp = env.dic["envExec"]
 }@elif(flag == 2){
  #sp = execmain
 }@elif(l.int == 1){
  #sp = env.dic["envExec"]
 }@elif(l.int == 2){
  #sp = execmain
 }@else{
  #sp = env.dic["envExec"]
 } 
 #ex = execGetx(o, sp)
 @if(!ex){
  die("exec: unknown type "+classx(o).name);
 }
 @return callx(ex, [o], env);
}

tobj2objx ->(to Cptx)Cptx{
 @return objNewx(to.obj)
}