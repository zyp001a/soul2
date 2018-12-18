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
  
  "NS", "SCOPE"
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
 
 name: Str
 id: Str
 scope: Cptx 

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
 #x = &Cptx{
  type: @T("NS") 
  dic: @Dicx{}
  id: uidx()    
  name: name  
 }
 root[name] = x 
 @return x;
}
scopeNewx = &(ns Cptx, name Str, arr Arrx)Cptx{
 #x = &Cptx{
  type: @T("SCOPE")
  scope: ns
  arr: arrOrx(arr)
  dic: @Dicx{}
  id: uidx()  
  name: name
 }
 x.dic["."] = x
 x.dic[".."] = ns
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
  o.arr = @Arrx{}
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
routex = &(o Cptx, scope Cptx, name Str){
 #dic = scope.dic;
 dic[name] = o 
 o.name = name;
 o.scope = scope
}
##defns = nsNewx("def")
##defmain = scopeNewx(defns, "main")

##cptc = classNewx();
routex(cptc, defmain, "Cpt");
cptc.ctype = @T("CPT")
##cptv = &Cptx{
 type: @T("CPT")
 fdefault: @Boolean(1)
}


##objc = classNewx();
routex(objc, defmain, "Obj");
objc.ctype = @T("OBJ")

##classc = classNewx();
routex(classc, defmain, "Class");
classc.ctype = @T("CLASS")

##scopec = classNewx()
routex(scopec, defmain, "Scope")
scopec.ctype = @T("SCOPE")

##nsc = classNewx()
routex(nsc, defmain, "Ns")
nsc.ctype = @T("NS")

/////4 def new func
objNewx = &(class Cptx, dic Dicx)Cptx{
 #x = &Cptx{
  type: @T("OBJ")
  fdefault: @Boolean(1)
  id: uidx()
  dic: dicOrx(dic)
  obj: class
 }
 @return x;
}
classDefx = &(scope Cptx, name Str, parents Arrx, schema Dicx)Cptx{
 #x = classNewx(parents)
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
nsGetx = &(ns Cptx, key Str)Cptx{
 #s = ns.dic[key];
 @if(s != _){
  @return s;
 }
 #s = scopeNewx(ns, key)
 Str#f = getenv("HOME")+"/soul2/db/"+ns.name+"/"+key+".slp"
 @if(fileExists(f)){
  Str#fc = fileRead(f)
  ArrStr#arr = fc.split(" ")
  @foreach v arr{
   push(s.arr, nsGetx(ns, v))
  }
 }
 @return s;
}
dbGetx = &(scope Cptx, key Str)Str{
 Str#f = pathResolve(getenv("HOME")+"/soul2/db/"+scope.scope.name+"/"+scope.name + "/" + key + ".sl")
 @if(fileExists(f)){
  @return fileRead(f)
 }
 @if(fileExists(f+"t")){
  @return "@`"+fileRead(f+"t")+"` '"+f+"t'";
 } 
 @return ""
}
scopeGetx = &(scope Cptx, key Str, cache Dic)Cptx{
 #r = scope.dic[key]
 @if(r != _){
  @return r
 }
 @if(!cache){
  cache = {}
 }

 #sstr = dbGetx(scope, key);
 @if(sstr != ""){
  sstr = key+" = "+sstr;
  r = progl2cptx(sstr, scope, classNewx(), classNewx())
  @return r;
 }

 @foreach v scope.arr {
  Str#k = v.id
  @if(cache[k] != _){ @continue };
  cache[k] = 1;
  r = scopeGetx(v, key, cache)
  @if(r != _){
   @return r;
  }
 }
 @return _
}
methodGetSubx = &(scope Cptx, v Cptx, key Str)Cptx{
 #r = scopeGetx(scope, v.name + "_" + key);
 @if(r != _){
  @return r
 }
 @foreach vv v.arr{
  r = methodGetSubx(scope, vv, key)
  @if(r != _){
   @return r
  }
 }
 @return r
}
methodGetx = &(scope Cptx, func Cptx)Cptx{
 Cptx#r = scopeGetx(scope, func.name);
 @if(r != _){
  @return r  
 }
 Arrx#arr = func.dic["funcVarTypes"].arr;
 @if(len(arr) < 0){
  @return _
 }
 Arrx#p = classx(arr[0]).arr
 @foreach v p{
  r = methodGetSubx(scope, v, func.str)
  @if(r != _){
   @return r
  }
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
}
##falsev = &Cptx{
 type: @T("INT")
 obj: boolc
 int: 0
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
##arrstaticc = curryDefx(defmain, "ArrStatic", arrc)

##midc = classDefx(defmain, "Mid", [objc])
itemDefx = &(class Cptx, type Cptx, mid Boolean)Cptx{
 @if(type != _ && type.id != cptc.id){
  Str#n = class.name+"_"+type.name
  Cptx#r = scopeGetx(defmain, n)
  @if(r == _){
   #r = classDefx(defmain, n, [class], {itemsType: type})  
  }
 }@else{
  r = class
 }
 @if(mid){
  Str#n = r.name+"_Mid"
  Cptx#r2 = scopeGetx(defmain, n)
  @if(r2 == _){
   #r = classDefx(defmain, n, [r, midc])
  }@else{
   r = r2
  }
 }
 @return r;
}
itemDefx(arrc, bytec)
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
 @if(class == _){
  class = dicc;
 }
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


##enumc = classDefx(defmain, "Enum", [valc], {
 enum: arrc
})
##bufferc = classDefx(defmain, "Buffer", [valc])
##pointerc = classDefx(defmain, "Pointer", [valc])

##pathc = classDefx(defmain, "Path", [objc], {
 path: strc
})
##filec = classDefx(defmain, "File", [pathc])
##dirc = classDefx(defmain, "Dir", [pathc])

