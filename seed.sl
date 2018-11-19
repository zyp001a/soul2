/////1 set class/structs
T = =>Enum {
 enum: [
  "OBJ", "CLASS",
  "NULL",
  "INT", "FLOAT", "BIG"
  "STR", "BYTE", "BYTES"
  "DIC", "ARR", "VALFUNC"
  "NS", "SCOPE", "STATE"
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
 default: Boolean 
 name: Str
 id: Str
 scope: Objx
 
 class: Objx
 parents: Dicx
 
 dic: Dicx
 arr: Arrx
 val: Val
}
Astx = => ArrStatic {
 itemsType: Voidp
}
/////2 preset root ...
Uint##uidi = 0;
uidx = &()Str{
 Str#r = str(uidi)
 uidi += 1
 @return r;
}
routex = &(o Objx, scope Objx, name Str){
 #dic = scope.dic;
 dic[name] = o 
 o.name = name;
 o.id = uidx()
 o.scope = scope
}
parentsMakex = &(o Objx, parentarr Arrx)Dicx{
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
classPresetx = &(parentarr Arrx)Objx{
 #x = &Objx{
  type: @T("CLASS")   
  dic: @Dicx{}
 }
 parentsMakex(x, parentarr) 
 @return x;
}
scopePresetx = &(ns Objx, name Str, parentarr Arrx)Objx{
 #x = &Objx{
  type: @T("SCOPE") 
  name: name
  scope: ns
  dic: @Dicx{}
 }
 parentsMakex(x, parentarr)  
 x.dic["."] = x
 x.dic[".."] = ns
 ns.dic[name] = x
 @return x;
}
##root = @Dicx{}
nsPresetx = &(name Str)Objx{
 #x = &Objx{
  type: @T("NS") 
  name: name
  dic: @Dicx{}
 }
 root[name] = x 
 @return x;
}
##defns = nsPresetx("def")
##defmain = scopePresetx(defns, "main")
##objc = classPresetx();
routex(objc, defmain, "Obj");
##objdefc = classPresetx([objc])
routex(objdefc, defmain, "ObjDef")
##classc = classPresetx([objdefc])
routex(classc, defmain, "Class")
##scopec = classPresetx([objdefc])
routex(scopec, defmain, "Scope")
classc.ctype = @T("SCOPE")
##nsc = classPresetx([objc])
routex(nsc, defmain, "Ns")
classc.ctype = @T("NS")

defns.class = nsc
defmain.class = scopec
objc.class = classc
objdefc.class = classc
classc.class = classc
scopec.class = classc
nsc.class = classc

/////3 def scope/MVClasscNew
dicOrx = &(x Dicx)Dicx{
 @if(x == _){
  @return @Dicx{}
 }@else{
  @return x
 }
}
isclassx = &(c Objx, t Objx, cache Dic)Boolean{
 @if(c.id != "" && c.id == t.id){
  @return @Boolean(1)
 }
 @if(!cache){
  cache = {}
 }
 @each k v c.parents{
  @if(cache[k] != _){
   @continue
  }
  cache[k] = 1
  @if(isclassx(v, t, cache)){
   @return @Boolean(1)
  }
 }
 @return @Boolean(0)
}
classGetx = &(class Objx, key Str)Objx{
 #x = class.dic[key]
 @if(x != _){
  @return x
 }
 @foreach v class.parents{
  #x = classGetx(v, key)
  @if(x != _){
   @return x
  }  
 }
 @return _
}
objInitx = &(class Objx, dic Dicx)Objx{
 #x = &Objx{
  type: @T("OBJ")
  class: class
  dic: dicOrx(dic)
 }
 @if(dic != _){
  //TODO assign value 
  @each k v dic{
   #t = classGetx(class, k)
   @if(t == _){
    die("objInitx: not in "+ class.name + " "+k)
   }
   Objx#c = t.class
   @if(!isclassx(v.class, c)){
    die("objInitx: " + v.class.name + " is not " + c.name)
   }
  }
 }@else{
  x.default = @Boolean(1)
 }
 @return x; 
}
objNewx = &(scope Objx, name Str, class Objx, dic Dicx)Objx{
 #x = objInitx(class, dic)
 routex(x, scope, name)
 @return x
}
scopeDefx = &(ns Objx, name Str, parentarr Arrx)Objx{
//THROW when key match "_"
 #x = scopePresetx(ns, name, parentarr)
 x.class = scopec
 @return x
}
nsDefx = &(name Str)Objx{
 #x = nsPresetx(name)
 x.class = nsc
 @return x;
}
classInitx = &(parentarr Arrx, schema Dicx)Objx{
 #x = classPresetx(parentarr)
 x.class = classc
 @each k v schema{
  x.dic[k] = objInitx(v)
 }
 @return x;
}
classNewx = &(scope Objx, name Str, parentarr Arrx, schema Dicx)Objx{
 #x = classInitx(parentarr, schema)
 routex(x, scope, name)
 @return x
}
curryNewx = &(scope Objx, name Str, class Objx, schema Dicx)Objx{
 #x = &Objx{
  type: @T("CLASS")
  class: classc
  dic: dicOrx(schema)
 }
 parentsMakex(x, [class]) 
 routex(x, scope, name)
 @return x
}

