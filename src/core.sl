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
//calls.class: func
//idstate.class: def
//idclass.class: val
@load "init"

@load "utils"

@load "ast"

@load "def"