/////9 def var/block/func
##arrstrc = itemDefx(arrc, strc)
##dicstrc = itemDefx(dicc, strc)
##dicuintc = itemDefx(dicc, uintc)
##dicclassc = itemDefx(dicc, classc)
##arrclassc = itemDefx(arrc, classc)

##funcc = classDefx(defmain, "Func", [objc])
##funcprotoc = classDefx(defmain, "FuncProto", [funcc], {
 funcVars: arrstrc
 funcVarTypes: arrc
 funcReturn: classc
})

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
 
 blockScope: scopec, 
 blockPath: strc 
})

blockc.dic["blockParent"] = defx(blockc)

##blockmainc = curryDefx(defmain, "BlockMain", blockc)

//stack
##funcblockc = classDefx(defmain, "FuncBlock", [funcprotoc], {
 funcBlock: blockc
})
##functplc = classDefx(defmain, "FuncTpl", [funcprotoc], {
 funcTpl: strc
 funcTplPath: strc
})

/////10 def mid

##callc = classDefx(defmain, "Call", [midc], {
 callFunc: funcc
 callArgs: arrc
})

##callrawc = curryDefx(defmain, "CallRaw", callc)

##callmethodc = curryDefx(defmain, "CallMethod", callc)
##callreflectc = curryDefx(defmain, "CallReflect", callc)


##idc = classDefx(defmain, "Id", [midc])
##idstrc =  classDefx(defmain, "IdStr", [idc], {
 idStr: strc,
})
//##iduintc =  classDefx(defmain, "IdUintc", [idc], {
// idUint: uintc,
//})
##idstatec = classDefx(defmain, "IdState", [idstrc], {
 idState: classc 
})
##idlocalc = curryDefx(defmain, "IdLocal", idstatec)
##idparentc = curryDefx(defmain, "IdParent", idstatec)
##idglobalc = curryDefx(defmain, "IdGlobal", idstatec)
##idscopec = classDefx(defmain, "IdScope", [idstrc], {
 idVal: cptc
})

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
##signalc = classDefx(defmain, "Signal", [objc]);
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
##ctrlc = classDefx(defmain, "Ctrl", [objc])
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
##envc = classDefx(defmain, "Env", [objc], {
 envExec: scopec
