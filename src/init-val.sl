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
