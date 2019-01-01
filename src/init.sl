T := @enum CPT OBJ CLASS TOBJ NULL \
 INT FLOAT NUMBIG STR DIC ARR \
 NATIVE CALL ID FUNC BLOCK \
 IF FOR SIGNAL
Funcx ->(Arrx, Cptx)Cptx
Cptx => {
 type: T
 ctype: T
 
 fmid: Bool//is mid?
 fdefault: Bool//is default?
 fprop: Bool //is method?
 fstatic: Bool //cptc cptv nullc nullv emptyc ...
 fast: Bool //defined in ast
 farg: Bool //is arg
 fbitems: Bool //is basic element?

 ast: Astx
 
 name: Str
 id: Str
 class: Cptx 

 obj: Cptx
 dic: Dicx
 arr: Arrx
 str: Str
 int: Int
// func: Funcx
 val: Cpt
}
Dicx := @type Dic Cptx
Arrx := @type Arr Cptx
Astx := @type JsonArr

version := 100

uidi := Uint(0);
_indentx := " "

inClassCache := {}Int

root := &Dicx
defns := nsNewx("def")
defmain := scopeNewx(defns, "main")
execns := nsNewx("exec")
execmain := scopeNewx(execns, "main")
tplmain := classNewx([defmain])

_osArgs := Cptx()


//init main
cptc := classNewx();
routex(cptc, defmain, "Cpt");
cptc.ctype = T##CPT
cptc.fdefault = @true

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

tobjc := classNewx();
routex(tobjc, defmain, "TObj");
tobjc.ctype = T##TOBJ


emptyclassgetc := classDefx(defmain, "EmptyClassGet")//classGet none means cache
emptyclassgetv := objNewx(emptyclassgetc)
emptyclassgetv.fstatic = @true

midc := classDefx(defmain, "Mid")
//midc must defined before itemDefx

//init val
valc := classDefx(defmain, "Val")
nullv := &Cptx{
 type: T##NULL
 fdefault: @true
 fstatic: @true 
 id: uidx()
}
nullc := classDefx(defmain, "Null")
nullc.ctype = T##NULL
numc := classDefx(defmain, "Num", [valc])
intc := classDefx(defmain, "Int", [numc])
intc.ctype = T##INT
uintc := classDefx(defmain, "Uint", [intc])
floatc := classDefx(defmain, "Float", [numc])
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

//init items
itemsc := classDefx(defmain, "Items", _, {
 itemsType: cptc
})
itemslimitedc := classDefx(defmain, "ItemsLimited", [itemsc], {
 itemsLimitedLength: uintc
})
arrc := curryDefx(defmain, "Arr", itemsc)
arrc.ctype = T##ARR
arrc.fbitems = @true

staticarrc := curryDefx(defmain, "StaticArr", arrc)
staticarrc.fbitems = @true

dicc := curryDefx(defmain, "Dic", itemsc)
dicc.ctype = T##DIC
dicc.fbitems = @true

/////8 advanced type init: string, enum, unlimited number...
bytesc := itemDefx(arrc, bytec)
bytesc.ctype = T##STR
bytesc.arr.push(valc)
strc := curryDefx(defmain, "Str", bytesc)


arrstrc := itemDefx(arrc, strc)
dicstrc := itemDefx(dicc, strc)
dicuintc := itemDefx(dicc, uintc)
dicclassc := itemDefx(dicc, classc)
arrclassc := itemDefx(arrc, classc)


//init misc type
enumc := classDefx(defmain, "Enum", [uintc], {
 enum: arrstrc
 enumDic: dicuintc
})

jsonc := classDefx(defmain, "Json", [dicc])
jsonarrc := classDefx(defmain,, "JsonArr", [arrc])
jsonarrc.fbitems = @true

bufferc := classDefx(defmain, "Buffer", [strc])
pathc := classDefx(defmain, "Path", _, {
 path: strc
})
filec := classDefx(defmain, "File", [pathc])
dirc := classDefx(defmain, "Dir", [pathc])

//init call
emptyreturnc := classDefx(defmain, "EmptyReturn")//return empty mean no return
emptyreturnv := objNewx(emptyreturnc)
emptyreturnv.fstatic = @true

funcc := classDefx(defmain, "Func")
funcprotoc := classDefx(defmain, "FuncProto", [funcc], {
 funcVarTypes: arrc
 funcReturn: classc
})
nativec := classDefx(defmain, "Native")
nativec.ctype = T##NATIVE
funcnativec := classDefx(defmain, "FuncNative", [funcprotoc], {
 funcNative: nativec
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
 funcTplBlock: blockc
 funcTplPath: strc
})

//elements
elemc := classDefx(defmain, "Elem")
routerc := classDefx(defmain, "Router", [elemc])
msgc := classDefx(defmain, "Msg", _, {
 msgSrc: elemc
 msgContent: cptc
 
})

/////10 def mid

callc := classDefx(defmain, "Call", [midc])
callc.ctype = T##CALL

callpassrefc := curryDefx(defmain, "CallPassRef", callc)

callrawc := curryDefx(defmain, "CallRaw", callc)
calltypec := curryDefx(defmain, "CallType", callrawc)
callassignc := curryDefx(defmain, "CallAssign", callrawc)

callmethodc := curryDefx(defmain, "CallMethod", callc)
callreflectc := curryDefx(defmain, "CallReflect", callc)


//init id
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

//alias is id processed in lex scope
aliasc := classDefx(defmain, "Alias")

//init op
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

//init ctrl
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


envc := classDefx(defmain, "Env", _, {
 envStack: arrc
 envLocal: objc
 
 envExec: classc 
 envBlock: blockmainc
})
