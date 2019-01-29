T := @enum CPT OBJ CLASS TOBJ \
 INT FLOAT NUMBIG STR BYTES\
 ARR DIC\
 ID CALL
//ID is superior than call becasue CallId exists
Funcx ->(Arrx, Cptx)Cptx
Cptx => {
 type: T
 ctype: T
 
 fmid: Bool//is mid?
 fdefault: Bool//is default?
 //for class and func
 fprop: Bool //is method?
 
 fstatic: Bool //cptc cptv nullc nullv emptyc ...
 //for any
 fast: Bool //defined in ast
 //for tobj
 farg: Bool //is arg

 //for class
 fbitems: Bool //is basic items like Arr Dic Json? 
 fbnum: Bool //is basic number?
 fscope: Bool //is scope?

 //for func
 fraw: Bool //is raw func?(callraw, not eval args)

 fdefmain: Bool //is force exec with defmain

 ast: Astx
 
 name: Str
 id: Uint
 id2: Uint 
 class: Cptx 

 obj: Cptx
 pred: Cptx //cache type pred
 
 dic: Dicx
 arr: Arrx
 str: Str
 bytes: Bytes
 int: Int
// func: Funcx
 val: Cpt
}
Dicx := @type Dic Cptx
Arrx := @type Arr Cptx
Astx := @type JsonArr

version := 100

uidi := Uint(1);
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
emptyc := classDefx(defmain, "Empty")//return empty mean no return
emptyv := objNewx(emptyc)
emptyv.fstatic = @true
unknownc := classDefx(defmain, "Unknown")//return empty mean no return
unknownv := objNewx(unknownc)
unknownv.fstatic = @true
nullc := classDefx(defmain, "Null")
nullv := objNewx(nullc)
nullv.fstatic = @true
//cpt: all (anything, everything)
//empty: no (no return, not exist
//unknown: unknown(js-undefined)
//null: null(obj not init)
//val: pass by val
//items: set, collection of same type
//mid: runtime obj
//call, func, block, arrcall: for exec


objc := classNewx();
routex(objc, defmain, "Obj");
objc.ctype = T##OBJ

classc := classNewx();
routex(classc, defmain, "Class");
classc.ctype = T##CLASS

tobjc := classNewx();
routex(tobjc, defmain, "TObj");
tobjc.ctype = T##TOBJ

nativec := classDefx(defmain, "Native")
midc := classDefx(defmain, "Mid")
//midc must defined before itemsDefx

//alias is id processed in lex scope
aliasc := classDefx(defmain, "Alias")

//init val
valc := classDefx(defmain, "Val")
numc := classDefx(defmain, "Num", [valc])

intc := bnumDefx("Int", numc)
intc.ctype = T##INT
uintc := bnumDefx("Uint", intc)

floatc := bnumDefx("Float", numc)
floatc.ctype = T##FLOAT


boolc := bnumDefx("Bool", uintc)

bytec := bnumDefx("Byte", intc)

bnumDefx("Int16", intc)
bnumDefx("Int32", intc)
bnumDefx("Int64", intc)

bnumDefx("Uint8", uintc)
bnumDefx("Uint16", uintc)
bnumDefx("Uint32", uintc)
bnumDefx("Uint64", uintc)

bnumDefx("Float32", floatc)
bnumDefx("Float64", floatc)

numbigc := classDefx(defmain, "NumBig", [numc, nativec])
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
 itemsLimitedLen: uintc
})
arrc := curryDefx(defmain, "Arr", itemsc)
arrc.ctype = T##ARR
arrc.fbitems = @true
arrc.str = arrc.name

staticarrc := curryDefx(defmain, "StaticArr", arrc)
staticarrc.fbitems = @true
staticarrc.str = staticarrc.name

dicc := curryDefx(defmain, "Dic", itemsc)
dicc.ctype = T##DIC
dicc.fbitems = @true
dicc.str = dicc.name

/////8 advanced type init: string, enum, unlimited number...
bytesc := itemsDefx(staticarrc, bytec)
bytesc.ctype = T##BYTES

