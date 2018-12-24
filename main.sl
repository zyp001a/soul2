///cache usage
//functpl.val: cache ast(progl2ast from str)
//func.val: cache state(nlocal)
//items.val: cache init expr
//class.obj: cache single instance
//class.str: ns, scope, str
/////1 set class/structs
T := @enum CPT OBJ CLASS NULL INT FLOAT NUMBIG STR DIC ARR VALFUNC
Dicx := @type Dic Cptx
Arrx := @type Arr Cptx
Cptx => {
 type: T
 ctype: T
 
 fmid: Bool
 fdefault: Bool
 
 name: Str
 id: Str
 scope: Cptx 

 obj: Cptx
 dic: Dicx
 arr: Arrx
 str: Str
 int: Int
 val: Cpt
}
Astx := @type ArrStatic Cpt

uidi := Uint(0);
uidx -> ()Str{
 Str#r = Str(uidi)
 uidi += 1
 @return r;
}
