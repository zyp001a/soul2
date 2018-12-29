nsGetx ->(ns Cptx, key Str)Cptx{
 #s = ns.dic[key];
 @if(s != _){
  @return s;
 }
 #s = scopeNewx(ns, key)
 #f = File(osEnvGet("HOME")+"/soul2/db/"+ns.str+"/"+key+".slp")
 @if(f.exists()){
  Str#fc = f.readAll()
  Arr_Str#arr = fc.split(" ")
  @each _ v arr{
   s.arr.push(nsGetx(ns, v))
  }
 }
 @return s;
}
dbGetx ->(scope Cptx, key Str)Cptx{
 #fstr = osEnvGet("HOME")+"/soul2/db/"+scope.str + "/" + key + ".sl" 
 #f = File(fstr)
 #f2 = File(fstr+"t")
 #fcache = File(fstr+".cache")
 #f2cache = File(fstr+"t.cache")  
 
 @if(f.exists()){
  Str#str = f.readAll()
  @if(f.timeMod() > fcache.timeMod()){
   Str#jstr = osCmd("./sl-reader", key + " := "+str)
   fcache.write(jstr)
  }@else{
   Str#jstr = fcache.readAll()
  }
 }@elif(f2.exists()){
  str = "@`"+f2.readAll()+"` '"+fstr+"t'";
  @if(f2.timeMod() > f2cache.timeMod()){
   Str#jstr = osCmd("./sl-reader", key + " := "+str)
   f2cache.write(jstr)
  }@else{
   Str#jstr = f2cache.readAll()
  }
 }@else{
  @return _
 }
 Astx#ast = JsonArr(jstr)
 @if(ast.len() == 0){
  die("dbGetx: wrong grammar")
 }
 Cptx#r = ast2cptx(ast, scope, classNewx())
 @return r
}
subClassGetx ->(scope Cptx, key Str, cache Dic)Cptx{
 #r = scope.dic[key]
 @if(r != _){ 
  @return r
 }
 @if(scope.str != ""){
  #r = dbGetx(scope, key);
  @if(r != _){
   scope.dic[key] = r
   @return r;
  }
 }

 @each _ v scope.arr {
  Str#k = v.id
  @if(cache[k] != _){ @continue };
  cache[k] = 1;
  r = subClassGetx(v, key, cache)
  @if(r != _){
   @return r;
  }
 }
 @return _
}
propDefx ->(scope Cptx, key Str, r Cptx)Cptx{
 Cptx#o = copyx(r)
 o.class = scope
 o.name = scope.name + "_" + key
 @return o;
}
classGetx ->(scope Cptx, key Str)Cptx{
 Cptx#r = subClassGetx(scope, key, {})
 @if(r == _){
  @if(scope.str != ""){//if class is scope
   scope.dic[key] = emptyclassgetv
  }
  @return _
 }@elif(r.id == emptyclassgetv.id){
  @return _
 }
 @if(r.fprop){
  @return propDefx(scope, key, r)
 }
 @return r;
}

subMethodGetx ->(scope Cptx, v Cptx, key Str)Cptx{
 #r = classGetx(scope, v.name + "_" + key);
 @if(r != _){
  @return r
 }
 @each _ vv v.arr{
  r = subMethodGetx(scope, vv, key)
  @if(r != _){
   @return r
  }
 }
 @return r
}
methodGetx ->(scope Cptx, func Cptx)Cptx{
 Cptx#r = classGetx(scope, func.name);
 @if(r != _){
  @return r  
 }

 Cptx#o = func.class
 Arrx#p = o.arr
 @each _ v p{
  r = subMethodGetx(scope, v, func.str)
  @if(r != _){
   @return r
  }
 }

 r = subMethodGetx(scope, classc, func.str)
 @if(r != _){
  @return r
 }  

 r = subMethodGetx(scope, cptc, func.str)
 @if(r != _){
  @return r
 }   
 @return _
}
classRawx ->(t T)Cptx{
 @if(t == T##CPT){
  @return cptc
 }@elif(t == T##OBJ){
  @return objc
 }@elif(t == T##CLASS){
  @return classc
 }@elif(t == T##NULL){
  @return nullc
 }@elif(t == T##INT){
  @return intc
 }@elif(t == T##FLOAT){
  @return floatc  
 }@elif(t == T##NUMBIG){
  @return numbigc
 }@elif(t == T##STR){
  @return strc
 }@elif(t == T##DIC){
  @return dicc
 }@elif(t == T##ARR){
  @return arrc
 }@elif(t == T##NATIVE){
  @return nativec
 }@elif(t == T##CALL){
  @return callc
 }@elif(t == T##FUNC){
  @return funcc
 }@elif(t == T##BLOCK){
  @return blockc
 }@else{
  die("NOTYPE")
 }
 @return _
}
inClassx ->(c Cptx, t Cptx, cache Dic)Bool{
 @if(c.type != T##CLASS){
  log(strx(c) )
  die("inClass: left not class")
 }
 @if(t.type != T##CLASS){
  log(strx(t) )
  die("inClass: right not class")
 }
 @if(t.id == cptc.id){//everything is cpt
  @return @true
 }
 @if(t.id == objc.id && c.ctype == T##OBJ){
  @return @true
 }
 @if(c.id != "" && c.id == t.id){
  @return @true
 }
 #key = c.id + "_" + t.id
 #r = inClassCache[key]
 @if(r == 1){
  @return @true
 }
 @if(r == 2){
  @return @false
 }
 @if(!cache){
  cache = {}
 }
 @each _ v c.arr{
  @if(cache[v.id] != _){
   @continue
  }
  cache[v.id] = 1
  @if(inClassx(v, t, cache)){
   inClassCache[key] = 1
   @return @true
  }
 }
 inClassCache[key] = 2
 @return @false
}
parentClassGetx ->(o Cptx, key Str)Cptx{
 @if(o.arr == _){
  @return _
 }
 @each _ v o.arr{
  Dicx#d = v.dic
  Cptx#r = d[key]
  @if(r != _){
   @return v
  }
  r = parentClassGetx(v, key)
  @if(r != _){
   @return r
  }
 }
 @return _;
}
