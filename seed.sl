/////1 set class/structs
T = =>Enum {
 enum: [
  "CPT",
  "OBJ", "CLASS"
  
  "NULL",
  "INT", "FLOAT", "BIG"
  "STR",
  "DIC", "ARR", "VALFUNC"
//  "FUNCP", "FUNCN", "FUNCB", "FUNCT"
//  "CALL"
  "NS", "SCOPE"
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
 
 fmid: Boolean
 fdefault: Boolean
 
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
  ctype: @T("OBJ")
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

##cptc = classNewx();
routex(cptc, defmain, "Cpt");
cptc.ctype = @T("CPT")
##cptv = &Objx{
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
objNewx = &(class Objx, dic Dicx)Objx{
 #x = &Objx{
  type: @T("OBJ")
  fdefault: @Boolean(1)
  id: uidx()
  dic: dicOrx(dic)
  obj: class
 }
 @return x;
}
classDefx = &(scope Objx, name Str, parents Arrx, schema Dicx)Objx{
 #x = classNewx(parents)
 @each k v schema{
  @if(v == _){
   log(name)
   die(k)
  }
  x.dic[k] = objDefx(v)
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
 val: cptc
})
##nullv =  &Objx{
 type: @T("NULL")
 fdefault: @Boolean(1)
}
##nullc = curryDefx(defmain, "Null", valc, {
 val: nullv
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
 val: zerostrv
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

##blockc = classDefx(defmain, "Block", _, {
 blockVal: arrc,
 blockStateDef: classc,
 blockLabels: dicuintc,
 
 blockScope: scopec, 
 blockName: strc 
})
blockc.dic["blockParent"] = objDefx(blockc)
//stack
##funcblockc = classDefx(defmain, "FuncBlock", [funcprotoc], {
 funcBlock: blockc
})
##functplc = classDefx(defmain, "FuncTpl", [funcprotoc], {
 funcTpl: strc
 funcTplName: strc
})

/////10 def mid
##midc = classDefx(defmain, "Mid", [objc])

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
##idglobalc = curryDefx(defmain, "IdGlobal", idstatec)
##idscopec = classDefx(defmain, "IdScope", [idstrc], {
 idVal: cptc
})
/*
##iddicc = classDefx(defmain, "IdDic", [idstrc], {
 idDic: dicc
})
##idarrc = classDefx(defmain, "IdArr", [iduintc], {
 idArr: arrc
})
##idobjc = classDefx(defmain, "IdObj", [idstrc], {
 idObj: objc
})
*/
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

