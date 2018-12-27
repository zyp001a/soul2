///cache usage
//functpl.val: cache ast(progl2ast from str)
//func.val: cache state(nlocal)
//items.val: cache init expr
//class.obj: cache single instance
//class.str: ns, scope, str
/////1 set class/structs
T = =>Enum {
 enum: [
  "CPT",
  "OBJ", "CLASS"
  
  "NULL",
  "INT", "FLOAT", "NUMBIG"
  "STR",
  "DIC", "ARR",
  "VALFUNC"  
 ]
}
Dicx = => Dic {
 itemsType: Cptx
}
Arrx = => Arr {
 itemsType: Cptx
}
ArrStr = => Arr {
 itemsType: Str
}
Cptx = <>{
 type: T
 ctype: T
 
 fmid: Boolean
 fdefault: Boolean
 fprop: Boolean
 farg: Boolean
 fstatic: Boolean   
 
 name: Str
 id: Str
 class: Cptx  

 obj: Cptx
 dic: Dicx
 arr: Arrx
 str: Str
 int: Int
 val: Val
}
Astx = => ArrStatic {
 itemsType: Val
}
/////2 common func ...
Uint##uidi = 0;
uidx = &()Str{
 Str#r = str(uidi)
 uidi += 1
 @return r;
}
dicOrx = &(x Dicx)Dicx{
 @if(x == _){
  @return @Dicx{}
 }@else{
  @return x
 }
}
arrOrx = &(x Arrx)Arrx{
 @if(x == _){
  @return @Arrx{}
 }@else{
  @return x
 }
}
##_indentx = " "
indx = &(s Str, first Int)Str{
 @if(s == ""){
  @return s
 }
 ArrStr#arr = s.split("\n")
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
/////3 root ...
##root = @Dicx{}
nsNewx = &(name Str)Cptx{
 Cptx#x = dicNewx()
 x.name = "Ns_" + name
 x.str = name
 @return x;
}
scopeNewx = &(ns Cptx, name Str)Cptx{
 Cptx#x = classNewx()
 x.name = "Scope_" + ns.str + "_" + name
 x.str = ns.str + "/" + name
 @if(ns.dic[name] == _){
  push(ns.arr, strNewx(name))
 }
 ns.dic[name] = x 
 @return x;
}
parentMakex = &(o Cptx, parentarr Arrx){
 @if parentarr != _ {
  T#ctype = o.ctype
  @foreach e parentarr{
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
   o.arr = @Arrx{}
  }
 }
}
classNewx = &(arr Arrx, dic Dicx)Cptx{
 #r = &Cptx{
  type: @T("CLASS")
  ctype: @T("OBJ")
  id: uidx()    
 } 
 r.dic = dicOrx(dic)
 parentMakex(r, arr)
 @return r;
}
routex = &(o Cptx, scope Cptx, name Str)Cptx{
 //TODO route name should not contain $
 #dic = scope.dic;
 dic[name] = o 
 o.name = name;
 o.class = scope
 @return o
}
##defns = nsNewx("def")
##defmain = scopeNewx(defns, "main")

##cptc = classNewx();
routex(cptc, defmain, "Cpt");
cptc.ctype = @T("CPT")
cptc.fstatic = @Boolean(1)
##cptv = &Cptx{
 type: @T("CPT")
 fdefault: @Boolean(1)
 fstatic: @Boolean(1) 
 id: uidx()
}


##objc = classNewx();
routex(objc, defmain, "Obj");
objc.ctype = @T("OBJ")

##classc = classNewx();
routex(classc, defmain, "Class");
classc.ctype = @T("CLASS")

/////4 def new func
objNewx = &(class Cptx, dic Dicx)Cptx{
 @if(class.ctype != @T("OBJ")){
  die("objNew error, should use def")
 }
 #x = &Cptx{
  type: @T("OBJ")
  id: uidx()
  dic: dicOrx(dic)
  obj: class
 }
 class.obj = x
 @if(dic == _ || len(dic) == 0){
  x.fdefault = @Boolean(1)
 }
 @return x;
}

scopeObjNewx = &(class Cptx)Cptx{
 @if(class.obj != _){
  @return class.obj
 }
 @return objNewx(class)
}

classDefx = &(scope Cptx, name Str, parents Arrx, schema Dicx)Cptx{
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
curryDefx = &(scope Cptx, name Str, class Cptx, schema Dicx)Cptx{
 #x = classNewx([class], schema)
 routex(x, scope, name)
 @return x
}

/////5 scope func
##emptyclassgetc = classDefx(defmain, "EmptyClassGet")//classGet none means cache
##emptyclassgetv = objNewx(emptyclassgetc)
nsGetx = &(ns Cptx, key Str)Cptx{
 #s = ns.dic[key];
 @if(s != _){
  @return s;
 }
 #s = scopeNewx(ns, key)
 Str#f = getenv("HOME")+"/soul2/db/"+ns.str+"/"+key+".slp"
 @if(fileExists(f)){
  Str#fc = fileRead(f)
  ArrStr#arr = fc.split(" ")
  @foreach v arr{
   push(s.arr, nsGetx(ns, v))
  }
 }
 @return s;
}
//TOOD cachedb
dbGetx = &(scope Cptx, key Str)Str{
 Str#f = pathResolve(getenv("HOME")+"/soul2/db/"+scope.str + "/" + key + ".sl")

 @if(fileExists(f)){
  @return fileRead(f)
 }@elif(fileExists(f+"t")){
  @return "@`"+fileRead(f+"t")+"` '"+f+"t'";
 }
 @return ""
}
subClassGetx = &(scope Cptx, key Str, cache Dic)Cptx{
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

 @foreach v scope.arr {
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
propDefx = &(scope Cptx, key Str, r Cptx)Cptx{
 Cptx#o = copyx(r)
 o.class = scope
 o.name = scope.name + "_" + key
 @return o;
}
classGetx = &(scope Cptx, key Str)Cptx{
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
subMethodGetx = &(scope Cptx, v Cptx, key Str)Cptx{
 #r = classGetx(scope, v.name + "_" + key);
 @if(r != _){
  @return r
 }
 @foreach vv v.arr{
  r = subMethodGetx(scope, vv, key)
  @if(r != _){
   @return r
  }
 }
 @return r
}
methodGetx = &(scope Cptx, func Cptx)Cptx{
 Cptx#r = classGetx(scope, func.name);
 @if(r != _){
  @return r  
 }

 Cptx#o = func.class
 Arrx#p = o.arr
 @foreach v p{
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
##valc = classDefx(defmain, "Val", _, {
 val: cptc
})
##nullv =  &Cptx{
 type: @T("NULL")
 fdefault: @Boolean(1)
 fstatic: @Boolean(1)
 id: uidx()
}
nullOrx = &(x Cptx)Cptx{
 @if(x == _){
  @return nullv
 }
 @return x
}
##nullc = curryDefx(defmain, "Null", valc, {
 val: nullv
})
nullc.ctype = @T("NULL")
isnull = &(o Cptx)Boolean{
 @return (o.type == @T("NULL"))
}
##zerointv = &Cptx{
 type: @T("INT")
 int: 0
}
##zerofloatv = &Cptx{
 type: @T("FLOAT")
 val: 0.0
}
##numc = classDefx(defmain, "Num", [valc])
##intc = classDefx(defmain, "Int", [numc], {
 val: zerointv
})
intc.ctype = @T("INT")
##uintc = classDefx(defmain, "Uint", [intc])
##floatc = classDefx(defmain, "Float", [numc], {
 val: zerofloatv
})
floatc.ctype = @T("FLOAT")

##boolc = curryDefx(defmain, "Bool", intc)
##bytec = curryDefx(defmain, "Byte", intc)
curryDefx(defmain, "Int16", intc)
curryDefx(defmain, "Int32", intc)
curryDefx(defmain, "Int64", intc)

curryDefx(defmain, "Uint8", uintc)
curryDefx(defmain, "Uint16", uintc)
curryDefx(defmain, "Uint32", uintc)
curryDefx(defmain, "Uint64", uintc)

curryDefx(defmain, "Float32", floatc)
curryDefx(defmain, "Float64", floatc)

##numbigc = curryDefx(defmain, "NumBig", numc)
//TODO
numbigc.ctype = @T("NUMBIG")

intNewx = &(x Int)Cptx{
 @return &Cptx{
  type: @T("INT")
  int: x
 }
}
uintNewx = &(x Int)Cptx{
 @return &Cptx{
  type: @T("INT")
  obj: uintc
  int: x
 }
}
##truev = &Cptx{
 type: @T("INT")
 obj: boolc
 int: 1
 id: uidx()
}
##falsev = &Cptx{
 type: @T("INT")
 obj: boolc
 int: 0
 id: uidx() 
}
boolNewx = &(x Boolean)Cptx{
 @if(x){
  @return truev
 }
 @return falsev;
}
floatNewx = &(x Num)Cptx{
 @return &Cptx{
  type: @T("FLOAT")
  val: x
 }
}

/////7 def items
##itemsc = classDefx(defmain, "Items", [valc], {
 itemsType: cptc
})
##itemslimitedc = classDefx(defmain, "ItemsLimited", [itemsc], {
 itemsLimitedLength: uintc
})
##arrc = curryDefx(defmain, "Arr", itemsc)
arrc.ctype = @T("ARR")
##staticarrc = curryDefx(defmain, "StaticArr", arrc)

##midc = classDefx(defmain, "Mid")
itemDefx = &(class Cptx, type Cptx, mid Boolean)Cptx{
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
##arrbytec = itemDefx(arrc, bytec)
##dicc = curryDefx(defmain, "Dic", itemsc)
dicc.ctype = @T("DIC")

arrNewx = &(class Cptx, val Arrx)Cptx{
 @if(class == _){
  class = arrc;
 }
 #x = &Cptx{
  type: @T("ARR")
  id: uidx()  
  obj: class
 }
 @if(val != _){
  x.arr = val
 }@else{
  x.arr = @Arrx{}
 }
 @return x
}
dicNewx = &(class Cptx, val Dicx, arr Arrx)Cptx{
 #r = &Cptx{
  type: @T("DIC")
  obj: class
  id: uidx()
  dic: dicOrx(val)
  arr: arrOrx(arr)
 }
 @if(val != _ && arr == _){
  @each k v val{
   push(r.arr, strNewx(k))
   unused(v)
  }
 }
 @return r
}

/////8 advanced type init: string, enum, unlimited number...
##zerostrv = &Cptx{
 type: @T("STR")
 str: ""
}
##strc = curryDefx(defmain, "Str", valc, {
 val: zerostrv
})
strc.ctype = @T("STR")

strNewx = &(x Str)Cptx{
 @return &Cptx{
  type: @T("STR")
  str: x
 }
}
##arrstrc = itemDefx(arrc, strc)
##dicstrc = itemDefx(dicc, strc)
##dicuintc = itemDefx(dicc, uintc)
##dicclassc = itemDefx(dicc, classc)
##arrclassc = itemDefx(arrc, classc)

