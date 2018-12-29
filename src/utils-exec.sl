tplCallx ->(func Cptx, args Arrx, env Cptx)Cptx{
// log(func.dic["funcTplPath"].str)
 #b = func.dic["funcTplBlock"]
 @if(b == _){
  @return strNewx("")
 }

 #localx = b.dic["blockStateDef"]
 #nstate = objNewx(localx)
 nstate.fdefault = @false
 nstate.int = 2
 @each i v args{
  nstate.dic[Str(i)] = v;
 }
 
 Arrx#stack = env.dic["envStack"].arr;
 #ostate = env.dic["envLocal"]
 stack.push(ostate)
 env.dic["envLocal"]  = nstate
 blockExecx(b, env)
 env.dic["envLocal"] = stack[stack.len()-1]
 stack.pop()

 @return nstate.dic["$str"]
}

callx ->(func Cptx, args Arrx, env Cptx)Cptx{
 @if(func == _ || func.obj == _){
  log(arr2strx(args))
  log(strx(func))  
  die("func not defined")
 }
 @if(inClassx(func.obj, funcnativec)){
  @return call(Funcx(getx(func, "funcNative").val), [args, env]);
 }
 @if(inClassx(func.obj, functplc)){ 
  @return tplCallx(func, args, env)
 }
 @if(inClassx(func.obj, funcblockc)){
  Cptx#block = func.dic["funcBlock"]
  #nstate = objNewx(block.dic["blockStateDef"])
  nstate.fdefault = @false  
  nstate.int = 2  
  Arrx#stack = env.dic["envStack"].arr;
  #ostate = env.dic["envLocal"]
  stack.push(ostate)
  env.dic["envLocal"]  = nstate
  Arrx#vars = func.dic["funcVars"].arr
  @each i arg args{
   nstate.dic[vars[i].str] = arg   
  }
  Cptx#r = blockExecx(block, env)
  env.dic["envLocal"] = stack[stack.len()-1]
  stack.pop()

  @if(inClassx(classx(r), signalc)){
   @if(r.obj.id == returnc.id){
    @return r.dic["return"]
   }  
   @if(r.obj.id == errorc.id){
    //TODO pass to blockpost or up
   }  
   @if(r.obj.id == breakc.id){
    die("break in function!")
   }
   @if(r.obj.id == continuec.id){
    die("continue in function!")
   }
  }
  @return r;
 }
 log(strx(func.obj))
 die("callx: unknown func")
 @return nullv;
}
classExecGetx ->(c Cptx, execsp Cptx, cache Dic)Cptx{
 @if(c.id == ""){
  log(strx(c))
  die("no id")
 }
 #r = execsp.dic[c.id]
 @if(r != _){
  @return r;
 }
 @if(c.name != ""){
  #exect = classGetx(execsp, c.name)
  @if(exect != _){
   execsp.dic[c.id] = exect;  
   @return exect
  }
 }
 @if(c.arr != _){
  @each _ v c.arr{
   @if(cache[v.id] != _){ @return; }
   cache[v.id] = 1;
   Cptx#exect = classExecGetx(v, execsp, cache);
   @if(exect != _){
    @return exect;
   }
  }
 }
 @return _
}
execGetx ->(c Cptx, execsp Cptx)Cptx{
 @if(c.type == T##CLASS){
  Cptx#exect = classExecGetx(classc, execsp, {});
  @if(exect != _){
   @return exect;
  }
 }@else{
  Cptx#t = classx(c)
  Cptx#exect = classExecGetx(t, execsp, {});
  @if(exect != _){
   @return exect;
  }
  @if(c.type == T##OBJ){
   Cptx#exect = classExecGetx(objc, execsp, {});
   @if(exect != _){
    @return exect;
   }
  }
 }
 //Cpt no need
 @return _
}
blockExecx ->(o Cptx, env Cptx, stt Uint)Cptx{
 Cptx#b = o.dic["blockVal"]
 @each i v b.arr{
  @if(stt != 0 && stt < i){
   @continue
  }
  Cptx#r = execx(v, env)
  @if(inClassx(classx(r), signalc)){
   @return r
  }
 }
 @return nullv
}
preExecx ->(o Cptx)Cptx{
//TODO pre exec 1+1 =2 like
//pre exec idClass.idVal
 @if(inClassx(classx(o), idclassc)){
  @return o.dic["idVal"]
 }
 @return o
}
execx ->(o Cptx, env Cptx, flag Int)Cptx{
 #l = env.dic["envLocal"]
 @if(flag == 1){
  #sp = env.dic["envExec"]
 }@elif(flag == 2){
  #sp = execmain
 }@elif(l.int == 1){
  #sp = env.dic["envExec"]
 }@elif(l.int == 2){
  #sp = execmain
 }@else{
  #sp = env.dic["envExec"]
 } 
 #ex = execGetx(o, sp)
 @if(!ex){
  die("exec: unknown type "+classx(o).name);
 }
 @return callx(ex, [o], env);
}
