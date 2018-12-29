T := @enum CPT OBJ CLASS NULL INT FLOAT NUMBIG STR DIC ARR NATIVE CALL FUNC BLOCK ID IF FOR EACH CTRL
Funcx := @type ->(Arrx, Cptx)Cptx
Cptx => {
 type: T
 ctype: T
 
 fmid: Bool//is mid?
 fdefault: Bool//is default?
 fprop: Bool //is method?
 fstatic: Bool //cptc cptv nullc nullv emptyc ...
 fast: Bool //defined in ast
 farg: Bool //TODO rm

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

