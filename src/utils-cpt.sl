classx ->(o Cptx)Cptx{
 @if(o.type == T##CLASS){
  @return o
 }
 @if(o.obj != _){
  @return o.obj
 }
 @return classRawx(o.type)
}
defaultx ->(t Cptx)Cptx{
 @if(t.ctype == T##INT){
  #tar = intNewx(0)
 }@elif(t.ctype == T##FLOAT){
  #tar = floatNewx(0.0)
 }@elif(t.ctype == T##NUMBIG){   
 }@elif(t.ctype == T##STR){
  #tar = strNewx("")
 }@else{
  #tar = nullv
 }
 @return tar
}
defx ->(class Cptx, dic Dicx)Cptx{
 @if(class.ctype == T##CPT){
  @return cptv
 }@elif(class.ctype == T##OBJ){
  @if(dic != _){
   @each k v dic{
    Cptx#t = classGetx(class, k)
    @if(t == _){
     die("defx: not in "+ class.name + " "+k)
    }
    @if(v == _){
     log(k)
     die("defx: dic val null")     
    }
    Cptx#pt = typepredx(v);
    @if(pt == _ || pt.id == cptc.id){
     @continue;
    }
    @if(!inClassx(pt, classx(t))){
     log(class.name)    
     log(k)
     log(strx(v))
     log(strx(pt))     
     log(strx(t))
     die("defx: type error")
    }
   }
   Cptx#r = objNewx(class, dic)
   @if(dic.len() != 0){
    r.fdefault = @false
   }
  }@else{
   Cptx#r = objNewx(class)
  }
  @if(midc != _){
   @if(inClassx(class, midc) ){//TODO speed up
    r.fmid = @true
   }
  }
  @return r
 }@elif(class.ctype == T##CLASS){
  @return cptc
 }@elif(class.ctype == T##NULL){
  @return nullv
 }@elif(class.ctype == T##INT){
  Cptx#x = intNewx(0)
  @if(class.name != "Int"){
   x.obj = class
  }
 }@elif(class.ctype == T##FLOAT){
  Cptx#x = floatNewx(0.0)
  @if(class.name != "Float"){
   x.obj = class
  }
 }@elif(class.ctype == T##NUMBIG){
  Cptx#x = nullv//TODO
 }@elif(class.ctype == T##STR){
  Cptx#x = strNewx("")
  @if(class.name != "Str"){
   x.obj = class
  }
 }@elif(class.ctype == T##NATIVE){
  Cptx#x = nativeNewx()
 }@elif(class.ctype == T##CALL){
  Cptx#x = callNewx()
  x.fdefault = @true     
 }@elif(class.ctype == T##FUNC){
  Cptx#x = nullv//TODO
 }@elif(class.ctype == T##BLOCK){
  Cptx#x = nullv//TODO
 }@elif(class.ctype == T##DIC){
  #x = dicNewx(class)
  x.fdefault = @true     
 }@elif(class.ctype == T##ARR){
  #x = arrNewx(class)
  x.fdefault = @true     
 }@else{
  die("unknown class type")
  @return
 }
 @return x
}

copyx ->(o Cptx)Cptx{
 @if(o.type == T##CPT){
  @return o
 }
 @if(o.type == T##NULL){
  @return o
 }
 @if(o.type == T##CLASS){
  @return o
 }
 #x = &Cptx{
  type: o.type
  ctype: o.ctype  
  fmid: o.fmid
  fdefault: o.fdefault
  fprop: o.fprop

  name: o.name
  id: uidx()
  class: o.class
  
  obj: o.obj
  
  dic: dicCopyx(o.dic)
  arr: arrCopyx(o.arr)
  str: o.str
  int: o.int
  val: o.val
 }
 @return x
}

