emptyreturnc := classDefx(defmain, "EmptyReturn")//return empty mean no return
emptyreturnv := objNewx(emptyreturnc)
emptyreturnc.fstatic = @true
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

/////10 def mid

callc := classDefx(defmain, "Call", [midc])
callc.ctype = T##CALL

callpassrefc := curryDefx(defmain, "CallPassRef", callc)

callrawc := curryDefx(defmain, "CallRaw", callc)
calltypec := curryDefx(defmain, "CallType", callrawc)
callassignc := curryDefx(defmain, "CallAssign", callrawc)

callmethodc := curryDefx(defmain, "CallMethod", callc)
callreflectc := curryDefx(defmain, "CallReflect", callc)

