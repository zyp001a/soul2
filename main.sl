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

@load "src/init-global"
@load "src/init-main"


@load "src/init-val"
@load "src/init-items"

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

@load "src/init-call"
@load "src/init-id"
@load "src/init-op"
@load "src/init-ctrl"

envc := classDefx(defmain, "Env", _, {
 envStack: arrc
 envLocal: objc
 
 envExec: classc 
 envBlock: blockmainc
})


@load "src/utils-common"
@load "src/utils-new"

@load "src/utils-def"
@load "src/utils-oop"
@load "src/utils-cpt"
@load "src/utils-log"
@load "src/utils-exec"
@load "src/utils-ast"

@load "src/def-func"
@load "src/def-method"
@load "src/def-op"
@load "src/def-exec"

/////24 main func
#osargs = osArgs()
@if(osargs.len() == 1){
 log("./soul3 [FILE] [EXECFLAG] [DEFFLAG]")
}@else{
 Str#fc = File(osargs[1]).readAll()
 Str#execsp = "main"
 Str#defsp = "main"
 @if(osargs.len() > 2){
  #execsp = osargs[2] 
 }
 @if(osargs.len() > 3){
  #defsp = osargs[3] 
 }
 #main = progl2cptx("@env "+execsp+" | " + defsp + " {"+fc+"}'"+osargs[1]+"'", defmain)
 execx(main, main, 2)
}