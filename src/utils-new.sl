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
nativeNewx ->(f Funcx)Cptx{
 @return &Cptx{
  type: T##NATIVE
  id: uidx()    
  val: f
 } 
}
callNewx ->(func Cptx, args Arrx, obj Cptx)Cptx{
 @return &Cptx{
  type: T##CALL
  id: uidx()
  fmid: @true
  obj: obj  
  class: func
  arr: arrOrx(args)
 }
}
funcNewx ->(val Funcx, argtypes Arrx, return Cptx)Cptx{
 @if(return == _){
  return = emptyreturnc
 }
 Arrx#arr = &Arrx
 @each _ v argtypes{
  arr.push(defx(v))
 } 
 #fp = fpDefx(arr, return)
 @if(val != _){
  Cptx#x = classNewx([fp, funcnativec])
  x.dic["funcNative"] = nativeNewx(val)  
 }@else{
  #x = classNewx([fp])
 }
 @return objNewx(x)
}
uintNewx ->(x Int)Cptx{
 @return &Cptx{
  type: T##INT
  obj: uintc
  int: x
 }
}
boolNewx ->(x Bool)Cptx{
 @if(x){
  @return truev
 }
 @return falsev;
}
