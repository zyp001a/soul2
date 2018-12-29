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
