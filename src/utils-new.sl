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
intNewx ->(x Int)Cptx{
 @return &Cptx{
  type: T##INT
  int: x
 }
}
arrNewx ->(class Cptx, val Arrx)Cptx{
 #x = &Cptx{
  type: T##ARR
  id: uidx()  
  obj: class
 }
 @if(val != _){
  x.arr = val
 }@else{
  x.arr = &Arrx
 }
 @return x
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
objNewx ->(class Cptx, dic Dicx)Cptx{
 @if(class.ctype != T##OBJ){
  die("objNew error, should use def")
 }
 #x = &Cptx{
  type: T##OBJ
  id: uidx()
  dic: dicOrx(dic)
  obj: class
 }
 @if(dic == _ || dic.len() == 0){
  x.fdefault = @true
 } 
 class.obj = x
 @return x;
}
scopeObjNewx ->(class Cptx)Cptx{
 @if(class.obj != _){
  @return class.obj
 }
 @return objNewx(class)
}
floatNewx ->(x Float)Cptx{
 @return &Cptx{
  type: T##FLOAT
  val: x
 }
}
