/////1 set class/structs
T = =>Enum {
 enum: [
  "NULL", "INT", "FLOAT", "BIG"
  "STR", "CHAR", "DIC", "ARR", "VALFUNC"
  "CLASS", "OBJ", "NS", "SCOPE", "STATE"
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
parentsMakex = &(parentarr Arrx)Dicx{
 @if parentarr == _ {
  @return
 }
 #x = @Dicx{}
 @foreach e parentarr{
  //TODO reduce
  @if(e.id == ""){
   die("no id")
  }
  x[e.id] = e;
 }
 @return x
}
classPresetx = &(parentarr Arrx)Objx{
 #x = &Objx{
  type: @T("CLASS")   
  parents: parentsMakex(parentarr)
  dic: @Dicx{}
 }
 @return x;
}
scopePresetx = &(ns Objx, name Str, parentarr Arrx)Objx{
 #x = &Objx{
  type: @T("SCOPE") 
  name: name
  scope: ns
  parents: parentsMakex(parentarr)
  dic: @Dicx{}
 }
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
##nsc = classPresetx([objc])
routex(nsc, defmain, "Ns")

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
  parents: parentsMakex([class])
  class: classc
  dic: dicOrx(schema)
 }
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
##uintc = classNewx(defmain, "Uint", [intc])
##floatc = classNewx(defmain, "Float", [numc])

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
##charc = inttDefx("Char")//Int8
inttDefx("Int16")
inttDefx("Int32")
inttDefx("Int64")
uinttDefx("Uint8")
uinttDefx("Uint16")
uinttDefx("Uint32")
uinttDefx("Uint64")
floattDefx("Float32")
floattDefx("Float64")

curryNewx(defmain, "NumBig", numc)

/////6 def items 
##itemsc =  classNewx(defmain, "Items", [valc], {
 itemsType: classc
})
##itemslimitedc =  classNewx(defmain, "ItemsLimited", [itemsc], {
 itemsLimitedLength: uintc
})
##arrc = curryNewx(defmain, "Arr", itemsc)
##arrstaticc = curryNewx(defmain, "ArrStatic", arrc)
##arrcharc = curryNewx(defmain, "ArrChar", arrc, {
 itemsType: charc
})
##dicc = curryNewx(defmain, "Dic", itemsc)

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
zerostrv.class = strc

##enumc = classNewx(defmain, "Enum", [valc], {
 enum: arrc
})
##bufferc = classNewx(defmain, "Buffer", [valc])
##pointerc = classNewx(defmain, "Pointer", [valc])

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
charDefx = &(x Char)Objx{
 @return &Objx{
  type: @T("CHAR")
  class: charc
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

##funcnativec = classNewx(defmain, "FuncNative", [funcprotoc], {
 funcNative: valfuncc
})
##blockc = classNewx(defmain, "Block", [objc], {
 blockVal: arrc,
 blockClass: classc, 
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
  parents: parentsMakex([statec])
  dic: @Dicx{}
  arr: @Arrx{}
  val: @Dicx{}
 }
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
##iduintc =  classNewx(defmain, "IdUint", [idc], {
 idUint: uintc,
})
##idstatec = classNewx(defmain, "IdState", [idstrc], {
 idClass: classc 
})
##idlocalc = curryNewx(defmain, "IdLocal", idstatec)
##idglobalc = curryNewx(defmain, "IdGlobal", idstatec)
##idscopec = classNewx(defmain, "IdScope", [idstrc], {
 idVal: objc
})
##idobjc = classNewx(defmain, "IdObj", [idstrc], {
 idObj: objc
})
##iddicc = classNewx(defmain, "IdDic", [idstrc], {
 idDic: dicc
})
##idarrc = classNewx(defmain, "IdArr", [iduintc], {
 idArr: arrc
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
 op: objc
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
##ctrlgotoc = curryNewx(defmain, "CtrlGoto", ctrlargsc)

##ctrlreturnc = curryNewx(defmain, "CtrlReturn", ctrlargsc)
##ctrlerrorc = curryNewx(defmain, "CtrlError", ctrlargsc)

/////12 def  env
##envc = classNewx(defmain, "Env", [objc], {
 envExec: scopec
 envDef: scopec
 envLocal: statec 
 envGlobal: statec
})
##execc = classNewx(defmain, "Exec", [objc], {
 execBlock: blockc
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

