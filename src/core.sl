//field usage
//*.obj ->the class of obj
//*.class ->the class of method/prop

///cache usage
//funcblock.val: cache state(nlocal)
//items.val: cache init expr
//class.obj: cache single instance
//byte.str: cache char

///special usage
//items.str: for rec
//str.int: fixed size
//method.str: store pure name
//handler-class.str: store handler class name
//ns.str: store pure name
//scope.str: store pure name
//state.str: store path
//state.int: store line no
//call.class: func
//env.int: active
//calls.class: func
//idstate.class: def
//idclass.class: val
//idarg.class: def
@load "init"

@load "utils"

@load "ast"

@load "def"