/////4 def val, voidp, null
##valc = classNewx(defmain, "Val", [objc], {
 val: objc
})
##nullv =  &Objx{
 type: @T("NULL")
}
##nullc = curryNewx(defmain, "Null", valc, {
 val: nullv
})
nullc.ctype = @T("NULL")
nullv.class = nullc
isnull = &(o Objx)Boolean{
 @return (o.type == @T("NULL"))
}
##zerointv = &Objx{
 type: @T("INT")
 val: 0
}
##zerofloatv = &Objx{
 type: @T("FLOAT")
 val: 0.0
}
##numc = classNewx(defmain, "Num", [valc])
##intc = classNewx(defmain, "Int", [numc])
intc.ctype = @T("INT")
##uintc = classNewx(defmain, "Uint", [intc])
##floatc = classNewx(defmain, "Float", [numc])
floatc.ctype = @T("FLOAT")

zerofloatv.class = floatc
zerointv.class = intc
inttDefx = &(x Str)Objx{
 @return curryNewx(defmain, x, intc, {
  val: zerointv
 })
}
uinttDefx = &(x Str)Objx{
 @return curryNewx(defmain, x, uintc, {
  val: zerointv
 })
}
floattDefx = &(x Str)Objx{
 @return curryNewx(defmain, x, floatc, {
  val: zerofloatv
 })
}
inttDefx("Boolean")//Int1
##bytec = inttDefx("Byte")//Int8
bytec.ctype = @T("BYTE")
inttDefx("Int16")
inttDefx("Int32")
inttDefx("Int64")
uinttDefx("Uint8")
uinttDefx("Uint16")
uinttDefx("Uint32")
uinttDefx("Uint64")
floattDefx("Float32")
floattDefx("Float64")

##numbigc = curryNewx(defmain, "NumBig", numc)
numbigc.ctype = @T("BIG")
/////6 def items 
##itemsc =  classNewx(defmain, "Items", [valc], {
 itemsType: classc
})
##itemslimitedc =  classNewx(defmain, "ItemsLimited", [itemsc], {
 itemsLimitedLength: uintc
})
##arrc = curryNewx(defmain, "Arr", itemsc)
arrc.ctype = @T("ARR")
##arrstaticc = curryNewx(defmain, "ArrStatic", arrc)
##bytesc = curryNewx(defmain, "Bytes", arrc, {
 itemsType: bytec
})
bytesc.ctype = @T("BYTES")
##dicc = curryNewx(defmain, "Dic", itemsc)
dicc.ctype = @T("DIC")

arrDefx = &(class Objx, val Arrx)Objx{
 @if(class == _){
  class = arrc;
 }
 #x = &Objx{
  type: @T("ARR")
  class: class
 }
 @if(val != _){
  x.arr = val
 }@else{
  x.arr = @Arrx{}
 }
 @return x
}
dicDefx = &(class Objx, val Dicx)Objx{
 @if(class == _){
  class = dicc;
 }
 @return &Objx{
  type: @T("DIC")
  class: class
  dic: dicOrx(val)
 }
}


/////7 advanced type init: string, enum, unlimited number...
##zerostrv = &Objx{
 type: @T("STR")
 val: ""
}
##strc = curryNewx(defmain, "Str", valc)
strc.dic["val"] = zerostrv
strc.ctype = @T("STR")
zerostrv.class = strc

##enumc = classNewx(defmain, "Enum", [valc], {
 enum: arrc
})
##bufferc = classNewx(defmain, "Buffer", [valc])
##pointerc = classNewx(defmain, "Pointer", [valc])

##filec = classNewx(defmain, "File", [objc])
##agentc = classNewx(defmain, "Agent", [objc])


intDefx = &(x Int)Objx{
 @return &Objx{
  type: @T("INT")
  class: intc
  val: x
 }
}
uintDefx = &(x Int)Objx{
 @return &Objx{
  type: @T("INT")
  class: uintc
  val: x
 }
}
floatDefx = &(x Num)Objx{
 @return &Objx{
  type: @T("FLOAT")
  class: floatc
  val: x
 }
}
strDefx = &(x Str)Objx{
 @return &Objx{
  type: @T("STR")
  class: strc
  val: x
 }
}
bytesDefx = &(x Bytes)Objx{
 @return &Objx{
  type: @T("BYTES")
  class: bytesc
  val: x
 }
}
byteDefx = &(x Byte)Objx{
 @return &Objx{
  type: @T("BYTE")
  class: bytec
  val: x
 } 
}

/////8 def var/block/func
ArrStrx = => Arr {
 itemsType: Str
}
##arrstrc = curryNewx(defmain, "ArrStr", arrc, {
 itemsType: strc
})
##dicclassc = curryNewx(defmain, "DicClass", dicc, {
 itemsType: classc
})
##arrclassc = curryNewx(defmain, "ArrClass", arrc, {
 itemsType: classc
})




##funcc = classNewx(defmain, "Func", [objc])

##funcprotoc = classNewx(defmain, "FuncProto", [funcc], {
 funcVars: arrstrc
 funcVarTypes: arrc
 funcReturn: classc
})

