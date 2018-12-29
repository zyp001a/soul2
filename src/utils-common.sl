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
arrCopyx ->(o Arrx)Arrx{
 @if(o == _){ @return }
 #n = &Arrx
 @each _ e o{
  n.push(e)
 }
 @return n;
}
dicCopyx ->(o Dicx)Dicx{
 @if(o == _){ @return }
 #n = &Dicx
 @each k v o{
  n[k] = v
 }
 @return n
}
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
dynEnsure ->(v Cptx)Cptx{
 @if(v.fast){
  #x = copyx(v)
  x.fast = @false
  @return x
 }
 @return v
}
escapex ->(s Str)Str{
 @return s.replace("\\", "\\\\").replace("\n", "\\n").replace("\t", "\\t").replace("\r", "\\r").replace("\"", "\\\"")
}
//TODO no recursive dirWritex
dirWritex ->(d Str, dic Dicx){
 @each k v dic{
  @if(v.type == T##STR){
   #x = File(d + k)
   x.write(v.str)
   
  }@elif(v.type == T##DIC){
   dirWritex(d + k, v.dic)
  }@else{
   log(dic2strx(dic))
   die("wrong dic for dirWrite")
  }
 } 
}
appendClassx ->(o Cptx, c Cptx){
 @each _ k keys(c.dic).sort(){
  @if(o.dic[k] == _){
   o.arr.push(strNewx(k))
   o.dic[k] = c.dic[k]   
  }
 }
 @each _ v c.arr{
  appendClassx(o, v)
 }
}
ifcheckx ->(r Cptx)Bool{
 @if(r.type == T##INT){
  @return r.int != 0
 }
 @return r.type != T##NULL
}
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
routex ->(o Cptx, scope Cptx, name Str)Cptx{
 //TODO route name should not contain $
 #dic = scope.dic;
 dic[name] = o 
 o.name = name;
 o.class = scope
 @return o
}
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

funcSetClosurex ->(func Cptx){
 func.obj.arr[1] = funcclosurec
}
funcSetOpx ->(func Cptx, op Cptx){
 func.obj.arr.push(op)
}
checkid ->(id Str, local Cptx, func Cptx)Cptx{
 #r = getx(local, id)
 @if(r != _){
  #r = local.dic[id]
  @if(r == _){
   die("checkid: "+id + " used in parent block");
  }
  @return r
 }
 @return _
}
valuesx ->(o Cptx)Cptx{
 #arr = &Arrx
 @each _ k o.arr{
  Cptx#v = o.dic[k.str]
  arr.push(v)
 }
 #it = getx(o, "itemsType");
 @if(it == _){
  #c = arrc
 }@else{
  #c = itemDefx(arrc, classx(it))
 }
 @return arrNewx(c, arr) 
}
prepareArgsx ->(args Arrx, f Cptx, env Cptx)Arrx{
 #argsx = &Arrx
 @if(!inClassx(classx(f), functplc)){ //fill args
  Arrx#vartypes = getx(f, "funcVarTypes").arr
  @each i argdef vartypes{
   @if(Int(i) < args.len()){
    #t = passx(execx(args[i], env))
   }@else{
    t = copyx(argdef)
   }
   argsx.push(t)
  }
 }@else{
  @each _ arg args{
   #x = passx(execx(arg, env))
   argsx.push(x)
  }
 }
 @return argsx
}
prepareArgsRefx ->(args Arrx, f Cptx, env Cptx)Arrx{
 #argsx = &Arrx
 @if(!inClassx(classx(f), functplc)){ //fill args
  Arrx#vartypes = getx(f, "funcVarTypes").arr
  @each i argdef vartypes{
   @if(Int(i) < args.len()){
    #t = execx(args[i], env)
   }@else{
    t = argdef
   }
   argsx.push(t)
  }
 }@else{
  @each _ arg args{
   #x = passx(execx(arg, env))
   argsx.push(x)
  }
 }
 @return argsx
}