##enumc = classDefx(defmain, "Enum", [uintc], {
 enum: arrstrc
 enumDic: dicuintc
})
##bufferc = classDefx(defmain, "Buffer", [strc])
##jsonc = classDefx(defmain, "Json")
##jsonarrc = classDefx(defmain,, "JsonArr", [arrc])
##pointerc = classDefx(defmain, "Pointer", [valc])

##pathc = classDefx(defmain, "Path", _, {
 path: strc
})
##filec = classDefx(defmain, "File", [pathc])
##dirc = classDefx(defmain, "Dir", [pathc])

/////9 def var/block/func
##emptyreturnc = classDefx(defmain, "EmptyReturn")//return empty mean no return
##emptyreturnv = objNewx(emptyreturnc)

##funcc = classDefx(defmain, "Func")
##funcprotoc = classDefx(defmain, "FuncProto", [funcc], {
 funcVarTypes: arrc
 funcReturn: classc
})
fpDefx = &(types Arrx, return Cptx)Cptx{
 #n = "FuncProto"
 @foreach v types{
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

##valfuncc = curryDefx(defmain, "ValFunc", valc)
valfuncc.ctype = @T("VALFUNC")
##funcnativec = classDefx(defmain, "FuncNative", [funcprotoc], {
 funcNative: valfuncc
})

//func -> vars + block/native/tpl
//block -> val + state

##blockc = classDefx(defmain, "Block", _, {
 blockVal: arrc,
 blockStateDef: classc,
 blockLabels: dicuintc,
 
 blockScope: classc, 
 blockPath: strc 
})

blockc.dic["blockParent"] = defx(blockc)

##blockmainc = curryDefx(defmain, "BlockMain", blockc)

//stack
##funcblockc = classDefx(defmain, "FuncBlock", [funcprotoc], {
 funcVars: arrstrc
 funcBlock: blockc
})
##funcclosurec = curryDefx(defmain, "FuncClosure", funcblockc)

##functplc = classDefx(defmain, "FuncTpl", [funcc], {
 funcTpl: strc
 funcTplPath: strc
})

funcSetClosurex = &(func Cptx){
 func.obj.arr[1] = funcclosurec
}
/////10 def mid

##callc = classDefx(defmain, "Call", [midc], {
 callFunc: funcc
 callArgs: arrc
})

##callrawc = curryDefx(defmain, "CallRaw", callc)

##callmethodc = curryDefx(defmain, "CallMethod", callc)
##callreflectc = curryDefx(defmain, "CallReflect", callc)


##idc = classDefx(defmain, "Id")
##idstrc =  classDefx(defmain, "IdStr", [idc], {
 idStr: strc,
})
//##iduintc =  classDefx(defmain, "IdUintc", [idc], {
// idUint: uintc,
//})
##idstatec = classDefx(defmain, "IdState", [idstrc, midc], {
 idState: classc 
})
##idlocalc = curryDefx(defmain, "IdLocal", idstatec)
##idparentc = curryDefx(defmain, "IdParent", idstatec)
##idglobalc = curryDefx(defmain, "IdGlobal", idstatec)

##idclassc = classDefx(defmain, "IdClass", [idstrc], {
 idVal: cptc
})
##aliasc = classDefx(defmain, "Alias")

aliasDefx = &(scope Cptx, key Str, class Cptx)Cptx{
 #x = classDefx(scope, key, [aliasc, class])
 @return x
}
aliasGetx = &(c Cptx)Cptx{
 @if(c.arr == _){
  log(strx(c))
  die("wrong cpt")
 }
 @if(len(c.arr) > 1){
  @if(c.arr[0].id == aliasc.id){  
   @return aliasGetx(c.arr[1])
  }
 }
 @return c
}

/////11 def op
//for op
##opc = classDefx(defmain, "Op", [funcc], {
 opPrecedence: intc
})
##op1c = classDefx(defmain, "Op1", [opc])
##op2c = classDefx(defmain, "Op2", [opc])
//https://en.cppreference.com/w/c/language/operator_precedence
//remove unused
##opgetc = curryDefx(defmain, "OpGet", op2c, {
 opPrecedence: intNewx(0)
})
##opnotc = curryDefx(defmain, "OpNot", op1c, {
 opPrecedence: intNewx(10)
})
//##opdefinedc = curryDefx(defmain, "OpDefined", op1c, {
// opPrecedence: intNewx(10)
//})
##opmultiplyc = curryDefx(defmain, "OpMultiply", op2c, {
 opPrecedence: intNewx(20)
})
##opdividec = curryDefx(defmain, "OpDivide", op2c, {
 opPrecedence: intNewx(20)
})
##opmodc = curryDefx(defmain, "OpMod", op2c, {
 opPrecedence: intNewx(20)
})
##opaddc = curryDefx(defmain, "OpAdd", op2c, {
 opPrecedence: intNewx(30)
})

##opsubtractc = curryDefx(defmain, "OpSubtract", op2c, {
 opPrecedence: intNewx(30)
})
##opgec = curryDefx(defmain, "OpGe", op2c, {
 opPrecedence: intNewx(40)
})
##oplec = curryDefx(defmain, "OpLe", op2c, {
 opPrecedence: intNewx(40)
})
##opgtc = curryDefx(defmain, "OpGt", op2c, {
 opPrecedence: intNewx(40)
})
##opltc = curryDefx(defmain, "OpLt", op2c, {
 opPrecedence: intNewx(40)
})
##opeqc = curryDefx(defmain, "OpEq", op2c, {
 opPrecedence: intNewx(50)
})
##opnec = curryDefx(defmain, "OpNe", op2c, {
 opPrecedence: intNewx(50)
})
##opandc = curryDefx(defmain, "OpAnd", op2c, {
 opPrecedence: intNewx(60)
})
##oporc = curryDefx(defmain, "OpOr", op2c, {
 opPrecedence: intNewx(70)
})
##opassignc = curryDefx(defmain, "OpAssign", op2c, {
 opPrecedence: intNewx(80)
})
##opconcatc = curryDefx(defmain, "OpConcat", op2c, {
 opPrecedence: intNewx(80)
})

/////12 def signal
##signalc = classDefx(defmain, "Signal");
##continuec = curryDefx(defmain, "Continue", signalc)
##breakc = curryDefx(defmain, "Break", signalc)
##gotoc = classDefx(defmain, "Goto", [signalc], {
 goto: uintc
})
##returnc = classDefx(defmain, "Return", [signalc], {
 return: cptc
})
##errorc = classDefx(defmain, "Error", [signalc], {
 errorCode: uintc
 errorMsg: strc
})
/////13 def ctrl
##ctrlc = classDefx(defmain, "Ctrl")
##ctrlargc = classDefx(defmain, "CtrlArg", [ctrlc], {
 ctrlArg: cptc 
})
##ctrlargsc = classDefx(defmain, "CtrlArgs", [ctrlc], {
 ctrlArgs: arrc
})
##ctrlifc = curryDefx(defmain, "CtrlIf", ctrlargsc)
##ctrlforc = curryDefx(defmain, "CtrlFor", ctrlargsc)
##ctrleachc = curryDefx(defmain, "CtrlEach", ctrlargsc)
##ctrlforeachc = curryDefx(defmain, "CtrlForeach", ctrlargsc)
##ctrlwhilec = curryDefx(defmain, "CtrlWhile", ctrlargsc)
##ctrlbreakc = curryDefx(defmain, "CtrlBreak", ctrlc)
##ctrlcontinuec = curryDefx(defmain, "CtrlContinue", ctrlc)
##ctrlgotoc = curryDefx(defmain, "CtrlGoto", ctrlargc)

##ctrlreturnc = curryDefx(defmain, "CtrlReturn", ctrlargc)
##ctrlerrorc = curryDefx(defmain, "CtrlError", ctrlargsc)

/////14 def  env
##envc = classDefx(defmain, "Env", _, {
 envStack: arrc
 envLocal: objc
 
 envExec: classc 
 envBlock: blockmainc
 envActive: boolc
})


/////15 func newfunc

Funcx = => Func{
 funcVars: arrNewx(arrstrc, [strNewx("o"), strNewx("env")])
 o: objNewx(arrc)
 env: objNewx(envc)
}
valfuncNewx = &(f Funcx)Cptx{
 @return &Cptx{
  type: @T("VALFUNC")
  id: uidx()    
  val: f
 } 
}


funcNewx = &(val Funcx, argtypes Arrx, return Cptx)Cptx{
 @if(return == _){
  return = emptyreturnc
 }
 Arrx#arr = @Arrx{}
 @foreach v argtypes{
  push(arr, defx(v))
 }
 #fp = fpDefx(arr, return)
 @if(val != _){
  Cptx#x = classNewx([fp, funcnativec])
  x.dic["funcNative"] = valfuncNewx(val)  
 }@else{
  #x = classNewx([fp])
 }
 @return objNewx(x)
}

funcDefx = &(scope Cptx, name Str, val Funcx, argtypes Arrx, return Cptx)Cptx{
//FuncNative new
 #fn = funcNewx(val, arrOrx(argtypes), return)
 routex(fn, scope, name);
 @return fn
}
methodDefx = &(class Cptx, name Str, val Funcx, argtypes Arrx, return Cptx)Cptx{//FuncNative new
 @if(argtypes != _){
  unshift(argtypes, class)
 }@else{
  argtypes = [class]
 }
 #fn = funcNewx(val, argtypes, return)
 fn.fprop = @Boolean(1)
 class.dic[name] = fn;
 fn.name = class.name + "_" + name
 fn.str = name
 @return fn
}
funcSetOpx = &(func Cptx, op Cptx){
 push(func.obj.arr, op)
}
opDefx = &(class Cptx, name Str, val Funcx, arg Cptx, return Cptx, op Cptx)Cptx{
 #argt = @Arrx{}
 @if(arg != _){
  push(argt, arg)
 }
 #func = methodDefx(class, name, val, argt, return)
 funcSetOpx(func, op)
 @return func;
}

