uidx ->()Uint{
// Str#r = Str(uidi)
 uidi ++
 @return uidi;
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
byteCopyx ->(o Bytes)Bytes{
 @if(o == _){ @return }
 #n = malloc(o.len(), Byte)
 @each i e o{
  n[i] = e
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
 @return r.id != nullv.id
}
parentMakex ->(o Cptx, parentarr Arrx){
 @if parentarr != _ {
  T#ctype = o.ctype
  @each _ e parentarr{
   //TODO reduce
   @if(!e.id){
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
 //TODO route name should not contain $ ?
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
  die("alias wrong cpt")
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
  #c = itemsDefx(arrc, classx(it))
 }
 @return arrNewx(arr, c) 
}
prepareArgsx ->(args Arrx, f Cptx, env Cptx)Arrx{
 #argsx = &Arrx
 @if(!inClassx(classx(f), functplc)){ //fill args
  Arrx#vartypes = getx(f, "funcVarTypes").arr
  @each i argdef vartypes{
   @if(i < args.len()){
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
   @if(i < args.len()){
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

strNewx ->(x Str, c Cptx)Cptx{
 @return &Cptx{
  type: T##STR
  obj: c
  str: x
 }
}
bytesNewx ->(x Bytes, c Cptx)Cptx{
 #r = &Cptx{
  type: T##BYTES
  obj: c
  bytes: x
 }
 @if(x == _){
  r.bytes = &Bytes
 }
 @return r
}
intNewx ->(x Int, c Cptx)Cptx{
 @return &Cptx{
  type: T##INT
  obj: c
  int: x
 }
}
arrNewx ->(val Arrx, class Cptx)Cptx{
 #x = &Cptx{
  type: T##ARR
  id: uidx()  
  obj: class
  arr: arrOrx(val)
 }
 @return x
}
dicNewx ->(dic Dicx, arr Arrx, class Cptx)Cptx{
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
 x.fscope = @true
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
floatNewx ->(x Float, c Cptx)Cptx{
 @return &Cptx{
  type: T##FLOAT
  obj: c
  val: x
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

idNewx ->(def Cptx, key Str, obj Cptx)Cptx{
 #x = &Cptx{
  type: T##ID
  id: uidx()
  obj: obj
  class: def
  str: key
 }
 @if(obj != _ && !inClassx(obj, idclassc)){
  x.fmid = @true
 }
 @return x
}
funcNewx ->(val Funcx, argtypes Arrx, return Cptx)Cptx{
 @if(return == _){
  return = emptyc
 }
 Arrx#arr = &Arrx
 @each _ v argtypes{
  arr.push(defx(v))
 } 
 #fp = fpDefx(arr, return)
 @if(val != _){
  Cptx#x = classNewx([fp, funcnativec])
  #y = objNewx(x)
  y.val = val
 }@else{
  #x = classNewx([fp])
  #y = objNewx(x)  
 }
 y.id2 = uidx()
 @return y
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
 @if(class == _){
  #x = classNewx([], schema)
 }@else{
  #x = classNewx([class], schema) 
 }
 routex(x, scope, name)
 @return x
}
bnumDefx ->(name Str, class Cptx)Cptx{
 #x = curryDefx(defmain, name, class)
 x.fbnum = @true
 @return x
}
getNamex ->(x Cptx)Str{
 @if(x.name != ""){
  @return x.name
 }
 @each _ v x.arr{
  #r = getNamex(v)
  @if(r != ""){
   @return r
  }
 }
 @return ""
}
itemsChangeBasicx ->(v Cptx, nb Cptx)Cptx{
 @if(v.fmid){
  die("cannot change basic for mid")
 }
 @if(v.type != nb.ctype){
  die("cannot change between ARR DIC JSON")
 }
 #ob = itemsGetBasicx(classx(v))
 #r = getx(v, "itemsLimitedLen")
 @if(r == _){
  #l = 0
 }@else{
  #l = r.int
 }
 v.obj = itemsDefx(ob, classx(getx(v, "itemsType")), l)
 @return v
}
itemsGetBasicx ->(c Cptx)Cptx{
 @if(c.fbitems){
  @return c
 }
 @each _ v c.arr{
  #r = itemsGetBasicx(v)
  @if(r){
   @return r
  }
 }
 @return _;
}
itemsDefx ->(class Cptx, type Cptx, len Int, mid Bool)Cptx{
 @if(!class.fbitems){
  die("item def first arg error")
 }
 @if(type != _ && type.id != cptc.id && type.id != unknownc.id){
  type = aliasGetx(type)
  Str#n = class.name+"_"+type.name
  @if(n == "StaticArr_Byte"){
   n = "Bytes"
  }
  Cptx#r = classGetx(defmain, n)
  @if(r == _){
   #r = classDefx(defmain, n, [class], {itemsType: type})  
  }
 }@else{
  r = class
 }
 r.str = r.name 
 @if(!mid && len == 0){
  @return r
 }
 r = classNewx([r])
 r.str = r.name 
 @if(len > 0){
  r.arr.push(classNewx([itemslimitedc], {
   itemsLimitedLen: intNewx(len, uintc)
  }))
  r.str += "_" + len
 }
 @if(mid){
  r.arr.push(midc)
 }
 @return r;
}
fpDefx ->(types Arrx, return Cptx)Cptx{
 #n = "FuncProto"
 @each _ v types{
  #n += "__" + aliasGetx(classx(v)).name
 }
 @if(return == _){
  return = emptyc
 }
 #n += "__"+return.name
 #x = classGetx(defmain, n);
 @if(x == _){
  #x = curryDefx(defmain, n, funcprotoc, {
   funcVarTypes: arrNewx(types)
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
 fn.class = class
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
 #f = osEnvGet("HOME")+"/soul2/db/"+ns.str+"/"+key+".slp"
 @if(@fs.has(f)){
  Str#fc = @fs[f]
  Arr_Str#arr = fc.split(" ")
  @each _ v arr{
   s.arr.push(nsGetx(ns, v))
  }
 }
 @return s;
}
dbGetx ->(scope Cptx, key Str)Cptx{
 #fstr = osEnvGet("HOME")+"/soul2/db/"+scope.str + "/" + key + ".sl" 
 #f = @fs.stat(fstr)
 #f2 = @fs.stat(fstr+"t")
 #fcache = @fs.stat(fstr+".cache")
 #f2cache = @fs.stat(fstr+"t.cache")  
 
 @if(f){
  Str#str = @fs[fstr]
  @if(f["timeMod"] > fcache["timeMod"]){
   Str#jstr = osCmd("./sl-reader", key + " := "+str)
   @fs[fstr + ".cache"] = jstr
  }@else{
   Str#jstr = @fs[fstr + ".cache"]
  }
 }@elif(f2){
  str = "@`"+@fs[fstr+"t"]+"` '"+fstr+"t'";
  @if(f2["timeMod"] > f2cache["timeMod"]){  
   Str#jstr = osCmd("./sl-reader", key + " := "+str)
   @fs[fstr + "t.cache"] = jstr   
  }@else{
   Str#jstr = @fs[fstr + "t.cache"]  
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
 @if(scope.fscope){
  #r = dbGetx(scope, key);
  @if(r != _){
   scope.dic[key] = r
   @return r;
  }
 }

 @each _ v scope.arr {
  #k = Str(v.id)
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
 @if(r.name != scope.name + "_" + key){
  Cptx#o = copyx(r)
  o.class = scope
  o.name = scope.name + "_" + key
  scope.dic[key] = o
  o.class = scope
  @return o;  
 }
 @return r;
}
classGetx ->(scope Cptx, key Str)Cptx{
 Cptx#r = subClassGetx(scope, key, {})
 @if(r == _){
  @if(scope.str != ""){//if class is scope
   scope.dic[key] = emptyv
  }
  @return _
 }@elif(r.id == emptyv.id){
  @return _
 }
 @if(r.fprop){
  @return propDefx(scope, key, r)
 }
 @return r;
}

subPropGetx ->(scope Cptx, v Cptx, key Str)Cptx{
 #r = classGetx(scope, v.name + "_" + key);
 @if(r != _){
  @return r
 }
 @each _ vv v.arr{
  r = subPropGetx(scope, vv, key)
  @if(r != _){
   @return r
  }
 }
 @return r
}
mustPropGetx ->(scope Cptx, o Cptx, key Str)Cptx{
 #r = propGetx(scope, o, key)
 @if(!r){
  log(scope)
  die("no method "+o.name + "_"+ key)
 }
 @return r
}
propGetx ->(scope Cptx, o Cptx, key Str)Cptx{
 Cptx#r = classGetx(scope, o.name + "_" + key);
 @if(r != _){
  @return r  
 }

 Arrx#p = o.arr
 @each _ v p{
  r = subPropGetx(scope, v, key)
  @if(r != _){
   @return r
  }
 }

 r = subPropGetx(scope, classc, key)
 @if(r != _){
  @return r
 }  

 r = subPropGetx(scope, cptc, key)
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
 }@elif(t == T##INT){
  @return intc
 }@elif(t == T##FLOAT){
  @return floatc  
 }@elif(t == T##NUMBIG){
  @return numbigc
 }@elif(t == T##STR){
  @return strc
 }@elif(t == T##BYTES){
  @return bytesc
 }@elif(t == T##DIC){
  @return dicc
 }@elif(t == T##ARR){
  @return arrc
 }@elif(t == T##CALL){
  @return callc
 }@elif(t == T##ID){
  @return idc
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
 @if(c.id != 0 && c.id == t.id){
  @return @true
 }
 #key = Str(c.id) + "_" + t.id
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
  #k = Str(v.id)
  @if(cache[k] != _){
   @continue
  }
  cache[k] = 1
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
 @if(t == _){
  @return nullv
 }
 @if(t.ctype == T##INT){
  #tar = intNewx(0, t)
 }@elif(t.ctype == T##FLOAT){
  #tar = floatNewx(0.0, t)
 }@elif(t.ctype == T##NUMBIG){   
 }@elif(t.ctype == T##STR){
  #tar = strNewx("", t)
 }@else{
  #tar = nullv
 }
 @return tar
}
defx ->(class Cptx, dic Dicx)Cptx{
 @if(class.ctype == T##CPT){
  @return cptv
 }@elif(class.ctype == T##OBJ){
  @if(class.obj != _ && class.obj.fstatic){
   @return class.obj
  }
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
    @if(pt.id == unknownc.id || pt.id == cptc.id){
     @continue;
    }
    @if(!inClassx(pt, classx(t))){
     log(class.name)    
     log(k)
     log(strx(v))
     log(strx(pt))     
     log(strx(classx(t)))
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
 }@elif(class.ctype == T##INT){
  Cptx#x = intNewx(0)
 }@elif(class.ctype == T##FLOAT){
  Cptx#x = floatNewx(0.0)
 }@elif(class.ctype == T##NUMBIG){
  Cptx#x = nullv//TODO
  die("no numbig")
 }@elif(class.ctype == T##STR){
  Cptx#x = strNewx("")
  x.obj = class
 }@elif(class.ctype == T##BYTES){
  Cptx#x = bytesNewx()
  x.obj = class
  x.fdefault = @true  
 }@elif(class.ctype == T##CALL){
  Cptx#x = callNewx()
  x.obj = class
  x.fdefault = @true     
 }@elif(class.ctype == T##ID){
  Cptx#x = idNewx()
  x.fdefault = @true
 }@elif(class.ctype == T##DIC){
  #x = dicNewx()
  x.fdefault = @true     
 }@elif(class.ctype == T##ARR){
  #x = arrNewx()
  x.fdefault = @true     
 }@else{
  die("unknown class type")
  @return
 }
 x.obj = class 
 @return x
}

copyx ->(o Cptx)Cptx{
 @if(o.fstatic){
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
  fbnum: o.fbnum
  fscope: o.fscope  
  fraw: o.fraw
  fdefmain: o.fdefmain

  name: o.name
  id: uidx()
  id2: o.id2
  class: o.class
  
  obj: o.obj
  pred: o.pred
  
  dic: dicCopyx(o.dic)
  arr: arrCopyx(o.arr)
  str: o.str
  bytes: byteCopyx(o.bytes)
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
 }@elif(t == T##OBJ){
  @return l.id == r.id  
 }@elif(t == T##CLASS){
  @return l.id == r.id
 }@elif(t == T##DIC){
  @return l.id == r.id
 }@elif(t == T##ARR){
  @return l.id == r.id
 }@elif(t == T##CALL){
  @return l.id == r.id  
 }@elif(t == T##ID){
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
mustGetx ->(o Cptx, key Str)Cptx{
 #r = getx(o, key)
 @if(r == _){
  die(key + " not found!")
 }
 @return r
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
 #x = copyCptFromAstx(val)
 o.dic[key] = x
 @return x
}

mustTypepredx ->(o Cptx)Cptx{
 #r = typepredx(o)
 @if(r.id == unknownc.id){
  log(strx(o)) 
  log(strx(r))
  die("unknown type")
 }
 /*
 @if(r.name == ""){
  log(strx(o)) 
  log(strx(r))  
  die("typepredx: type with no name")
 }
 */
 @return r
}
typepredx ->(o Cptx)Cptx{
 @if(o.pred){
  @return o.pred
 }
 #x = subTypepredx(o)
 @if(x == _){
  x = unknownc
 }
 o.pred = x
 @return x
}
subTypepredx ->(o Cptx)Cptx{
 #t = o.type
 @if(t == T##CALL){
  Cptx#f = o.class
  #args = o.arr
  @if(f == _){
   @return callc
  }
  @if(f.id2 != 0 && f.id2 == classc.dic["new"].id2){
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
  @if(f.id == defmain.dic["strConvert"].id){
   Cptx#arg1 = args[1]
   @return arg1
  }
  @if(f.id == defmain.dic["implConvert"].id){
   Cptx#arg1 = args[1]
   @return arg1
  }
  @if(f.id == defmain.dic["type"].id){
   Cptx#arg0 = args[0]
   @return arg0
  }    
  @if(f.id == defmain.dic["malloc"].id){
   Cptx#arg1 = args[1]
   @return itemsDefx(staticarrc, arg1)
  }    
  @if(f.id == defmain.dic["call"].id){
   Cptx#arg0 = args[0]
   #f = typepredx(arg0)
   @if(f.id == unknownc.id){
    @return f;
   }
   #ret = getx(f, "funcReturn")
   @if(!ret){
    @return cptc
   }
   @if(ret.id == emptyc.id){
    @return cptc;
   }   
   @return ret
  }
  
  //if is itemGet    
  @if(f.id == defmain.dic["get"].id){
   Cptx#arg0 = args[0]     
   Cptx#arg1 = args[1]
   Cptx#at0 = typepredx(arg0)
   @if(at0.id == unknownc.id || at0.id == cptv.id){
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
   Cptx#at0 = mustTypepredx(arg0)     
   #r = getx(at0, "itemsType")
   @if(r != _){
    @return classx(r)
   }@else{
    @return cptc
   }
  }
     //if is opassign
  @if(inClassx(f.obj, opassignc)){
   Cptx#arg1 = args[1]
   @return typepredx(arg1)
  }
   //is ne eq gt ge nt ne
  @if(inClassx(f.obj, opcmpc)){
   @return boolc
  }
   //if is other op2
  @if(inClassx(f.obj, op2c)){
   Cptx#arg0 = args[0]
   @return typepredx(arg0)
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
   @if(ret.id == emptyc.id){
    @return cptc;
   }
   @return ret
  }
  @if(inClassx(f.obj, midc)){
   //TODO predict return func call
   @return _
  }
  @return _
 }@elif(t == T##ID){
  //if is idstate
  @if(inClassx(o.obj, idstatec)){
   Str#id = o.str
   @if(id.isInt()){
    @return cptc
   }
   Cptx#s = o.class
   #r = s.dic[id]
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
   Cptx#s = o.class
   @return classx(s)
  }
  
  @if(inClassx(o.obj, idcondc)){
   @if(o.str == "ctx"){
    @return dicc
   }
  }
  die("wrong id: "+o.str)
  @return _
 }@elif(t == T##OBJ){
  @return o.obj
 }@elif(t == T##CLASS){
  @return classc
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
 #s = ""
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
 @return s
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
 @if(i > 3 && o.id > 0){
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
 }@elif(t == T##INT){
  @return Str(o.int)
 }@elif(t == T##FLOAT){
  @return Str(Float(o.val))
 }@elif(t == T##STR){
  @return '"'+ escapex(o.str) + '"'
 }@elif(t == T##BYTES){
  @return "@"+Str(o.bytes)
 }@elif(t == T##CALL){
  @return strx(o.class) + "(" + arr2strx(o.arr, i) +")"
 }@elif(t == T##ID){  
  @return "&ID "+o.str
 }@elif(t == T##DIC){
  @return dic2strx(o.dic, i)
 }@elif(t == T##ARR){
  @return "[" + arr2strx(o.arr, i) +"]"
 }@else{
  log(o.obj)
  log(o)
  die("cpt2str unknown")
  @return ""
 }
}
tplCallx ->(func Cptx, args Arrx, env Cptx)Cptx{
 #b = func.dic["funcTplBlock"]
 @if(b == _){
  @return strNewx("")
 }

 #localx = b.dic["blockStateDef"]
 #nstate = objNewx(localx)
 nstate.fdefault = @false
 nstate.fdefmain = @true
 @each i v args{
  nstate.dic[Str(i)] = v;
 }
 
 Arrx#stack = env.dic["envStack"].arr;
 #ostate = env.dic["envLocal"]
 #ctx = ostate.dic["@ctx"]
 #ctxn = dicNewx()
 nstate.dic["@ctx"] = ctxn
 @if(ctx != _ && !ctx.fdefault){
  @each k v ctx.dic{
   ctxn.arr.push(strNewx(k))
   ctxn.dic[k] = v
  }
 }
 
 stack.push(ostate)
 @if(func.dic["funcTplPath"]){
  nstate.str = func.dic["funcTplPath"].str
 }@else{
  nstate.str = "Tpl: "+func.name
 } 
 env.dic["envLocal"]  = nstate
 blockExecx(b, env)
 env.dic["envLocal"] = stack[stack.len() - 1]
 stack.pop()
// #buf = BuilderStr(nstate.dic["$buf"].val)
// #r = strNewx(buf)
// @return r
 @return nstate.dic["$str"]
}

callx ->(func Cptx, args Arrx, env Cptx)Cptx{
 @if(func == _ || func.obj == _){
  log(arr2strx(args))
  log(strx(func))  
  die("func not defined")
 }
 @if(inClassx(func.obj, funcnativec)){
  @return call(Funcx(func.val), [args, env]);
 }
 @if(inClassx(func.obj, functplc)){ 
  @return tplCallx(func, args, env)
 }
 @if(inClassx(func.obj, funcblockc)){
  Cptx#block = func.dic["funcBlock"]
  #nstate = objNewx(block.dic["blockStateDef"])
  nstate.fdefault = @false
  nstate.fdefmain = @true  
  Arrx#stack = env.dic["envStack"].arr;
  #ostate = env.dic["envLocal"]
  //TODO func def path
  #ctx = ostate.dic["@ctx"]
  @if(ctx){
   nstate.dic["@ctx"] = ctx
  }
  stack.push(ostate)
  nstate.str = "Block:" + func.name  
  env.dic["envLocal"]  = nstate
  Arrx#vars = func.dic["funcVars"].arr
  @each i arg args{
   nstate.dic[vars[i].str] = arg   
  }
  Cptx#r = blockExecx(block, env)
  env.dic["envLocal"] = stack[stack.len() - 1]
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
 @if(!c.id){
  log(strx(c))
  die("no id")
 }
 #key = Str(c.id)
 #r = execsp.dic[key]
 @if(r != _){
  @return r;
 }
 @if(c.name != ""){
  #exect = classGetx(execsp, c.name)
  @if(exect != _){
   execsp.dic[key] = exect;  
   @return exect
  }
 }
 @if(c.arr != _){
  @each _ v c.arr{
   #k = Str(v.id)
   @if(cache[k] != _){ @return; }
   cache[k] = 1;
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
 @return subBlockExecx(o.dic["blockVal"].arr, env, stt)
}
subBlockExecx ->(arr Arrx, env Cptx, stt Uint)Cptx{
 #l = env.dic["envLocal"]
 @each i v arr{
  @if(stt != 0 && stt < i){
   @continue
  }
  l.int = Int(i)
  l.ast = v.ast
  Cptx#r = execx(v, env)
  @if(inClassx(classx(r), signalc)){
   @return r
  }
 }
 @return nullv
}
preExecx ->(o Cptx)Cptx{
//TODO pre exec 1+1 =2 like??
//pre exec idClass.idVal
 @if(o.type == T##ID && inClassx(classx(o), idclassc)){
  @return o.class
 }
 @return o
}
execx ->(o Cptx, env Cptx, flag Int)Cptx{
 #l = env.dic["envLocal"]
 @if(flag == 1){
  #sp = env.dic["envExec"]
 }@elif(flag == 2){
  #sp = execmain
 }@elif(l.fdefmain){
  #sp = execmain
 }@else{
  #sp = env.dic["envExec"]
 } 
 #ex = execGetx(o, sp)
 @if(!ex){
  die("exec: unknown type "+classx(o).name);
 }
 #r = callx(ex, [o], env);
 @if(r == _){
  diex("exec return null", env)
 }
 @return r;
}

tobj2objx ->(to Cptx)Cptx{
 @return objNewx(to.obj)
}

convertx ->(val Cptx, to Cptx)Cptx{
 @if(!val){
  die("convertx val null")
 }
 @if(val.id == nullv.id){
  @return val
 } 
 @if(!to || to.id == cptc.id || to.id == unknownc.id){
  @return val
 }
 #from = typepredx(val)
 @if(from.id == unknownc.id){
  @return val
 }
 #from = aliasGetx(from) 
 to = aliasGetx(to)
 @if(from.id == to.id){
  @return val
 }
 @if(from.id == cptc.id){
  @return callNewx(defmain.dic["as"], [val, to])
 }
 @if(from.fbnum && to.fbnum){
  @if(val.fmid){
   @return callNewx(defmain.dic["numConvert"], [val, to])
  }
  val.obj = to
  val.pred = to
  to.obj = val
  @return val  
 }
 @if(to.ctype == from.ctype && from.ctype == T##STR){
  @if(!val.fmid){
   @return strNewx(val.str, to)
  }
  @return callNewx(defmain.dic["strConvert"], [val, to])
 }
 @if(inClassx(from, to)){
  @if(to.ctype == from.ctype && to.ctype == T##OBJ){
   @if(!inClassx(to, funcc)){
  //TODO convert struct TODO TODO   
    @return callNewx(defmain.dic["implConvert"], [val, to])
   }
  }
  @return val
 } 
 @if(to.ctype == from.ctype){
  @if(!val.fmid){ 
   @if(inClassx(to, from)){//specify eg. Arr to ArrStatic
    val.obj = to
    val.pred = to    
    to.obj = val
    @return val  
   }@elif(val.type == T##ARR || val.type == T##DIC){
    @if(to.fbitems){
     @return itemsChangeBasicx(val, to)
    }   
   }
  }
  @if(from.ctype == T##ARR || from.ctype == T##DIC){
   @if(from.str == "Static" + to.str){
    #f = getx(staticarrc, "toArr")
    @return callNewx(f, [val])
   }
   @if("Static" + from.str == to.str){
    #f = getx(arrc, "toStaticArr")   
    @return callNewx(f, [val])
   }
  }
 }

 #name = getNamex(to)
 @if(name == ""){
  die("class with no name")
 }
 #r = getx(from, "to"+name)
 @if(r == _){
  log(strx(val))
  log(strx(from))   
  log(strx(to))
  log("to"+name)
  die("convert func not defined")
 }
 @return callNewx(r, [val])
}
byte2strx ->(b Byte)Str{
 #c = malloc(1, Byte)
 c[0] = b
 @return Str(c) 
}
/*
sendFinalx ->(arrx Arrx, scope Cptx, from Cptx, to Cptx)Bool{
//should read from left
 #fromt = mustTypepredx(from)
 #tot = mustTypepredx(to)
 @if(inClassx(tot, handlerc)){ //read from val
  @return @false
 }
 @if(to.type != T##ID){
  die("if not handler, can only assign to ID");
  @return @false
 }

 @if(inClassx(fromt, handlerc)){
  #r = propGetx(scope, fromt, "read"+tot.name)
  @if(r){
   #fromx = callNewx(r, [from])  
   #assignf = mustGetx(to, "assign")
   #ncall = callNewx(assignf, [to, fromx], callrawc)
   arrx.push(ncall)
   @return @true
  }
  #stmread = mustPropGetx(scope, fromt, "read")
  #stmfrom = callNewx(stmread, [from])
  #stmfromt = classGetx(fromt, "handlerStreamOutType")
  #fread = mustPropGetx(scope, stmfromt, "read")
  #fromx = callNewx(fread, [stmfrom])
  #fromxt = classGetx(fromt, "handlerMsgOutType")
 }@elif(inClassx(fromt, streamc)){
  #fread = mustPropGetx(scope, fromt, "read")
  #fromx = callNewx(fread, [from])
  #fromxt = bytesc
 }@else{
  #fromx = from
  #fromxt = fromt 
 }
 @if(tot.id == nullc.id){
  tot = fromxt
  to.pred = fromxt  
  to.class.dic[to.str] = defx(fromxt)
// }@elif(){
  
 }@else{
  fromx = convertx(fromx, tot)  
 }
  
 #assignf = mustGetx(to, "assign")
 #ncall = callNewx(assignf, [to, fromx], callrawc)
 arrx.push(ncall)

 @return @true
}
*/
sendx ->(scope Cptx, arr Arrx)Arrx{
/*
 #arrx = &Arrx;
 #l = arr.len()
 @for #i=0; i<l - 1; i++{
  #from = arr[i]
  #to = arr[i+1]
  #fromt = mustTypepredx(from)
  #tot = mustTypepredx(to)
  //&B = A_read(&A)
  #done = sendFinalx(arrx, scope, from, to)
  @if(done){
   @continue
  }

  //B_write(&B, &A)
  @if(!inClassx(fromt, handlerc)){ //write to val
   #tomsgt = classx(classGetx(tot, "handlerMsgInType"))
   #fwrite = mustPropGetx(scope, tot, "write")
   from = convertx(from, tomsgt)
   arrx.push(callNewx(fwrite, [to, from]))
   @continue;
  }

  //A_pipeB(&A, &B)
  #f = propGetx(scope, fromt, "pipe" + tot.name)
  @if(f){
   arrx.push(callNewx(f, [from, to]))
   @continue
  }

  //B_write(&B, A_read(&A))
  #fread = mustPropGetx(scope, fromt, "read")
  #fwrite = mustPropGetx(scope, tot, "write")
  #tomsgt = classx(classGetx(tot, "handlerMsgInType"))
  #cread = convertx(callNewx(fread, [from]), tomsgt)
  arrx.push(callNewx(fwrite, [to, cread]))
  @continue
  log(arr)
  log(i)
  die("cannot send, not function matched")
 }
 @return arrx
 */
 @return &Arrx
}
diex ->(str Str, env Cptx){
 @each _ v env.dic["envStack"].arr{
  log(v.str + ":" + v.int)
 }
 #l = env.dic["envLocal"]
 log(l.str + ":" + l.int)
 log(l.ast)  
 die(str)
}
httpx ->(){
}