// envDef: scopec
 envStack: arrc
 envLocal: objc 
 envGlobal: objc
})
##execc = classDefx(defmain, "Exec", [objc], {
 execBlock: blockc
 execLocal: classc
 execScope: scopec
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
 @if(val == _){
  #c = funcprotoc
 }@else{
  #c = funcnativec
 }
 #x = objNewx(c)
 #funcVars = arrNewx(arrstrc)
 #funcVarTypes = arrNewx(arrc)
 @each i v argtypes{
  push(funcVars.arr, strNewx("$arg"+str(i)))
  push(funcVarTypes.arr, defx(v))
 }
 x.dic["funcVars"] = funcVars
 x.dic["funcVarTypes"] = funcVarTypes
 @if(return != _){
  x.dic["funcReturn"] = return
 }
 @if(val != _){
  x.dic["funcNative"] = valfuncNewx(val)
 }
 @return x
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
 class.dic[name] = fn;
 fn.name = class.name + "_" + name
 fn.str = name
 @return fn
}
funcSetOpx = &(func Cptx, op Cptx)Cptx{
 Str#n = func.obj.name + "_" + op.name
 Cptx#r = scopeGetx(defmain, n)
 @if(r == _){
  r = classDefx(defmain, n, [func.obj, op])
 }
 func.obj = r;
 @return r
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
 }@elif(t == @T("NS")){
  @return nsc
 }@elif(t == @T("SCOPE")){
  @return scopec
 }@else{
  log(t)
  die("wrong type")
  @return
 }
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
  log(cpt2strx(c))
  die("inClass: left not class")
 }
 @if(t.type != @T("CLASS")){
  log(cpt2strx(t))
  die("inClass: right not class")
 }
 @if(t.id == cptc.id){//everything is cpt
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
inx = &(c Cptx, t Cptx)Boolean{
 @if(t.type == @T("CPT")){
  @return @Boolean(1)
 }
 @if(t.type == @T("OBJ") && c.type == @T("OBJ")){
  @return @Boolean(1)
 }
 @if(c.type != t.type){
  @return @Boolean(0)
 }
 @if(c.obj != _){
  Boolean#r = inClassx(classx(c), classx(t))
  @if(!r){
   @return @Boolean(0)
  }
 }
 @return @Boolean(1)
}
defx = &(class Cptx, dic Dicx)Cptx{
 @if(class.ctype == @T("CPT")){
  @return cptv
 }@elif(class.ctype == @T("OBJ")){
  //TODO
  @if(dic != _){
  //TODO assign value 
   @each k v dic{
    Cptx#t = classGetx(class, k)
    @if(t == _){
     die("defx: not in "+ class.name + " "+k)
    }
    @if(v == _){
     log(k)
     die("defx: dic val null")     
    }
    @if(!inx(v, t)){
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
   r.fdefault = @Boolean(0)
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
 }@elif(class.ctype == @T("FLOAT")){
  Cptx#x = floatNewx(0.0)
 }@elif(class.ctype == @T("NUMBIG")){
  Cptx#x = nullv//TODO
 }@elif(class.ctype == @T("STR")){
  Cptx#x = strNewx("")
 }@elif(class.ctype == @T("VALFUNC")){
  Cptx#x = valfuncNewx()
 }@elif(class.ctype == @T("DIC")){
  @return dicNewx(class)
 }@elif(class.ctype == @T("ARR")){
  @return arrNewx(class)
 }@elif(class.ctype == @T("NS")){
  @return &Cptx{
   type: @T("NS") 
   dic: @Dicx{}
   str: ""
   fdefault: @Boolean(1)
  }
 }@elif(class.ctype == @T("SCOPE")){
  @return &Cptx{
   type: @T("SCOPE")
   arr: @Arrx{}
   dic: @Dicx{}
   str: ""
   fdefault: @Boolean(1)   
  }
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

  name: o.name
  id: uidx()
  scope: o.scope
  
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
 }@elif(t == @T("OBJ")){
  @return l.id == r.id  
 }@elif(t == @T("CLASS")){
  @return l.id == r.id
 }@elif(t == @T("NULL")){
  @return @Boolean(1)
 }@elif(t == @T("INT")){
  @return l.int == r.int
 }@elif(t == @T("FLOAT")){
  @return Float(l.val) == Float(r.val)
 }@elif(t == @T("NUMBIG")){
  @return @Boolean(1) //TODO
 }@elif(t == @T("STR")){
  @return l.str == r.str
 }@elif(t == @T("DIC")){
  @return l.id == r.id
 }@elif(t == @T("ARR")){
  @return l.id == r.id
 }@elif(t == @T("VALFUNC")){
  @return l.id == r.id
 }@elif(t == @T("NS")){
  @return l.id == r.id
 }@elif(t == @T("SCOPE")){
  @return l.id == r.id
 }@else{
  log(t)
  die("wrong type")
  @return @Boolean(0)
 } 
}


classGetx = &(class Cptx, key Str)Cptx{
 #x = class.dic[key]
 @if(x != _){
  @return x
 }
 //TODO read file, use val as cache
 
 @foreach v class.arr{
  #x = classGetx(v, key)
  @if(x != _){
   @return x
  }  
 }
 @return _
}

objGetParentx = &(o Cptx, key Str)Cptx{
 @if(o.arr != _){
  @foreach v o.arr{
   Cptx#r = getx(v, key)
   @if(r != _){
    @return v
   }
  }
 }
 @return _;
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
  #r = o.dic[key]
  @if(r != _){
   @return r
  }
  @if(o.arr != _){
   @foreach v o.arr{
    Cptx#r = getx(v, key)
    @if(r != _){
     @return r
    }
   }
  }
  r = classGetx(o.obj, key) 
  @if(r != _){
   @return r
  }  
  r = classGetx(objc, key) 
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
    Cptx#s = o.dic["idState"]
    #r = getx(s, o.dic["idStr"].str)
    @if(r == _){
     log(cpt2strx(s)) 
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
      log(cpt2strx(arg0))
      log(cpt2strx(at0))
      die("obj not defined "+arg1.str)
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
    //TODO if is dynamic funcReturn, like values 
    @return f.dic["funcReturn"]
   }
   //if is idscope
   @if(inClassx(o.obj, idscopec)){
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
  s+=indx(k + ":" + cpt2strx(v, i+1))+"\n"
 }
 @return s + "}"
}
arr2strx = &(a Arrx, i Int)Str{
 #s = "["
 @if(len(a) > 1){
  s+="\n"
  @foreach v a{
   s+=indx(cpt2strx(v, i+1))+"\n"
  }
 }@else{
  @foreach v a{
   s += cpt2strx(v, i+1)
  }
 }
 @return s + "]"
}
parent2strx = &(d Arrx)Str{
 #s = ""
 @foreach v d{
  s+= v.name + " "
 }
 @return s
}
cpt2strx = &(o Cptx, i Int)Str{
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
   s += "&" + dic2strx(o.obj.dic, i)
  }
  @if(!o.fdefault){
   s += dic2strx(o.dic, i)
  }
  @return s
 }@elif(t == @T("CLASS")){
  Str#s = "" 
  @if(o.name != ""){
   #s += o.name + " = "
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
 }@elif(t == @T("SCOPE")){
  Str#s = "@scope " + o.scope.name + "/" + o.name+ " "
  @foreach v o.arr{
   s += v.name + ", "
  }
  @return s
 }@elif(t == @T("NS")){
  @return "@ns " +o.name
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
tplCallx = &(func Cptx, args Arrx, env Cptx)Cptx{
 @if(func.val == _){//use val as cache
  Str#sstr = func.dic["funcTpl"].str
  Astx#ast = jsonParse(cmd("./slt-reader", sstr))
  @if(len(ast) == 0){
   die("tplCall: grammar error" + getx(func, "funcTplPath").str)
  }
  func.val = ast;
 }@else{
  ast = Astx(func.val)
 }
 #localx = classNewx()
 localx.dic["$env"] = env
 localx.dic["$this"] = func
 @each i v args{
  localx.dic[str(i)] = v;
 }
 
 Cptx#globalp = env.dic["envGlobal"]
 #global = getx(globalp, "$tplglobal")
 @if(global == _){
  log(cpt2strx(globalp))
  die("run in place with no $tplglobal");
 }
 Cptx#b = ast2cptx(ast, defmain, localx, global.obj)

 #local = objNewx(localx) 
 #nenv = defx(envc, {
  envLocal: local
  envGlobal: global
  envStack: arrNewx(arrc, @Arrx{})
  envExec: execmain
 })
 Cptx#r = blockExecx(b, nenv)
 @return r
}
callx = &(func Cptx, args Arrx, env Cptx)Cptx{
 @if(func == _ || func.obj == _){
  log(arr2strx(args))
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
  Arrx#stack = env.dic["envStack"].arr;
  #ostate = env.dic["envLocal"]
  @if(!nstate.arr){
   nstate.arr = [ostate]
  }
  push(stack, ostate)
  env.dic["envLocal"]  = nstate
  Arrx#vars = func.dic["funcVars"].arr
  @each i arg args{
   nstate.dic[vars[i].str] = arg   
  }
  Cptx#r = blockExecx(func.dic["funcBlock"], env)
  env.dic["envLocal"] = stack[len(stack)-1]
  pop(stack)

  @if(r != _ && inClassx(classx(r), signalc)){
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
 log(func.obj)
 die("callx: unknown func")
 @return nullv;
}
classExecGetx = &(c Cptx, execsp Cptx, cache Dic)Cptx{
 #r = execsp.dic[c.id]
 @if(r != _){
  @return r;
 }
 @if(c.name != ""){
  #t = c.name
  #x = execsp.dic[t]
  @if(x != _){
   @return x
  }
  #exect = scopeGetx(execsp, t)
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
 Cptx#t = classx(c)
 Cptx#exect = classExecGetx(t, execsp, {});
 @if(exect != _){
  @return exect;
 }
 @if(c.type == @T("OBJ") || c.type == @T("CLASS")){
  Cptx#t = classRawx(c.type)
  Cptx#exect = classExecGetx(t, execsp, {});
  @if(exect != _){
   @return exect;
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
  @if(r != _ && inClassx(classx(r), signalc)){
   @if(r.obj.id == returnc.id){
    @return r.dic["return"];
   }
   @return r
  }
 }
 @return nullv
}
preExecx = &(o Cptx, env Cptx)Cptx{
//TODO pre exec 1+1 =2 like
// @if(inClassx(classx(o), idscopec)){
//  @return o.dic["idVal"]
// }
 @return o
}
execx = &(o Cptx, env Cptx)Cptx{
 #ex = execGetx(o, env.dic["envExec"])
 @if(!ex){
  log(cpt2strx(o))
  die("exec: unknown type "+classx(o).name);
 }
 @return callx(ex, [o], env);
}

/////19 func parse
checkid = &(id Str, local Cptx, global Cptx)Cptx{
 #r = getx(local, id)
 @if(r != _){
  #r2 = objGetParentx(local, id)
  @if(r2 != _){
   die("checkid: "+id + " used in parent block");
  }
  @return r
 }
 #r = getx(global, id)
 @if(r != _){
  @return r
 }
 @return _
}
id2cptx = &(id Str, def Cptx, local Cptx, global Cptx)Cptx{
 #r = getx(local, id)
 @if(r != _){
  #r = objGetParentx(local, id)
  @if(r == _){
   @return defx(idlocalc, {
    idStr: strNewx(id),
    idState: local
   })
  }@else{
   @return defx(idparentc, {
    idStr: strNewx(id),
    idState: r
   })  
  }
 }
 @if(getx(global, id) != _){
  @return defx(idglobalc, {
   idStr: strNewx(id),
   idState: global
  })
 }
 #r = scopeGetx(def, id)
 @if(r != _){
  @return defx(idscopec, {
   idStr: strNewx(id),
   idVal: r
  })
 }
 @return _
}
exec2cptx = &(ast Astx, def Cptx, local Cptx, global Cptx)Cptx{
 #v = Astx(ast[2])
 #l = classNewx()
 Cptx#b = ast2cptx(v, def, l, global)
 @if(!inClassx(b.obj, blockc)){
  b = preExecx(b);
 }
 #x = defx(execc, {
  execBlock: b
  execLocal: l
 })
 #execsp = nsGetx(execns, Str(ast[1]));
 //TODO get 
 //TODO check exist
 @if(execsp == _){
  die("no execsp")
 }
 x.dic["execScope"] = execsp
 @return x
}
blockmain2cptx = &(ast Astx, def Cptx, local Cptx, global Cptx)Cptx{
 #scopename = Str(ast[2])
 @if(scopename != ""){
  #d = nsGetx(defns, scopename)
  #l = classNewx()  
 }@else{
  #d = def
  #l = local
 }
 #v = Astx(ast[1])
 Cptx#b = ast2blockx(v, d, l, global);
 b.obj = blockmainc
 @if(len(ast) == 4){
  b.dic["blockPath"] = strNewx(Str(ast[3]))
 }
 @return b
}
func2cptx = &(ast Astx, def Cptx, local Cptx, global Cptx, name Str)Cptx{
 //CLASS ARGDEF RETURN BLOCK AFTERBLOCK
 #v = Astx(ast[1])
 #funcVars = @Arrx{}
 #funcVarTypes = @Arrx{}
 #nlocal = classNewx([local])
 @if(v[0] != _){
  #class = scopeGetx(def, Str(v[0]))
  push(funcVars, strNewx("$self"))
  #x = defx(class)  
  push(funcVarTypes, x)
  nlocal.dic["$self"] = x
 }
 #args = Astx(v[1])
 @foreach arg args{
  #argdef = Astx(arg)
  #varid = Str(argdef[0])
  push(funcVars, strNewx(varid))
  @if(argdef[2] != _){//defined default arg val
   Cptx#varval = ast2cptx(Astx(argdef[2]), def, local, global)
  }@elif(argdef[1] != _){
   #t = scopeGetx(def, Str(argdef[1]))
   @if(t == _){
    die("func2cptx: arg type not defined "+Str(argdef[1]))
   }
   #varval = defx(t)
  }@else{
   #varval = defx(objc)
  }
  push(funcVarTypes, varval)
  nlocal.dic[varid] = varval
 }
 @if(v[3] != _){
  Cptx#b = ast2blockx(Astx(v[3]), def, nlocal, global);  
  #x = defx(funcblockc, {
   funcVars: arrNewx(arrstrc, funcVars)
   funcVarTypes: arrNewx(arrc, funcVarTypes)
   funcBlock: b
  })  
  @if(v[4] != _){
   die("TODO alterblock")
  }
 }@else{
  #x = defx(funcprotoc, {
   funcVars: arrNewx(arrstrc, funcVars)
   funcVarTypes: arrNewx(arrc, funcVarTypes)
  }) 
 }
 @if(len(v) > 2 && v[2] != _){
  x.dic["funcReturn"] = scopeGetx(def, Str(v[2]))
 } 
 @if(name != ""){
  routex(x, def, name)
 }
 @return x;
}
class2cptx = &(ast Astx, def Cptx, local Cptx, global Cptx, name Str)Cptx{
//'class' parents schema
 #parents = Astx(ast[1])
 #arr = @Arrx{}
 @foreach e parents{
  #s = Str(e)
  #r = scopeGetx(def, s)
  @if(r == _){
   die("class2obj: no class "+s)
  }
  push(arr, r)
 }
 Cptx#schema = ast2dicx(Astx(ast[2]), def, local, global);
 #x = classNewx(arr)
 @each k v schema.dic{
  x.dic[k] = v
 } 
 @if(name != ""){
  routex(x, def, name)
 }
 @return x
}
obj2cptx =  &(ast Astx, def Cptx, local Cptx, global Cptx, name Str)Cptx{
 #c = scopeGetx(def, Str(ast[1]))
 @if(c == _){
   die("obj2obj: no class "+Str(ast[1])) 
 }
 Cptx#schema = ast2dicx(Astx(ast[2]), def, local, global);
 @if(schema.fmid){
 //TOTEST
  #x = defx(callc, {
   callFunc: defmain.dic["new"]
   callArgs: arrNewx(arrc, [c, schema])
  })
 }@else{
  #x = defx(c, schema.dic)
 }
 @if(name != ""){
  routex(x, def, name)
 }
 @return x 
}
op2cptx = &(ast Astx, def Cptx, local Cptx, global Cptx)Cptx{
 #op = Str(ast[1])
// Str#cname = "Op"+ucfirst(op)
 
 #args = Astx(ast[2])
 Cptx#arg0 = ast2cptx(Astx(args[0]), def, local, global)
 #t0 = typepredx(arg0)

 @if(t0 == _){
  t0 = cptc
 }
 #f = getx(t0, op);
 @if(f == _){
  log(cpt2strx(arg0)) 
  log(cpt2strx(t0))
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
  Cptx#arg1 = ast2cptx(Astx(args[1]), def, local, global)
  //TODO convert arg1
  @return defx(callc, {
   callFunc: f
   callArgs: arrNewx(arrc, [arg0, arg1])
  })  
 }
 @return _
}

