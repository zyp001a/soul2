
cptc := classNewx();
routex(cptc, defmain, "Cpt");
cptc.ctype = T##CPT
cptc.fdefault = @true
cptc.fstatic = @true

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


emptyclassgetc := classDefx(defmain, "EmptyClassGet")//classGet none means cache
emptyclassgetv := objNewx(emptyclassgetc)
emptyclassgetc.fstatic = @true
emptyclassgetv.fstatic = @true

midc := classDefx(defmain, "Mid")
//midc must defined before itemDefx