##valfuncc = curryNewx(defmain, "ValFunc", valc)
valfuncc.ctype = @T("VALFUNC")
##funcnativec = classNewx(defmain, "FuncNative", [funcprotoc], {
 funcNative: valfuncc
})
##blockc = classNewx(defmain, "Block", [objc], {
 blockVal: arrc,
 blockClass: classc,
})
##blockxc = classNewx(defmain, "BlockX", [blockc], {
 blockFileName: strc 
})
##breakpointc = classNewx(defmain, "Breakpoint", [objc], {
 breakpointIndex: uintc
 breakpointBlock: blockc
})
##dicbreakpointc = curryNewx(defmain, "DicBreakpoint", dicc, {
 itemsType: breakpointc
})
##statec = classNewx(defmain, "State", [objdefc], {
 stateVars: arrstrc
 stateVal: dicc
 stateBreakpoints: dicbreakpointc
})
//stack
##arrstatec = curryNewx(defmain, "ArrState", arrc, {
 itemsType: statec
})
//??
##statefuncc = classNewx(defmain, "StateFunc", [statec], {
 stateFunc: funcc
})
##funcclassc = classNewx(defmain, "FuncClass", [funcprotoc], {
 funcClass: classc
})
##funcblockc = classNewx(defmain, "FuncBlock", [funcclassc], {
 funcBlock: blockc
})
##functplc = classNewx(defmain, "FuncTpl", [funcblockc], {
 funcTpl: strc
 funcTplFileName: strc
})
stateInitx = &()Objx{
 #x = &Objx{
  type: @T("STATE")
  class: classc
  dic: @Dicx{}
  arr: @Arrx{}
  val: @Dicx{}
 }
 parentsMakex(x, [statec])  
 @return x
}
/////9 def mid
##midc = classNewx(defmain, "Mid", [objc])

##convc = classNewx(defmain, "Conv", [midc], {
 convToType: classc
 convFrom: objc
})
##convimpc = curryNewx(defmain, "ConvImp", convc)
##convexpc = curryNewx(defmain, "ConvExp", convc)

##callc = classNewx(defmain, "Call", [midc], {
 callFunc: funcc
 callArgs: arrc
})

##idc = classNewx(defmain, "Id", [midc])
##idstrc =  classNewx(defmain, "IdStr", [idc], {
 idStr: strc,
})
##idstatec = classNewx(defmain, "IdState", [idstrc], {
 idClass: classc 
})
##idlocalc = curryNewx(defmain, "IdLocal", idstatec)
##idglobalc = curryNewx(defmain, "IdGlobal", idstatec)
##idscopec = classNewx(defmain, "IdScope", [idstrc], {
 idVal: objc
})

##assignc = classNewx(defmain, "Assign", [midc], {
 assignL: idc
 assignR: objc
})
##assignafterc = curryNewx(defmain, "AssignAfter", assignc)

##opc = classNewx(defmain, "Op", [midc], {
 opPrecedence: uintc
})
##op1c = classNewx(defmain, "Op1", [opc], {
 opV: objc
})
##op2c = classNewx(defmain, "Op2", [opc], {
 opL: objc
 opR: objc
})
//https://en.cppreference.com/w/c/language/operator_precedence
//remove unused
//get and assign are not operators in Soul PL
##opnotc = curryNewx(defmain, "OpNot", op1c, {
 opPrecedence: intDefx(10)
})
##opdefinedc = curryNewx(defmain, "OpDefined", op1c, {
 opPrecedence: intDefx(10)
})
##optimesc = curryNewx(defmain, "OpTimes", op2c, {
 opPrecedence: intDefx(20)
})
##opobelusc = curryNewx(defmain, "OpObelus", op2c, {
 opPrecedence: intDefx(20)
})
##opmodc = curryNewx(defmain, "OpMod", op2c, {
 opPrecedence: intDefx(20)
})
##opplusc = curryNewx(defmain, "OpPlus", op2c, {
 opPrecedence: intDefx(30)
})
##opplusintc = curryNewx(defmain, "OpPlusInt", opplusc)
##opplusfloatc = curryNewx(defmain, "OpPlusFloat", opplusc)
##opplusbigc = curryNewx(defmain, "OpPlusBig", opplusc)

##opminusc = curryNewx(defmain, "OpMinus", op2c, {
 opPrecedence: intDefx(30)
})
##opgec = curryNewx(defmain, "OpGe", op2c, {
 opPrecedence: intDefx(40)
})
##oplec = curryNewx(defmain, "OpLe", op2c, {
 opPrecedence: intDefx(40)
})
##opgtc = curryNewx(defmain, "OpGt", op2c, {
 opPrecedence: intDefx(40)
})
##opltc = curryNewx(defmain, "OpLt", op2c, {
 opPrecedence: intDefx(40)
})
##opeqc = curryNewx(defmain, "OpEq", op2c, {
 opPrecedence: intDefx(50)
})
##opnec = curryNewx(defmain, "OpNe", op2c, {
 opPrecedence: intDefx(50)
})
##opandc = curryNewx(defmain, "OpAnd", op2c, {
 opPrecedence: intDefx(60)
})
##oporc = curryNewx(defmain, "OpOr", op2c, {
 opPrecedence: intDefx(70)
})
##opassignc = curryNewx(defmain, "OpAssign", op2c, {
 opPrecedence: intDefx(80)
})