funcDefx = &(scope Objx, name Str, val Funcx, argtypes Arrx, return Objx)Objx{
//FuncNative new
 #fn = funcNewx(val, arrOrx(argtypes), return)
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
funcSetOpx = &(func Objx, op Objx)Objx{
 Str#n = func.obj.name + "_" + op.name
 Objx#r = scopeGetx(defmain, n)
 @if(r == _){
  r = classDefx(defmain, n, [func.obj, op])
 }
 func.obj = r;
 @return r
}
opDefx = &(class Objx, name Str, val Funcx, arg Objx, return Objx, op Objx)Objx{
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
objCopyx = &(o Objx)Objx{
 #x = &Objx{
  type: o.type
  ctype: o.ctype  
  fmid: o.fmid
  fdefault: o.fdefault

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
classRawx = &(t T)Objx{
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
 }@elif(t == @T("BIG")){
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
classx = &(o Objx)Objx{
 @if(o.obj != _){
  @return o.obj
 }
 @if(o.parents != _){
  @return o;
 }
 @return classRawx(o.type)
}
isclassx = &(c Objx, t Objx, cache Dic)Boolean{
 @if(t.id == cptc.id){//everything is cpt
  @return @Boolean(1)
 }
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
isx = &(c Objx, t Objx)Boolean{
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
  Boolean#r = isclassx(classx(c), classx(t))
  @if(!r){
   @return @Boolean(0)
  }
 }
 @return @Boolean(1)
}
objDefx = &(class Objx, dic Dicx)Objx{
 @if(class.ctype == @T("CPT")){
  @return cptv
 }@elif(class.ctype == @T("OBJ")){
  //TODO
  @if(dic != _){
  //TODO assign value 
   @each k v dic{
    Objx#t = classGetx(class, k)
    @if(t == _){
     die("objDefx: not in "+ class.name + " "+k)
    }
    @if(v == _){
     log(k)
     die("objDefx: dic val null")     
    }
    @if(!isx(v, t)){
     log(v)
     log(t)
     log(v.obj)
     log(t.obj)
     log(k)
     log(class.name)
     die("objDefx: type error")
    }
   }
   Objx#r = objNewx(class, dic)
   r.fdefault = @Boolean(0)
   @return r   
  }@else{
   @return objNewx(class)  
  }
 }@elif(class.ctype == @T("CLASS")){
  @return classNewx()
 }@elif(class.ctype == @T("NULL")){
  @return nullv
 }@elif(class.ctype == @T("INT")){
  Objx#x = intNewx(0)
 }@elif(class.ctype == @T("FLOAT")){
  Objx#x = floatNewx(0.0)
 }@elif(class.ctype == @T("BIG")){
  Objx#x = nullv//TODO
 }@elif(class.ctype == @T("STR")){
  Objx#x = strNewx("")
 }@elif(class.ctype == @T("VALFUNC")){
  Objx#x = valfuncNewx()
 }@elif(class.ctype == @T("DIC")){
  @return dicNewx(class)
 }@elif(class.ctype == @T("ARR")){
  @return arrNewx(class)
 }@elif(class.ctype == @T("NS")){
  @return &Objx{
   type: @T("NS") 
   dic: @Dicx{}
   str: ""  
  }
 }@elif(class.ctype == @T("SCOPE")){
  @return &Objx{
   type: @T("SCOPE")
   arr: @Arrx{}
   dic: @Dicx{}
   str: ""
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
objGetx = &(o Objx, key Str)Objx{
 #r = o.dic[key]
 @if(r != _){
  @return r
 }
 @return classGetx(classx(o), key)
}
getx = &(o Objx, n Str)Objx{
 @if(o.type == @T("OBJ")){
  @return objGetx(o, n)
 }@elif(o.type == @T("CLASS")){
  @return classGetx(o, n)
 }@else{
  @return classGetx(classx(o), n)
 }
}
typepredx = &(o Objx)Objx{
 #t = o.type
 @if(t == @T("OBJ")){ 
  @if(isclassx(o.obj, idstatec)){
   Objx#s = o.dic["idState"]
   @return typepredx(s.dic[o.dic["idStr"].str])
  }
  @if(isclassx(o.obj, callc)){
   Objx#f = o.dic["callFunc"]
   @if(isclassx(f.obj, opgetc)){
    Objx#args = o.dic["callArgs"]
    Objx#arg0 = args.arr[0]
    @return classGetx(arg0.obj, "itemsType")
   }
   @return o.dic["funcReturn"]
  }
  @return _
 }@else{
  @return classx(o)
 }
}

/////18 func exec
##execns = nsNewx("exec")
##execmain = scopeNewx(execns, "main")
tplCallx = &(func Objx, args Arrx, env Objx)Objx{
 Str#sstr = func.dic["funcTpl"].str
 Astx#ast = jsonParse(cmd("./slt-reader", sstr))
 #localx = classNewx()
 localx.dic["$global"] = classx(env.dic["envGlobal"])
 localx.dic["$local"] = classx(env.dic["envLocal"])
 localx.dic["$env"] = envc
 @each i v args{
  localx.dic[str(i)] = classx(v);
 }
 
 //TODO $this
 #local = objNewx(localx)
 Objx#globalp = env.dic["envGlobal"]
 #global = objGetx(globalp, "$tplglobal")
 Objx#b = ast2objx(ast, defmain, localx, global.obj)
 #nenv = objDefx(envc, {
  envLocal: local
  envGlobal: global
  envStack: arrNewx(arrc, @Arrx{})
  envExec: execmain  
 })

 local.dic["$global"] = env.dic["envGlobal"]
 local.dic["$local"] = env.dic["envLocal"]
 local.dic["$env"] = nenv
 @each i v args{
  local.dic[str(i)] = v;
 }

 Objx#r = blockExecx(b, nenv)
 @return r
}
callx = &(func Objx, args Arrx, env Objx)Objx{
 @if(isclassx(func.obj, funcnativec)){
  @return call(Funcx(objGetx(func, "funcNative").val), [args, env]);
 }
 @if(isclassx(func.obj, functplc)){ 
  @return tplCallx(func, args, env)
 }
 @if(isclassx(func.obj, funcblockc)){
  Objx#block = func.dic["funcBlock"]
  #nstate = objNewx(block.dic["blockStateDef"])
  Arrx#stack = env.dic["envStack"].arr;
  push(stack, env.dic["envLocal"])
  env.dic["envLocal"]  = nstate
  Arrx#vars = func.dic["funcVars"].arr
  @each i arg args{
   nstate.dic[vars[i].str] = arg   
  }
  Objx#r = blockExecx(func.dic["funcBlock"], env)
  //TODO signal
  env.dic["envLocal"] = stack[len(stack)-1]
  pop(stack)
  @return r;
 }
 log(func.obj)
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
 Objx#exect = execGetx(classRawx(c.type), execsp, cache);
 @if(exect != _){
  execsp.dic[t] = exect;
  @return exect;
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
  @if(r != _ && isclassx(classx(r), signalc)){
   @if(classx(r).id == returnc.id){
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
 #ex = execGetx(classx(o), env.dic["envExec"])
 @if(!ex){
  log(classx(o))
  die("exec: unknown type");
 }
// log("Exec: "+ex.name)
 @return callx(ex, [o], env);
}

/////19 func parse
id2objx = &(id Str, def Objx, local Objx, global Objx)Objx{
 @if(local.dic[id] != _){
  @return objDefx(idlocalc, {
   idStr: strNewx(id),
   idState: local
  })
 }
 @if(global.dic[id] != _){
  @return objDefx(idglobalc, {
   idStr: strNewx(id),
   idState: global
  })
 }
 @if(def.dic[id] != _){
  @return objDefx(idscopec, {
   idStr: strNewx(id),
   idVal: def.dic[id]
  })
 }
 @return _
}
exec2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #v = Astx(ast[2])
 #l = classNewx()
 Objx#b = ast2objx(v, def, l, global)
 @if(!isclassx(b.obj, blockc)){
  b = preExecx(b);
 }
 #x = objDefx(execc, {
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
 #l = classNewx()
 #v = Astx(ast[1])
 Objx#b = ast2blockx(v, d, l, global);
 b.obj = blockc
 @if(len(ast) == 4){
  b.dic["blockName"] = strNewx(Str(ast[3]))
 }
 @return b
}
func2objx = &(ast Astx, def Objx, local Objx, global Objx, name Str)Objx{
 //CLASS ARGDEF RETURN BLOCK AFTERBLOCK
 #v = Astx(ast[1])
 #funcVars = @Arrx{}
 #funcVarTypes = @Arrx{}
 #newstate = classNewx() 
 @if(v[0] != _){
  #class = scopeGetx(def, Str(v[0]))
  push(funcVars, strNewx("$self"))
  push(funcVarTypes, class)
  newstate.dic["$self"] = objDefx(class)
 }
 #args = Astx(v[1])
 @foreach arg args{
  #argdef = Astx(arg)
  #varid = Str(argdef[0])
  push(funcVars, strNewx(varid))
  @if(argdef[2] != _){//defined default arg val
   Objx#varval = ast2objx(Astx(argdef[2]), def, local, global)
  }@elif(argdef[1] != _){
   #t = scopeGetx(def, Str(argdef[1]))
   @if(t == _){
    die("func2objx: arg type not defined "+Str(argdef[1]))
   }
   #varval = objDefx(t)
  }@else{
   #varval = objDefx(objc)
  }
  push(funcVarTypes, classx(varval))
  newstate.dic[varid] = varval
 }
 @if(v[3] != _){
  Objx#b = ast2blockx(Astx(v[3]), def, newstate, global);
  #x = objDefx(funcblockc, {
   funcVars: arrNewx(arrstrc, funcVars)
   funcVarTypes: arrNewx(arrc, funcVarTypes)
   funcBlock: b
  })  
  @if(v[4] != _){
   die("TODO alterblock")
  }
 }@else{
  #x = objDefx(funcprotoc, {
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
class2objx = &(ast Astx, def Objx, local Objx, global Objx, name Str)Objx{
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
 Objx#schema = ast2dicx(Astx(ast[2]), def, local, global);
 #x = classNewx(arr)
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
 @if(schema.fmid){
 //TOTEST
  #x = objDefx(callc, {
   callFunc: defmain.dic["new"]
   callArgs: arrNewx(arrc, [c, schema])
  })
 }@else{
  #x = objDefx(c, schema.dic)
 }
 @if(name != ""){
  routex(x, def, name)
 }
 @return x 
}
op2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #op = Str(ast[1])
// Str#cname = "Op"+ucfirst(op)
 
 #args = Astx(ast[2])
 Objx#arg0 = ast2objx(Astx(args[0]), def, local, global)
 #t0 = typepredx(arg0)

 #f = classGetx(t0, op);
 @if(len(args) == 1){
  @return objDefx(callc, {
   callFunc: f
   callArgs: arrNewx(arrc, [arg0])
  })
 }@else{
  Objx#arg1 = ast2objx(Astx(args[1]), def, local, global)
  //TODO convert arg1
  @return objDefx(callc, {
   callFunc: f
   callArgs: arrNewx(arrc, [arg0, arg1])
  })  
 }
 @return _
}

itemsget2objx =  &(ast Astx, def Objx, local Objx, global Objx)Objx{
 Objx#items = ast2objx(Astx(ast[1]), def, local, global)
 #itemst = typepredx(items)
 #getf = classGetx(itemst, "get")
 Objx#key = ast2objx(Astx(ast[2]), def, local, global)
 @return objDefx(callc, {
  callFunc: getf
  callArgs: arrNewx(arrc, [items, key])
 })
}
objget2objx =  &(ast Astx, def Objx, local Objx, global Objx)Objx{
 Objx#obj = ast2objx(Astx(ast[1]), def, local, global)
 @if(obj.type == @T("OBJ")){
  @return objDefx(callc, {
   callFunc: defmain.dic["get"]
   callArgs: arrNewx(arrc, [obj, strNewx(Str(ast[2]))])
  })
 }@else{
  @return
 }
}
assign2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #v = Astx(ast[1])
 #left = Astx(v[0])
 #right = Astx(v[1])
 #leftt = Str(left[0])
 @if(leftt == "id" && len(v) == 2){//define statement
  #name = Str(left[1])
  #lefto = id2objx(name, def, local, global)
  @if(lefto == _){
   @return ast2objx(right, def, local, global, name)
  }
  die("cannot defined! id already defined "+name)
  @return
 }
 @if(leftt == "objget"){
  @return 
 }
 @if(leftt == "itemsget"){
  @return 
 }
 Objx#lefto = ast2objx(left, def, local, global)
 Objx#righto = ast2objx(right, def, local, global)
 //TODO set type
 #predt = typepredx(righto)
 @if(predt != _){
  @if(classx(lefto).id == idlocalc.id){
   Str#idstr = lefto.dic["idStr"].str
   #type = local.dic[idstr]
   @if(type == _){
    local.dic[idstr] = predt
   }
  }
 }
 @if(len(v) > 2){
  #op = Str(v[2])
  #lpredt = typepredx(lefto)  
  @if(op == "add"){
   #ff = classGetx(lpredt, "concat")
   @if(ff != _){
    @return objDefx(callc, {
     callFunc: ff
     callArgs: arrNewx(arrc, [lefto, righto])
    })  
   }
  }
  #ff = classGetx(lpredt, op)
  righto = objDefx(callc, {
   callFunc: ff
   callArgs: arrNewx(arrc, [lefto, righto])   
  })
 } 
 #f = classGetx(lefto.obj, "assign")
 @return objDefx(callrawc, {
  callFunc: f
  callArgs: arrNewx(arrc, [lefto, righto])
 })
}
call2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #v = Astx(ast[1])
 Objx#f = ast2objx(v, def, local, global)
 @if(classx(f).id == idscopec.id){
  #f = f.dic["idVal"]
//  @if(isx(f.class, classc)){
//   @return objDefx(convc, {//TODO implicit vs explicit
//    convertToType: def
//    convertFrom: ast2objx(Astx(Astx(ast[2])[0]), def, local, global)
//   })
//  }
 }
 Objx#arr = ast2arrx(Astx(ast[2]), def, local, global)
 @return objDefx(callc, {
  callFunc: f
  callArgs: arr
 }) 
}
callreflect2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 @return nullv
}
callmethod2objx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 Objx#oo = ast2objx(Astx(ast[1]), def, local, global)
 Objx#to = typepredx(oo) 
 //TODO CLASS get CALL
 Objx#arr = ast2arrx(Astx(ast[3]), def, local, global)
 #f = classGetx(to, Str(ast[2]))
 unshift(arr.arr, oo)
 @return objDefx(callmethodc, {
  callFunc: f
  callArgs: arr
 })
}
ast2blockx = &(ast Astx, def Objx, local Objx, global Objx)Objx{
 #arr = @Arrx{}
 #x = objNewx(blockc)
 #dicl = dicNewx(dicuintc, @Dicx{})
 x.fdefault = @Boolean(0)
 //TODO read def function and breakpoints first
 @each i e ast{
  #ee = Astx(e)
  push(arr, ast2objx(Astx(ee[0]), def, local, global))
  @if(len(ee) == 2){
   dicl.dic[Str(ee[1])] = uintNewx(Int(i))
  }
 }
 x.dic["blockVal"] = arrNewx(arrc, arr)
 x.dic["blockStateDef"] = local
 x.dic["blockLabels"] = dicl
 @return x
}

