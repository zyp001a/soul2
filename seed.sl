/////1 set class/structs
T = =>Enum {
 enum: [
  "OBJ", "CLASS"
  
  "NULL",
  "INT", "FLOAT", "BIG"
  "STR",
  "DIC", "ARR", "VALFUNC"
//  "FUNCP", "FUNCN", "FUNCB", "FUNCT"
//  "CALL"
  "NS", "SCOPE",
  "STATE"
 ]
}
Dicx = => Dic {
 itemsType: Objx
}
Arrx = => Arr {
 itemsType: Objx
}
Objx = <>{
 type: T
 ctype: T  
 mid: Boolean
 
 name: Str
 id: Str
 scope: Objx
 
 parents: Dicx

 obj: Objx
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
/////3 root ...
##root = @Dicx{}
nsNewx = &(name Str)Objx{
 #x = &Objx{
  type: @T("NS") 
  dic: @Dicx{}
  str: name  
 }
 root[name] = x 
 @return x;
}
scopeNewx = &(ns Objx, name Str, arr Arrx)Objx{
 #x = &Objx{
  type: @T("SCOPE")
  arr: arrOrx(arr)
  dic: @Dicx{}
  str: name
 }
 x.dic["."] = x
 x.dic[".."] = ns
 ns.dic[name] = x
 @return x;
}
parentMakex = &(o Objx, parentarr Arrx)Dicx{
 @if parentarr == _ {
  @return
 }
 #x = @Dicx{}
 T#ctype = o.ctype
 @foreach e parentarr{
  //TODO reduce
  @if(e.id == ""){
   die("no id")
  }
  x[e.id] = e;
  @if(e.ctype > ctype){
   ctype = e.ctype
  }
 }
 o.parents = x
 o.ctype = ctype
 @return x
}
classNewx = &(arr Arrx, dic Dicx)Objx{
 #r = &Objx{
  type: @T("CLASS")   
  dic: @Dicx{}
 } 
 r.dic = dicOrx(dic)
 parentMakex(r, arr)
 @return r;
}
routex = &(o Objx, scope Objx, name Str){
 #dic = scope.dic;
 dic[name] = o 
 o.name = name;
 o.id = uidx()
 o.scope = scope
}
##defns = nsNewx("def")
##defmain = scopeNewx(defns, "main")

//class is basic
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
objNewx = &(class Objx)Objx{
 #x = &Objx{
  type: @T("OBJ")
  id: uidx()
  dic: @Dicx{}
  obj: class
 }
 @return x;
}
classDefx = &(scope Objx, name Str, parents Arrx, schema Dicx)Objx{
 #x = classNewx(parents)
 @each k v schema{
  x.dic[k] = objNewx(v)
 }
 routex(x, scope, name)
 @return x
}
curryDefx = &(scope Objx, name Str, class Objx, schema Dicx)Objx{
 #x = classNewx([class], schema)
 routex(x, scope, name)
 @return x
}

/////5 scope func
dbGetx = &(scope Objx, key Str)Str{
 @return ""
}
scopeGetx = &(scope Objx, key Str, cache Dic)Objx{
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
//   r = progl2objx(nscope, {}, sstr)
//   @return r;
  @return _
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


/////6 def val, null
##valc = classDefx(defmain, "Val", _, {
 valDefault: objc
})
##nullv =  &Objx{
 type: @T("NULL")
}
##nullc = curryDefx(defmain, "Null", valc, {
 valDefault: nullv
})
nullc.ctype = @T("NULL")
isnull = &(o Objx)Boolean{
 @return (o.type == @T("NULL"))
}
##zerointv = &Objx{
 type: @T("INT")
 int: 0
}
##zerofloatv = &Objx{
 type: @T("FLOAT")
 val: 0.0
}
##numc = classDefx(defmain, "Num", [valc])
##intc = classDefx(defmain, "Int", [numc], {
 valDefault: zerointv
})
intc.ctype = @T("INT")
##uintc = classDefx(defmain, "Uint", [intc])
##floatc = classDefx(defmain, "Float", [numc], {
 valDefault: zerofloatv
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
numbigc.ctype = @T("BIG")

