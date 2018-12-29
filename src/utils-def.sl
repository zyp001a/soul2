classDefx ->(scope Cptx, name Str, parents Arrx, schema Dicx)Cptx{
 Cptx#x = classNewx(parents)
 @each k v schema{
  @if(v == _){
   log(name)
   die(k)
  }
  x.dic[k] = defx(v)
 }
 routex(x, scope, name)
 @return x
}
curryDefx ->(scope Cptx, name Str, class Cptx, schema Dicx)Cptx{
 #x = classNewx([class], schema)
 routex(x, scope, name)
 @return x
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

aliasDefx ->(scope Cptx, key Str, class Cptx)Cptx{
 #x = classDefx(scope, key, [aliasc, class])
 @return x
}

funcDefx ->(scope Cptx, name Str, val Funcx, argtypes Arrx, return Cptx)Cptx{
//FuncNative new
 #fn = funcNewx(val, arrOrx(argtypes), return)
 routex(fn, scope, name);
 @return fn
}
methodDefx ->(class Cptx, name Str, val Funcx, argtypes Arrx, return Cptx)Cptx{//FuncNative new
 @if(argtypes != _){
  argtypes.unshift(class)
 }@else{
  argtypes = [class]
 }
 #fn = funcNewx(val, argtypes, return)
 fn.fprop = @true
 class.dic[name] = fn;
 fn.name = class.name + "_" + name
 fn.str = name
 @return fn
}
opDefx ->(class Cptx, name Str, val Funcx, arg Cptx, return Cptx, op Cptx)Cptx{
 #argt = &Arrx
 @if(arg != _){
  argt.push(arg)
 }
 #func = methodDefx(class, name, val, argt, return)
 funcSetOpx(func, op)
 @return func;
}
execDefx ->(name Str, f Funcx)Cptx{
 #fn = funcNewx(f, [cptc], cptc)
 routex(fn, execmain, name);
 @return fn
}
