passx ->(v Cptx)Cptx{
 @if(inClassx(classx(v), valc)){
  @return copyx(v)
 }
 @return v
}
nullOrx ->(x Cptx)Cptx{
 @if(x == _){
  @return nullv
 }
 @return x
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
itemDefx ->(class Cptx, type Cptx, mid Bool)Cptx{
 @if(type != _ && type.id != cptc.id){
  type = aliasGetx(type)
  Str#n = class.name+"_"+type.name
  Cptx#r = classGetx(defmain, n)
  @if(r == _){
   #r = classDefx(defmain, n, [class], {itemsType: type})  
  }
 }@else{
  r = class
 }
 @if(mid){
  @return classDefx(defmain, n, [r, midc])
 }
 @return r;
}
fpDefx ->(types Arrx, return Cptx)Cptx{
 #n = "FuncProto"
 @each _ v types{
  #n += "_" + aliasGetx(classx(v)).name
 }
 #n += "__"+return.name
 #x = classGetx(defmain, n);
 @if(x == _){
  #x = curryDefx(defmain, n, funcprotoc, {
   funcVarTypes: arrNewx(arrc, types)
   funcReturn: return
  })
 }
 @return x
}
funcSetClosurex ->(func Cptx){
 func.obj.arr[1] = funcclosurec
}
aliasDefx ->(scope Cptx, key Str, class Cptx)Cptx{
 #x = classDefx(scope, key, [aliasc, class])
 @return x
}
aliasGetx ->(c Cptx)Cptx{
 @if(c.arr == _){
  log(strx(c))
  die("wrong cpt")
 }
 @if(c.arr.len() > 1){
  @if(c.arr[0].id == aliasc.id){  
   @return aliasGetx(c.arr[1])
  }
 }
 @return c
}

