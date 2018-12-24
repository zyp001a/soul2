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

/////2 common func ...
uidi := Uint(0);
uidx ->()Str{
 Str#r = Str(uidi)
 uidi += 1
 @return r;
}
dicOrx ->(x Dicx)Dicx{
 @if(!x){
  @return &Dicx
 }@else{
  @return x
 }
}
arrOrx ->(x Arrx)Arrx{
 @if(!x){
  @return &Arrx
 }@else{
  @return x
 }
}
_indentx := ""
indx ->(s Str, first Int)Str{
 @if(s == ""){
  @return s
 }
 Arr_Str#arr = s.split("\n")
 #r = ""
 @if(first == 0){
  #r += _indentx
 }
 @each i x arr{
  @if(i != 0 && x != ""){
   r += "\n"
   r += _indentx
  }
  r += x
 }
 @return r
}

/////3 root newfuncs
root := &Dicx
parentMakex ->(o Cptx, parentarr Arrx){
 @if parentarr != _ {
  T#ctype = o.ctype
  @each _ e parentarr{
   //TODO reduce
   @if(e.id == ""){
    die("no id")
   }
   @if(e.ctype > ctype){
    ctype = e.ctype
   }
  }
  o.arr = parentarr
  o.ctype = ctype
 }@else{
  @if(o.arr == _){
   o.arr = &Arrx
  }
 }
}
classNewx ->(arr Arrx, dic Dicx)Cptx{
 #r = &Cptx{
  type: T##CLASS
  ctype: T##OBJ
  id: uidx() 
 }
 r.dic = dicOrx(dic)
 parentMakex(r, arr)
 @return r;
}

strNewx ->(x Str)Cptx{
 @return &Cptx{
  type: T##STR
  str: x
 }
}
dicNewx ->(class Cptx, dic Dicx, arr Arrx)Cptx{
 #r = &Cptx{
  type: T##DIC
  obj: class
  id: uidx()
  dic: dicOrx(dic)
  arr: arrOrx(arr)
 }
 @if(arr == _){ 
  @if(dic != _){   
   @each k _ dic{
    r.arr.push(strNewx(k))
   }
  }@else{
   r.arr = &Arrx
  }
 }@else{
  r.arr = arr
 }
 @return r
}

nsNewx ->(name Str)Cptx{
 Cptx#x = dicNewx()
 x.name = "Ns_" + name
 x.str = name
 @return x;
}

scopeNewx ->(ns Cptx, name Str)Cptx{
 Cptx#x = classNewx()
 x.name = "Scope_" + ns.str + "_" + name
 x.str = ns.str + "/" + name
 @if(ns.dic[name] == _){
  ns.arr.push(strNewx(name))
 }
 ns.dic[name] = x
 @return x;
}

