id2cptx ->(id Str, def Cptx, local Cptx, func Cptx)Cptx{
 #r = getx(local, id)
 @if(r != _){
  #r = local.dic[id]
  @if(r != _){
   @return defx(idlocalc, {
    idStr: strNewx(id),
    idState: local
   })
  }@else{
   @if(func != _){ //null if func tpl
    funcSetClosurex(func)   
   }
   #p = parentClassGetx(local, id)
   @if(p == _){
    log(strx(local))   
    log(id)
    die("no parent")
   }
   @return defx(idparentc, {
    idStr: strNewx(id),
    idState: p
   })  
  }
 }
 #r = classGetx(def, id)
 @if(r != _){
  @if(r.name == ""){
   @return defx(idglobalc, {
    idStr: strNewx(id),
    idState: def
   })   
  }@else{
   @return defx(idclassc, {
    idStr: strNewx(id),
    idVal: r
   })
  }
 }
 @return _
}
env2cptx ->(ast Astx, def Cptx, local Cptx)Cptx{
 #v = Astx(ast[2])
 Cptx#b = ast2cptx(v, def, local)
 #execsp = nsGetx(execns, Str(ast[1]));
 @if(execsp == _){
  die("no execsp")
 }
 #x = defx(envc, {
  envLocal: scopeObjNewx(b.dic["blockStateDef"])
  envStack: arrNewx(arrc, &Arrx) 
  envExec: execsp
  envBlock: b
 })
 @return x
}
subFunc2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, isproto Int)Cptx{
 #v = Astx(ast[1])
 #funcVars = &Arrx
 #funcVarTypes = &Arrx
 #nlocal = classNewx([local])
 @if(v[0] != _){ //method
  #class = classGetx(def, Str(v[0]))
  funcVars.push(strNewx("$self"))
  Cptx#x = defx(class)
  @if(!x.fstatic){
   x.farg = @true
  }
  funcVarTypes.push(x)
  nlocal.dic["$self"] = x
 }
 #args = Astx(v[1])
 @each _ arg args{
  #argdef = Astx(arg)
  #varid = Str(argdef[0])
  funcVars.push(strNewx(varid))
  @if(argdef[2] != _){//defined default arg val TOTEST
   Cptx#varval = ast2cptx(Astx(argdef[2]), def, local, func)
  }@elif(argdef[1] != _){
   #t = classGetx(def, Str(argdef[1]))
   @if(t == _){
    die("func2cptx: arg type not defined "+Str(argdef[1]))
   }
   #varval = defx(t)
  }@else{
   #varval = cptv
  }
  @if(!varval.fstatic){
   varval.farg = @true
  }
  funcVarTypes.push(varval)
  nlocal.dic[varid] = varval
 }
 @if(v.len() > 2 && v[2] != _){
  #ret = classGetx(def, Str(v[2]))
 }@else{
  #ret = emptyc
 }
 #fp = fpDefx(funcVarTypes, ret)
 @if(isproto > 0){
  @return fp
 }
 #cx = classNewx([fp, funcblockc])
 Cptx#x = objNewx(cx);
 x.dic["funcVars"] = arrNewx(arrstrc, funcVars)
 x.val = nlocal
 @return x
}
func2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, name Str, pre Int)Cptx{
 //CLASS ARGDEF RETURN BLOCK AFTERBLOCK
 //TODO func name should not contain $
 @if(pre != 0 && name == ""){
  die("def must have name");
 }

 @if(name != ""){
  Cptx#x = def.dic[name]
  @if(x == _){
   #x = subFunc2cptx(ast, def, local, func)
   routex(x, def, name)
  }
 }@else{
  #x = subFunc2cptx(ast, def, local, func)
 }
 @if(pre != 0){
  @return x
 }
 #v = Astx(ast[1]) 
 x.dic["funcBlock"] = ast2blockx(Astx(v[3]), def, Cptx(x.val), x);
 @if(v[4] != _){
  die("TODO alterblock")
 }
 @return x;
}
class2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, name Str, pre Int)Cptx{
//'class' parents schema
 @if(pre == 1 || pre == 0){
  #parents = Astx(ast[1])
  Arrx#arr = &Arrx
  @each _ e parents{
   #s = Str(e)
   #r = classGetx(def, s)
   @if(r == _){
    die("class2obj: no class "+s)
   }
   arr.push(r)
  }
  #x = classNewx(arr)
  routex(x, def, name) 
 }
 @if(pre == 2 || pre == 0){ 
  #x = def.dic[name]
  Cptx#schema = ast2dicx(Astx(ast[2]), def, local, func);
  #c = Str(ast[0])
  @if(c == "classx"){
   @each k v schema.dic{
    x.dic[k] = v
   }
  }@else{
  //TODO free schema
   @each k v schema.dic{
    x.dic[k] = defx(v)
   }
  }
 }
 @return x
}