/////16 common utils
arrCopyx = &(o Arrx)Arrx{
 @if(o == _){ @return }
 #n = @Arrx{}
 @foreach e o{
  push(n, e)
 }
 @return n;
}
dicCopyx = &(o Dicx)Dicx{
 @if(o == _){ @return }
 #n = @Dicx{}
 @each k v o{
  n[k] = v
 }
 @return n
}
/////17 oop func
classRawx = &(t T)Cptx{
 @if(t == @T("CPT")){
  @return cptc
 }@elif(t == @T("OBJ")){
  @return objc
 }@elif(t == @T("CLASS")){
  @return classc
 }@elif(t == @T("NULL")){
  @return nullc
 }@elif(t == @T("INT")){
  @return intc
 }@elif(t == @T("FLOAT")){
  @return floatc  
 }@elif(t == @T("NUMBIG")){
  @return numbigc
 }@elif(t == @T("STR")){
  @return strc
 }@elif(t == @T("DIC")){
  @return dicc
 }@elif(t == @T("ARR")){
  @return arrc
 }@elif(t == @T("VALFUNC")){
  @return valfuncc
 }@else{
  die("NOTYPE")
 }
 @return _
}
typex = &(o Cptx)Str{
 @return ""
}
classx = &(o Cptx)Cptx{
 @if(o.type == @T("CLASS")){
  @return o
 }
 @if(o.obj != _){
  @return o.obj
 }
 @return classRawx(o.type)
}
inClassx = &(c Cptx, t Cptx, cache Dic)Boolean{
 @if(c.type != @T("CLASS")){
  log(strx(c))
  die("inClass: left not class")
 }
 @if(t.type != @T("CLASS")){
  log(strx(t))
  die("inClass: right not class")
 }
 @if(t.id == cptc.id){//everything is cpt
  @return @Boolean(1)
 }
 @if(t.id == objc.id && c.ctype == @T("OBJ")){
  @return @Boolean(1)
 }
 @if(c.id != "" && c.id == t.id){
  @return @Boolean(1)
 }
 @if(!cache){
  cache = {}
 }
 @foreach v c.arr{
  @if(cache[v.id] != _){
   @continue
  }
  cache[v.id] = 1
  @if(inClassx(v, t, cache)){
   @return @Boolean(1)
  }
 }
 @return @Boolean(0) 
}
defaultx = &(t Cptx)Cptx{
 @if(t.ctype == @T("INT")){
  #tar = zerointv
 }@elif(t.ctype == @T("FLOAT")){
  #tar = zerofloatv   
 }@elif(t.ctype == @T("NUMBIG")){   
 }@elif(t.ctype == @T("STR")){
  #tar = zerostrv    
 }@else{
  #tar = nullv
 }
 @return tar
}

defx = &(class Cptx, dic Dicx)Cptx{
 @if(class.ctype == @T("CPT")){
  @return cptv
 }@elif(class.ctype == @T("OBJ")){
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
   @if(len(dic) != 0){
    r.fdefault = @Boolean(0)
   }
  }@else{
   Cptx#r = objNewx(class)
  }
  @if(midc != _){
   @if(inClassx(class, midc)){//TODO speed up
    r.fmid = @Boolean(1)
   }
  }
  @return r
 }@elif(class.ctype == @T("CLASS")){
  @return cptc
 }@elif(class.ctype == @T("NULL")){
  @return nullv
 }@elif(class.ctype == @T("INT")){
  Cptx#x = intNewx(0)
  @if(class.name != "Int"){
   x.obj = class
  }
 }@elif(class.ctype == @T("FLOAT")){
  Cptx#x = floatNewx(0.0)
  @if(class.name != "Float"){
   x.obj = class
  }
 }@elif(class.ctype == @T("NUMBIG")){
  Cptx#x = nullv//TODO
 }@elif(class.ctype == @T("STR")){
  Cptx#x = strNewx("")
  @if(class.name != "Str"){
   x.obj = class
  }
 }@elif(class.ctype == @T("VALFUNC")){
  Cptx#x = valfuncNewx()
 }@elif(class.ctype == @T("DIC")){
  #x = dicNewx(class)
  x.fdefault = @Boolean(1)  
 }@elif(class.ctype == @T("ARR")){
  #x = arrNewx(class)
  x.fdefault = @Boolean(1)    
 }@else{
  die("unknown class type")
  @return
 }
