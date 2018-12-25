///cache usage
//functpl.val: cache ast(progl2ast from str)
//func.val: cache state(nlocal)
//items.val: cache init expr
//class.obj: cache single instance
//class.str: ns, scope, str
/////1 set class/structs
T := @enum CPT OBJ CLASS NULL INT FLOAT NUMBIG STR DIC ARR VALFUNC
Cptx => {
 type: T
 ctype: T
 
 fmid: Bool
 fdefault: Bool
 fprop: Bool
 fstatic: Bool 
 
 name: Str
 id: Str
 class: Cptx 

 obj: Cptx
 dic: Dicx
 arr: Arrx
 str: Str
 int: Int
 val: Cpt
}
Dicx := @type Dic Cptx
Arrx := @type Arr Cptx
Astx := @type ArrStatic Cpt
Funcx := @type ->(Arrx, Cptx)Cptx

/////2 common func ...
uidi := Uint(0);
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
_indentx := ""
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
escapex ->(s Str)Str{
 @return s.replace("\\", "\\\\").replace("\n", "\\n").replace("\t", "\\t").replace("\r", "\\r").replace("\"", "\\\"")
}


/////3 root newfuncs
root := &Dicx
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
classNewx ->(arr Arrx, dic Dicx)Cptx{
 #r = &Cptx{
  type: T##CLASS
  ctype: T##OBJ
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
scopeObjNewx ->(class Cptx)Cptx{
 @if(class.obj != _){
  @return class.obj
 }
 @return objNewx(class)
}
routex ->(o Cptx, scope Cptx, name Str)Cptx{
 //TODO route name should not contain $
 #dic = scope.dic;
 dic[name] = o 
 o.name = name;
 o.class = scope
 @return o
}

defns := nsNewx("def")
defmain := scopeNewx(defns, "main")

cptc := classNewx();
routex(cptc, defmain, "Cpt");
cptc.ctype = T##CPT
cptc.fdefault = @true
cptc.fstatic = @true

cptv := &Cptx{
 type: T##CPT
 fdefault: @true
 fstatic: @true
 id: uidx()
}

objc := classNewx();
routex(objc, defmain, "Obj");
objc.ctype = T##OBJ

classc := classNewx();
routex(classc, defmain, "Class");
classc.ctype = T##CLASS

/////4 def new func
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
/////5 scope func
emptyclassgetc := classDefx(defmain, "EmptyClassGet")//classGet none means cache
emptyclassgetv := objNewx(emptyclassgetc)

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

//TOOD cachedb
dbGetx ->(scope Cptx, key Str)Str{
 #fstr = osEnvGet("HOME")+"/soul2/db/"+scope.str + "/" + key + ".sl"
 #f = File(fstr)
 #f2 = File(fstr+"t") 

 @if(f.exists()){
  @return f.readAll()
 }@elif(f2.exists()){
  @return "@`"+f2.readAll()+"` '"+fstr+"t'";
 }
 @return ""
}
subClassGetx ->(scope Cptx, key Str, cache Dic)Cptx{
 #r = scope.dic[key]
 @if(r != _){ 
  @return r
 }
 @if(scope.str != ""){
  #sstr = dbGetx(scope, key);
  @if(sstr != ""){
   r = libProgl2cptx(sstr, scope, key)
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

/////6 def val, null
valc := classDefx(defmain, "Val", _, {
 val: cptc
})
nullv := &Cptx{
 type: T##NULL
 fdefault: @true
 fstatic: @true 
 id: uidx()
}
nullOrx ->(x Cptx)Cptx{
 @if(x == _){
  @return nullv
 }
 @return x
}
nullc := curryDefx(defmain, "Null", valc, {
 val: nullv
})
nullc.ctype = T##NULL
isnull ->(o Cptx)Bool{
 @return o.type == T##NULL
}
zerointv := &Cptx{
 type: T##INT
 int: 0
}
zerofloatv := &Cptx{
 type: T##FLOAT
 val: 0.0
}
numc := classDefx(defmain, "Num", [valc])
intc := classDefx(defmain, "Int", [numc], {
 val: zerointv
})
intc.ctype = T##INT
uintc := classDefx(defmain, "Uint", [intc])
floatc := classDefx(defmain, "Float", [numc], {
 val: zerofloatv
})
floatc.ctype = T##FLOAT

boolc := curryDefx(defmain, "Bool", intc)
bytec := curryDefx(defmain, "Byte", intc)
curryDefx(defmain, "Int16", intc)
curryDefx(defmain, "Int32", intc)
curryDefx(defmain, "Int64", intc)

curryDefx(defmain, "Uint8", uintc)
curryDefx(defmain, "Uint16", uintc)
curryDefx(defmain, "Uint32", uintc)
curryDefx(defmain, "Uint64", uintc)

curryDefx(defmain, "Float32", floatc)
curryDefx(defmain, "Float64", floatc)

numbigc := curryDefx(defmain, "NumBig", numc)
//TODO
numbigc.ctype = T##NUMBIG

uintNewx ->(x Int)Cptx{
 @return &Cptx{
  type: T##INT
  obj: uintc
  int: x
 }
}
truev := &Cptx{
 type: T##INT
 obj: boolc
 int: 1
 id: uidx()
}
falsev := &Cptx{
 type: T##INT
 obj: boolc
 int: 0
 id: uidx() 
}
boolNewx ->(x Bool)Cptx{
 @if(x){
  @return truev
 }
 @return falsev;
}
floatNewx ->(x Float)Cptx{
 @return &Cptx{
  type: T##FLOAT
  val: x
 }
}

/////7 def items
itemsc := classDefx(defmain, "Items", [valc], {
 itemsType: cptc
})
itemslimitedc := classDefx(defmain, "ItemsLimited", [itemsc], {
 itemsLimitedLength: uintc
})
arrc := curryDefx(defmain, "Arr", itemsc)
arrc.ctype = T##ARR
arrstaticc := curryDefx(defmain, "ArrStatic", arrc)

midc := classDefx(defmain, "Mid")
itemDefx ->(class Cptx, type Cptx, mid Bool)Cptx{
 @if(type != _ && type.id != cptc.id){
  type = aliasGetx(type)
  Str#n = class.name+"_"+type.name
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
itemDefx(arrc, bytec)
dicc := curryDefx(defmain, "Dic", itemsc)
dicc.ctype = T##DIC

/////8 advanced type init: string, enum, unlimited number...
zerostrv := &Cptx{
 type: T##STR 
 str: ""
}
strc := curryDefx(defmain, "Str", valc, {
 val: zerostrv
})
strc.ctype = T##STR

arrstrc := itemDefx(arrc, strc)
dicstrc := itemDefx(dicc, strc)
dicuintc := itemDefx(dicc, uintc)
dicclassc := itemDefx(dicc, classc)
arrclassc := itemDefx(arrc, classc)

enumc := classDefx(defmain, "Enum", [uintc], {
 enum: arrstrc
 enumDic: dicuintc
})
bufferc := classDefx(defmain, "Buffer", [strc])
pointerc := classDefx(defmain, "Pointer", [valc])

pathc := classDefx(defmain, "Path", _, {
 path: strc
})
filec := classDefx(defmain, "File", [pathc])
dirc := classDefx(defmain, "Dir", [pathc])

/////9 def var/block/func
emptyreturnc := classDefx(defmain, "EmptyReturn")//return empty mean no return
emptyreturnv := objNewx(emptyreturnc)

funcc := classDefx(defmain, "Func")
funcprotoc := classDefx(defmain, "FuncProto", [funcc], {
 funcVarTypes: arrc
 funcReturn: classc
})
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

valfuncc := curryDefx(defmain, "ValFunc", valc)
valfuncc.ctype = T##VALFUNC
funcnativec := classDefx(defmain, "FuncNative", [funcprotoc], {
 funcNative: valfuncc
})

//func -> vars + block/native/tpl
//block -> val + state

blockc := classDefx(defmain, "Block", _, {
 blockVal: arrc,
 blockStateDef: classc,
 blockLabels: dicuintc,
 
 blockScope: classc, 
 blockPath: strc 
})

blockc.dic["blockParent"] = defx(blockc)

blockmainc := curryDefx(defmain, "BlockMain", blockc)

//stack
funcblockc := classDefx(defmain, "FuncBlock", [funcprotoc], {
 funcVars: arrstrc
 funcBlock: blockc
})
funcclosurec := curryDefx(defmain, "FuncClosure", funcblockc)

functplc := classDefx(defmain, "FuncTpl", [funcc], {
 funcTpl: strc
 funcTplPath: strc
})

funcSetClosurex ->(func Cptx){
 func.obj.arr[1] = funcclosurec
}
/////10 def mid

callc := classDefx(defmain, "Call", [midc], {
 callFunc: funcc
 callArgs: arrc
})

callrawc := curryDefx(defmain, "CallRaw", callc)

callmethodc := curryDefx(defmain, "CallMethod", callc)
callreflectc := curryDefx(defmain, "CallReflect", callc)


idc := classDefx(defmain, "Id")
idstrc :=  classDefx(defmain, "IdStr", [idc], {
 idStr: strc,
})
idstatec := classDefx(defmain, "IdState", [idstrc, midc], {
 idState: classc 
})
idlocalc := curryDefx(defmain, "IdLocal", idstatec)
idparentc := curryDefx(defmain, "IdParent", idstatec)
idglobalc := curryDefx(defmain, "IdGlobal", idstatec)

idclassc := classDefx(defmain, "IdClass", [idstrc], {
 idVal: cptc
})
aliasc := classDefx(defmain, "Alias")

aliasDefx ->(scope Cptx, key Str, class Cptx)Cptx{
 #x = classDefx(scope, key, [aliasc, class])
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

/////11 def op
//for op
opc := classDefx(defmain, "Op", [funcc], {
 opPrecedence: intc
})
op1c := classDefx(defmain, "Op1", [opc])
op2c := classDefx(defmain, "Op2", [opc])
//https://en.cppreference.com/w/c/language/operator_precedence
//remove unused
opgetc := curryDefx(defmain, "OpGet", op2c, {
 opPrecedence: intNewx(0)
})
opnotc := curryDefx(defmain, "OpNot", op1c, {
 opPrecedence: intNewx(10)
})
opmultiplyc := curryDefx(defmain, "OpMultiply", op2c, {
 opPrecedence: intNewx(20)
})
opdividec := curryDefx(defmain, "OpDivide", op2c, {
 opPrecedence: intNewx(20)
})
opmodc := curryDefx(defmain, "OpMod", op2c, {
 opPrecedence: intNewx(20)
})
opaddc := curryDefx(defmain, "OpAdd", op2c, {
 opPrecedence: intNewx(30)
})

opsubtractc := curryDefx(defmain, "OpSubtract", op2c, {
 opPrecedence: intNewx(30)
})
opgec := curryDefx(defmain, "OpGe", op2c, {
 opPrecedence: intNewx(40)
})
oplec := curryDefx(defmain, "OpLe", op2c, {
 opPrecedence: intNewx(40)
})
opgtc := curryDefx(defmain, "OpGt", op2c, {
 opPrecedence: intNewx(40)
})
opltc := curryDefx(defmain, "OpLt", op2c, {
 opPrecedence: intNewx(40)
})
opeqc := curryDefx(defmain, "OpEq", op2c, {
 opPrecedence: intNewx(50)
})
opnec := curryDefx(defmain, "OpNe", op2c, {
 opPrecedence: intNewx(50)
})
opandc := curryDefx(defmain, "OpAnd", op2c, {
 opPrecedence: intNewx(60)
})
oporc := curryDefx(defmain, "OpOr", op2c, {
 opPrecedence: intNewx(70)
})
opassignc := curryDefx(defmain, "OpAssign", op2c, {
 opPrecedence: intNewx(80)
})
opconcatc := curryDefx(defmain, "OpConcat", op2c, {
 opPrecedence: intNewx(80)
})

/////12 def signal
signalc := classDefx(defmain, "Signal");
continuec := curryDefx(defmain, "Continue", signalc)
breakc := curryDefx(defmain, "Break", signalc)
gotoc := classDefx(defmain, "Goto", [signalc], {
 goto: uintc
})
returnc := classDefx(defmain, "Return", [signalc], {
 return: cptc
})
errorc := classDefx(defmain, "Error", [signalc], {
 errorCode: uintc
 errorMsg: strc
})
/////13 def ctrl
ctrlc := classDefx(defmain, "Ctrl")
ctrlargc := classDefx(defmain, "CtrlArg", [ctrlc], {
 ctrlArg: cptc 
})
ctrlargsc := classDefx(defmain, "CtrlArgs", [ctrlc], {
 ctrlArgs: arrc
})
ctrlifc := curryDefx(defmain, "CtrlIf", ctrlargsc)
ctrlforc := curryDefx(defmain, "CtrlFor", ctrlargsc)
ctrleachc := curryDefx(defmain, "CtrlEach", ctrlargsc)
ctrlwhilec := curryDefx(defmain, "CtrlWhile", ctrlargsc)
ctrlbreakc := curryDefx(defmain, "CtrlBreak", ctrlc)
ctrlcontinuec := curryDefx(defmain, "CtrlContinue", ctrlc)
ctrlgotoc := curryDefx(defmain, "CtrlGoto", ctrlargc)

ctrlreturnc := curryDefx(defmain, "CtrlReturn", ctrlargc)
ctrlerrorc := curryDefx(defmain, "CtrlError", ctrlargsc)

/////14 def  env
envc := classDefx(defmain, "Env", _, {
 envStack: arrc
 envLocal: objc
 
 envExec: classc 
 envBlock: blockmainc
 envActive: boolc
})

/////15 func newfunc
valfuncNewx ->(f Funcx)Cptx{
 @return &Cptx{
  type: T##VALFUNC
  id: uidx()    
  val: f
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
 #fp = fpDefx(argtypes, return)
 @if(val != _){
  Cptx#x = classNewx([fp, funcnativec])
  x.dic["funcNative"] = valfuncNewx(val)  
 }@else{
  #x = classNewx([fp])
 }
 @return objNewx(x)
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
funcSetOpx ->(func Cptx, op Cptx){
 func.obj.arr.push(op)
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

/////16 TODO
/////17 oop func
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
 }@elif(t == T##VALFUNC){
  @return valfuncc
 }@else{
  die("NOTYPE")
 }
 @return _
}
typex ->(o Cptx)Str{
 @return ""
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
 @if(c.id != "" && c.id == t.id){
  @return @true
 }
 @if(!cache){
  cache = {}
 }
 @each _ v c.arr{
  @if(cache[v.id] != _){
   @continue
  }
  cache[v.id] = 1
  @if(inClassx(v, t, cache) ){
   @return @true
  }
 }
 @return @false 
}
defaultx ->(t Cptx)Cptx{
 @if(t.ctype == T##INT){
  #tar = zerointv
 }@elif(t.ctype == T##FLOAT){
  #tar = zerofloatv   
 }@elif(t.ctype == T##NUMBIG){   
 }@elif(t.ctype == T##STR){
  #tar = zerostrv    
 }@else{
  #tar = nullv
 }
 @return tar
}
inx ->(c Cptx, t Cptx)Bool{
 @if(t.type == T##CPT){
  @return @true
 }
 @if(t.type == T##OBJ && c.type == T##OBJ){
  @return @true
 }
 @if(c.type != t.type){
  @return @false
 }
 @if(c.obj != _){
  Bool#r = inClassx(classx(c), classx(t) )
  @if(!r){
   @return @false
  }
 }
 @return @true
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
    @if(!inx(v, t) ){
     log(v)
     log(t)
     log(v.obj)
     log(t.obj)
     log(k)
     log(class.name)
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
 }@elif(class.ctype == T##VALFUNC){
  Cptx#x = valfuncNewx()
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
 }@elif(t == T##VALFUNC){
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


getParentx ->(o Cptx, key Str)Cptx{
 @if(o.arr == _){
  @return _
 }
 @each _ v o.arr{
  Dicx#d = v.dic
  Cptx#r = d[key]
  @if(r != _){
   @return v
  }
  r = getParentx(v, key)
  @if(r != _){
   @return r
  }
 }
 @return _;
}
objGetLocalx ->(o Cptx, key Str)Cptx{
 #r = o.dic[key]
 @if(r != _){
  @return r
 }
 @if(o.obj == _){
  log(strx(o))
  die("local with no def")
 }
 r = classGetx(o.obj, key) 
 @if(r != _){
  @return r
 }
 @return _
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
 @return val
}

typepredx ->(o Cptx)Cptx{
 #t = o.type
 @if(t == T##OBJ){
  @if(o.fmid){
   //if is idstate
   @if(inClassx(o.obj, idstatec)){
    Cptx#s = o.dic["idState"]
    #r = getx(s, o.dic["idStr"].str)
    @if(r == _){
     log(strx(s)) 
     log(o.dic["idStr"].str)    
     die("not defined in idstate, may use #1 #2 like")
     @return r
    }
    @return typepredx(r)
   }
   //if is call
   @if(inClassx(o.obj, callc)){
    Cptx#f = o.dic["callFunc"]
    Cptx#args = o.dic["callArgs"]
    @if(f.id == defmain.dic["new"].id){
     Cptx#arg0 = args.arr[0]
     @return arg0
    }
    @if(f.id == defmain.dic["as"].id){
     Cptx#arg1 = args.arr[1]
     @return arg1
    }    
    //if is itemGet    
    @if(f.id == defmain.dic["get"].id){
     Cptx#arg0 = args.arr[0]       
     Cptx#arg1 = args.arr[1]
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
     Cptx#arg0 = args.arr[0]
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
   }
   //if is idscope
   @if(inClassx(o.obj, idclassc)){
    Cptx#s = o.dic["idVal"]
    @return typepredx(s)
   }
   log(o)
   die("typepred: wrong mid")
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

/*

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
  }
  @if(o.obj.name != ""){
   s += "&"+o.obj.name
  }@else{
   s += "&~" + o.obj.id
  }
  @if(!o.fdefault){
   s += dic2strx(o.dic, i)
  }
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
 }@elif(t == T##VALFUNC){
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
*/
strx ->(o Cptx, i Int)Str{@return ""}
libProgl2cptx ->(str Str, def Cptx, name Str)Cptx{@return _}