blockmain2cptx ->(ast Astx, def Cptx, local Cptx, name Str)Cptx{
 #b = objNewx(blockmainc)
 b.fdefault = @false
 @if(name != ""){
  routex(b, def, name)
 } 

 #scopename = Str(ast[2])
 @if(scopename != ""){
  #d = classNewx([nsGetx(defns, scopename)])
  #l = classNewx()
 }@else{
  @if(local == _){
   die("no local for blockmain")
  }
  #d = def
  #l = local
 }
 #v = Astx(ast[1])
 @if(d.obj == _){
  objNewx(d)//preassign global
 }
 preAst2blockx(v, d, l);

 ast2blockx(v, d, l, _, b);
 @if(ast.len() == 4){
  b.dic["blockPath"] = strNewx(Str(ast[3]))
 }
 @return b
}
tpl2cptx ->(ast Astx, def Cptx, local Cptx, name Str)Cptx{
 @if(name == ""){
  die("tpl no name")
 }
 #x = defx(functplc) 
 routex(x, def, name)
 
 Astx#astb = JsonArr(Str(ast[1]))
 @if(astb.len() != 0){
  #localx = classNewx()
  Cptx#b = blockmain2cptx(astb, tplmain, localx)
  x.dic["funcTplBlock"] = b
 }
 @if(ast.len() == 3){
  x.dic["funcTplPath"] = strNewx(Str(ast[2]))
 }
 @return x   
}
enum2cptx ->(ast Astx, def Cptx, local Cptx, name Str)Cptx{
 @if(name == ""){
  die("enum no name")
 }
 #a = &Arrx
 #d = &Dicx 
 #c = curryDefx(def, name, enumc, {
  enum: arrNewx(arrstrc, a)
  enumDic: dicNewx(dicuintc, d)
 })
 
 #arr = Astx(ast[1])
 @each i v arr{
  a.push(strNewx(Str(v)))
  #ii = intNewx(Int(i))
  ii.obj = c;
  c.obj = ii
  d[Str(v)] = ii
 }
 @return c
}
send2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #x = defx(sendc)
 #arr = Astx(ast[1])
 #l = arr.len()
 @for #i=0; i<l-1; i++{
  #from = ast2cptx(Astx(arr[i]), def, local, func)
  #to = ast2cptx(Astx(arr[i+1]), def, local, func)
  #fromt = typepredx(from)
  #tot = typepredx(to)
  @if(!fromt){
   log(arr)
   log(i)   
   die("send from type not defined")
  }
  @if(!tot){
   log(arr)
   log(i)
   die("send to type not defined")
  }
  @if(fromt.name == ""){
   log(strx(from))
   log(strx(fromt))   
   die("send from type no name")  
  }
  @if(tot.name == ""){
   log(strx(to))
   log(strx(tot))   
   die("send to type no name")  
  }
  @if(!inClassx(fromt, handlerc)){ //write to val
   #tomsgt = classx(classGetx(tot, "handlerMsgInType"))
   @if(!inClassx(fromt, tomsgt)){
  //TODO check if can convert or die
    log(strx(fromt))
    log(strx(tomsgt))   
    die("cannot send to toVal");
   }
   #fwrite = classGetx(tot, "write")
   x.arr.push(callNewx(fwrite, [to, from]))   
   @continue;
  }
  @if(!inClassx(tot, handlerc)){ //read from val
   @if(!inClassx(classx(to), idc)){
    log(strx(to))
    log(strx(tot))    
    die("cannot assign to from handler");
   }  
   #msgt = classx(classGetx(fromt, "handlerMsgOutType"))
   @if(tot.id == nullc.id){
    tot = msgt
    to.dic["idState"].dic[to.dic["idStr"].str] = msgt
   }@else{
    @if(!inClassx(msgt, tot)){
   //TODO check if can convert or die
     log(strx(msgt))
     log(strx(tot))
     die("cannot send to fromVal");
    }
   }
   #fread = classGetx(fromt, "read")
   #assignf = getx(to, "assign")
   #ncall = callNewx(assignf, [to, callNewx(fread, [from])], callassignc)
   x.arr.push(ncall)   
   @continue;
  }
  @if(!msgt){
   #msgt = classx(classGetx(fromt, "handlerMsgOutType"))
  }
  @if(!tomsgt){
   #tomsgt = classx(classGetx(fromt, "handlerMsgInType"))
  }
  @if(!inClassx(msgt, tomsgt)){
  //TODO check if can convert or die
   log(strx(msgt))
   log(strx(tomsgt))   
   die("cannot send to");
  }
  #f = classGetx(fromt, "pipe" + tot.name)
  @if(f){
   x.arr.push(callNewx(f, [from, to]))
   @continue
  }
  #fread = classGetx(fromt, "read")
  //TODO convertt  
  #fwrite = classGetx(tot, "write")
  @if(fread != _ && fwrite != _){
   #tmpid = objNewx(idlocalc, {
    idStr: strNewx("tmp" + uidx())
    idState: local
   })
   x.arr.push(callNewx(classGetx(idlocalc, "assign"), [
    tmpid,
    callNewx(fread, [from])   
   ], callassignc))
   x.arr.push(callNewx(fwrite, [to, tmpid]))
   @continue   
  }
  log(arr)
  log(i)
  die("cannot send, not function matched")
 }
 @return x
}
obj2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #c = classGetx(def, Str(ast[1]))
 @if(c == _){
   die("obj2cpt: no class "+Str(ast[1])) 
 }
 Cptx#schema = ast2dicx(Astx(ast[2]), def, local, func);
 @if(schema.fmid){
  #x = callNewx(defmain.dic["new"], [c, schema])
 }@else{
  #x = defx(c, schema.dic)
 }
 @return x 
}
op2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #op = Str(ast[1])
// Str#cname = "Op"+ucfirst(op)
 
 #args = Astx(ast[2])
 Cptx#arg0 = ast2cptx(Astx(args[0]), def, local, func)
 #t0 = typepredx(arg0)

 @if(t0 == _){
  t0 = cptc
 }
 #f = getx(t0, op);
 @if(f == _ || f.id == nullv.id){
  log(strx(arg0)) 
  log(strx(t0))
  die("Op not find "+op)
 }
 @if(args.len() == 1){
  //TODO not
  @if(op == "not"){
   @if(!inClassx(t0, boolc)){
    @return callNewx(getx(t0, "eq"), [arg0, defaultx(t0)])
   }
  }
  
  @return callNewx(f, [arg0])
 }@else{
  Cptx#arg1 = ast2cptx(Astx(args[1]), def, local, func)
  //TODO convert arg1
  @return callNewx(f, [arg0, arg1])
 }
 @return _
}