/////10 def signal
##signalc = classNewx(defmain, "Signal", [objc]);
##continuec = curryNewx(defmain, "Continue", signalc)
##breakc = curryNewx(defmain, "Break", signalc)
##gotoc = classNewx(defmain, "Goto", [signalc], {
 goto: uintc
})
##returnc = classNewx(defmain, "Return", [signalc], {
 return: objc
})
##errorc = classNewx(defmain, "Error", [signalc], {
 errorCode: uintc
 errorMsg: strc
})
/////11 def ctrl
##ctrlc = classNewx(defmain, "Ctrl", [objc])
##ctrlargc = classNewx(defmain, "CtrlArg", [ctrlc], {
 ctrlArg: objc 
})
##ctrlargsc = classNewx(defmain, "CtrlArgs", [ctrlc], {
 ctrlArgs: arrc
})
##ctrlifc = curryNewx(defmain, "CtrlIf", ctrlargsc)
##ctrlforc = curryNewx(defmain, "CtrlFor", ctrlargsc)
##ctrleachc = curryNewx(defmain, "CtrlEach", ctrlargsc)
##ctrlforeachc = curryNewx(defmain, "CtrlForeach", ctrlargsc)
##ctrlwhilec = curryNewx(defmain, "CtrlWhile", ctrlargsc)
##ctrlbreakc = curryNewx(defmain, "CtrlBreak", ctrlc)
##ctrlcontinuec = curryNewx(defmain, "CtrlContinue", ctrlc)
##ctrlgotoc = curryNewx(defmain, "CtrlGoto", ctrlargc)

##ctrlreturnc = curryNewx(defmain, "CtrlReturn", ctrlargc)
##ctrlerrorc = curryNewx(defmain, "CtrlError", ctrlargsc)

/////12 def  env
##envc = classNewx(defmain, "Env", [objc], {
 envExec: scopec
// envDef: scopec
 envStack: arrstatec
 envLocal: statec 
 envGlobal: statec
})
##execc = classNewx(defmain, "Exec", [objc], {
 execBlock: blockxc
 execLocal: classc
 execScope: scopec
})

/////13 func newfunc

Funcx = => Func{
 funcVars: arrDefx(arrstrc, [strDefx("o"), strDefx("env")])
 o: objInitx(arrc)
 env: objInitx(envc)
}
valfuncDefx = &(f Funcx)Objx{
 @return &Objx{
  type: @T("VALFUNC")
  class: valfuncc
  val: f
 } 
}

fnInitx = &(val Funcx, argtypes Arrx, return Objx)Objx{
 @if(val == _){
  #c = funcprotoc
 }@else{
  #c = funcnativec
 }
 #x = objInitx(c)
 #funcVars = arrDefx(arrstrc)
 #funcVarTypes = arrDefx(arrc)
 @each i v argtypes{
  push(funcVars.arr, strDefx("$arg"+str(i)))
  push(funcVarTypes.arr, objInitx(v))
 }
 x.dic["funcVars"] = funcVars
 x.dic["funcVarTypes"] = funcVarTypes
 @if(return != _){
  x.dic["funcReturn"] = return
 } 
 @if(val != _){
  x.dic["funcNative"] = valfuncDefx(val)
 }
 @return x
}