// @if(dic != _ && dic["val"] != _){
//  x.val = dic["val"].val
// }
 @return x
}
copyx = &(o Cptx)Cptx{
 @if(o.type == @T("CPT")){
  @return o
 }
 @if(o.type == @T("NULL")){
  @return o
 }
 @if(o.type == @T("CLASS")){
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
eqx = &(l Cptx, r Cptx)Boolean{
 @if(l.type != r.type){
  @return @Boolean(0)
 }
 #t = l.type
 @if(t == @T("CPT")){
  @return @Boolean(1)
 }@elif(t == @T("NULL")){
  @return @Boolean(1)  
 }@elif(t == @T("OBJ")){
  @return l.id == r.id  
 }@elif(t == @T("CLASS")){
  @return l.id == r.id
 }@elif(t == @T("DIC")){
  @return l.id == r.id
 }@elif(t == @T("ARR")){
  @return l.id == r.id
 }@elif(t == @T("VALFUNC")){
  @return l.id == r.id  
 }@elif(t == @T("INT")){
  @return l.int == r.int
 }@elif(t == @T("FLOAT")){
  @return Float(l.val) == Float(r.val)
 }@elif(t == @T("NUMBIG")){
  @return @Boolean(1) //TODO
 }@elif(t == @T("STR")){
  @return l.str == r.str
 }@else{
  log(t)
  die("wrong type")
  @return @Boolean(0)
 } 
}


getParentx = &(o Cptx, key Str)Cptx{
 @if(o.arr == _){
  @return _
 }
 @foreach v o.arr{
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
objGetLocalx = &(o Cptx, key Str)Cptx{
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
getx = &(o Cptx, key Str)Cptx{
 @if(o.type == @T("CLASS")){
  #r = classGetx(o, key)
  @if(r != _){
   @return r
  }
  r = classGetx(classc, key) 
  @if(r != _){
   @return r
  }
 }@elif(o.type == @T("OBJ")){
  #r = o.dic[key] //getlocal1
  @if(r != _){
   @return r
  }
  /*
  @if(o.arr != _){ //getparent
   @foreach v o.arr{
    Cptx#r = getx(v, key)
    @if(r != _){
     @return r
    }
   }
  }
  */
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
setx = &(o Cptx, key Str, val Cptx)Cptx{
 //TODO objSet
 @return val
}

typepredx = &(o Cptx)Cptx{
 #t = o.type
 @if(t == @T("OBJ")){
  @if(o.fmid){
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
    @if(f.id == defmain.dic["numConvert"].id){
     Cptx#arg1 = args.arr[1]
     @return arg1
    }
    @if(f.id == defmain.dic["type"].id){
     Cptx#arg0 = args.arr[0]
     @return arg0
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
//      @if(arg1.str == "farg"){
  //     log(strx(arg0))
    //   log(strx(at0))
      // die("typepred: cannot pred obj get, key is "+arg1.str)
      //}
      @return _;      
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
dic2strx = &(d Dicx, i Int)Str{
 #s = "{\n"
 @each k v d{
  s+=indx(k + ":" + strx(v, i+1))+"\n"
 }
 @return s + "}"
}
arr2strx = &(a Arrx, i Int)Str{
 #s = "["
 @if(len(a) > 1){
  s+="\n"
  @foreach v a{
   s+=indx(strx(v, i+1))+"\n"
  }
 }@else{
  @foreach v a{
   s += strx(v, i+1)
  }
 }
 @return s + "]"
}
parent2strx = &(d Arrx)Str{
 #s = ""
 @foreach v d{
  @if(v.name != ""){
   s+= v.name + " "
  }@else{
   s+= "~" + v.id + " "  
  }
 }
 @return s
}
strx = &(o Cptx, i Int)Str{
 @if(i > 3 && o.id != ""){
  @return "~"+o.id
 }
 T#t = o.type
 @if(t == @T("CPT")){
  @return "&Cpt"
 }@elif(t == @T("OBJ")){
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
 }@elif(t == @T("CLASS")){
  Str#s = "" 
  @if(o.name != ""){
   #s += o.name + " = "
  }@else{
   #s += "~"+o.id + " = "  
  }
  s+="@class "+ parent2strx(o.arr)+" "+dic2strx(o.dic, i)  
  @return s
 }@elif(t == @T("NULL")){
  @return "_"
 }@elif(t == @T("INT")){
  @return str(o.int)
 }@elif(t == @T("FLOAT")){
  @return str(Float(o.val))
 }@elif(t == @T("STR")){
  @return '"'+ escapex(o.str) + '"'
 }@elif(t == @T("VALFUNC")){
  @return "&ValFunc"
 }@elif(t == @T("DIC")){
  @return dic2strx(o.dic, i)
 }@elif(t == @T("ARR")){
  @return arr2strx(o.arr, i)
 }@else{
  log(o.obj)
  log(o)
  die("cpt2str unknown")
  @return ""
 }
}
/////18 func exec
##execns = nsNewx("exec")
##execmain = scopeNewx(execns, "main")
##tplmain = classNewx([defmain])
tplCallx = &(func Cptx, args Arrx, env Cptx)Cptx{
// log(func.dic["funcTplPath"].str)
// log(arr2strx(args)) 
 @if(func.val == _){//use val as cache
  Str#sstr = func.dic["funcTpl"].str
  @if(sstr == ""){
   @return strNewx("")
  }@else{
   Astx#ast = jsonParse(cmd("./slt-reader", sstr))
   @if(len(ast) == 0){
    die("tplCall: grammar error" + getx(func, "funcTplPath").str)
   }
   func.val = ast;
  }
 }@else{
  ast = Astx(func.val)
 }
 
 #localx = classNewx()
 localx.dic["$env"] = env
 localx.dic["$this"] = func
 @each i v args{
  localx.dic[str(i)] = v;
 }
 
 Cptx#b = ast2cptx(ast, tplmain, localx)


 #nstate = objNewx(localx)
 nstate.int = 2
 Arrx#stack = env.dic["envStack"].arr;
 #ostate = env.dic["envLocal"]
 push(stack, ostate)
 env.dic["envLocal"]  = nstate
 blockExecx(b, env)
 env.dic["envLocal"] = stack[len(stack)-1]
 pop(stack)

/*
 #local = objNewx(localx) 
 #nenv = defx(envc, {
  envLocal: local
  envStack: arrNewx(arrc, @Arrx{})
  envExec: execmain
  envBlock: b
  envActive: truev
 })
 blockExecx(b, nenv) //short for execx(&BlockMain, nenv)
 */ 
 @return nstate.dic["$str"]
}
callx = &(func Cptx, args Arrx, env Cptx)Cptx{
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
  nstate.int = 2
  Arrx#stack = env.dic["envStack"].arr;
  #ostate = env.dic["envLocal"]
  push(stack, ostate)
  env.dic["envLocal"]  = nstate
  Arrx#vars = func.dic["funcVars"].arr
  @each i arg args{
   nstate.dic[vars[i].str] = arg   
  }
  Cptx#r = blockExecx(block, env)
  env.dic["envLocal"] = stack[len(stack)-1]
  pop(stack)

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
classExecGetx = &(c Cptx, execsp Cptx, cache Dic)Cptx{
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
  @foreach v c.arr{
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
execGetx = &(c Cptx, execsp Cptx)Cptx{
 @if(c.type == @T("CLASS")){
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
  @if(c.type == @T("OBJ")){
   Cptx#exect = classExecGetx(objc, execsp, {});
   @if(exect != _){
    @return exect;
   }
  }
 }
 //Cpt no need
 @return _
}
blockExecx = &(o Cptx, env Cptx, stt Uint)Cptx{
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
preExecx = &(o Cptx)Cptx{
//TODO pre exec 1+1 =2 like
//pre exec idClass.idVal
 @if(inClassx(classx(o), idclassc)){
  @return o.dic["idVal"]
 }
 @return o
}
execx = &(o Cptx, env Cptx, flag Int)Cptx{
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

/////19 func parse
checkid = &(id Str, local Cptx, func Cptx)Cptx{
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
id2cptx = &(id Str, def Cptx, local Cptx, func Cptx)Cptx{
 #r = getx(local, id)
 @if(r != _){
  #r = local.dic[id]
  @if(r != _){
   @return defx(idlocalc, {
    idStr: strNewx(id),
    idState: local
   })
  }@else{
   @if(func != _){ //null if func tpl
    funcSetClosurex(func)   
   }
   #p = getParentx(local, id)
   @if(p == _){
    log(strx(local))   
    log(id)
    die("no parent")
   }
   @return defx(idparentc, {
    idStr: strNewx(id),
    idState: p
   })  
  }
 }
 #r = classGetx(def, id)
 @if(r != _){
  @if(r.name == ""){
   @return defx(idglobalc, {
    idStr: strNewx(id),
    idState: def
   })   
  }@else{
   @return defx(idclassc, {
    idStr: strNewx(id),
    idVal: r
   })
  }
 }
 @return _
}
env2cptx = &(ast Astx, def Cptx, local Cptx)Cptx{
 #v = Astx(ast[2])
 Cptx#b = ast2cptx(v, def, local)
 #execsp = nsGetx(execns, Str(ast[1]));
 @if(execsp == _){
  die("no execsp")
 }
 #x = defx(envc, {
  envLocal: scopeObjNewx(b.dic["blockStateDef"])
  envStack: arrNewx(arrc, @Arrx{}) 
  envExec: execsp
  envBlock: b
  envActive: falsev    
 })
 @return x
}
subFunc2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx, isproto Int)Cptx{
 #v = Astx(ast[1])
 #funcVars = @Arrx{}
 #funcVarTypes = @Arrx{}
 #nlocal = classNewx([local])
 @if(v[0] != _){ //method
  #class = classGetx(def, Str(v[0]))
  push(funcVars, strNewx("$self"))
  Cptx#x = defx(class)
  x.farg = @Boolean(1)
  push(funcVarTypes, x)
  nlocal.dic["$self"] = x
 }
 #args = Astx(v[1])
 @foreach arg args{
  #argdef = Astx(arg)
  #varid = Str(argdef[0])
  push(funcVars, strNewx(varid))
  @if(argdef[2] != _){//defined default arg val TOTEST
   Cptx#varval = ast2cptx(Astx(argdef[2]), def, local, func)
  }@elif(argdef[1] != _){
   #t = classGetx(def, Str(argdef[1]))
   @if(t == _){
    die("func2cptx: arg type not defined "+Str(argdef[1]))
   }
   #varval = defx(t)
  }@else{
   #varval = cptv
  }
  @if(!varval.fstatic){
   varval.farg = @Boolean(1)
  }
  push(funcVarTypes, varval)
  nlocal.dic[varid] = varval
 }
 @if(len(v) > 2 && v[2] != _){
  #ret = classGetx(def, Str(v[2]))
  @if(ret == _){
   log(v[2])
   die("return not defined")
  }
 }@else{
  #ret = emptyreturnc
 }
 #fp = fpDefx(funcVarTypes, ret)
 @if(isproto > 0){
  @return fp
 }
 #cx = classNewx([fp, funcblockc])
 Cptx#x = objNewx(cx);
 x.dic["funcVars"] = arrNewx(arrstrc, funcVars)
 x.val = nlocal
 @return x
}
func2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx, name Str, pre Int)Cptx{
 //CLASS ARGDEF RETURN BLOCK AFTERBLOCK
 //TODO func name should not contain $
 @if(pre != 0 && name == ""){
  die("def must have name");
 }

 @if(name != ""){
  Cptx#x = def.dic[name]
  @if(x == _){
   #x = subFunc2cptx(ast, def, local, func)
   routex(x, def, name)
  }
 }@else{
  #x = subFunc2cptx(ast, def, local, func)
 }
 @if(pre != 0){
  @return x
 }
 #v = Astx(ast[1]) 
 x.dic["funcBlock"] = ast2blockx(Astx(v[3]), def, Cptx(x.val), x);
 @if(v[4] != _){
  die("TODO alterblock")
 }
 @return x;
}
class2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx, name Str, pre Int)Cptx{
//'class' parents schema
 @if(pre == 1 || pre == 0){
  #parents = Astx(ast[1])
  Arrx#arr = @Arrx{}
  @foreach e parents{
   #s = Str(e)
   #r = classGetx(def, s)
   @if(r == _){
    die("class2obj: no class "+s)
   }
   push(arr, r)
  }
  #x = classNewx(arr)
  routex(x, def, name) 
 }
 @if(pre == 2 || pre == 0){ 
  #x = def.dic[name]
  Cptx#schema = ast2dicx(Astx(ast[2]), def, local, func);
  #c = Str(ast[0])
  @if(c == "classx"){
   @each k v schema.dic{
    x.dic[k] = v
   }
  }@else{
  //TODO free schema
   @each k v schema.dic{
    x.dic[k] = defx(v)
   }
  }
 }
 @return x
}

blockmain2cptx = &(ast Astx, def Cptx, local Cptx, name Str)Cptx{
 #scopename = Str(ast[2])
 @if(scopename != ""){
  #d = classNewx([nsGetx(defns, scopename)])
  #l = classNewx()
 }@else{
  @if(local == _){
   die("no local for blockmain")
  }
  #d = def
  #l = local
 }
 #v = Astx(ast[1])
 @if(d.obj == _){
  objNewx(d)//preassign global
 }
 preAst2blockx(v, d, l); 
 Cptx#b = ast2blockx(v, d, l);
 b.obj = blockmainc
 blockmainc.obj = b
 @if(len(ast) == 4){
  b.dic["blockPath"] = strNewx(Str(ast[3]))
 }
 @if(name != ""){
  routex(b, def, name)
 } 
 @return b
}
tpl2cptx = &(ast Astx, def Cptx, local Cptx, name Str)Cptx{
 @if(name == ""){
  die("tpl no name")
 }
 #x = defx(functplc, {
  funcTpl: strNewx(Str(ast[1]))   
 })
 @if(len(ast) == 3){
  x.dic["funcTplPath"] = strNewx(Str(ast[2]))
 }
 routex(x, def, name)
 @return x   
}
enum2cptx = &(ast Astx, def Cptx, local Cptx, name Str)Cptx{
 @if(name == ""){
  die("enum no name")
 }
 #a = @Arrx{}
 #d = @Dicx{} 
 #c = curryDefx(def, name, enumc, {
  enum: arrNewx(arrstrc, a)
  enumDic: dicNewx(dicuintc, d)
 })
 
 #arr = Astx(ast[1])
 @each i v arr{
  push(a, strNewx(Str(v)))
  #ii = intNewx(Int(i))
  ii.obj = c;
  c.obj = ii
  d[Str(v)] = ii
 }
 @return c
}
obj2cptx =  &(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #c = classGetx(def, Str(ast[1]))
 @if(c == _){
   die("obj2obj: no class "+Str(ast[1])) 
 }
 Cptx#schema = ast2dicx(Astx(ast[2]), def, local, func);
 @if(schema.fmid){
  #x = defx(callc, {
   callFunc: defmain.dic["new"]
   callArgs: arrNewx(arrc, [c, schema])
  })
 }@else{
  #x = defx(c, schema.dic)
 }
 @return x 
}
op2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #op = Str(ast[1])
// Str#cname = "Op"+ucfirst(op)
 
 #args = Astx(ast[2])
 Cptx#arg0 = ast2cptx(Astx(args[0]), def, local, func)
 #t0 = typepredx(arg0)

 @if(t0 == _){
  t0 = cptc
 }
 #f = getx(t0, op);
 @if(f == _ || f.id == nullv.id){
  log(strx(arg0)) 
  log(strx(t0))
  die("Op not find "+op)
 }
 @if(len(args) == 1){
  //TODO not
  @if(op == "not"){
   @if(!inClassx(t0, boolc)){    
    @return defx(callc, {
     callFunc: getx(t0, "eq")
     callArgs: arrNewx(arrc, [arg0, defaultx(t0)])
    })
   }
  }
  
  @return defx(callc, {
   callFunc: f
   callArgs: arrNewx(arrc, [arg0])
  })
 }@else{
  Cptx#arg1 = ast2cptx(Astx(args[1]), def, local, func)
  //TODO convert arg1
  @return defx(callc, {
   callFunc: f
   callArgs: arrNewx(arrc, [arg0, arg1])
  })  
 }
 @return _
}

itemsget2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx, v Cptx)Cptx{
 Cptx#items = ast2cptx(Astx(ast[1]), def, local, func)
 #itemstc = typepredx(items)
 @if(itemstc == _){
  log(strx(items))
  die("don't known dic or arr")
 }
 Cptx#key = ast2cptx(Astx(ast[2]), def, local, func) 
 @if(v == _){
  #getf = getx(itemstc, "get")
  @if(getf == _){
   log(strx(items))
   log(strx(itemstc))  
   die("no getf")
  }
  @return defx(callc, {
   callFunc: getf
   callArgs: arrNewx(arrc, [items, key])
  })
 }
 #setf = getx(itemstc, "set")
  //TODO check/convert v type
 @if(setf == _){
  die("no setf")
 }  
 #lefto = defx(callc, {
  callFunc: setf
  callArgs:  arrNewx(arrc, [items, key, v])
 })
  
 #predt = typepredx(v)  
  
 @if(inClassx(classx(items), idstatec)){//a[1] = 1->change Arr#a to Arr_Int#a
  Cptx#s = items.dic["idState"]
  Str#str = items.dic["idStr"].str
  Cptx#itemst = s.dic[str]
  Cptx#itemstt = itemst.obj
  @if(itemst.farg){
   @return lefto
  }
  #it = getx(itemst, "itemsType")
  @if(predt != _ && predt.id != cptc.id){ 
   @if(it.id == cptv.id){
//    @if(itemstt.name != "Dic" && itemstt.name != "Arr"){
//     die("error, itemsType defined but name not changed "+itemst.obj.name)
 //   }
    itemst.obj = itemDefx(itemstt, predt)
    @if(itemst.val != _){
     //cached init right expr a = {}/[]
     #oo = Cptx(itemst.val)
     convertx(itemstt, itemst.obj, oo)
    }
   }@elif(!inClassx(predt, classx(it))){
    die("TODO convert items assign: "+predt.name + " is not "+classx(it).name);
   }
  }
 }
 @return lefto
}
return2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx, v Cptx)Cptx{
 @if(func == _){
  log(ast)
  die("return outside func")
 }
 #ret = getx(func, "funcReturn")
 @if(len(ast) > 1){
  Cptx#arg = ast2cptx(Astx(ast[1]), def, local, func)
  @if(ret.id == emptyreturnc.id){
   die("func "+func.name+" should not return value")
  }
 }@else{
  @if(ret.id == emptyreturnc.id){
   Cptx#arg = emptyreturnv
  }@else{
   Cptx#arg = nullv  
  }
 }
 @return defx(ctrlreturnc, @Dicx{
  ctrlArg: arg
 })
}
objget2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx, v Cptx)Cptx{
 Cptx#obj = ast2cptx(Astx(ast[1]), def, local, func)
 @if(obj.type == @T("OBJ")){
  @if(v == _){
   @return defx(callc, {
    callFunc: defmain.dic["get"]
    callArgs: arrNewx(arrc, [obj, strNewx(Str(ast[2]))])
   })
  }@else{
   @return defx(callc, {
    callFunc: defmain.dic["set"]
    callArgs: arrNewx(arrc, [obj, strNewx(Str(ast[2])), v])
   })  
  }
 }@else{
 //TODO objget for other type
  @return
 }
}
if2cptx =  &(ast Astx, def Cptx, local Cptx, func Cptx, block Cptx)Cptx{
 #v = Astx(ast[1])
 Cptx#a = ast2arrx(v, def, local, func)
 Arrx#args = a.arr;
 Int#l = len(args)
 @for Int#i=0;i<l-1;i+=2{
  #t = typepredx(args[i])
  @if(t == _){
   log(strx(args[i]))
   die("if: typepred error")
  }
  @if(!inClassx(t, boolc)){
   args[i] = defx(callc, {
    callFunc: getx(t, "ne")
    callArgs: arrNewx(arrc, [args[i], defaultx(t)])
   })
  }
  Cptx#d = args[i+1]
  d.dic["blockParent"] = block
 }
 @if(l%2 == 1){
  Cptx#d = args[l-1]
  d.dic["blockParent"] = block
 }
 
 @return defx(ctrlifc, {ctrlArgs: a})
}
each2cptx =  &(ast Astx, def Cptx, local Cptx, func Cptx, block Cptx)Cptx{
 #v = Astx(ast[1])
 #key = Str(v[0])
 #val = Str(v[1])
 Cptx#expr = ast2cptx(Astx(v[2]), def, local, func)
 #et = typepredx(expr)
 @if(et == _){
  die("no type for each")
 }
 @if(key != ""){
  #r = checkid(key, local, func)
  @if(inClassx(et, dicc)){
   @if(r != _){
    @if(classx(r).id != strc.id){
     die("each key id defined "+key)
    }
   }@else{
    local.dic[key] = strNewx("")
   }
  }@elif(inClassx(et, arrc)){
   @if(r != _){
    @if(classx(r).id != uintc.id){
     die("each key id defined "+key)
    }
   }@else{
    local.dic[key] = uintNewx(0)
   }
  }@else{
   log(strx(et))
   die("TODO: items other than dic or arr")
  }
 }
 @if(val != ""){
  #it = getx(et, "itemsType")
  #r = checkid(val, local, func)
  @if(it == _){
   it = cptv;
  }
  @if(r != _){
   @if(classx(r).id != classx(it).id){
    log(classx(r).name)
    log(classx(it).name)    
    die("each val id defined "+val)
   }
  }@else{
   local.dic[val] = it
  }  
 }
 Cptx#bl = ast2blockx(Astx(v[3]), def, local, func)
 bl.dic["blockParent"] = block
 @return defx(ctrleachc, {
  ctrlArgs: arrNewx(arrc, [
   strNewx(key)
   strNewx(val)
   expr
   bl
  ])
 })
}
for2cptx =  &(ast Astx, def Cptx, local Cptx, func Cptx, block Cptx)Cptx{
 #v = Astx(ast[1])
 @if(v[0] != _){
  Cptx#start = ast2cptx(Astx(v[0]), def, local, func)
 }@else{
  #start = nullv
 }
 Cptx#check = ast2cptx(Astx(v[1]), def, local, func)
 #t = typepredx(check)
 @if(!inClassx(t, boolc)){
  check = defx(callc, {
   callFunc: getx(t, "ne")
   callArgs: arrNewx(arrc, [check, defaultx(t)])
  })
 }
 
 @if(v[2] != _){ 
  Cptx#inc = ast2cptx(Astx(v[2]), def, local, func)
 }@else{
  #inc = nullv 
 }
 Cptx#bl = ast2blockx(Astx(v[3]), def, local, func)
 
 @return defx(ctrlforc, {
  ctrlArgs: arrNewx(arrc, [
   start
   check
   inc
   bl
  ])
 }) 
 @return 
}
alias2cptx =  &(ast Astx, def Cptx, name Str)Cptx{
 Str#n = Str(ast[1])
 @if(n == "Class" || n== "Obj" || n == "Cpt"){
  die("no alias for this")
 }
 #x = classGetx(def, n)
 @if(x == _){
  die("alias error "+Str(ast[1]));
 }
 @return aliasDefx(def, name, x)
}
itemdef2cptx =  &(ast Astx, def Cptx, name Str)Cptx{
 #x = classGetx(def, Str(ast[1]))
 #it = classGetx(def, Str(ast[2]))
 @if(x == _){
  die("itemdef error, items "+Str(ast[1]));
 }
 @if(it == _){
  die("itemdef error, itemsType "+Str(ast[2]));
 }
 @return aliasDefx(def, name, itemDefx(x, it))
}
funcproto2cptx =  &(ast Astx, def Cptx, local Cptx, func Cptx, name Str)Cptx{
 #x = subFunc2cptx(ast, def, local, func, 1)  
 @return aliasDefx(def, name, x)   
}
def2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx, pre Int)Cptx{
 #id = Str(ast[1])
 #v = Astx(ast[2])
//pre 1 2 3 0 three times
//when 1 -> new class, enum/tpl/blockmain/type
//when 2 -> class specify/func def
//when 0 -> other/func specify
 #c = Str(v[0])
 @if(pre == 1){
  #dfd = def.dic[id]
  @if(dfd != _){
   die("class def twice "+id)
  } 
  @if(c == "enum"){
   @return enum2cptx(v, def, local, id)
  }@elif(c == "tpl"){
   @return tpl2cptx(v, def, local, id)  
  }@elif(c == "blockmain"){
   @return blockmain2cptx(v, def, local, id)
  }@elif(c == "class" || c == "classx"){
   @return class2cptx(v, def, local, func, id, pre)  
  }@elif(c == "alias"){
   @return alias2cptx(v, def, id)
  }@elif(c == "itemdef"){
   @return itemdef2cptx(v, def, id)  
  }@else{
   @return _
  }
 }
 @if(pre == 2){
  @if(c == "class" || c == "classx"){
   @return class2cptx(v, def, local, func, id, pre)
  }@elif(c == "funcproto"){
   @return funcproto2cptx(v, def, local, func, id)       
  }@elif(c == "func"){
   #dfd = def.dic[id]
   @if(dfd != _){
    die("func def twice "+id)
   }   
   @return func2cptx(v, def, local, func, id, pre)  
  }@else{
   @return _
  }
 }
 //pre 0
 @if(c != "func"){
  #dfd = def.dic[id]
  @if(dfd != _){
   @return dfd
  }
 }

 Cptx#r = ast2cptx(v, def, local, func, id)
 @if(r.name == ""){
  #t = typepredx(r)
  @if(t == _){
   log(id)
   log(v)
   die("global var must know type")
  }
  def.dic[id] = defx(t);
  #ip = defx(idglobalc, {
   idStr: strNewx(id),
   idState: def
  })
  @return defx(callrawc, {
   callFunc: classGetx(idglobalc, "assign")
   callArgs: arrNewx(arrc, [ip, r])
  })
 }
 @return r
}
convertx = &(from Cptx, to Cptx, val Cptx)Cptx{
 @if(to.id == from.id){
  @return val
 }
 @if(from.id == cptc.id){
  @return defx(callc, {
   callFunc: defmain.dic["as"]
   callArgs: arrNewx(arrc, [val, to])
  })
 }
 @if(to.ctype != from.ctype){
  @return _ 
 }
 @if(inClassx(classx(val), midc)){
  @if(to.ctype == @T("INT") || to.ctype == @T("FLOAT")){
   @return defx(callc, {
    callFunc: defmain.dic["numConvert"]
    callArgs: arrNewx(arrc, [val, to])
   })
  } 
  @return _
 }
// @if(inClassx(to, from)){//specify eg. Arr to ArrStatic
    //convert val
 val.obj = to
 to.obj = val
 @return val
// }
// @return _
}
assign2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #v = Astx(ast[1])
 #left = Astx(v[0])
 #right = Astx(v[1])
 #leftt = Str(left[0])
 Cptx#righto = ast2cptx(right, def, local, func)
 #predt = typepredx(righto)

 @if(leftt == "objget"){
  Cptx#lefto = objget2cptx(left, def, local, func, righto)
  //TODO check type
  @return lefto
 }
 @if(leftt == "itemsget"){ //expr[1] = 1
  Cptx#lefto = itemsget2cptx(left, def, local, func, righto)
  @return lefto
 }
 
 @if(leftt == "id" && len(v) == 2){// a = 1 to  #a =1
  #name = Str(left[1])
  @if(getx(local, name) == _){
   @if(getx(def.obj, name) == _){
    left[0] = "idlocal"//if assign to id, id is idlocal
   }@else{
    Cptx#lefto = defx(idglobalc, {
     idStr: strNewx(name)
     idState: def
    })
   }
  }
 }
 @if(lefto == _){
  Cptx#lefto = ast2cptx(left, def, local, func)
 }


 @if(inClassx(classx(lefto), idstatec)){ //#a = 1  set a type Int
  Cptx#s = lefto.dic["idState"]
  Str#idstr = lefto.dic["idStr"].str
  #type = s.dic[idstr]
  @if(type == _ || type.id == nullv.id){//only set in not like Str#a
   @if(predt == _){
    s.dic[idstr] = cptv
   }@else{
    s.dic[idstr] = defx(predt)
    #lpredt = predt;
    @if(predt.id == dicc.id || predt.id == arrc.id){
     //a = {}/[];cache init right expr for future a itemsType change
     s.dic[idstr].val = righto
    }
   }
  }
 }

 @if(lpredt == _){
  #lpredt = typepredx(lefto)
 }
 @if(len(v) > 2){// a += 1   -= *= ...
  #op = Str(v[2])
  @if(op == "add"){
   #ff = getx(lpredt, "concat")
   @if(ff != _){
    @return defx(callc, {
     callFunc: ff
     callArgs: arrNewx(arrc, [lefto, righto])
    })  
   }
  }
  #ff = getx(lpredt, op)
  @if(ff == _){
   log("no op "+lpredt.name + " " +op)
  }
  righto = defx(callc, {
   callFunc: ff
   callArgs: arrNewx(arrc, [lefto, righto])   
  })
 }