itemsget2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, v Cptx)Cptx{
 Cptx#items = ast2cptx(Astx(ast[1]), def, local, func)
 #itemstc = typepredx(items)
 @if(itemstc == _){
  log(strx(items))
  die("don't known dic or arr")
 }
 Cptx#key = ast2cptx(Astx(ast[2]), def, local, func) 
 @if(v == _){
  #getf = getx(itemstc, "get")
  @if(getf == _){
   log(strx(items))  
   log(strx(itemstc))
   die("no getf")
  }
  @return callNewx(getf, [items, key])
 }
 #setf = getx(itemstc, "set")
  //TODO check/convert v type
 @if(setf == _){
  die("no setf")
 }  
 #lefto = callNewx(setf, [items, key, v])
  
 #predt = typepredx(v)  
  
 @if(inClassx(classx(items), idstatec)){//a[1] = 1->change Arr#a to Arr_Int#a
  Cptx#s = items.dic["idState"]
  Str#str = items.dic["idStr"].str
  Cptx#itemst = s.dic[str]
  Cptx#itemstt = aliasGetx(itemst.obj)
  @if(itemst.farg){
   @return lefto
  }
  #it = getx(itemst, "itemsType")
  @if(predt != _ && predt.id != cptc.id){ 
   @if(it.id == cptv.id){
//    @if(itemstt.name != "Dic" && itemstt.name != "Arr"){
 //    die("error, itemsType defined but name not changed "+itemst.obj.name)
  //  }
    itemst.obj = itemDefx(itemstt, predt)
    @if(itemst.val != _){
     //cached init right expr a = {}/[]
     #oo = Cptx(itemst.val)
     convertx(itemstt, itemst.obj, oo)
    }
   }@elif(!inClassx(predt, classx(it))){
    die("TODO convert items assign: "+predt.name + " is not "+classx(it).name);
   }
  }
 }
 @return lefto
}
return2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, v Cptx)Cptx{
 @if(func == _){
  log(ast)
  die("return outside func")
 }
 #ret = getx(func, "funcReturn")
 @if(ast.len() > 1){
  Cptx#arg = ast2cptx(Astx(ast[1]), def, local, func)
  @if(ret.id == emptyc.id){
   die("func "+func.name+" should not return value")
  }
 }@else{
  @if(ret.id == emptyc.id){
   Cptx#arg = emptyv
  }@else{
   Cptx#arg = nullv  
  }
 }
 @return defx(ctrlreturnc, {
  ctrlArg: arg
 })
}
objget2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, v Cptx)Cptx{
 Cptx#obj = ast2cptx(Astx(ast[1]), def, local, func)
 @if(obj.type == T##OBJ || obj.type == T##CALL){
  @if(v == _){
   @return callNewx(defmain.dic["get"], [obj, strNewx(Str(ast[2]))])
  }@else{
   @return callNewx(defmain.dic["set"], [obj, strNewx(Str(ast[2])), v])
  }
 }@else{
 //TODO objget for other type
  @return
 }
}
if2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, block Cptx)Cptx{
 #v = Astx(ast[1])
 Cptx#a = ast2arrx(v, def, local, func)
 Arrx#args = a.arr;
 Int#l = args.len()
 @for Int#i=0;i<l-1;i+=2{
  #t = typepredx(args[i])
  @if(t == _){
   log(strx(args[i]))
   die("if: typepred error")
  }
  @if(!inClassx(t, boolc)){
   args[i] = callNewx(getx(t, "ne"), [args[i], defaultx(t)])
  }
  Cptx#d = args[i+1]
  d.dic["blockParent"] = block
 }
 @if(l%2 == 1){
  Cptx#d = args[l-1]
  d.dic["blockParent"] = block
 }
 
 @return defx(ctrlifc, {ctrlArgs: a})
}
each2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, block Cptx)Cptx{
 #v = Astx(ast[1])
 #key = Str(v[0])
 #val = Str(v[1])
 Cptx#expr = ast2cptx(Astx(v[2]), def, local, func)
 #et = typepredx(expr)
 @if(et == _){
  die("no type for each")
 }
 @if(key != ""){
  #r = checkid(key, local, func)
  @if(inClassx(et, dicc)){
   @if(r != _){
    @if(classx(r).id != strc.id){
     die("each key id defined "+key)
    }
   }@else{
    local.dic[key] = strNewx("")
   }
  }@elif(inClassx(et, arrc)){
   @if(r != _){
    @if(classx(r).id != uintc.id){
     die("each key id defined "+key)
    }
   }@else{
    local.dic[key] = uintNewx(0)
   }
  }@else{
   log(strx(et))
   die("TODO: items other than dic or arr")
  }
 }
 @if(val != ""){
  #it = getx(et, "itemsType")
  #r = checkid(val, local, func)
  @if(it == _){
   it = cptv;
  }
  @if(r != _){
   @if(classx(r).id != classx(it).id){
    log(classx(r).name)
    log(classx(it).name)    
    die("each val id defined "+val)
   }
  }@else{
   local.dic[val] = it
  }  
 }
 Cptx#bl = ast2blockx(Astx(v[3]), def, local, func)
 bl.dic["blockParent"] = block
 @return defx(ctrleachc, {
  ctrlArgs: arrNewx(arrc, [
   strNewx(key)
   strNewx(val)
   expr
   bl
  ])
 })
}
for2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, block Cptx)Cptx{
 #v = Astx(ast[1])
 @if(v[0] != _){
  Cptx#start = ast2cptx(Astx(v[0]), def, local, func)
 }@else{
  #start = nullv
 }
 Cptx#check = ast2cptx(Astx(v[1]), def, local, func)
 #t = typepredx(check)
 @if(!inClassx(t, boolc)){
  check = callNewx(getx(t, "ne"), [check, defaultx(t)])
 }
 
 @if(v[2] != _){ 
  Cptx#inc = ast2cptx(Astx(v[2]), def, local, func)
 }@else{
  #inc = nullv 
 }
 Cptx#bl = ast2blockx(Astx(v[3]), def, local, func)
 
 @return defx(ctrlforc, {
  ctrlArgs: arrNewx(arrc, [
   start
   check
   inc
   bl
  ])
 }) 
 @return 
}
alias2cptx ->(ast Astx, def Cptx, name Str)Cptx{
 Str#n = Str(ast[1])
 @if(n == "Class" || n== "Obj" || n == "Cpt"){
  die("no alias for this")
 }
 #x = classGetx(def, n)
 @if(x == _){
  die("alias error "+Str(ast[1]));
 }
 @return aliasDefx(def, name, x)
}
itemdef2cptx ->(ast Astx, def Cptx, name Str)Cptx{
 #x = classGetx(def, Str(ast[1]))
 #it = classGetx(def, Str(ast[2]))
 @if(x == _){
  die("itemdef error, items "+Str(ast[1]));
 }
 @if(it == _){
  die("itemdef error, itemsType "+Str(ast[2]));
 }
 @return aliasDefx(def, name, itemDefx(x, it))
}
funcproto2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, name Str)Cptx{
 #x = subFunc2cptx(ast, def, local, func, 1)  
 @return aliasDefx(def, name, x)   
}
def2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, pre Int)Cptx{
 #id = Str(ast[1])
 #v = Astx(ast[2])
//pre 1 2 3 0 three times
//when 1 -> new class, enum/tpl/blockmain/type
//when 2 -> class specify/func def
//when 0 -> other/func specify
 #c = Str(v[0])
 @if(pre == 1){
  #dfd = def.dic[id]
  @if(dfd != _){
   die("class def twice "+id)
  } 
  @if(c == "enum"){
   @return enum2cptx(v, def, local, id)
  }@elif(c == "tpl"){
   @return tpl2cptx(v, def, local, id)  
  }@elif(c == "blockmain"){
   @return blockmain2cptx(v, def, local, id)
  }@elif(c == "class" || c == "classx"){
   @return class2cptx(v, def, local, func, id, pre)  
  }@elif(c == "alias"){
   @return alias2cptx(v, def, id)
  }@elif(c == "itemdef"){
   @return itemdef2cptx(v, def, id)  
  }@else{
   @return _
  }
 }
 @if(pre == 2){
  @if(c == "class" || c == "classx"){
   @return class2cptx(v, def, local, func, id, pre)
  }@elif(c == "funcproto"){
   @return funcproto2cptx(v, def, local, func, id)       
  }@elif(c == "func"){
   #dfd = def.dic[id]
   @if(dfd != _){
    die("func def twice "+id)
   }   
   @return func2cptx(v, def, local, func, id, pre)  
  }@else{
   @return _
  }
 }
 //pre 0
 @if(c != "func"){
  #dfd = def.dic[id]
  @if(dfd != _){
   @return dfd
  }
 }

 Cptx#r = ast2cptx(v, def, local, func, id)
 @if(r.name == ""){
  #t = typepredx(r)
  @if(t == _){
   log(id)
   log(v)
   die("global var must know type")
  }
  def.dic[id] = defx(t);
  #ip = defx(idglobalc, {
   idStr: strNewx(id),
   idState: def
  })
  #af = classGetx(idglobalc, "assign")
  @return callNewx(af, [ip, r], callassignc)
 }
 @return r
}
convertx ->(from Cptx, to Cptx, val Cptx)Cptx{
 @if(to.id == from.id){
  @return _
 }
 @if(from.id == cptc.id){
  @return callNewx(defmain.dic["as"], [val, to])
 }
 @if(to.ctype != from.ctype){
  @return _ 
 }
 @if(inClassx(classx(val), midc)){
  @if(to.fbnum){
   @return callNewx(defmain.dic["numConvert"], [val, to])
  } 
  @return _
 }
// @if(inClassx(to, from)){//specify eg. Arr to ArrStatic
    //convert val
 val.obj = to
 to.obj = val
 @return val
// }
// @return _
}
assign2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #v = Astx(ast[1])
 #left = Astx(v[0])
 #right = Astx(v[1])
 #leftt = Str(left[0])
 Cptx#righto = ast2cptx(right, def, local, func)
 #predt = typepredx(righto)

 @if(v.len() > 2){// a += 1   -= *= ...
  #op = Str(v[2])
  @if(op == "add"){
   Cptx#lefto = ast2cptx(left, def, local, func)
   #lpredt = typepredx(lefto)
   
   #ff = getx(lpredt, "concat")
   @if(ff != _){
    @return callNewx(ff, [lefto, righto], callpassrefc)
   }
  }
  #ff = getx(lpredt, op)
  @if(ff == _){
   log("no op "+lpredt.name + " " +op)
  }
  righto = callNewx(ff, [lefto, righto])
 }


 @if(leftt == "objget"){
  Cptx#lefto = objget2cptx(left, def, local, func, righto)
  //TODO check type
  @return lefto
 }
 @if(leftt == "itemsget"){ //expr[1] = 1
  Cptx#lefto = itemsget2cptx(left, def, local, func, righto)
  @return lefto
 }
 
 @if(leftt == "id" && v.len() == 2){// a = 1 to  #a =1
  #name = Str(left[1])
  @if(getx(local, name) == _){
   @if(getx(def.obj, name) == _){
    left[0] = "idlocal"//if assign to id, id is idlocal
   }@else{
    Cptx#lefto = defx(idglobalc, {
     idStr: strNewx(name)
     idState: def
    })
   }
  }
 }
 @if(lefto == _){
  Cptx#lefto = ast2cptx(left, def, local, func)
 }


 @if(inClassx(classx(lefto), idstatec)){ //#a = 1  set a type Int
  Cptx#s = lefto.dic["idState"]
  Str#idstr = lefto.dic["idStr"].str
  #type = s.dic[idstr]
  @if(type == _ || type.id == nullv.id){//only set in not like Str#a
   @if(predt == _){
    s.dic[idstr] = cptv
   }@else{
    s.dic[idstr] = defx(predt)
    #lpredt = predt;
    @if(predt.id == dicc.id || predt.id == arrc.id){
     //a = {}/[];cache init right expr for future a itemsType change
     s.dic[idstr].val = righto
    }
   }
  }
 }

