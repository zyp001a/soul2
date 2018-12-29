//field usage
//*.obj ->the class of obj
//*.class ->the class of method/prop

///cache usage
//func.val: cache state(nlocal)
//items.val: cache init expr
//class.obj: cache single instance

///special usage
//method.str: store pure name
//ns.str: store pure name
//scope.str: store pure name
//call.class: func
//env.int: active

@load "init-global"
@load "init-main"


@load "init-val"
@load "init-items"

enumc := classDefx(defmain, "Enum", [uintc], {
 enum: arrstrc
 enumDic: dicuintc
})
bufferc := classDefx(defmain, "Buffer", [strc])
jsonc := classDefx(defmain, "Json", [dicc])
jsonarrc := classDefx(defmain,, "JsonArr", [arrc])
/////7 def items
pathc := classDefx(defmain, "Path", _, {
 path: strc
})
filec := classDefx(defmain, "File", [pathc])
dirc := classDefx(defmain, "Dir", [pathc])

@load "init-call"
@load "init-id"
@load "init-op"
@load "init-ctrl"

envc := classDefx(defmain, "Env", _, {
 envStack: arrc
 envLocal: objc
 
 envExec: classc 
 envBlock: blockmainc
})


@load "utils-common"
@load "utils-new"

@load "utils-def"
@load "utils-oop"
@load "utils-cpt"
@load "utils-log"
@load "utils-exec"
@load "utils-ast"

@load "def-func"
@load "def-method"
@load "def-op"
@load "def-exec"