/*
 @if(predt != _ && lpredt != _){ //for exp: Uint#a = 1
  #cvt = convertx(predt, lpredt, righto)
  @if(cvt != _){
   righto = cvt
  }
 }
*/
 #f = getx(lefto, "assign")
 @return defx(callrawc, {
  callFunc: f
  callArgs: arrNewx(arrc, [lefto, righto])
 })
}
call2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #v = Astx(ast[1])
 Cptx#f = ast2cptx(v, def, local, func)
 @if(classx(f).id == idclassc.id){
  #f = f.dic["idVal"]
 }
 Cptx#arr = ast2arrx(Astx(ast[2]), def, local, func) 
 @if(f.type == @T("CLASS")){
  f = aliasGetx(f)
  @if(len(arr.arr) == 0){
   @return defx(callrawc, {
    callFunc: defmain.dic["type"]
    callArgs: arrNewx(arrc, [f])
   })
  }
  Cptx#a0 = arr.arr[0]
  #t = typepredx(a0)
  @if(t == _){
   log(a0)
   die("convert from type not defined")
  }
  #aa0 = convertx(t, f, a0)
  @if(aa0 != _){
   @return aa0
  }

  @if(f.name == ""){
   die("class with no name")
  }
  #r = getx(t, "to"+f.name)
  @if(r == _){
   log(strx(t))
   log(strx(a0))  
   log(f.name)
   die("convert func not defined")
  }
  @return defx(callc, {
   callFunc: r
   callArgs: arr
  })
 }
 //TODO if f is funcproto check type
 @return defx(callc, {
  callFunc: f
  callArgs: arr
 }) 
}
callreflect2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 @return nullv
}
callmethod2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 Cptx#oo = ast2cptx(Astx(ast[1]), def, local, func)
 Cptx#to = typepredx(oo)
 @if(to == _){
  log(strx(oo))
  die("cannot typepred obj")
 }
 //TODO CLASS get CALL
 Cptx#arr = ast2arrx(Astx(ast[3]), def, local, func)
 #f = getx(to, Str(ast[2]))
 @if(f == _){
  log(strx(oo))
  log(strx(to))
  log(Str(ast[2]))  
  die("no method")
 }
 unshift(arr.arr, oo)
 @return defx(callmethodc, {
  callFunc: f
  callArgs: arr
 })
}
preAst2blockx = &(ast Astx, def Cptx, local Cptx, func Cptx){
 @each i e ast{
  #ee = Astx(e)
  #eee = Astx(ee[0])
  #idpre = Str(eee[0])
  @if(idpre == "def"){
   def2cptx(eee, def, local, func, 1)
  }
 }
 @each i e ast{
  #ee = Astx(e)
  #eee = Astx(ee[0])
  #idpre = Str(eee[0])
  @if(idpre == "def"){
   def2cptx(eee, def, local, func, 2)
  }
 }
}
ast2blockx = &(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #arr = @Arrx{}
 #x = objNewx(blockc)
 #dicl = dicNewx(dicuintc, @Dicx{})
 x.fdefault = @Boolean(0)
 //TODO read def function and breakpoints first
 Int#i = 0;
 @foreach e ast{
  #ee = Astx(e)
  #idpre = Str(Astx(ee[0])[0])
  @if(idpre == "if"){
   Cptx#c = if2cptx(Astx(ee[0]), def, local, func, x)
  }@elif(idpre == "each"){
   Cptx#c = each2cptx(Astx(ee[0]), def, local, func, x)
  }@elif(idpre == "for"){
   Cptx#c = for2cptx(Astx(ee[0]), def, local, func, x) 
  }@else{
   Cptx#c = ast2cptx(Astx(ee[0]), def, local, func)  
  }
  @if(c == _){
   @continue
  }
  push(arr, c)
  @if(len(ee) == 2){
   dicl.dic[Str(ee[1])] = uintNewx(i)
  }
  i++  
 }
 x.dic["blockVal"] = arrNewx(arrc, arr)
 x.dic["blockStateDef"] = local
 x.dic["blockLabels"] = dicl
 
 x.dic["blockScope"] = def
 @return x
}