ast2arrx = &(asts Astx, def Objx, local Objx, global Objx, class Objx)Objx{
 @if(class == _){
  class = arrc
 }
 #arrx = @Arrx{}
 #callable = 0;
 @foreach e asts{
  Objx#ee = ast2objx(Astx(e), def, local, global)
  @if(ee.fmid){
   callable = 1;
  }
  push(arrx, ee)
 }
 @if(!callable){
  @each k v arrx{
   arrx[k] = preExecx(v)
  }
 }
 #r = arrNewx(class, arrx)
 @if(callable != 0){
  r.fmid = @Boolean(1)
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
  @if(ee.fmid){
   callable = 1;
  }
  dicx[k] = ee;
 }
 @if(!callable){
  @each k v dicx{
   dicx[k] = preExecx(v)
  }
 }
 #r = dicNewx(dicc, dicx)
 @if(callable != 0){
  r.fmid = @Boolean(1)
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
  @return strNewx(Str(ast[1]))
 }@elif(t == "float"){
  @return floatNewx(float(Str(ast[1])))
 }@elif(t == "int"){
  @return intNewx(int(Str(ast[1])))
 }@elif(t == "null"){
  @return nullv
 }@elif(t == "idlocal"){
  @return objDefx(idlocalc, {
   idStr: strNewx(Str(ast[1])),
   idState: local
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
 }@elif(t == "callmethod"){
  @return callmethod2objx(ast, def, local, global)  
 }@elif(t == "callreflect"){
  @return callreflect2objx(ast, def, local, global)  
 }@elif(t == "assign"){
  @return assign2objx(ast, def, local, global)  
 }@elif(t == "func"){
  @return func2objx(ast, def, local, global, name)
 }@elif(t == "tpl"){
  #x = objDefx(functplc, {
   funcTpl: strNewx(Str(ast[1]))   
  })
  @if(len(ast) == 3){
   x.dic["funcTplName"] = strNewx(Str(ast[2]))
  }
  @if(name != ""){
   routex(x, def, name)
  }
  @return x
 }@elif(t == "arr"){
 //TODO itemsLimit itemsType
  @if(len(ast) > 2){
   #itemstype = scopeGetx(def, Str(ast[2]))
   #class = itemDefx(arrc, itemstype)
  }@else{
   #class = arrc
  }
  @return ast2arrx(Astx(ast[1]), def, local, global, class)
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
  @return objDefx(ctrlreturnc, @Dicx{
   ctrlArg: arg
  })
 }@elif(t == "itemsget"){
  @return itemsget2objx(ast, def, local, global)
 }@elif(t == "objget"){
  @return objget2objx(ast, def, local, global)
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
/////20 func def
funcDefx(defmain, "get", &(x Arrx, env Objx)Objx{
 Objx#o = x[0]
 Objx#e = x[1]
 @return objGetx(o, e.str)
},[objc, strc], cptc)
funcDefx(defmain, "exec", &(x Arrx, env Objx)Objx{
 Objx#l = x[0];
 Objx#r = x[1];
 @return execx(l, r)
}, [cptc, envc], cptc)
funcDefx(defmain, "log", &(x Arrx, env Objx)Objx{
 Objx#o = x[0];
 T#t = o.type
 @if(t == @T("INT")){
  log(o.int) 
 }@elif(t == @T("FLOAT")){
  log(Float(o.val))
 }@elif(t == @T("STR")){
  log(o.str)
 }@else{
  log("log unknown")
  log(o.obj)
  log(o)
 }
 @return nullv
}, [cptc])
/////21 method def
methodDefx(arrc, "push", &(x Arrx, env Objx)Objx{
 Objx#o = x[0]
 Objx#e = x[1] 
 push(o.arr, e)
 @return nullv
},[objc])
/////22 op def
opDefx(arrc, "get", &(x Arrx, env Objx)Objx{
 Objx#o = x[0]
 Objx#e = x[1]
 @return o.arr[e.int]
},strc, cptc, opgetc)
opDefx(dicc, "get", &(x Arrx, env Objx)Objx{
 Objx#o = x[0]
 Objx#e = x[1]
 @return o.dic[e.str]
},strc, cptc, opgetc)
opDefx(idlocalc, "assign", &(x Arrx, env Objx)Objx{
 Objx#l = x[0];
 Objx#r = x[1];  
 #v = execx(r, env)
 Objx#local = env.dic["envLocal"]
 #str = l.dic["idStr"]
 local.dic[str.str] = v 
 @return v
}, cptc, cptc, opassignc)
opDefx(strc, "add", &(x Arrx, env Objx)Objx{
 Objx#l = x[0];
 Objx#r = x[1];
 @return strNewx(l.str + r.str)
}, strc, strc, opaddc)
opDefx(intc, "add", &(x Arrx, env Objx)Objx{
 Objx#l = x[0];
 Objx#r = x[1];
 @return intNewx(l.int + r.int)
}, intc, intc, opaddc)
opDefx(strc, "concat", &(x Arrx, env Objx)Objx{
 Objx#l = x[0];
 Objx#r = x[1];
 l.str += r.str
 @return l
}, strc, strc, opconcatc)
/////23 exec def
execDefx = &(name Str, f Funcx)Objx{
 #fn = funcNewx(f, [objc], objc)
 routex(fn, execmain, name);
 @return fn
}
execDefx("Exec", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 #global = classNewx()
 global.dic["$global"] = env.dic["envGlobal"]
 global.dic["$tplglobal"] = objNewx(classNewx())
 #env = objDefx(envc, {
  envGlobal: objNewx(global)
  envLocal: objNewx(c.dic["execLocal"])
  envStack: arrNewx(arrc, @Arrx{})
  envExec: c.dic["execScope"]
 })
 #r = blockExecx(c.dic["execBlock"], env);
 //process signal TODO!!!
 @return r;
})
execDefx("Call", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 Arrx#args = c.dic["callArgs"].arr
 #argsx = @Arrx{}
 @foreach arg args{
  #t = execx(arg, env);
  push(argsx, t)
 }
 @return callx(c.dic["callFunc"], argsx, env)
})
execDefx("CallRaw", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 Arrx#args = c.dic["callArgs"].arr
 @return callx(c.dic["callFunc"], args, env)
})
execDefx("Obj", &(x Arrx, env Objx)Objx{
 @return x[0]
})
execDefx("Class", &(x Arrx, env Objx)Objx{
 @return x[0]
})
execDefx("Val", &(x Arrx, env Objx)Objx{
 @return x[0]
})
execDefx("CtrlReturn", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 #f = execx(c.dic["ctrlArg"], env)
 @return objDefx(returnc, {
  return: f
 })
})
execDefx("IdScope", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 @return objGetx(c, "idVal")
})
execDefx("IdLocal", &(x Arrx, env Objx)Objx{
 Objx#c = x[0]
 Objx#l = env.dic["envLocal"]
 Str#k = c.dic["idStr"].str
 @return l.dic[k]
})

/////24 main func
#global = classNewx()
#local = classNewx()
Str#fc = fileRead(osArgs(1))
#main = progl2objx("@exec|{"+fc+"}'"+osArgs(1)+"'", defmain, local, global)
#env = objDefx(envc, {
 envGlobal: objNewx(global)
 envLocal: objNewx(local)
 envStack: arrNewx(arrc, @Arrx{})
 envExec: execmain
})
execx(main, env);