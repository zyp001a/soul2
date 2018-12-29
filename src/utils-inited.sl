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