strc := curryDefx(defmain, "Str")
strc.ctype = T##STR

arrstrc := itemsDefx(arrc, strc)
dicstrc := itemsDefx(dicc, strc)
dicuintc := itemsDefx(dicc, uintc)
dicclassc := itemsDefx(dicc, classc)
arrclassc := itemsDefx(arrc, classc)


errc := classDefx(defmain, "Err", [strc])
rawc := classDefx(defmain, "Raw", [strc])
//def path
pathc := classDefx(defmain, "Path", [strc])


//init misc type
enumc := classDefx(defmain, "Enum", [uintc], {
 enum: arrstrc
 enumDic: dicuintc
})
timec := classDefx(defmain, "Time", [uintc])

jsonc := classDefx(defmain, "Json", [dicc])
jsonarrc := classDefx(defmain, "JsonArr", [arrc])

stackc := classDefx(defmain, "Stack", [arrc])
stackc.fbitems = @true
queuec := classDefx(defmain, "Queue", [arrc])
queuec.fbitems = @true


//init call

funcc := classDefx(defmain, "Func")
funcprotoc := classDefx(defmain, "FuncProto", [funcc], {
 funcVarTypes: arrc
 funcReturn: classc
})
funcvarsc  := classDefx(defmain, "FuncProto", [funcprotoc], {
 funcVars: arrstrc
})

funcnativec := classDefx(defmain, "FuncNative", [funcvarsc, nativec])

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


////init signal
signalc := classDefx(defmain, "Signal");
continuec := curryDefx(defmain, "Continue", signalc)
breakc := curryDefx(defmain, "Break", signalc)
gotoc := classDefx(defmain, "Goto", [signalc], {
 goto: uintc
})
returnc := classDefx(defmain, "Return", [signalc], {
 return: cptc
})


funcblockc := classDefx(defmain, "FuncBlock", [funcc], {
 funcBlock: blockc
})
funcstdc := classDefx(defmain, "FuncStd", [funcblockc, funcvarsc], {
 funcErrFunc: fpDefx([defx(errc), defx(strc)], boolc)
})
handlerc := classDefx(defmain, "Handler", [funcblockc])
funcclosurec := curryDefx(defmain, "FuncClosure", funcstdc)

functplc := classDefx(defmain, "FuncTpl", [funcc], {
 funcTplBlock: blockc
 funcTplPath: strc
})


////concurrency
channelc := classDefx(defmain, "Channel", [nativec])

////////////def stream and handlers
streamc := classDefx(defmain, "Stream", [nativec], {
 streamReadable: boolc
 streamWritable: boolc
})
bufferc := classDefx(defmain, "Buffer", [streamc])
builderstrc := classDefx(defmain, "BuilderStr", [nativec])

//add
//subtract
//parent

//handler is the basic unit for soul

routerc := classDefx(defmain, "Router", [itemsc], {
 itemsType: bytesc
 routerPath: pathc
})
routerc.fbitems = @true
//get
//set
//select 
//update
//rm

routerrootedc := classDefx(defmain, "RouterRooted", [routerc])
routerrootedc.dic["routerRoot"] = defx(routerrootedc)


///////def os and network abstract type
///inet in soul

ipc := classDefx(defmain, "Ip", [pathc])
ip6c := classDefx(defmain, "Ip6", [ipc])

pathfsc := curryDefx(defmain, "PathFs", pathc)
dirc := classDefx(defmain, "Dir", [routerrootedc], {
 routerPath: pathfsc
})
fsv := defx(dirc, {
 routerPath: strNewx("", pathfsc)
})
fsv.fstatic = @true
fsv.dic["treeRoot"] = fsv


schemac := curryDefx(defmain, "Schema", pathc)
dbmsc := classDefx(defmain, "Dbms", [routerrootedc], {
 itemsType: schemac
})


procc := classDefx(defmain, "Proc", [routerc])

netc := classDefx(defmain, "Net", [routerc], {
 routerPath: ipc
})
netv := defx(netc)
netv.fstatic = @true