// @if(predt != _ && lpredt != _){ //for exp: Uint#a = 1
//  #cvt = convertx(predt, lpredt, righto)
//  @if(cvt != _){
//   righto = cvt
//  }
// }

 #f = getx(lefto, "assign")
 @return callNewx(f, [lefto, righto], callassignc)
}
call2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #v = Astx(ast[1])
 Cptx#f = ast2cptx(v, def, local, func)
 @if(classx(f).id == idclassc.id){
  #f = f.dic["idVal"]
 }
 Cptx#arr = ast2arrx(Astx(ast[2]), def, local, func) 
 @if(f.type == T##CLASS){
  f = aliasGetx(f)   
  @if(arr.arr.len() == 0){
   @return callNewx(defmain.dic["type"], [f], calltypec)
  }  
  Cptx#a0 = arr.arr[0]
  #t = typepredx(a0)
  @if(t == _){
   log(a0)
   die("convert from type not defined")
  }
  #aa0 = convertx(t, f, a0)
  @if(aa0 != _){
   @return aa0
  }

  @if(f.name == ""){
   die("class with no name")
  }
  #r = getx(t, "to"+f.name)
  @if(r == _){
   log(strx(t))
   log(strx(a0)) 
   log("to"+f.name)
   die("convert func not defined")
  }
  @return callNewx(r, arr.arr)
 }
 //TODO if f is funcproto check type
 @return callNewx(f, arr.arr)
}
callmethod2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 Cptx#oo = ast2cptx(Astx(ast[1]), def, local, func)
 Cptx#to = typepredx(oo)
 @if(to == _){
  log(strx(oo))
  die("cannot typepred obj")
 }
 //TODO CLASS get CALL
 Cptx#arr = ast2arrx(Astx(ast[3]), def, local, func)
 #f = getx(to, Str(ast[2]))
 @if(f == _){
  log(strx(oo))
  log(strx(to))
  log(Str(ast[2]))  
  die("no method")
 }
 arr.arr.unshift(oo)
 @return callNewx(f, arr.arr, callmethodc)
}
preAst2blockx ->(ast Astx, def Cptx, local Cptx, func Cptx){
 @each i e ast{
  #ee = Astx(e)
  #eee = Astx(ee[0])
  #idpre = Str(eee[0])
  @if(idpre == "def"){
   def2cptx(eee, def, local, func, 1)
  }
 }
 @each i e ast{
  #ee = Astx(e)
  #eee = Astx(ee[0])
  #idpre = Str(eee[0])
  @if(idpre == "def"){
   def2cptx(eee, def, local, func, 2)
  }
 }
}
ast2blockx ->(ast Astx, def Cptx, local Cptx, func Cptx, block Cptx)Cptx{
 #arr = &Arrx
 @if(block != _){
  #x = block
 }@else{
  #x = objNewx(blockc)
  x.fdefault = @false  
 }
 #dicl = dicNewx(dicuintc, &Dicx)
 //TODO read def function and breakpoints first
 Int#i = 0;
 @each _ e ast{
  #ee = Astx(e)
  #idpre = Str(Astx(ee[0])[0])
  @if(ee.len() == 2){
   dicl.dic[Str(ee[1])] = uintNewx(i)
  }
  @if(idpre == "if"){
   Cptx#c = if2cptx(Astx(ee[0]), def, local, func, x)
  }@elif(idpre == "each"){
   Cptx#c = each2cptx(Astx(ee[0]), def, local, func, x)
  }@elif(idpre == "for"){
   Cptx#c = for2cptx(Astx(ee[0]), def, local, func, x)
  }@elif(idpre == "send"){
   Cptx#c = send2cptx(Astx(ee[0]), def, local, func)   
  }@else{
   Cptx#c = subAst2cptx(Astx(ee[0]), def, local, func)  
  }
  c.ast = Astx(ee[0])
  @if(c == _){
   @continue
  }
  arr.push(c)
  i++  
 }
 x.dic["blockVal"] = arrNewx(arrc, arr)
 x.dic["blockStateDef"] = local
 x.dic["blockLabels"] = dicl
 
 x.dic["blockScope"] = def
 @return x
}