itemsget2cptx =  &(ast Astx, def Cptx, local Cptx, global Cptx, v Cptx)Cptx{
 Cptx#items = ast2cptx(Astx(ast[1]), def, local, global)
 #itemst = typepredx(items)
 Cptx#key = ast2cptx(Astx(ast[2]), def, local, global) 
 @if(v == _){
  #getf = getx(itemst, "get")
  @return defx(callc, {
   callFunc: getf
   callArgs: arrNewx(arrc, [items, key])
  })
 }@else{
  #setf = getx(itemst, "set")
  //TODO check v type
  @return defx(callc, {
   callFunc: setf
   callArgs:  arrNewx(arrc, [items, key, v])
  })
 }

}
objget2cptx =  &(ast Astx, def Cptx, local Cptx, global Cptx, v Cptx)Cptx{
 Cptx#obj = ast2cptx(Astx(ast[1]), def, local, global)
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
if2cptx =  &(ast Astx, def Cptx, local Cptx, global Cptx, block Cptx)Cptx{
 #v = Astx(ast[1])
 Cptx#a = ast2arrx(v, def, local, global)
 Arrx#args = a.arr;
 Int#l = len(args)
 @for Int#i=0;i<l-1;i+=2{
  #t = typepredx(args[i])
  @if(t == _){
   log(cpt2strx(args[i]))
   die("if: typepred error")
  }
  @if(!inClassx(t, boolc)){
   args[i] = defx(callc, {
    callFunc: getx(t, "ne")
    callArgs: arrNewx(arrc, [args[i], defaultx(t)])
   })
   Cptx#d = args[i+1]
   d.dic["blockParent"] = block
  }
 }
 @if(l%2 == 1){
  Cptx#d = args[l-1]
  d.dic["blockParent"] = block
 }
 
 @return defx(ctrlifc, {ctrlArgs: a})
}
each2cptx =  &(ast Astx, def Cptx, local Cptx, global Cptx, block Cptx)Cptx{
 #v = Astx(ast[1])
 #key = Str(v[0])
 #val = Str(v[1])
 Cptx#expr = ast2cptx(Astx(v[2]), def, local, global)
 #et = typepredx(expr)
 @if(et == _){
  die("no type for each")
 }
 @if(key != ""){
  #r = checkid(key, local, global)
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
   log(cpt2strx(et))
   die("TODO: items other than dic or arr")
  }
 }
 @if(val != ""){
  #it = getx(et, "itemsType")
  @if(it == _){
   it = cptv;
  }
  @if(r != _){
   @if(classx(r).id != classx(it).id){
    die("each val id defined "+val)
   }
  }@else{
   local.dic[val] = defx(it)
  }  
 }
 Cptx#bl = ast2blockx(Astx(v[3]), def, local, global)
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
for2cptx =  &(ast Astx, def Cptx, local Cptx, global Cptx, block Cptx)Cptx{
 #v = Astx(ast[1])
 log(v)
 @return 
}
assign2cptx = &(ast Astx, def Cptx, local Cptx, global Cptx)Cptx{
 #v = Astx(ast[1])
 #left = Astx(v[0])
 #right = Astx(v[1])
 #leftt = Str(left[0])
 @if(leftt == "objget"){
  Cptx#lefto = ast2cptx(left, def, local, global)
  Cptx#righto = ast2cptx(right, def, local, global)    
  @return 
 }
 @if(leftt == "itemsget"){
  Cptx#righto = ast2cptx(right, def, local, global) 
  Cptx#lefto = itemsget2cptx(left, def, local, global, righto)
  @return lefto
 }
 @if(leftt == "id" && len(v) == 2){
  #name = Str(left[1])
  @if(getx(local, name) == _ && getx(global, name) == _){
   //is define statement
   //TODO scope ns is not allowed
   @return ast2cptx(right, def, local, global, name)
   //is idparent assign 
  }
  //normal assign
 } 
 Cptx#lefto = ast2cptx(left, def, local, global)
 Cptx#righto = ast2cptx(right, def, local, global)
 //TODO set type

 @if(classx(lefto).id == idlocalc.id){
  Str#idstr = lefto.dic["idStr"].str
  #type = getx(local, idstr)
  @if(type == _){
   #predt = typepredx(righto)   
   @if(predt == _){
    local.dic[idstr] = cptv    
   }@else{
    local.dic[idstr] = defx(predt)
   }
  }
 }
 @if(classx(lefto).id == idglobalc.id){
  Str#idstr = lefto.dic["idStr"].str
  #type = getx(global, idstr)  
  @if(type == _){
   #predt = typepredx(righto)
   @if(predt == _){
    global.dic[idstr] = cptv       
   }@else{
    global.dic[idstr] = defx(predt)
   }
  }
 }
 
 @if(len(v) > 2){
  #op = Str(v[2])
  #lpredt = typepredx(lefto)  
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
  righto = defx(callc, {
   callFunc: ff
   callArgs: arrNewx(arrc, [lefto, righto])   
  })
 } 
 #f = getx(lefto, "assign")
 @return defx(callrawc, {
  callFunc: f
  callArgs: arrNewx(arrc, [lefto, righto])
 })
}
call2cptx = &(ast Astx, def Cptx, local Cptx, global Cptx)Cptx{
 #v = Astx(ast[1])
 Cptx#f = ast2cptx(v, def, local, global)
 @if(classx(f).id == idscopec.id){
  #f = f.dic["idVal"]
 }
 Cptx#arr = ast2arrx(Astx(ast[2]), def, local, global) 
 @if(f.type == @T("CLASS")){
  Cptx#a0 = arr.arr[0]
  #t = typepredx(a0)
  @if(t == _){
   log(a0)
   die("convert from type not defined")
  }
  @if(inClassx(f, t)){
   @if(inClassx(classx(a0), valc)){
    //convert val
    a0.obj = f
    @return a0
   }
  }
  @if(f.name == ""){
   die("class with no name")
  }
  #r = getx(t, "to"+f.name)
  @if(r == _){
   log(cpt2strx(t))
   log(f.name)
   die("convert func not defined")
  }
  @return defx(callc, {
   callFunc: r
   callArgs: arr
  })
 } 
 @return defx(callc, {
  callFunc: f
  callArgs: arr
 }) 
}
callreflect2cptx = &(ast Astx, def Cptx, local Cptx, global Cptx)Cptx{
 @return nullv
}
callmethod2cptx = &(ast Astx, def Cptx, local Cptx, global Cptx)Cptx{
 Cptx#oo = ast2cptx(Astx(ast[1]), def, local, global)
 Cptx#to = typepredx(oo)
 @if(to == _){
  log(cpt2strx(oo))
  die("cannot typepred obj")
 }
 //TODO CLASS get CALL
 Cptx#arr = ast2arrx(Astx(ast[3]), def, local, global)
 #f = getx(to, Str(ast[2]))
 @if(f == _){
  log(cpt2strx(oo))
  log(cpt2strx(to))
  log(Str(ast[2]))  
  die("no method")
 }
 unshift(arr.arr, oo)
 @return defx(callmethodc, {
  callFunc: f
  callArgs: arr
 })
}
ast2blockx = &(ast Astx, def Cptx, local Cptx, global Cptx)Cptx{
 #arr = @Arrx{}
 #x = objNewx(blockc)
 #dicl = dicNewx(dicuintc, @Dicx{})
 x.fdefault = @Boolean(0)
 //TODO read def function and breakpoints first
 @each i e ast{
  #ee = Astx(e)
  #idpre = Str(Astx(ee[0])[0])
  @if(idpre == "if"){
   Cptx#c = if2cptx(Astx(ee[0]), def, local, global, x)
  }@elif(idpre == "each"){
   Cptx#c = each2cptx(Astx(ee[0]), def, local, global, x)
  }@elif(idpre == "for"){
   Cptx#c = for2cptx(Astx(ee[0]), def, local, global, x) 
  }@else{
   Cptx#c = ast2cptx(Astx(ee[0]), def, local, global)  
  }
  push(arr, c)
  @if(len(ee) == 2){
   dicl.dic[Str(ee[1])] = uintNewx(Int(i))
  }
 }
 x.dic["blockVal"] = arrNewx(arrc, arr)
 x.dic["blockStateDef"] = local
 x.dic["blockLabels"] = dicl
 
 x.dic["blockScope"] = def
 @return x
}