fnNewx = &(scope Objx, name Str, val Funcx, argtypes Arrx, return Objx)Objx{//FuncNative new
 #fn = fnInitx(val, argtypes, return)
 routex(fn, scope, name);
 //TODO if  raw
 @return fn
}
methodNewx = &(class Objx, name Str, val Funcx, argtypes Arrx, return Objx)Objx{//FuncNative new
 unshift(argtypes, class)
 #fn = fnInitx(val, argtypes, return)
 class.dic[name] = fn;
 //TODO if  raw
 @return fn
}
op1Newx = &(class Objx, name Str, val Funcx, argtype Objx, return Objx)Objx{
 @return methodNewx(class, name, val, [argtype], return)
}
op2Newx = &(class Objx, name Str, val Funcx, argtype Objx, return Objx)Objx{
 @return methodNewx(class, name, val, [argtype, argtype], return)
}
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
  default: o.default
  name: o.name
  id: uidx()
  scope: o.scope
  class: o.class
  parents: dicCopyx(o.parents)
  dic: dicCopyx(o.dic)
  arr: arrCopyx(o.arr)
 }
 @if(o.type == @T("STATE")){
  x.val = dicCopyx(Dicx(o.val))
 }@else{
  x.val = o.val
 }
 @return x
}
/////14 func oop
objxInitx = &(class Objx, dic Dicx)Objx{
 @if(class.ctype == @T("OBJ")){
  @return objInitx(class, dic)
 }@elif(class.ctype == @T("NULL")){
  @return nullv
 }@elif(class.ctype == @T("INT")){
  Objx#x = intDefx(0)
 }@elif(class.ctype == @T("FLOAT")){
  Objx#x = floatDefx(0.0)
 }@elif(class.ctype == @T("BIG")){
  Objx#x = nullv
 }@elif(class.ctype == @T("STR")){
  Objx#x = strDefx("")
 }@elif(class.ctype == @T("BYTE")){
  Objx#x = nullv
 }@elif(class.ctype == @T("VALFUNC")){
  Objx#x = nullv  
 }@elif(class.ctype == @T("DIC")){
  @return dicDefx(class)
 }@elif(class.ctype == @T("ARR")){
  @return arrDefx(class)
 }@elif(class.ctype == @T("NS")){
  @return nullv
 }@elif(class.ctype == @T("SCOPE")){
  @return nullv
 }@elif(class.ctype == @T("STATE")){
  @return nullv
 }@else{
  die("unknown class type")
  @return
 }
 @if(dic != _ && dic["val"] != _){
  x.val = dic["val"].val
 }
 @return x
}
objGetx = &(o Objx, s Str)Objx{
 @if(o.type == @T("OBJ")){
  #x = o.dic[s]
  @if(x != _){
   @return x
  }
  #r = classGetx(o.class, s)
  o.dic[s] = objCopyx(r);
  @return r
 }@elif(o.type == @T("CLASS")){
  @return classGetx(o, s)
 }@else{
  log("TODO other type objGet")
  @return nullv
 }
}
objSetx = &(o Objx, s Str, v Objx)Objx{
 @return nullv
}
typepredx = &(o Objx)Objx{
 @return arrc
}
/////15 func scope
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

 @each k v scope.parents {
  @if(cache[k] != _){ @continue };
  cache[k] = 1;
  r = scopeGetx(v, key, cache)
  @if(r != _){
   @return r;
  }
 }
 @return _
}
/////16 func exec
//exec use self as cache
##execns = nsDefx("exec")
##execmain = scopeDefx(execns, "main")
tplCallx = &(func Objx, args Arrx, env Objx)Objx{
 #sstr = Str(func.dic["funcTpl"].val)
 Astx#ast = jsonParse(cmd("./slt-reader", sstr))
 #localx = stateInitx()
 localx.dic["$global"] = env.dic["envGlobal"]
 localx.dic["$local"] = env.dic["envLocal"]
 //TODO $this
 #local = objInitx(localx)
 Objx#globalp = env.dic["envGlobal"]
 #global = objGetx(globalp, "$tplglobal")
 Objx#b = ast2objx(ast, defmain, localx, global.class)
 #nenv = objxInitx(envc, {
  envLocal: local
  envGlobal: global
  envStack: arrDefx(arrstatec, @Arrx{})
  envExec: execmain  
 })
 localx.dic["$env"] = nenv 
 Objx#r = blockExecx(b, nenv)
 @return r
}
callx = &(func Objx, args Arrx, env Objx)Objx{
 @if(func.class.id == funcnativec.id){
  @return call(Funcx(objGetx(func, "funcNative").val), [args, env]);
 }
 @if(func.class.id == functplc.id){
  @return tplCallx(func, args, env)
 }
 @if(func.class.id == funcblockc.id){
  #nstate = objInitx(func.dic["funcClass"])
  Arrx#stack = env.dic["envStack"].arr;
  push(stack, env.dic["envLocal"])
  env.dic["envLocal"]  = nstate
  Arrx#vars = func.dic["funcVars"].arr
  @each i arg args{
   nstate.dic[Str(vars[i].val)] = arg   
  }
  Objx#r = blockExecx(func.dic["funcBlock"], env)
  //TODO signal
  env.dic["envLocal"] = stack[len(stack)-1]
  pop(stack)
  @return r;
 }
 log(func.class)
 die("callx: unknown func")
 @return nullv;
}
execGetx = &(c Objx, execsp Objx, cache Dic)Objx{
 @if(!cache){
  cache = {}
 }
 @if(c.id != ""){
  #t = c.name
  #x = execsp.dic[t]
  @if(x != _){
   @return x
  }
  #execot = scopeGetx(execsp, t)
  @if(execot != _){
   execsp.dic[t] = execot
   @return execot
  }
 }
 @if(c.parents != _){
  @each k v c.parents{
   @if(cache[k] != _){ @return; }
   cache[k] = 1;
   Objx#exect = execGetx(v, execsp, cache);
   @if(exect != _){
    execsp.dic[t] = exect;
    @return exect;
   }
  }
 }
 @return _
}
blockExecx = &(o Objx, env Objx, stt Uint)Objx{
 Objx#b = o.dic["blockVal"]
 @each i v b.arr{
  @if(stt != 0 && stt < i){
   @continue
  }
  Objx#r = execx(v, env)
  @if(r != _ && isclassx(r.class, signalc)){
   @if(r.class.id == returnc.id){
    @return r.dic["return"];
   }
   @return r
  }
 }
 @return nullv
}
preExecx = &(o Objx)Objx{
 @return o
}
execx = &(o Objx, env Objx)Objx{
 #ex = execGetx(o.class, env.dic["envExec"])
 @if(!ex){
  log(o.class)
  die("exec: unknown type");
 }
// log("Exec: "+ex.name)
 @return callx(ex, [o], env);
}

