execDefx("Env", ->(x Arrx, env Cptx)Cptx{
 Cptx#nenv = x[0]
 _indentx = " "
 @if(nenv.int == 1){
  @return nenv
 }
 //if not active, start
 nenv.int = 1
 @if(nenv.dic["envExec"].id == execmain.id){
  @return blockExecx(nenv.dic["envBlock"], nenv)
 }
 @return execx(nenv, nenv, 1)
})
execDefx("Call", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#f = execx(c.class, env)
 Arrx#args = c.arr
 @if(f == _ || f.id == nullv.id){
  log(strx(c))
  die("Call: empty func")
 }
 #argsx = prepareArgsx(args, f, env)
 @return callx(f, argsx, env)
})
execDefx("CallPassRef", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#f = c.class//TODO exec
 Arrx#args = c.arr
 #argsx = prepareArgsRefx(args, f, env) 
 @return callx(c.class, argsx, env)
})
execDefx("CallRaw", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.arr
 @return callx(c.class, args, env)
})
execDefx("Null", ->(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Obj", ->(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Class", ->(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Val", ->(x Arrx, env Cptx)Cptx{
 @return x[0]
})
execDefx("Dic", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @if(inClassx(classx(o), midc)){
  #it = getx(o, "itemsType")
  @if(it == _){
   it = cptv
  } 
  #d = &Dicx
  @each k v o.dic{
   d[k] = execx(v, env)
  }
  #c = itemDefx(dicc, classx(it))
  @return dicNewx(c, d, arrCopyx(o.arr))
 }
 @return o
})
execDefx("Arr", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 @if(inClassx(classx(o), midc)){
  #it = getx(o, "itemsType")
  @if(it == _){
   it = cptv
  } 
  #a = &Arrx
  @each i v o.arr{
   a.push(execx(v, env))
  }
  #c = itemDefx(arrc, classx(it))
  @return arrNewx(c, a)
 }
 @return o
})

execDefx("CtrlReturn", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 #f = execx(c.dic["ctrlArg"], env)
 @return defx(returnc, {
  return: f
 })
})
execDefx("CtrlBreak", ->(x Arrx, env Cptx)Cptx{
 @return objNewx(breakc)
})
execDefx("CtrlContinue", ->(x Arrx, env Cptx)Cptx{
 @return objNewx(continuec)
})
execDefx("CtrlIf", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["ctrlArgs"].arr
 Int#l = args.len()
 @for Int#i=0;i<l-1;i+=2 {
  #r = execx(args[i], env)
  @if(ifcheckx(r)){
   @return blockExecx(args[i+1], env)
  }
 }
 @if(l%2 == 1){
  @return blockExecx(args[l-1], env)
 }
 @return nullv
})
execDefx("CtrlFor", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["ctrlArgs"].arr
 execx(args[0], env)
 @for 1 {
  Cptx#c = execx(args[1], env)
  @if(!ifcheckx(c)){
   @break
  }
  #r = blockExecx(args[3], env)
  @if(inClassx(classx(r), signalc)){
   @if(r.obj.id == breakc.id){
    @break;
   }
   @if(r.obj.id == continuec.id){
    @continue;
   }
   @return r    
  }
  execx(args[2], env)
 }
 @return nullv
})
execDefx("CtrlEach", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Arrx#args = c.dic["ctrlArgs"].arr
 Cptx#da = execx(args[2], env)
 Str#key = args[0].str
 Str#val = args[1].str
 Dicx#local =  env.dic["envLocal"].dic
 @if(da.type == T##DIC){
  @each _ kc da.arr{
   Str#k = kc.str
   Cptx#v = da.dic[k]
   @if(key != ""){
    local[key] = strNewx(k)
   }
   @if(val != ""){
    local[val] = v
   }
   #r = blockExecx(args[3], env)
   @if(inClassx(classx(r), signalc)){
    @if(r.obj.id == breakc.id){
     @break;
    }
    @if(r.obj.id == continuec.id){
     @continue;
    }
    @return r    
   }
  }
 }@elif(da.type == T##ARR){
  @each i v da.arr{
   @if(key != ""){
    local[key] = uintNewx(Int(i))
   }
   @if(val != ""){
    local[val] = v   
   }
   #r = blockExecx(args[3], env)
   @if(inClassx(classx(r), signalc)){
    @if(r.obj.id == breakc.id){
     @break;
    }
    @if(r.obj.id == continuec.id){
     @continue;
    }
    @return r    
   }
  }
 }@elif(da.type == T##NULL){
  @return nullv
 }@else{
  log(strx(da))
  log(da.type)
  log(classx(da).ctype)    
  die("CtrlEach: type not defined");
 }
 @return nullv
})
execDefx("IdClass", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 @return getx(c, "idVal")
})
execDefx("IdLocal", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Cptx#l = env.dic["envLocal"]
 Str#k = c.dic["idStr"].str
 #r = getx(l, k)
 @if(r == _){
  @return nullv
 }
 @return r;
})
execDefx("IdState", ->(x Arrx, env Cptx)Cptx{
 Cptx#c = x[0]
 Str#k = c.dic["idStr"].str
 Cptx#o = c.dic["idState"].obj
 #r = o.dic[k]
 @if(r == _){
  @return nullv
 }
 @return r;
})