ast2arrx = &(asts Astx, def Cptx, local Cptx, global Cptx, it Cptx, il Int)Cptx{
 #arrx = @Arrx{}
 #callable = @Boolean(0);
 @foreach e asts{
  Cptx#ee = ast2cptx(Astx(e), def, local, global)
  @if(ee.fmid){
   callable = @Boolean(1);
  }
  push(arrx, ee)
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
ast2dicx = &(asts Astx, def Cptx, local Cptx, global Cptx, it Cptx, il Int)Cptx{
 #dicx = @Dicx{}
 #arrx = @Arrx{} 
 #callable = @Boolean(0);
 @foreach eo asts{
  #e = Astx(eo)
  #k = Str(e[1])
  Cptx#ee = ast2cptx(Astx(e[0]), def, local, global)
  @if(ee.fmid){
   callable = @Boolean(1);
  }
  push(arrx, strNewx(k))
  dicx[k] = ee;
 }
 /*
 @if(!callable){
  @each k v dicx{
   dicx[k] = preExecx(v)
  }
 }
 */
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
ast2cptx = &(ast Astx, def Cptx, local Cptx, global Cptx, name Str)Cptx{
 @if(def == _){
  die("no def")
 }
 #t = Str(ast[0])
 @if(t == "exec"){
  @return exec2cptx(ast, def, local, global)
 }@elif(t == "block"){
  @return ast2blockx(Astx(ast[1]), def, local, global)
 }@elif(t == "blockmain"){
  @return blockmain2cptx(ast, def, local, global)
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
  //TODO
  #id = Str(ast[1])
  @if(len(ast) > 2){
   #type = scopeGetx(def, Str(ast[2]))
   @if(type == _){
    die("wrong type "+Str(ast[2]))
   }
   #val = getx(local, id)
   @if(val == _){
    local.dic[id] = defx(type)
   }   
  }
  @return defx(idlocalc, {
   idStr: strNewx(id),
   idState: local
  })  
 }@elif(t == "idglobal"){ 
  #id = Str(ast[1])
  @if(len(ast) > 2){   
   #type = scopeGetx(def, Str(ast[2]))
   @if(type == _){
    die("wrong type "+Str(ast[2]))
   }
   #val = getx(local, id)
   @if(val == _){
    global.dic[id] = defx(type)
   }   
  } 
  @return defx(idglobalc, {
   idStr: strNewx(Str(ast[1])),
   idState: global
  })     
 }@elif(t == "id"){
  #id = Str(ast[1])
  #x = id2cptx(id, def, local, global)
  @if(x == _){
   log(local)
   log(global)   
   die("id not defined "+ id)
  }
  @return x;
 }@elif(t == "call"){
  @return call2cptx(ast, def, local, global)
 }@elif(t == "callmethod"){
  @return callmethod2cptx(ast, def, local, global)  
 }@elif(t == "callreflect"){
  @return callreflect2cptx(ast, def, local, global)  
 }@elif(t == "assign"){
  @return assign2cptx(ast, def, local, global)  
 }@elif(t == "func"){
  @return func2cptx(ast, def, local, global, name)
 }@elif(t == "tpl"){
  #x = defx(functplc, {
   funcTpl: strNewx(Str(ast[1]))   
  })
  @if(len(ast) == 3){
   x.dic["funcTplPath"] = strNewx(Str(ast[2]))
  }
  @if(name != ""){
   routex(x, def, name)
  }
  @return x
 }@elif(t == "arr"){
  @if(len(ast) > 2){
   @if(ast[2] != _){
    #it = scopeGetx(def, Str(ast[2]))
   }
   @if(ast[3] != _){   
    Int#il = int(Str(ast[3]))
   }
  } 
  @return ast2arrx(Astx(ast[1]), def, local, global, it, il)
 }@elif(t == "dic"){
  @if(len(ast) > 2){
   @if(ast[2] != _){
    #it = scopeGetx(def, Str(ast[2]))
   }
   @if(ast[3] != _){   
    Int#il = int(Str(ast[3]))
   }
  }
  @return ast2dicx(Astx(ast[1]), def, local, global, it, il);
 }@elif(t == "class"){
  @return class2cptx(ast, def, local, global, name)
 }@elif(t == "obj"){
  @return obj2cptx(ast, def, local, global, name)
 }@elif(t == "op"){
  @return op2cptx(ast, def, local, global)
 }@elif(t == "itemsget"){
  @return itemsget2cptx(ast, def, local, global)
 }@elif(t == "objget"){
  @return objget2cptx(ast, def, local, global)
 }@elif(t == "return"){
  @if(len(ast) > 1){
   Cptx#arg = ast2cptx(Astx(ast[1]), def, local, global)   
  }@else{
   Cptx#arg = nullv
  }
  @return defx(ctrlreturnc, @Dicx{
   ctrlArg: arg
  })
 }@elif(t == "break"){
  @return objNewx(ctrlbreakc)
 }@elif(t == "continue"){
  @return objNewx(ctrlcontinuec)  
 }@else{
  die("ast2cptx: " + t + " is not defined")
 }
 @return
}
progl2cptx = &(str Str, def Cptx, local Cptx, global Cptx)Cptx{
 Astx#ast = jsonParse(cmd("./sl-reader", str))
 @if(len(ast) == 0){
  die("progl2cpt: wrong grammar")
 }
 #r = ast2cptx(ast, def, local, global)
 @return r
}
/////20 func def
funcDefx(defmain, "env", &(x Arrx, env Cptx)Cptx{
 //test function TODO delete
 @return env
}, _, envc)
funcDefx(defmain, "cmdRun", &(x Arrx, env Cptx)Cptx{
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
funcDefx(defmain, "getName", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return strNewx(o.name)
}, [cptc], strc)
funcDefx(defmain, "setIndent", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 _indentx = o.str
 @return nullv
},[strc])
funcDefx(defmain, "scopeGet", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #r = scopeGetx(o, e.str)
 @if(r != _){
  @return r
 }
 @return nullv
},[scopec, strc], cptc)
funcDefx(defmain, "methodGet", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#f = x[1]
 @return nullOrx(methodGetx(o, f))
},[scopec, funcc], cptc)
funcDefx(defmain, "scopeGet", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return nullOrx(scopeGetx(o, e.str))
},[scopec, strc], cptc)
funcDefx(defmain, "opp", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#op = x[1]
 Cptx#e = x[2]
 Cptx#ret = execx(o, e)
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
funcDefx(defmain, "get", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return nullOrx(getx(o, e.str))
},[cptc, strc], cptc)
funcDefx(defmain, "set", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 Cptx#v = x[2] 
 #r = setx(o, e.str, v)
 @if(r != _){
  @return r
 }
 @return nullv 
},[cptc, strc, cptc], cptc)
funcDefx(defmain, "exec", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return execx(l, r)
}, [cptc, envc], cptc)
funcDefx(defmain, "type", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @return strNewx(typex(l))
}, [cptc], strc)
funcDefx(defmain, "in", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1]; 
 @return boolNewx(inx(l, r))
}, [cptc, cptc], boolc)
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
funcDefx(defmain, "log", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0];
 log(cpt2strx(o))
 @return nullv
}, [cptc])
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
// Arrx#argsx = prepareArgsx(a.arr, f, env) 
 @return callx(f, a.arr, e)
}, [funcc, arrc, envc], cptc)
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