ast2arrx = &(asts Astx, def Cptx, local Cptx, func Cptx, it Cptx, il Int)Cptx{
 #arrx = @Arrx{}
 #callable = @Boolean(0);
 @foreach e asts{
  Cptx#ee = ast2cptx(Astx(e), def, local, func)
  @if(ee.fmid){
   callable = @Boolean(1);
  }
  @if(it == _){
   it = typepredx(ee)
  }    
  push(arrx, ee)
 }

 @if(!callable){
  @each i v arrx{
   arrx[i] = preExecx(v)
  }
 }
 

 @if(it != _ || callable){
  #c = itemDefx(arrc, it, callable)
  #r = arrNewx(c, arrx)
  @if(callable){
   r.fmid = @Boolean(1)
  }
 }@else{
  #r = arrNewx(arrc, arrx)  
 }
 @if(il != 0){
  r.int = il
 } 
 @return r;
}
ast2dicx = &(asts Astx, def Cptx, local Cptx, func Cptx, it Cptx, il Int)Cptx{
 #dicx = @Dicx{}
 #arrx = @Arrx{} 
 #callable = @Boolean(0);
 @foreach eo asts{
  #e = Astx(eo)
  #k = Str(e[1])
  Cptx#ee = ast2cptx(Astx(e[0]), def, local, func)
  @if(ee.fmid){
   callable = @Boolean(1);
  }
  @if(it == _){
   it = typepredx(ee)
  }
  push(arrx, strNewx(k))
  dicx[k] = ee;
 }
 
 @if(!callable){
  @each k v dicx{
   dicx[k] = preExecx(v)
  }
 }
 
 @if(it != _ || callable){
  #c = itemDefx(dicc, it, callable)
  #r = dicNewx(c, dicx, arrx)
  @if(callable){
   r.fmid = @Boolean(1)
  }
 }@else{
  #r = dicNewx(dicc, dicx, arrx)  
 }
 @if(il != 0){
  r.int = il
 }
 @return r;
}
ast2cptx = &(ast Astx, def Cptx, local Cptx, func Cptx, name Str)Cptx{
 @if(def == _){
  die("no def")
 }
 #t = Str(ast[0])
 @if(t == "env"){
  @return env2cptx(ast, def, local)
 }@elif(t == "enum"){
  @return enum2cptx(ast, def, local, name)
 }@elif(t == "tpl"){
  @return tpl2cptx(ast, def, local, name)
 }@elif(t == "blockmain"){
  @return blockmain2cptx(ast, def, local)
 }@elif(t == "class" || t == "classx"){
  @return class2cptx(ast, def, local, func, name)  
 }@elif(t == "alias"){
  @return alias2cptx(ast, def, name)
 }@elif(t == "itemdef"){
  @return itemdef2cptx(ast, def, name)  
 }@elif(t == "funcproto"){
  @return funcproto2cptx(ast, def, local, func, name)      
 }@elif(t == "block"){
  @return ast2blockx(Astx(ast[1]), def, local, func)
 }@elif(t == "str"){
  @return strNewx(Str(ast[1]))
 }@elif(t == "float"){
  @return floatNewx(float(Str(ast[1])))
 }@elif(t == "int"){
  @return intNewx(int(Str(ast[1])))
 }@elif(t == "null"){
  @return nullv
 }@elif(t == "true"){
  @return truev
 }@elif(t == "false"){
  @return falsev
 }@elif(t == "idlocal"){
  #id = Str(ast[1])

  #val = local.dic[id]
  @if(val == _){
   @if(len(ast) > 2){  
    #type = classGetx(def, Str(ast[2]))
    @if(type == _){
     die("wrong type "+Str(ast[2]))
    }
   }@else{
    #type = nullc
   }
   local.dic[id] = defx(type)   
  }
  @return defx(idlocalc, {
   idStr: strNewx(id),
   idState: local
  })  
 }@elif(t == "id"){
  #id = Str(ast[1])
  #x = id2cptx(id, def, local, func)
  @if(x == _){
   log(local)
   die("id not defined "+ id)
  }
  @return x;
 }@elif(t == "call"){
  @return call2cptx(ast, def, local, func)
 }@elif(t == "callmethod"){
  @return callmethod2cptx(ast, def, local, func)  
 }@elif(t == "callreflect"){
  @return callreflect2cptx(ast, def, local, func)  
 }@elif(t == "assign"){
  @return assign2cptx(ast, def, local, func)  
 }@elif(t == "def"){
  @return def2cptx(ast, def, local, func)   
 }@elif(t == "dic"){
  @if(len(ast) > 2){
   @if(ast[2] != _){
    #it = classGetx(def, Str(ast[2]))
   }
   @if(ast[3] != _){   
    Int#il = int(Str(ast[3]))
   }
  }
  @return ast2dicx(Astx(ast[1]), def, local, func, it, il);
 }@elif(t == "arr"){
  @if(len(ast) > 2){
   @if(ast[2] != _){
    #it = classGetx(def, Str(ast[2]))
   }
   @if(ast[3] != _){   
    Int#il = int(Str(ast[3]))
   }
  } 
  @return ast2arrx(Astx(ast[1]), def, local, func, it, il)  
 }@elif(t == "enumget"){
  #en = classGetx(def, Str(ast[1]))
  @if(en == _){
   log(ast[1])
   die("enum type not defined")
  }
  Dicx#dic = en.dic["enumDic"].dic
  #r = dic[Str(ast[2])]
  @if(r == _){
   log(ast[1])
   log(ast[2])   
   die("enum val not defined")
  }  
  @return r  
 }@elif(t == "func"){
  @return func2cptx(ast, def, local, func, name)  
 }@elif(t == "obj"){
  @return obj2cptx(ast, def, local, func)
 }@elif(t == "op"){
  @return op2cptx(ast, def, local, func)
 }@elif(t == "itemsget"){
  @return itemsget2cptx(ast, def, local, func)
 }@elif(t == "objget"){
  @return objget2cptx(ast, def, local, func)
 }@elif(t == "return"){
  @return return2cptx(ast, def, local, func) 
 }@elif(t == "break"){
  @return objNewx(ctrlbreakc)
 }@elif(t == "continue"){
  @return objNewx(ctrlcontinuec)  
 }@else{
  die("ast2cptx: " + t + " is not defined")
 }
 @return
}
progl2cptx = &(str Str, def Cptx, local Cptx)Cptx{
 Astx#ast = jsonParse(cmd("./sl-reader", str))
 @if(len(ast) == 0){
  die("progl2cpt: wrong grammar")
 }
 #r = ast2cptx(ast, def, local)
 @return r
}
libProgl2cptx = &(str Str, def Cptx, name Str)Cptx{
 Astx#ast = jsonParse(cmd("./sl-reader", name + " := "+str))
 @if(len(ast) == 0){
  die("libProgl2cpt: wrong grammar")
 }
 #r = ast2cptx(ast, def, classNewx())
 @return r
}
/////20 func def
funcDefx(defmain, "env", &(x Arrx, env Cptx)Cptx{
 //test function TODO delete
 @return env
}, _, envc)
funcDefx(defmain, "osCmd", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#p = x[1]
 @return strNewx(cmd(o.str, p.str))
}, [strc, strc], strc)
Cptx##_osArgs = nullv //TODO remove this line
_osArgs = _
funcDefx(defmain, "osArgs", &(x Arrx, env Cptx)Cptx{
 @if(_osArgs == _){
  #x = @Arrx{}
  ArrStr#aa = osArgs()
  @each i v aa{
   @if(i == 0){
    @continue
   }
   push(x, strNewx(v))
  }
  _osArgs = arrNewx(arrstrc, x)
 }
 @return _osArgs
}, _, arrstrc)
funcDefx(defmain, "osEnvGet", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(getenv(o.str))
}, [strc], strc)
funcDefx(defmain, "getArgFlag", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return boolNewx(o.farg)
}, [cptc], boolc)
funcDefx(defmain, "getDefaultFlag", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return boolNewx(o.fdefault)
}, [cptc], boolc)
funcDefx(defmain, "getName", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.name)
}, [cptc], strc)
funcDefx(defmain, "getId", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.id)
}, [cptc], strc)
funcDefx(defmain, "getNote", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.str)
}, [cptc], strc)
funcDefx(defmain, "setIndent", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 _indentx = o.str
 @return nullv
},[strc])