intNewx = &(x Int)Objx{
 @return &Objx{
  type: @T("INT")
  int: x
 }
}
uintNewx = &(x Int)Objx{
 @return &Objx{
  type: @T("INT")
  obj: uintc
  int: x
 }
}
floatNewx = &(x Num)Objx{
 @return &Objx{
  type: @T("FLOAT")
  val: x
 }
}

/////7 def items 
##itemsc = classDefx(defmain, "Items", [valc], {
 itemsType: classc
})
##itemslimitedc = classDefx(defmain, "ItemsLimited", [itemsc], {
 itemsLimitedLength: uintc
})
##arrc = curryDefx(defmain, "Arr", itemsc)
arrc.ctype = @T("ARR")
##arrstaticc = curryDefx(defmain, "ArrStatic", arrc)
itemDefx = &(class Objx, type Objx)Objx{
 Str#n = class.name+"_"+type.name
 Objx#r = scopeGetx(defmain, n)
 @if(r != _){
  @return r
 }
 #r = classDefx(defmain, n, [class], {itemsType: type})
 @return r
}
itemDefx(arrc, bytec)
##dicc = curryDefx(defmain, "Dic", itemsc)
dicc.ctype = @T("DIC")

arrNewx = &(class Objx, val Arrx)Objx{
 @if(class == _){
  class = arrc;
 }
 #x = &Objx{
  type: @T("ARR")
  obj: class
 }
 @if(val != _){
  x.arr = val
 }@else{
  x.arr = @Arrx{}
 }
 @return x
}
dicNewx = &(class Objx, val Dicx)Objx{
 @if(class == _){
  class = dicc;
 }
 @return &Objx{
  type: @T("DIC")
  obj: class
  dic: dicOrx(val)
 }
}


/////8 advanced type init: string, enum, unlimited number...
##zerostrv = &Objx{
 type: @T("STR")
 str: ""
}
##strc = curryDefx(defmain, "Str", valc, {
 valDefault: zerostrv
})
strc.ctype = @T("STR")

strNewx = &(x Str)Objx{
 @return &Objx{
  type: @T("STR")
  str: x
 }
}


##enumc = classDefx(defmain, "Enum", [valc], {
 enum: arrc
})
##bufferc = classDefx(defmain, "Buffer", [valc])
##pointerc = classDefx(defmain, "Pointer", [valc])

##addrc = classDefx(defmain, "Addr")
##filec = classDefx(defmain, "File", [addrc])

/////9 def var/block/func
##arrstrc = itemDefx(arrc, strc)
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

##statec = classDefx(defmain, "State", _, {
 stateVars: arrstrc
 stateVal: dicc
})
##blockc = classDefx(defmain, "Block", _, {
 blockVal: arrc,
 blockState: statec,
 blockParent: blockc,
 blockScope: scopec, 
 blockLabels: dicuintc,
 blockName: strc 
})
//stack
##arrstatec = itemDefx(arrc, statec)
##funcblockc = classDefx(defmain, "FuncBlock", [funcprotoc], {
 funcBlock: blockc
})
##functplc = classDefx(defmain, "FuncTpl", [funcprotoc], {
 funcTpl: strc
 funcTplName: strc
})
stateNewx = &()Objx{
 #x = &Objx{
  type: @T("STATE")
  dic: @Dicx{}
  arr: @Arrx{}
 }
 @return x
}
/////10 def mid
##midc = classDefx(defmain, "Mid", [objc])

##callc = classDefx(defmain, "Call", [midc], {
 callFunc: funcc
 callArgs: arrc
})
##callmethodc = curryDefx(defmain, "CallMethod", callc)
##callreflectc = curryDefx(defmain, "CallReflect", callc)