methodDefx(strc, "toFile", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return objNewx(filec, {
  path: strNewx(pathResolve(o.str))
 })
},[strc], filec)
methodDefx(strc, "toDir", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return objNewx(dirc, {
  path: strNewx(pathResolve(o.str) + "/")
 })
},[strc], dirc)
escapex = &(s Str)Str{
 @return s.replace("\\", "\\\\").replace("\n", "\\n").replace("\t", "\\t").replace("\r", "\\r").replace("\"", "\\\"")
}
methodDefx(strc, "escape", &(x Arrx, env Cptx)Cptx{
 Str#s = x[0].str
 @return strNewx(escapex(s))//TODO replace 
},[strc], strc)

methodDefx(arrc, "push", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1] 
 push(o.arr, e)
 @return nullv
},[objc])
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
 @return v
}, [uintc, cptc], cptc)

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

methodDefx(dicc, "set", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#i = x[1]
 Cptx#v = x[2]
 @if(o.dic[i.str] == _){
  push(o.arr, i)
 }
 o.dic[i.str] = v 
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
methodDefx(dicc, "keys", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @return copyx(arrNewx(arrstrc, o.arr))
}, _, arrc)
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
},strc, cptc, opgetc)

opDefx(dicc, "get", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #r = o.dic[e.str]
 @if(r == _){ r = nullv}
 @return r
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

idparentAssign = &(local Cptx, key Str, v Cptx){
 Arrx#xx = local.arr
 @foreach x xx{
  Dicx#d = x.dic;
  @if(d[key] != _){
   d[key] = v
   @break
  }
  @if(x.arr != _){
   idparentAssign(x, key, v)
  }
 }
}
opDefx(idparentc, "assign", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 #v = execx(r, env)
 Cptx#local = env.dic["envLocal"]
 #str = l.dic["idStr"]
 idparentAssign(local, str.str, v)
 @return v
}, cptc, cptc, opassignc)