funcDefx(defmain, "methodGet", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#f = x[1]
 @return nullOrx(methodGetx(o, f))
},[classc, funcc], cptc)

funcDefx(defmain, "opp", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#op = x[1]
 Cptx#e = x[2]
 Cptx#ret = execx(o, e, 1)
 @if(ret.type != @T("STR")){
  die("opp: not used in tplCall")
 }
 @if(!inClassx(classx(o), callc)){
  @return ret
 }
 Cptx#f = o.dic["callFunc"]
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
funcDefx(defmain, "new", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return defx(o, e.dic)
},[classc, dicc], cptc)
funcDefx(defmain, "as", &(x Arrx, env Cptx)Cptx{//Cpt to any
 Cptx#o = x[0]
 @return o
},[cptc, classc], cptc)
funcDefx(defmain, "type", &(x Arrx, env Cptx)Cptx{//Cpt to any
 @return nullv
},[cptc], cptc)
funcDefx(defmain, "numConvert", &(x Arrx, env Cptx)Cptx{//int/ convertion
 Cptx#o = x[0]
 Cptx#c = x[0]
 @if(o.type != c.ctype){//int to int
  die("numConvert between float int big")
 }
 o.obj = c
 @return o
},[cptc, classc], cptc)
funcDefx(defmain, "get", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return nullOrx(getx(o, e.str))
},[cptc, strc], cptc)
funcDefx(defmain, "mustGet", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #r = getx(o, e.str)
 @if(r == _){
  die(e.str + " not found!")
 }
 @return r
},[cptc, strc], cptc)
funcDefx(defmain, "set", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 Cptx#v = x[2] 
 #r = setx(o, e.str, v)
 @if(r != _){
  @return r
 }
 o.fdefault = @Boolean(0)
 @return nullv 
},[cptc, strc, cptc], cptc)
funcDefx(defmain, "exec", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return execx(l, r, 1)
}, [cptc, envc], cptc)
funcDefx(defmain, "type", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return strNewx(typex(l))
}, [cptc], strc)
funcDefx(defmain, "inClass", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1]; 
 @return boolNewx(inClassx(l, r))
}, [classc, classc], boolc)
funcDefx(defmain, "class", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return classx(l)
}, [cptc], cptc)
funcDefx(defmain, "typepred", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return nullOrx(typepredx(l))
}, [cptc], classc)
funcDefx(defmain, "isCpt", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == @T("CPT"))
}, [cptc], boolc)
funcDefx(defmain, "isObj", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == @T("OBJ"))
}, [cptc], boolc)
funcDefx(defmain, "isClass", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == @T("CLASS"))
}, [cptc], boolc)
funcDefx(defmain, "isNull", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == @T("NULL"))
}, [cptc], boolc)
funcDefx(defmain, "isInt", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == @T("INT"))
}, [cptc], boolc)
funcDefx(defmain, "isFloat", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == @T("FLOAT"))
}, [cptc], boolc)
funcDefx(defmain, "isNumBig", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == @T("NUMBIG"))
}, [cptc], boolc)
funcDefx(defmain, "isStr", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == @T("STR"))
}, [cptc], boolc)
funcDefx(defmain, "isArr", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == @T("ARR"))
}, [cptc], boolc)
funcDefx(defmain, "isDic", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return boolNewx(l.type == @T("DIC"))
}, [cptc], boolc)
funcDefx(defmain, "uid", &(x Arrx, env Cptx)Cptx{
 @return strNewx(uidx())
}, _, strc)
funcDefx(defmain, "log", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 log(strx(o))
 @return nullv
}, [cptc])
funcDefx(defmain, "die", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 die(o.str)
 @return nullv
}, [strc])
funcDefx(defmain, "print", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 print(o.str)
 @return nullv
}, [strc])
funcDefx(defmain, "appendIfExists", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 Cptx#app = x[1]; 
 @if(o.str == ""){
  @return o
 }
 o.str += app.str
 @return o
}, [strc, strc], strc)
funcDefx(defmain, "ind", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#f = x[1] 
 @return strNewx(indx(o.str, f.int))
}, [strc, intc], strc)
funcDefx(defmain, "call", &(x Arrx, env Cptx)Cptx{
 Cptx#f = x[0];
 Cptx#a = x[1];
 Cptx#e = x[2];
 @if(e.fdefault){
  e = env
 }
 @if(f == _ || f.id == nullv.id){
  log(strx(a))
  die("call() error");
 }
 @if(!inClassx(classx(f), funcc)){
  log(strx(f))
  die("not func")
 }
 @return callx(f, a.arr, e)
}, [funcc, arrc, envc], cptc)
funcDefx(defmain, "tplCall", &(x Arrx, env Cptx)Cptx{
 Cptx#f = x[0];
 Cptx#a = x[1];
 Cptx#e = x[2];
 @if(e.fdefault){
  e = env
 }
 @return tplCallx(f, a.arr, e)
}, [functplc, arrc, envc], cptc)
funcDefx(defmain, "keys", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return copyx(arrNewx(arrstrc, o.arr))
}, [dicc], arrstrc)
##_mapping = @Dicx{} //TODO remove this line
##_mapping = _
readWordMap = &(key Str, dic Dicx){
 
}
funcDefx(defmain, "natlLoadWordMap", &(x Arrx, env Cptx)Cptx{
 @return nullv
}, [strc])
funcDefx(defmain, "natlRead", &(x Arrx, env Cptx)Cptx{
 @if(_mapping == _){
  ##_mapping = @Dicx{}
  readWordMap("main", _mapping)
 }
 @return nullv
}, [strc], cptc)


/////21 method def
//TODO no recursive dirWritex
dirWritex = &(d Str, dic Dicx){
 @each k v dic{
  @if(v.type == @T("STR")){
   fileWrite(d + k, v.str)
   
  }@elif(v.type == @T("DIC")){
   dirWritex(d + k, v.dic)
  }@else{
   log(dic2strx(dic))
   die("wrong dic for dirWrite")
  }
 } 
}
methodDefx(aliasc, "getClass", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return aliasGetx(o)
}, _, classc)

methodDefx(pathc, "exists", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Str#p = o.dic["path"].str
 @return boolNewx(fileExists(p))
}, [strc], boolc)
methodDefx(pathc, "resolve", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Str#p = o.dic["path"].str
 @return strNewx(pathResolve(p))
}, [strc], strc)

methodDefx(filec, "write", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#d = x[1]
 Str#p = o.dic["path"].str
 fileWrite(p, d.str)
 @return nullv
}, [strc])
methodDefx(filec, "readAll", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Str#p = o.dic["path"].str
 @return strNewx(fileRead(p))
}, _, strc)

methodDefx(dirc, "write", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#d = x[1]
 Str#p = o.dic["path"].str
 dirWritex(p, d.dic) 
 @return nullv
}, [dicc])
methodDefx(dirc, "writeFile", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#f = x[1]
 Cptx#s = x[2] 
 fileWrite(o.dic["path"].str + f.str, s.str) 
 @return nullv
}, [strc, strc])
methodDefx(dirc, "makeAll", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#p = x[1]
 #ps = p.str 
 @if(ps == ""){
  #ps = "0777"
 }

 mkdirAll(o.dic["path"].str, ps)
 @return nullv
}, [strc, strc])

methodDefx(objc, "toDic", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #arrx = @Arrx{}
 @foreach k sortKeys(o.dic){
  push(arrx, strNewx(k))
 }
 @return dicNewx(dicc, o.dic, arrx)
}, _, dicc)

methodDefx(classc, "schema", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #arrx = @Arrx{}
 @foreach k sortKeys(o.dic){
  push(arrx, strNewx(k))
 }
 @return dicNewx(dicc, o.dic, arrx)
}, _, dicc)
methodDefx(classc, "parents", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return arrNewx(arrclassc, arrCopyx(o.arr))
}, _, arrc)

methodDefx(intc, "toStr", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(str(o.int))
},[intc], strc)

methodDefx(floatc, "toStr", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(str(Float(o.val)))
},[intc], strc)

methodDefx(strc, "split", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#sep = x[1] 
 ArrStr#xx = o.str.split(sep.str)
 Arrx#y = @Arrx{}
 @foreach v xx{
  push(y, strNewx(v))
 }
 @return arrNewx(arrstrc, y)
},[strc, strc], arrstrc)
methodDefx(strc, "replace", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#fr = x[1]
 Cptx#to = x[2]  
 @return strNewx(o.str.replace(fr.str, to.str))
},[strc, strc], strc)
methodDefx(strc, "toPath", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return objNewx(filec, {
  path: strNewx(pathResolve(o.str))
 })
},_, filec)
methodDefx(strc, "toFile", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return objNewx(filec, {
  path: strNewx(pathResolve(o.str))
 })
},_, filec)
methodDefx(strc, "toDir", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return objNewx(dirc, {
  path: strNewx(pathResolve(o.str) + "/")
 })
},_, dirc)
methodDefx(strc, "toJsonArr", &(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
 //TODO
 @return nullv
},_, jsonarrc)
methodDefx(strc, "toJson", &(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
 //TODO
 @return nullv
},_, jsonc)
methodDefx(strc, "toInt", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return intNewx(int(o.str))
},_, intc)
methodDefx(strc, "toFloat", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return floatNewx(float(o.str))
},_, floatc)
escapex = &(s Str)Str{
 @return s.replace("\\", "\\\\").replace("\n", "\\n").replace("\t", "\\t").replace("\r", "\\r").replace("\"", "\\\"")
}
methodDefx(strc, "escape", &(x Arrx, env Cptx)Cptx{
 Str#s = x[0].str
 @return strNewx(escapex(s))
},[strc], strc)
methodDefx(strc, "isInt", &(x Arrx, env Cptx)Cptx{
 Str#s = x[0].str
 @return boolNewx(s.isInt())
},[strc], boolc)