ast2arrx ->(asts Astx, def Cptx, local Cptx, func Cptx, it Cptx, il Int)Cptx{
 #arrx = &Arrx
 #callable = @false;
 @each _ e asts{
  Cptx#ee = ast2cptx(Astx(e), def, local, func)
  @if(ee.fmid){
   callable = @true;
  }
  @if(it == _){
   it = typepredx(ee)
  }    
  arrx.push(ee)
 }

 @if(!callable){
  @each i v arrx{
   arrx[i] = preExecx(v)
  }
 }
 

 @if(it != _ || callable){
  #c = itemDefx(arrc, it, callable)
  #r = arrNewx(c, arrx)
  @if(callable){
   r.fmid = @true
  }
 }@else{
  #r = arrNewx(arrc, arrx)  
 }
 @if(il != 0){
  r.int = il
 } 
 @return r;
}
ast2dicx ->(asts Astx, def Cptx, local Cptx, func Cptx, it Cptx, il Int)Cptx{
 #dicx = &Dicx
 #arrx = &Arrx 
 #callable = @false;
 @each _ eo asts{
  #e = Astx(eo)
  #k = Str(e[1])
  Cptx#ee = ast2cptx(Astx(e[0]), def, local, func)
  @if(ee.fmid){
   callable = @true;
  }
  @if(it == _){
   it = typepredx(ee)
  }
  arrx.push(strNewx(k))
  dicx[k] = ee;
 }
 
 @if(!callable){
  @each k v dicx{
   dicx[k] = preExecx(v)
  }
 }
 
 @if(it != _ || callable){
  #c = itemDefx(dicc, it, callable)
  #r = dicNewx(c, dicx, arrx)
  @if(callable){
   r.fmid = @true
  }
 }@else{
  #r = dicNewx(dicc, dicx, arrx)  
 }
 @if(il != 0){
  r.int = il
 }
 @return r;
}
ast2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, name Str)Cptx{
 Cptx#x = subAst2cptx(ast, def, local, func, name);
 @if(x){
  x.ast = ast
 }
 @return x
}
subAst2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, name Str)Cptx{
 @if(def == _){
  die("no def")
 }
 #t = Str(ast[0])
 @if(t == "env"){
  @return env2cptx(ast, def, local)
 }@elif(t == "enum"){
  @return enum2cptx(ast, def, local, name)
 }@elif(t == "tpl"){
  @return tpl2cptx(ast, def, local, name)
 }@elif(t == "blockmain"){
  @return blockmain2cptx(ast, def, local)
 }@elif(t == "class" || t == "classx"){
  @return class2cptx(ast, def, local, func, name)  
 }@elif(t == "alias"){
  @return alias2cptx(ast, def, name)
 }@elif(t == "itemdef"){
  @return itemdef2cptx(ast, def, name)  
 }@elif(t == "funcproto"){
  @return funcproto2cptx(ast, def, local, func, name)      
 }@elif(t == "block"){
  @return ast2blockx(Astx(ast[1]), def, local, func)
 }@elif(t == "null"){
  @return nullv
 }@elif(t == "true"){
  @return truev
 }@elif(t == "false"){
  @return falsev
 }@elif(t == "idlocal"){
  #id = Str(ast[1])

  #val = local.dic[id]
  @if(val == _){
   @if(ast.len() > 2){  
    #type = classGetx(def, Str(ast[2]))
    @if(type == _){
     die("wrong type "+Str(ast[2]))
    }
   }@else{
    #type = nullc
   }
   local.dic[id] = defx(type)   
  }
  @return defx(idlocalc, {
   idStr: strNewx(id),
   idState: local
  })  
 }@elif(t == "id"){
  #id = Str(ast[1])
  #x = id2cptx(id, def, local, func)
  @if(x == _){
   log(strx(local))
   log(strx(def))   
   die("id not defined "+ id)
  }
  @return x;
 }@elif(t == "call"){
  @return call2cptx(ast, def, local, func)
 }@elif(t == "callmethod"){
  @return callmethod2cptx(ast, def, local, func)
 }@elif(t == "assign"){
  @return assign2cptx(ast, def, local, func)  
 }@elif(t == "def"){
  @return def2cptx(ast, def, local, func)
 }@elif(t == "enumget"){
  #en = classGetx(def, Str(ast[1]))
  @if(en == _){
   log(ast[1])
   die("enum type not defined")
  }
  Dicx#dic = en.dic["enumDic"].dic
  #r = dic[Str(ast[2])]
  @if(r == _){
   log(ast[1])
   log(ast[2])   
   die("enum val not defined")
  }  
  @return r  
 }@elif(t == "func"){
  @return func2cptx(ast, def, local, func, name)    
 }@elif(t == "op"){
  @return op2cptx(ast, def, local, func)
 }@elif(t == "itemsget"){
  @return itemsget2cptx(ast, def, local, func)
 }@elif(t == "objget"){
  @return objget2cptx(ast, def, local, func)
 }@elif(t == "return"){
  @return return2cptx(ast, def, local, func) 
 }@elif(t == "break"){
  @return objNewx(ctrlbreakc)
 }@elif(t == "continue"){
  @return objNewx(ctrlcontinuec)    
 }@elif(t == "str"){
  #x = strNewx(Str(ast[1]))
  x.fast = @true
  @return x
 }@elif(t == "byte"){
//  #x = intNewx(Str(ast[1]), bytec)
//  x.fast = @true
//  @return x
 }@elif(t == "bytes"){
  #x = strNewx(Str(ast[1]), bytesc)
  x.fast = @true
  @return x
 }@elif(t == "float"){
  #x = floatNewx(Float(Str(ast[1])))
  x.fast = @true
  @return x  
 }@elif(t == "int"){ 
  #x = intNewx(Int(Str(ast[1])))
  x.fast = @true
  @return x  
 }@elif(t == "dic"){
  @if(ast.len() > 2){
   @if(ast[2] != _){
    #it = classGetx(def, Str(ast[2]))
   }
   @if(ast[3] != _){   
    Int#il = Int(Str(ast[3]))
   }
  }
  #x = ast2dicx(Astx(ast[1]), def, local, func, it, il);
  x.fast = @true
  @return x    
 }@elif(t == "arr"){
  @if(ast.len() > 2){
   @if(ast[2] != _){
    #it = classGetx(def, Str(ast[2]))
   }
   @if(ast[3] != _){
    Int#il = Int(Str(ast[3]))
   }
  } 
  #x = ast2arrx(Astx(ast[1]), def, local, func, it, il)
  x.fast = @true
  @return x    
 }@elif(t == "obj"){
  #x = obj2cptx(ast, def, local, func)
  x.fast = @true
  @return x
 }@elif(t == "fs"){
  @return fsv
 }@else{
  die("ast2cptx: " + t + " is not defined")
 }
 @return
}
progl2cptx ->(str Str, def Cptx, local Cptx)Cptx{
 Astx#ast = JsonArr(osCmd("./sl-reader", str))
 @if(ast.len() == 0){
  die("progl2cpt: wrong grammar")
 }
 #r = ast2cptx(ast, def, local)
 @return r
}