/////17 func parse/ast
id2objx = &(id Str, def Objx, local Objx, global Objx)Objx{
 @if(local.dic[id] != _){
  @return objInitx(idlocalc, {
   idStr: strDefx(id),
   idClass: local
  })
 }
 @if(global.dic[id] != _){
  @return objInitx(idglobalc, {
   idStr: strDefx(id),
   idClass: global
  })
 }
 @if(def.dic[id] != _){
  @return objInitx(idscopec, {
   idStr: strDefx(id),
   idVal: def.dic[id]
  })
 }
 @return nullv
}
exec2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #v = Astx(ast[2])
 #l = stateInitx()
 Objx#b = ast2objx(v, def, l, global)
 @if(!isclassx(b.class, blockc)){
  b = preExecx(b);
 }
 #x = objxInitx(execc, {
  execBlock: b
  execLocal: l
 })
 #execsp = execns.dic[Str(ast[1])];
 //TODO check exist
 x.dic["execScope"] = execsp
 @return x
}
blockx2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #d = defns.dic[Str(ast[2])]
 #l = stateInitx()
 #v = Astx(ast[1])
 Objx#b = ast2blockx(v, d, l, global);
 b.class = blockxc
 @if(len(ast) == 4){
  b.dic["blockFileName"] = strDefx(Str(ast[3]))
 }
 @return b
}
func2objx = &(ast Astx, def Objx, local Objx, global Objx, name Str)Objx{
 //CLASS ARGDEF RETURN BLOCK AFTERBLOCK
 #v = Astx(ast[1])
 @if(v[0] != _){
  scopeGetx(def, Str(v[0])) 
 }
 #funcVars = @Arrx{}
 #funcVarTypes = @Arrx{}
 #args = Astx(v[1])
 #newl = stateInitx() 
 @foreach arg args{
  #argdef = Astx(arg)
  #varid = Str(argdef[0])
  push(funcVars, strDefx(varid))
  @if(argdef[2] != _){
   Objx#varval = ast2objx(Astx(argdef[2]), def, local, global)
  }@elif(argdef[1] != _){
   #t = scopeGetx(def, Str(argdef[1]))
   @if(t == _){
    die("func2objx: arg type not defined "+Str(argdef[1]))
   }
   #varval = objxInitx(t)
  }@else{
   #varval = objxInitx(objc)  
  }
  push(funcVarTypes, varval.class)
  newl.dic[varid] = varval
 }
 @if(v[3] != _){
  Objx#b = ast2blockx(Astx(v[3]), def, newl, global);
  #x = objxInitx(funcblockc, {
   funcVars: arrDefx(arrstrc, funcVars)
   funcVarTypes: arrDefx(arrc, funcVarTypes)
   funcClass: newl
   funcBlock: b
  })  
  @if(v[4] != _){
   die("TODO alterblock")
  }
 }@else{
  #x = objxInitx(funcprotoc, {
   funcVars: arrDefx(arrstrc, funcVars)
   funcVarTypes: arrDefx(arrc, funcVarTypes)
  }) 
 }
 @if(v[2] != _){
  x.dic["funcReturn"] = scopeGetx(def, Str(v[2]))
 } 
 @if(name != ""){
  routex(x, def, name)
 }
 @return x;
}
class2objx = &(ast Astx, def Objx, local Objx, global Objx, name Str)Objx{
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
 Objx#schema = ast2dicx(Astx(ast[2]), def, local, global);
 #x = classInitx(arr)
 @each k v schema.dic{
  x.dic[k] = v
 } 
 @if(name != ""){
  routex(x, def, name)
 }
 @return x
}
obj2objx =  &(ast Astx, def Objx, local Objx, global Objx, name Str)Objx{
 #c = scopeGetx(def, Str(ast[1]))
 @if(c == _){
   die("obj2obj: no class "+Str(ast[1])) 
 }
 Objx#schema = ast2dicx(Astx(ast[2]), def, local, global);
 @if(schema.mid){
  #x = objxInitx(callc, {
   callFunc: defmain.dic["new"]
   callArgs: arrDefx(arrc, [c, schema])
  })
 }@else{
  #x = objxInitx(c, schema.dic)
 }
 @if(name != ""){
  routex(x, def, name)
 }
 @return x 
}
op2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #op = Str(ast[1])
 Str#cname = "Op"+ucfirst(op)
 #args = Astx(ast[2])
 @if(len(args) == 1){
  Objx#arg0 = ast2objx(Astx(args[0]), def, local, global)
  #class = defns.dic[cname]  
  @if(op == "not"){
   @return objInitx(opnotc, {
    opV: arg0
   })
  }
  @return objInitx(class, {
   opV: arg0
  })
 }@else{
  Objx#arg0 = ast2objx(Astx(args[0]), def, local, global)
  Objx#arg1 = ast2objx(Astx(args[1]), def, local, global)
  @if(op == "plus"){
   #t0 = typepredx(arg0)
   #t1 = typepredx(arg0)
   @if(t0 != t1){
   }
  }
  @return objInitx(class, {
   opL: arg0
   opR: arg1
  })
 }
 @return _
}