methodDefx(arrc, "push", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1] 
 push(o.arr, e)
 @return nullv
},[cptc])
methodDefx(arrc, "pop", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 pop(o.arr)
 @return nullv
})
methodDefx(arrc, "unshift", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1] 
 unshift(o.arr, e)
 @return nullv
},[cptc])
methodDefx(arrc, "len", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return intNewx(len(o.arr))
},_, intc)
methodDefx(arrc, "set", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#i = x[1]
 Cptx#v = x[2]
 @if(len(o.arr) <= i.int){
  log(arr2strx(o.arr))
  log(i.int)
  die("arrset: index out of range")
 }
 o.arr[i.int] = v
 o.fdefault = @Boolean(0) 
 @return v
}, [uintc, cptc], cptc)
methodDefx(arrstrc, "sort", &(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
 //TODO
 @return nullv
},_, arrstrc)

methodDefx(arrstrc, "join", &(x Arrx, env Cptx)Cptx{
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

methodDefx(jsonc, "len", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return intNewx(len(o.dic))
},_, intc)


methodDefx(dicc, "len", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return intNewx(len(o.dic))
},_, intc)
methodDefx(dicc, "set", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#i = x[1]
 Cptx#v = x[2]
 @if(o.dic[i.str] == _){
  push(o.arr, i)
 }
 o.dic[i.str] = v
 o.fdefault = @Boolean(0) 
 @return v
}, [strc, cptc], cptc)
methodDefx(dicc, "hasKey", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#i = x[1]
 @if(o.dic[i.str] != _){
  @return truev
 }
 @return falsev
}, [strc], boolc)
appendClassx = &(o Cptx, c Cptx){
 @foreach k sortKeys(c.dic){
  @if(o.dic[k] == _){
   push(o.arr, strNewx(k))
   o.dic[k] = c.dic[k]   
  }
 }
 @foreach v c.arr{
  appendClassx(o, v)
 }
}
methodDefx(dicc, "appendClass", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#c = x[1]
 appendClassx(o, c)
 @return o
}, [classc], dicc)
valuesx = &(o Cptx)Cptx{
 #arr = @Arrx{}
 @foreach k o.arr{
  Cptx#v = o.dic[k.str]
  push(arr, v)
 }
 #it = getx(o, "itemsType");
 @if(it == _){
  #c = arrc
 }@else{
  #c = itemDefx(arrc, classx(it))
 }
 @return arrNewx(c, arr) 
}
methodDefx(dicc, "values", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return valuesx(o)
}, _, arrc)
methodDefx(dicstrc, "values", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return valuesx(o)
}, _, arrstrc)


/////22 op def
opDefx(arrc, "get", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return o.arr[e.int]
},intc, cptc, opgetc)
opDefx(dicc, "get", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #r = o.dic[e.str]
 @return nullOrx(r)
},strc, cptc, opgetc)
opDefx(jsonc, "get", &(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// Cptx#e = x[1]
 //TODO
 @return nullv
},strc, cptc, opgetc)

opDefx(idlocalc, "assign", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];

 #v = execx(r, env)
 Cptx#local = env.dic["envLocal"]
 #str = l.dic["idStr"]
 local.dic[str.str] = v
 @return v
}, cptc, cptc, opassignc)

opDefx(idparentc, "assign", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 #v = execx(r, env)
 Str#k = l.dic["idStr"].str
 Cptx#o = l.dic["idState"].obj
 o.dic[k] = v
 @return v
}, cptc, cptc, opassignc)

opDefx(idglobalc, "assign", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 #v = execx(r, env)
 Str#k = l.dic["idStr"].str
 Cptx#o = l.dic["idState"].obj
 o.dic[k] = v
 @return v
}, cptc, cptc, opassignc)

opDefx(strc, "add", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return strNewx(l.str + r.str)
}, strc, strc, opaddc)
opDefx(strc, "eq", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.str == r.str)
}, strc, boolc, opeqc)
opDefx(strc, "ne", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.str != r.str)
}, strc, boolc, opnec)
opDefx(strc, "concat", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 l.str += r.str
 @return l
}, strc, strc, opconcatc)

opDefx(intc, "add", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int + r.int)
}, intc, intc, opaddc)
opDefx(intc, "subtract", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int - r.int)
}, intc, intc, opsubtractc)
opDefx(intc, "multiply", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int * r.int)
}, intc, intc, opmultiplyc)
opDefx(intc, "divide", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int / r.int)
}, intc, intc, opdividec)
opDefx(intc, "mod", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int % r.int)
}, intc, intc, opmodc)
opDefx(intc, "eq", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int == r.int)
}, intc, boolc, opeqc)
opDefx(intc, "ne", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int != r.int)
}, intc, boolc, opnec)
opDefx(intc, "lt", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int < r.int)
}, intc, boolc, opltc)
opDefx(intc, "gt", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int > r.int)
}, intc, boolc, opgtc)
opDefx(intc, "le", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int <= r.int)
}, intc, boolc, oplec)
opDefx(intc, "ge", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int >= r.int)
}, intc, boolc, opgec)

opDefx(boolc, "and", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int != 0 && r.int != 0)
}, boolc, boolc, opandc)
opDefx(boolc, "or", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int !=0 || r.int != 0)
}, boolc, boolc, oporc)

opDefx(cptc, "add", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @if(l.type != r.type){
  log(strx(l)) 
  die("add: wrong type")
 }
 @if(l.type == @T("INT")){ 
  @return intNewx(l.int + r.int)
 }
 @if(l.type == @T("FLOAT")){ 
  @return floatNewx(Float(l.val) + Float(r.val))
 }
 @if(l.type == @T("STR")){ 
  @return strNewx(l.str + r.str)
 }
 log(strx(l))
 die("cannot add")
 @return nullv
}, cptc, cptc, opaddc)
opDefx(cptc, "not", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @if(l.type != @T("INT")){
  log(strx(l)) 
  die("not wrong type")
 }
 @return boolNewx(l.int == 0)
}, _, boolc, opnotc)
opDefx(cptc, "ne", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(!eqx(l, r))
}, cptc, boolc, opnec)
opDefx(cptc, "eq", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(eqx(l, r))
}, cptc, boolc, opeqc)

/////23 exec def
execDefx = &(name Str, f Funcx)Cptx{
 #fn = funcNewx(f, [cptc], cptc)
 routex(fn, execmain, name);
 @return fn
}
execDefx("Env", &(x Arrx, env Cptx)Cptx{
 Cptx#nenv = x[0]
 _indentx = " "
 Cptx#a = nenv.dic["envActive"]
 @if(a.int == 1){
  @return nenv
 }
 //if not active, start
 nenv.dic["envActive"] = truev
 @return execx(nenv.dic["envBlock"], nenv)
})
execDefx("BlockMain", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #r = blockExecx(o, env);
 //process signal TODO!!!
 @return r; 
})
prepareArgsx = &(args Arrx, f Cptx, env Cptx)Arrx{
 #argsx = @Arrx{}
 @if(!inClassx(classx(f), functplc)){ //fill args
  Arrx#vartypes = getx(f, "funcVarTypes").arr
  @each i argdef vartypes{
   @if(Int(i) < len(args)){
    #t = execx(args[i], env);
   }@else{
    t = copyx(argdef)
   }
   push(argsx, t)
  }
 }@else{
  @foreach arg args{
   push(argsx, execx(arg, env))
  }
 }
 @return argsx
}
execDefx("Call", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#f = execx(c.dic["callFunc"], env)
 Arrx#args = c.dic["callArgs"].arr
 @if(f == _ || f.id == nullv.id){
  log(strx(c))
  die("Call: empty func")
 }
 #argsx = prepareArgsx(args, f, env)
 @return callx(f, argsx, env)
})
execDefx("CallRaw", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["callArgs"].arr
 @return callx(c.dic["callFunc"], args, env)
})
execDefx("Obj", &(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Class", &(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Val", &(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Dic", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @if(inClassx(classx(o), midc)){
  #it = getx(o, "itemsType")
  @if(it == _){
   it = cptv
  } 
  #d = @Dicx{}
  @each k v o.dic{
   d[k] = execx(v, env)
  }
  #c = itemDefx(dicc, classx(it))
  @return dicNewx(c, d, arrCopyx(o.arr))
 }
 @return o
})
execDefx("Arr", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @if(inClassx(classx(o), midc)){
  #it = getx(o, "itemsType")
  @if(it == _){
   it = cptv
  } 
  #a = @Arrx{}
  @each i v o.arr{
   push(a, execx(v, env))
  }
  #c = itemDefx(arrc, classx(it))
  @return arrNewx(c, a)
 }
 @return o
})

execDefx("CtrlReturn", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 #f = execx(c.dic["ctrlArg"], env)
 @return defx(returnc, {
  return: f
 })
})
execDefx("CtrlBreak", &(x Arrx, env Cptx)Cptx{
 @return objNewx(breakc)
})
execDefx("CtrlContinue", &(x Arrx, env Cptx)Cptx{
 @return objNewx(continuec)
})
ifcheckx = &(r Cptx)Boolean{
 @if(r.type == @T("INT")){
  @return r.int != 0
 }
 @return r.type != @T("NULL")
}
execDefx("CtrlIf", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["ctrlArgs"].arr
 Int#l = len(args)
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
execDefx("CtrlFor", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["ctrlArgs"].arr
 execx(args[0], env)
 @while(1){
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
execDefx("CtrlEach", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["ctrlArgs"].arr
 Cptx#da = execx(args[2], env)
 Str#key = args[0].str
 Str#val = args[1].str
 Dicx#local =  env.dic["envLocal"].dic
 @if(da.type == @T("DIC")){
  @foreach kc da.arr{
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
 }@elif(da.type == @T("ARR")){
  @each i v da.arr{
   @if(key != ""){
    local[key] = uintNewx(Int(i))
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
 }@elif(da.type == @T("NULL")){
  @return nullv
 }@else{
  log(strx(da))
  log(da.type)
  log(classx(da).ctype)    
  die("CtrlEach: type not defined");
 }
 @return nullv
})
execDefx("IdClass", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 @return getx(c, "idVal")
})
execDefx("IdLocal", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#l = env.dic["envLocal"]
 Str#k = c.dic["idStr"].str
 #r = getx(l, k)
 @if(r == _){
  @return nullv
 }
 @return r;
})
execDefx("IdState", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Str#k = c.dic["idStr"].str
 Cptx#o = c.dic["idState"].obj
 #r = o.dic[k]
 @if(r == _){
  @return nullv
 }
 @return r;
})

/////24 main func
Str#fc = fileRead(osArgs()[1])
Str#execsp = "main"
Str#defsp = "main"
@if(len(osArgs()) > 2){
 #execsp = osArgs()[2] 
}
@if(len(osArgs()) > 3){
 #defsp = osArgs()[3] 
}
#main = progl2cptx("@env "+execsp+" | " + defsp + " {"+fc+"}'"+osArgs()[1]+"'", defmain)
execx(main.dic["envBlock"], main)