##idc = classDefx(defmain, "Id", [midc])
##idstrc =  classDefx(defmain, "IdStr", [idc], {
 idStr: strc,
})
##iduintc =  classDefx(defmain, "IdUintc", [idc], {
 idUint: uintc,
})
##idstatec = classDefx(defmain, "IdState", [idstrc], {
 idState: statec 
})
##idlocalc = curryDefx(defmain, "IdLocal", idstatec)
##idglobalc = curryDefx(defmain, "IdGlobal", idstatec)
##idscopec = classDefx(defmain, "IdScope", [idstrc], {
 idVal: objc
})
##iddicc = classDefx(defmain, "IdDic", [idstrc], {
 idDic: objc
})
##idarrc = classDefx(defmain, "IdArr", [iduintc], {
 idArr: objc
})
##idobjc = classDefx(defmain, "IdObj", [idstrc], {
 idObj: objc
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
//get and assign are not operators in Soul PL
##opnotc = curryDefx(defmain, "OpNot", op1c, {
 opPrecedence: intNewx(10)
})
##opdefinedc = curryDefx(defmain, "OpDefined", op1c, {
 opPrecedence: intNewx(10)
})
##optimesc = curryDefx(defmain, "OpTimes", op2c, {
 opPrecedence: intNewx(20)
})
##opobelusc = curryDefx(defmain, "OpObelus", op2c, {
 opPrecedence: intNewx(20)
})
##opmodc = curryDefx(defmain, "OpMod", op2c, {
 opPrecedence: intNewx(20)
})
##opplusc = curryDefx(defmain, "OpPlus", op2c, {
 opPrecedence: intNewx(30)
})
##opplusintc = curryDefx(defmain, "OpPlusInt", opplusc)
##opplusfloatc = curryDefx(defmain, "OpPlusFloat", opplusc)
##opplusbigc = curryDefx(defmain, "OpPlusBig", opplusc)

##opminusc = curryDefx(defmain, "OpMinus", op2c, {
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

/////12 def signal
##signalc = classDefx(defmain, "Signal", [objc]);
##continuec = curryDefx(defmain, "Continue", signalc)
##breakc = curryDefx(defmain, "Break", signalc)
##gotoc = classDefx(defmain, "Goto", [signalc], {
 goto: uintc
})
##returnc = classDefx(defmain, "Return", [signalc], {
 return: objc
})
##errorc = classDefx(defmain, "Error", [signalc], {
 errorCode: uintc
 errorMsg: strc
})
/////13 def ctrl
##ctrlc = classDefx(defmain, "Ctrl", [objc])
##ctrlargc = classDefx(defmain, "CtrlArg", [ctrlc], {
 ctrlArg: objc 
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
 envStack: arrstatec
 envLocal: statec 
 envGlobal: statec
})
##execc = classDefx(defmain, "Exec", [objc], {
 execBlock: blockc
 execLocal: classc
 execScope: scopec
})


/////15 func newfunc

Funcx = => Func{
 funcVars: arrDefx(arrstrc, [strNewx("o"), strNewx("env")])
 o: objNewx(arrc)
 env: objNewx(envc)
}
valfuncNewx = &(f Funcx)Objx{
 @return &Objx{
  type: @T("VALFUNC")
  val: f
 } 
}


funcNewx = &(val Funcx, argtypes Arrx, return Objx)Objx{
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
  push(funcVarTypes.arr, objNewx(v))
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

funcDefx = &(scope Objx, name Str, val Funcx, return Objx)Objx{
//FuncNative new
 #fn = funcNewx(val, @Arrx{}, return)
 routex(fn, scope, name);
 @return fn
}
methodDefx = &(class Objx, name Str, val Funcx, argtypes Arrx, return Objx)Objx{//FuncNative new
 unshift(argtypes, class)
 #fn = funcNewx(val, argtypes, return)
 class.dic[name] = fn;
 fn.name = class.name + "_" + name
 @return fn
}
opDefx = &(func Objx, op Objx)Objx{
 Str#n = func.name + "_" + op.name
 Objx#r = scopeGetx(defmain, n)
 @if(r != _){
  @return r
 }
 #r = classDefx(defmain, n, [func, op])
 @return r
}
op1Defx = &(class Objx, name Str, val Funcx, op Objx)Objx{
 #func = methodDefx(class, name, val, @Arrx{}, class)
 @return opDefx(func, op)
}
op2Defx = &(class Objx, name Str, val Funcx, op Objx)Objx{
 #func = methodDefx(class, name, val, [class], class)
 @return opDefx(func, op) 
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
objCopyx = &(o Objx)Objx{
 #x = &Objx{
  type: o.type
  ctype: o.ctype  
  mid: o.mid
  
  name: o.name
  id: uidx()
  scope: o.scope
  
  parents: dicCopyx(o.parents)

  obj: o.obj
  dic: dicCopyx(o.dic)
  arr: arrCopyx(o.arr)
  str: o.str
  int: o.int
  val: o.val
 }
 @return x
}

/////17 oop func


/////18 func exec