stdinc := curryDefx(defmain, "Stdin", streamc, {
 streamReadable: boolNewx(@true)
})
stdoutc := curryDefx(defmain, "Stdout", streamc, {
 streamWritable: boolNewx(@true)
})
stderrc := curryDefx(defmain, "Stderr", streamc, {
 streamWritable: boolNewx(@true)
})
stdinv := defx(stdinc)
stdoutv := defx(stdoutc)
stderrv := defx(stderrc)

soulc := classDefx(defmain, "Soul", _, {
 soulIsSelf: boolc
 soulFs: dirc
 soulNet: netc
 soulProc: procc
})
soulsubc := curryDefx(defmain, "SoulSub", soulc)
soulv := defx(soulc, {
 soulIsSelf: boolNewx(@true)
 soulFs: fsv
 soulNet: netv
})



//impl type
protocolc := classDefx(defmain, "Protocol", _, {
 protocolName: strc
 protocolDefaultPort: uintc
})
httpc := curryDefx(defmain, "Http", protocolc, {
 protocolName: strNewx("http")
 protocolDefaultPort: intNewx(80, uintc)
})
httpsc := curryDefx(defmain, "Http", protocolc, {
 protocolName: strNewx("https")
 protocolDefaultPort: intNewx(443, uintc)
})

serverc := classDefx(defmain, "Server")
clientc := classDefx(defmain, "Client")
reqc := classDefx(defmain, "Req", [streamc])
respc := classDefx(defmain, "Resp", [streamc])

serverhttpc := classDefx(defmain, "ServerHttp", [serverc, httpc])
clienthttpc := classDefx(defmain, "ClientHttp", [clientc, httpc])
handlerhttpc := handlerDefx(fpDefx([defx(reqc), defx(respc)]))


///// def mid

callc := classDefx(defmain, "Call", [midc])
callc.ctype = T##CALL

arrcallc := itemsDefx(arrc, callc)

callpassrefc := curryDefx(defmain, "CallPassRef", callc)

callrawc := curryDefx(defmain, "CallRaw", callc)


//init id
idc := classDefx(defmain, "Id")
callidc := classDefx(defmain, "CallId", [callc, idc])
idc.ctype = T##ID

idstrc :=  classDefx(defmain, "IdStr", [idc], {
 idStr: strc,
})
idstatec := classDefx(defmain, "IdState", [idstrc, midc], {
 idState: classc 
})
idlocalc := curryDefx(defmain, "IdLocal", idstatec)
idparentc := curryDefx(defmain, "IdParent", idstatec)
idglobalc := curryDefx(defmain, "IdGlobal", idstatec)
idargc := curryDefx(defmain, "IdArg", idlocalc)

idclassc := classDefx(defmain, "IdClass", [idstrc], {
 idVal: cptc
})
idcondc := classDefx(defmain, "IdCond", [idstrc])



//init op
opc := classDefx(defmain, "Op", [funcc], {
 opPrecedence: intc
})
op1c := classDefx(defmain, "Op1", [opc])
op2c := classDefx(defmain, "Op2", [opc])
opcmpc := classDefx(defmain, "OpCmp", [op2c])
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
opgec := curryDefx(defmain, "OpGe", opcmpc, {
 opPrecedence: intNewx(40)
})
oplec := curryDefx(defmain, "OpLe", opcmpc, {
 opPrecedence: intNewx(40)
})
opgtc := curryDefx(defmain, "OpGt", opcmpc, {
 opPrecedence: intNewx(40)
})
opltc := curryDefx(defmain, "OpLt", opcmpc, {
 opPrecedence: intNewx(40)
})
opeqc := curryDefx(defmain, "OpEq", opcmpc, {
 opPrecedence: intNewx(50)
})
opnec := curryDefx(defmain, "OpNe", opcmpc, {
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
ctrlerrc := curryDefx(defmain, "CtrlErr", ctrlargsc)


envc := classDefx(defmain, "Env", _, {
 envStack: arrc
 envLocal: objc
 
 envExec: classc 
 envBlock: blockmainc
})