itemsget2objx =  &(ast Astx, def Objx, local Objx, global Objx)Arrx{
 Objx#items = ast2objx(Astx(ast[1]), def, local, global)
 #itemst = typepredx(items)
 #getf = classGetx(itemst, "get")
 Objx#key = ast2objx(Astx(ast[2]), def, local, global) 
 @return [getf, items, key]
}
objget2objx =  &(ast Astx, def Objx, local Objx, global Objx)Arrx{
 Objx#obj = ast2objx(Astx(ast[1]), def, local, global)
 Objx#key = ast2objx(Astx(ast[2]), def, local, global)
 @return [defmain.dic["get"], obj, key]
}
assign2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #v = Astx(ast[1])
 #left = Astx(v[0])
 #right = Astx(v[1])
 #leftt = Str(left[0])
 @if(leftt == "id"){
  #name = Str(left[1])
  #lefto = id2objx(name, def, local, global)
  @if(isnull(lefto)){
   @return ast2objx(right, def, local, global, name)
  }@else{
   log("TODO id alreadfy defined "+name)
  }
 }@elif(leftt == "objget"){
 }@elif(leftt == "itemsget"){   
 }@else{
  #lefto = ast2objx(left, def, local, global)
 }
 Objx#righto = ast2objx(right, def, local, global)
 //TODO set type
 #predt = typepredx(righto)
 @if(predt != _){
  @if(lefto.class.id == idlocalc.id){
   #idstr = Str(lefto.dic["idStr"].val)
   #type = local.dic[idstr]
   @if(type == _){
    local.dic[idstr] = predt
   }
  }
 }
 @return objxInitx(assignc, {
  assignL: lefto
  assignR: righto
 })
}
call2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #v = Astx(ast[1])
 Objx#f = ast2objx(v, def, local, global)
 @if(f.class.id == idscopec.id){
  #f = f.dic["idVal"]
  @if(isclassx(f.class, classc)){
   @return objxInitx(convc, {//TODO implicit vs explicit
    convertToType: def
    convertFrom: ast2objx(Astx(Astx(ast[2])[0]), def, local, global)
   })
  }
 }
 Objx#arr = ast2arrx(Astx(ast[2]), def, local, global)
 @return objxInitx(callc, {
  callFunc: f
  callArgs: arr
 }) 
}
ast2blockx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #arr = @Arrx{}
 #x = objxInitx(blockc, @Dicx{})
 @each i e ast{
  #ee = Astx(e)
  push(arr, ast2objx(Astx(ee[0]), def, local, global))
  @if(len(ee) == 2){
   Dicx(local.val)[Str(ee[1])] = objxInitx(breakpointc, {
    breakpointIndex: uintDefx(Int(i))
    breakpointBlock: x
   })
  }
 }
 x.dic["blockVal"] = arrDefx(arrc, arr)
 x.dic["blockClass"] = local
 @return x
}
ast2arrx = &(asts Astx, def Objx, local Objx, global Objx)Objx{
 #arrx = @Arrx{}
 #callable = 0;
 @foreach e asts{
  Objx#ee = ast2objx(Astx(e), def, local, global)
  @if(ee.mid){
   callable = 1;
  }
  push(arrx, ee)
 }
 @if(!callable){
  @each k v arrx{
   arrx[k] = preExecx(v)
  }
 }
 #r = arrDefx(arrc, arrx)
 @if(callable != 0){
  r.mid = @Boolean(1)
 }
 @return r;
}
ast2dicx = &(asts Astx, def Objx, local Objx, global Objx)Objx{
 #dicx = @Dicx{}
 #callable = 0;
 @foreach eo asts{
  #e = Astx(eo)
  #k = Str(e[1])
  Objx#ee = ast2objx(Astx(e[0]), def, local, global)
  @if(ee.mid){
   callable = 1;
  }
  dicx[k] = ee;
 }
 @if(!callable){
  @each k v dicx{
   dicx[k] = preExecx(v)
  }
 }
 #r = dicDefx(dicc, dicx)
 @if(callable != 0){
  r.mid = @Boolean(1)
 }
 @return r;
}
ast2objx = &(ast Astx, def Objx, local Objx, global Objx, name Str)Objx{
 #t = Str(ast[0])
 @if(t == "exec"){
  @return exec2objx(ast, def, local, global)
 }@elif(t == "blockx"){
  @return blockx2objx(ast, def, local, global)
 }@elif(t == "str"){
  @return strDefx(Str(ast[1]))
 }@elif(t == "float"){
  @return floatDefx(float(Str(ast[1])))
 }@elif(t == "int"){
  @return intDefx(int(Str(ast[1])))
 }@elif(t == "null"){
  @return nullv
 }@elif(t == "idlocal"){
  @return objxInitx(idlocalc, {
   idStr: strDefx(Str(ast[1])),
   idClass: local
  })  
 }@elif(t == "idglobal"){
  
 }@elif(t == "id"){
  #id = Str(ast[1])
  #x = id2objx(id, def, local, global)
  @if(isnull(x)){
   die("id not defined "+ id)
  }
  @return x;
 }@elif(t == "call"){
  @return call2objx(ast, def, local, global)
 }@elif(t == "assign"){
  @return assign2objx(ast, def, local, global)  
 }@elif(t == "func"){
  @return func2objx(ast, def, local, global, name)
 }@elif(t == "tpl"){
  #x = objxInitx(functplc, {
   funcTpl: strDefx(Str(ast[1]))   
  })
  @if(len(ast) == 3){
   x.dic["funcTplFileName"] = strDefx(Str(ast[2]))
  }
  @if(name != ""){
   routex(x, def, name)
  }
  @return x
 }@elif(t == "arr"){
 //TODO itemsLimit itemsType
  @return ast2arrx(Astx(ast[1]), def, local, global)
 }@elif(t == "dic"){
 //TODO
  @return ast2dicx(Astx(ast[1]), def, local, global);
 }@elif(t == "class"){
  @return class2objx(ast, def, local, global, name)
 }@elif(t == "obj"){
  @return obj2objx(ast, def, local, global, name)
 }@elif(t == "op"){
  @return op2objx(ast, def, local, global)
 }@elif(t == "return"){
  Objx#arg = ast2objx(Astx(ast[1]), def, local, global)
  @return objxInitx(ctrlreturnc, @Dicx{
   ctrlArg: arg
  })
 }@elif(t == "itemsget"){
  Arrx#arr =  itemsget2objx(ast, def, local, global)
  @return objxInitx(callc, {
   callFunc: arr[0]
   callArgs: arrDefx(arrc, [arr[1], arr[2]])
  })
 }@elif(t == "objget"){
  Arrx#arr = objget2objx(ast, def, local, global)
  @return objxInitx(callc, {
   callFunc: arr[0]
   callArgs: arrDefx(arrc, [arr[1], arr[2]])
  })
 }@else{
  die("ast2objx: " + t + " is not defined")
 }
 @return
}
progl2objx = &(str Str, def Objx, local Objx, global Objx)Objx{
 Astx#ast = jsonParse(cmd("./sl-reader", str))
 #r = ast2objx(ast, def, local, global)
 @return r
}
/////18 ....