eqx ->(l Cptx, r Cptx)Bool{
 @if(l.type != r.type){
  @return @false
 }
 #t = l.type
 @if(t == T##CPT){
  @return @true
 }@elif(t == T##NULL){
  @return @true  
 }@elif(t == T##OBJ){
  @return l.id == r.id  
 }@elif(t == T##CLASS){
  @return l.id == r.id
 }@elif(t == T##DIC){
  @return l.id == r.id
 }@elif(t == T##ARR){
  @return l.id == r.id
 }@elif(t == T##NATIVE){
  @return l.id == r.id  
 }@elif(t == T##CALL){
  @return l.id == r.id  
 }@elif(t == T##FUNC){
  @return l.id == r.id
 }@elif(t == T##BLOCK){
  @return l.id == r.id    
 }@elif(t == T##INT){
  @return l.int == r.int
 }@elif(t == T##FLOAT){
  @return Float(l.val) == Float(r.val)
 }@elif(t == T##NUMBIG){
  @return @true //TODO
 }@elif(t == T##STR){
  @return l.str == r.str
 }@else{
  log(t)
  die("wrong type")
  @return @false
 } 
}
getx ->(o Cptx, key Str)Cptx{
 @if(o.type == T##CLASS){
  #r = classGetx(o, key)
  @if(r != _){
   @return r
  }
  r = classGetx(classc, key) 
  @if(r != _){
   @return r
  }
 }@elif(o.type == T##OBJ){
  #r = o.dic[key] //getlocal1
  @if(r != _){
   @return r
  }
  r = classGetx(o.obj, key) //getlocal2
  @if(r != _){
   @return r
  }
  r = classGetx(objc, key)  //getobjc
  @if(r != _){
   @return r
  }  
 }@else{
  r = classGetx(classx(o), key)
  @if(r != _){
   @return r
  }
 }
 @return classGetx(cptc, key)
}
setx ->(o Cptx, key Str, val Cptx)Cptx{
 //TODO objSet
 @return dynEnsure(val)
}

typepredx ->(o Cptx)Cptx{
 #t = o.type
 @if(t == T##CALL){
  Cptx#f = o.class
  #args = o.arr
  @if(f == _){
   @return callc
  }
  @if(f.id == defmain.dic["new"].id){
   Cptx#arg0 = args[0]
   @return arg0
  }
  @if(f.id == defmain.dic["as"].id){
   Cptx#arg1 = args[1]
   @return arg1
  }
  @if(f.id == defmain.dic["numConvert"].id){
   Cptx#arg1 = args[1]
   @return arg1
  }
  @if(f.id == defmain.dic["type"].id){
   Cptx#arg0 = args[0]
   @return arg0
  }    
  //if is itemGet    
  @if(f.id == defmain.dic["get"].id){
   Cptx#arg0 = args[0]     
   Cptx#arg1 = args[1]
   Cptx#at0 = typepredx(arg0)
   @if(at0 == _ || at0.id == cptv.id){
    @return _
   }
   #cg = getx(at0, arg1.str)
   @if(cg == _){
    @return _;
    log(strx(arg0))
    log(strx(at0))
    die("typepred: cannot pred obj get, key is "+arg1.str)
   }
   @return classx(cg)
  }
    //if is opGet
  @if(inClassx(f.obj, opgetc)){
   Cptx#arg0 = args[0]
   Cptx#at0 = typepredx(arg0)     
   #r = getx(at0, "itemsType")
   @if(r != _){
    @return classx(r)
   }@else{
    @return cptc
   }
  }
    
  @if(inClassx(f.obj, functplc)){
   @return strc
  }

  @if(inClassx(f.obj, funcc)){
   //TODO if is dynamic funcReturn, like values, to,
   #ret = getx(f, "funcReturn")
   @if(ret == _){
    log(strx(f))
    die("no return")
   }
   @if(ret.id == emptyreturnc.id){
    @return cptc;
   }
   @return ret
  }
  @if(inClassx(f.obj, midc)){
   //TODO predict return func call
   @return _
  }
  @return _
 }@elif(t == T##OBJ){
  //if is idstate
  @if(inClassx(o.obj, idstatec)){
   Str#id = o.dic["idStr"].str
   @if(id.isInt()){
    @return cptc
   }
   Cptx#s = o.dic["idState"]
   #r = getx(s, id)
   @if(r == _){
    log(strx(s)) 
    log(id)
    die("not defined in idstate, may use #1 #2 like")
    @return r
   }
   @return typepredx(r)
  }
   //if is idscope
  @if(inClassx(o.obj, idclassc)){
   Cptx#s = o.dic["idVal"]
   @return typepredx(s)
  }
  @return o.obj
 }@else{
  @return classx(o) 
 }
}