opDefx(idglobalc, "assign", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];  
 #v = execx(r, env)
 Cptx#local = env.dic["envGlobal"]
 #str = l.dic["idStr"]
 local.dic[str.str] = v 
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
opDefx(intc, "multiply", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int * r.int)
}, intc, intc, opaddc)
opDefx(intc, "eq", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int == r.int)
}, intc, boolc, opeqc)
opDefx(intc, "eq", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int != r.int)
}, intc, boolc, opnec)

opDefx(cptc, "not", &(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
// log(cpt2strx(l))
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
execDefx("Exec", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 #global = classNewx()
 #block = c.dic["execBlock"]
 global.dic["$penv"] = env
 global.dic["$blockmain"] = block
 #tplglobal = classNewx()
 tplglobal.dic["$tplglobal"] = objNewx(tplglobal) 
 global.dic["$tplglobal"] = tplglobal.dic["$tplglobal"]
 
 #nenv = defx(envc, {
  envGlobal: objNewx(global)
  envLocal: objNewx(c.dic["execLocal"])
  envStack: arrNewx(arrc, @Arrx{})
  envExec: c.dic["execScope"]
 })
 _indentx = " "
 @return execx(block, nenv)
})
execDefx("BlockMain", &(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 #r = blockExecx(o, env);
 //process signal TODO!!!
 @return r; 
})
prepareArgsx = &(args Arrx, f Cptx, env Cptx)Arrx{
 #argsx = @Arrx{}
 @if(f.dic["funcVarTypes"] != _){
  Arrx#vartypes = f.dic["funcVarTypes"].arr
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
execDefx("CtrlIf", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["ctrlArgs"].arr
 Int#l = len(args)
 @for Int#i=0;i<l-1;i+=2 {
  #r = execx(args[i], env)
  @if(r.int != 0){
   @return blockExecx(args[i+1], env)
  }
 }
 @if(l%2 == 1){
  @return blockExecx(args[l-1], env)
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
   @if(r != _ && inClassx(classx(r), signalc)){
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
   @if(r != _ && inClassx(classx(r), signalc)){
    @if(r.obj.id == breakc.id){
     @break;
    }
    @if(r.obj.id == continuec.id){
     @continue;
    }
    @return r    
   }
  }  
 }@else{
  log(cpt2strx(da))
  die("CtrlEach: type not defined");
 }
 @return nullv
})
execDefx("IdScope", &(x Arrx, env Cptx)Cptx{
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
execDefx("IdParent", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#l = env.dic["envLocal"]
 Str#k = c.dic["idStr"].str
 #r = getx(l, k)
 @if(r == _){
  @return nullv
 }
 @return r;
})
execDefx("IdGlobal", &(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#l = env.dic["envGlobal"]
 Str#k = c.dic["idStr"].str
 #r = getx(l, k)
 @if(r == _){
  @return nullv
 }
 @return r;
})

/////24 main func
#global = classNewx()
#local = classNewx()
Str#fc = fileRead(osArgs()[1])
Str#execsp = "main"
Str#defsp = "main"
@if(len(osArgs()) > 2){
 #execsp = osArgs()[2] 
}
@if(len(osArgs()) > 3){
 #defsp = osArgs()[3] 
}
#main = progl2cptx("@exec "+execsp+" | " + defsp + " {"+fc+"}'"+osArgs()[1]+"'", defmain, local, global)
#env = defx(envc, {
 envGlobal: objNewx(global)
 envLocal: objNewx(local)
 envStack: arrNewx(arrc, @Arrx{})
 envExec: execmain
})
execx(main, env);