/////19 func io/cmd

/////20 init method
methodNewx(arrc, "get", &(x Arrx, env Objx)Objx{
 Objx#o = x[0]
 Objx#e = x[1]
 @return o.arr[int(Str(e.val))]
},[arrc, strc])
methodNewx(dicc, "get", &(x Arrx, env Objx)Objx{
 Objx#o = x[0]
 Objx#e = x[1]
 @return o.dic[Str(e.val)]
},[dicc, strc])

/////21 init internal func
fnNewx(defmain, "new", &(x Arrx, env Objx)Objx{
 Objx#o = x[0]
 Objx#e = x[1] 
 @return objxInitx(o, e.dic)
},[classc, dicc])
fnNewx(defmain, "get", &(x Arrx, env Objx)Objx{
 Objx#o = x[0]
 Objx#e = x[1]
 @return objGetx(o, Str(e.val))
},[objc, dicc])
fnNewx(defmain, "push", &(x Arrx, env Objx)Objx{
 Objx#o = x[0]
 Objx#e = x[1] 
 push(o.arr, e)
 @return nullv
},[arrc, objc])
fnNewx(defmain, "join", &(x Arrx, env Objx)Objx{
 Objx#o = x[0]
 Objx#e = x[1]
 #r = ""
 #sep = Str(x[1].val)
 @each i e o.arr{
  @if(i != 0){
   r += sep
  } 
  r += Str(e.val)
 }
 @return strDefx(r)
},[arrc, objc],strc)
fnNewx(defmain, "log", &(x Arrx, env Objx)Objx{
 T#o = x[0].type
 #v = x[0].val
 @if(o == @T("INT")){
  log(Int(v)) 
 }@elif(o == @T("FLOAT")){
  log(Float(v))
 }@elif(o == @T("STR")){
  log(Str(v))
 }@else{
  log("log unknown")
  log(x[0].class.name)
  log(x[0])
 }
 @return nullv
},[objc])
fnNewx(defmain, "uc", &(x Arrx, env Objx)Objx{
 @return strDefx(uc(Str(x[0].val)))
},[strc])
fnNewx(defmain, "ucfirst", &(x Arrx, env Objx)Objx{
 @return strDefx(ucfirst(Str(x[0].val)))
},[strc])
/////22 init type exec func
feNewx = &(name Str, f Funcx)Objx{
 @return fnNewx(execmain, name, f, [objc], objc)
}
feNewx("Exec", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 #global = stateInitx()
 global.dic["$global"] = env.dic["envGlobal"]
 global.dic["$tplglobal"] = objInitx(stateInitx())
 #env = objxInitx(envc, {
  envGlobal: objInitx(global)
  envLocal: objInitx(c.dic["execLocal"])
  envStack: arrDefx(arrstatec, @Arrx{})
  envExec: c.dic["execScope"]
 })
 #r = blockExecx(c.dic["execBlock"], env);
 //process signal TODO!!!
 @return r;
})
feNewx("Call", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 Arrx#args = c.dic["callArgs"].arr
 #argsx = @Arrx{}
 @foreach arg args{
  #t = execx(arg, env);
  push(argsx, t)
 }
 @return callx(c.dic["callFunc"], argsx, env)
})
feNewx("Obj", &(x Arrx, env Objx)Objx{
 @return x[0]
})
feNewx("OpPlusInt", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 Objx#l = c.dic["opL"]
 Objx#r = c.dic["opR"]
 @return intDefx(Int(l.val) + Int(r.val))
})
feNewx("CtrlReturn", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 #f = execx(c.dic["ctrlArg"], env)
 @return objxInitx(returnc, {
  return: f
 })
})
feNewx("Assign", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 #v = execx(c.dic["assignR"], env)
 Objx#left = c.dic["assignL"]
 #t = left.class.id
 @if(t == idlocalc.id){
  Objx#l = env.dic["envLocal"]
  #str = left.dic["idStr"]
  l.dic[Str(str.val)] = v
 }
 @return v
})
feNewx("IdScope", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 @return objGetx(c, "idVal")
})
feNewx("IdLocal", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 Objx#l = env.dic["envLocal"]
 #k = Str(c.dic["idStr"].val)
 @return l.dic[k]
})

/////23 main func
#global = stateInitx()
#local = stateInitx()
Str#fc = fileRead(osArgs(1))
#main = progl2objx("@exec|{"+fc+"}'"+osArgs(1)+"'", defmain, local, global)
#env = objxInitx(envc, {
 envGlobal: objInitx(global)
 envLocal: objInitx(local)
 envStack: arrDefx(arrstatec, @Arrx{})
 envExec: execmain
})
execx(main, env);