fnInitx = &(val Funcx, args ArrStrx, argtypes Arrx, return Objx)Objx{
 @if(val == _){
  #c = funcprotoc
 }@else{
  #c = funcnativec
 }
 #x = objInitx(c)
 #funcVars = arrDefx(arrstrc)
 #funcVarTypes = arrDefx(arrc)
 @each i v argtypes{
  push(funcVars.arr, strDefx(args[i]))
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

fnNewx = &(scope Objx, name Str, val Funcx, args ArrStrx, argtypes Arrx, return Objx)Objx{//FuncNative new
 #fn = fnInitx(val, args, argtypes, return)
 routex(fn, scope, name);
 //TODO if  raw
 @return fn
}

/////14 func oop

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

callx = &(func Objx, args Arrx, env Objx)Objx{
 @if(func.class.id == funcnativec.id){
  @return call(Funcx(func.dic["funcNative"].val), [args, env]);
 }
 @if(func.class.id == funcblockc.id){
  log("TODO")
  @return nullv;
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
   @return r;
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
 @return callx(ex, [o], env);
}

/////17 func parse
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
 @if(b.class.id != blockc.id){
  b = preExecx(b);
 }
 #x = objInitx(execc, {
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
 @return b
}
tpl2objx = &(ast Astx, def Objx, local Objx, global Objx, name Str)Objx{
 @return nullv
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
 @foreach arg args{
  #argdef = Astx(arg)
  log(argdef)
 }
 
 #x = objInitx(funcblockc, {
  funcVars: arrDefx(arrstrc, funcVars)
  funcVarTypes: arrDefx(arrc, funcVarTypes)
 })
 @if(v[2] != _){
  x.dic["funcReturn"] = scopeGetx(def, Str(v[2]))
 } 
 @if(name != ""){
  routex(x, def, name)
 }
 @return x;
}
class2objx = &(ast Astx, def Objx, local Objx, global Objx, name Str)Objx{
 @return nullv
}
obj2objx =  &(ast Astx, def Objx, local Objx, global Objx, name Str)Objx{
 @return nullv
}
assign2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #v = Astx(ast[1])
 #left = Astx(v[0])
 #right = Astx(v[1])
 #leftt = Str(left[0])
 @if(leftt == "id"){
  #name = Str(left[1])
  #ido = id2objx(name, def, local, global)
  @if(isnull(ido)){
   @return ast2objx(right, def, local, global, name)
  }
 }
 @return nullv
}
call2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #v = Astx(ast[1])
 Objx#f = ast2objx(v, def, local, global)
 @if(f.class.id == idscopec.id){
  #f = f.dic["idVal"]
  @if(isclassx(f.class, classc)){
   @return objInitx(convc, {//TODO implicit vs explicit
    convertToType: def
    convertFrom: ast2objx(Astx(Astx(ast[2])[0]), def, local, global)
   })
  }
 }
 Objx#arr = ast2arrx(Astx(ast[2]), def, local, global)
 @return objInitx(callc, {
  callFunc: f
  callArgs: arr
 }) 
}
ast2blockx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #arr = @Arrx{}
 #x = objInitx(blockc, @Dicx{})
 @each i e ast{
  #ee = Astx(e)
  push(arr, ast2objx(Astx(ee[0]), def, local, global))
  @if(len(ee) == 2){
   Dicx(local.val)[Str(ee[1])] = objInitx(breakpointc, {
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
  @return tpl2objx(ast, def, local, global, name)
 }@elif(t == "class"){
  @return class2objx(ast, def, local, global, name)
 }@elif(t == "obj"){
  @return obj2objx(ast, def, local, global, name)
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
/////18 func ast

/////19 func io/cmd

/////20 init method

/////21 init internal func
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
  log(o)
  log(x[0])
 }
 @return nullv
},["x"],[objc])

/////22 init type exec func
feNewx = &(name Str, f Funcx)Objx{
 @return fnNewx(execmain, name, f, ["x"], [objc], objc)
}
feNewx("Exec", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 #env = objInitx(envc, {
  envGlobal: env.dic["envGlobal"]
  envLocal: objInitx(c.dic["execLocal"])
  envExec: c.dic["execScope"]
 })
 #r = blockExecx(c.dic["execBlock"], env);
 //process signal TODO!!!
 @return r;
})
feNewx("Call", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 Arrx#args = c.dic["callArgs"].arr
 @return callx(c.dic["callFunc"], args, env)
})
feNewx("Obj", &(x Arrx, env Objx)Objx{
 @return x[0]
})
/////23 main func
#global = stateInitx()
#local = stateInitx()
Str#fc = fileRead(osArgs(1))
#main = progl2objx("@exec|{"+fc+"}", defmain, local, global)
/*#main = objInitx(callc, {
 callFunc: logf,
 callArgs: arrDefx(arrc, [intDefx(1)])
})*/
#env = objInitx(envc, {
 envGlobal: objInitx(global)
 envLocal: objInitx(local)
 envExec: execmain
})
execx(main, env);
