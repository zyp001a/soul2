id2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #id = Str(ast[1])
 @if(id == "$"){
  @return soulv
 }
 @if(func){
  #varts = getx(func, "funcVars")
  @if(varts){
   @each i stro varts.arr{
    @if(id == stro.str){
     #r = idNewx(local, stro.str, idargc)
     r.int = i
     @return r;
    }
   }
  }
 }
 #r = getx(local, id)
 @if(r != _){
  #r = local.dic[id]
  @if(r != _){
   @return idNewx(local, id, idlocalc)
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
   @return idNewx(p, id, idparentc)
  }
 }
 #r = classGetx(def, id)
 @if(r != _){
  @if(r.name == ""){
   @return idNewx(def, id, idglobalc)
  }@else{
   @return idNewx(r, id, idclassc)
  }
 }

 log(strx(local))
// log(strx(def))   
 die("id not defined "+ id)
 @return _
}
idlocal2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #id = Str(ast[1])
 #val = local.dic[id]
 #cc = idlocalc
 @if(id.isInt()){
  @if(func == _){
   diex("idarg #\d not func!!! "+id)
  }
  #idi = Int(id)  
  #vars = getx(func, "funcVars")
  @if(vars){
   @if(idi >= vars.arr.len()){
    die("#"+id + " not defined");
   }
   id = vars.arr[idi].str
  }@else{
   id = ""
  }
  #r = idNewx(local, id, idargc)
  r.int = idi
  @return r
 }
 
 @if(func){
  #varts = getx(func, "funcVars")
  @if(varts){
   @each i stro varts.arr{
    @if(id == stro.str){
     #r = idNewx(local, stro.str, idargc)
     r.int = i
     @return r;
    }
   }
  }
 }
 
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
 #r = idNewx(local, id, cc)
 @return r;
}
env2cptx ->(ast Astx, def Cptx, local Cptx)Cptx{
 #v = Astx(ast[2])
 Cptx#b = ast2cptx(v, def, local)
 #execsp = nsGetx(execns, Str(ast[1]));
 @if(execsp == _){
  die("no execsp")
 }
 #l = scopeObjNewx(b.dic["blockStateDef"])
 l.str = "Env " + execsp.str
 #x = defx(envc, {
  envLocal: l
  envStack: arrNewx()
  envExec: execsp
  envBlock: b
 })
 @return x
}
subFunc2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, isproto Int)Cptx{
 #v = Astx(ast[1])
 #cname = Str(v[0])
 #funcVars = &Arrx
 #funcVarTypes = &Arrx
 #nlocal = classNewx([local])
 @if(cname){ //method
  #class = classGetx(def, cname)  
  funcVars.push(strNewx("@this"))
  Cptx#x = defx(class)
  @if(!x.fstatic){
   x.farg = @true
  }
  funcVarTypes.push(x)
  nlocal.dic["@this"] = x
 }
 #args = JsonArr(v[1])
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
   #varval = unknownv
  }
  @if(!varval.fstatic){
   varval.farg = @true
  }
  funcVarTypes.push(varval)
 }
 nlocal.dic["@args"] = arrNewx(funcVarTypes)
 @if(v.len() > 2 && v[2] != _){
  #ret = classGetx(def, Str(v[2]))
 }@else{
  #ret = emptyc
 }
 #fp = fpDefx(funcVarTypes, ret)
 @if(isproto > 0){
  @return fp
 }
 #cx = classNewx([fp, funcstdc])
 Cptx#x = objNewx(cx);
 x.dic["funcVars"] = arrNewx(funcVars, arrstrc)
 x.val = nlocal
 @return x
}
func2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, name Str, pre Int)Cptx{
 //CLASS ARGDEF RETURN BLOCK AFTERBLOCK
 //TODO func name should not contain $
 @if(pre != 0 && name == ""){
  die("def must have name");
 }
 #v = Astx(ast[1]) 
 #cname = Str(v[0])
 @if(name != ""){
  #x = preGetx(def, name, cname)
  @if(x == _){
   #x = subFunc2cptx(ast, def, local, func)
   preSetx(x, def, name, cname)
  }
 }@else{
  @if(cname){
   die("anoymous function cannot be method")
  }
  #x = subFunc2cptx(ast, def, local, func)
 }
 @if(pre != 0){
  @return x
 }

 #nlocal = Cptx(x.val)
 #bl = ast2blockx(Astx(v[3]), def, nlocal, x);
 //fill end return
 autoReturnx(bl, x)
 x.dic["funcBlock"] = bl
 @if(v[4] != _){
  #ab = preExecx(ast2cptx(Astx(v[4]), def, local, x))
  x.dic["funcErrFunc"] = ab
 }@elif(func){
  x.dic["funcErrFunc"] = func.dic["funcErrFunc"]
 }@else{
  x.dic["funcErrFunc"] = defmain.dic["throw"]
 }
 @return x;
}

handler2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, name Str)Cptx{ 
 #v = Astx(ast[1]) 
 #blockast = Astx(v[0])
 #x = objNewx(handlerc)
 x.val = blockast
 @if(v[1] != _){
  #ab = preExecx(ast2cptx(Astx(v[1]), def, local, x))
  x.dic["funcErrFunc"] = ab
 }@elif(func){
  x.dic["funcErrFunc"] = func.dic["funcErrFunc"]
 }@else{
  x.dic["funcErrFunc"] = defmain.dic["throw"]
 } 
 @return x
}
class2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, name Str, pre Int)Cptx{
//['class' [cname, parents, schema, tobj_flag]]
 #vv = Astx(ast[1])
 #cname = Str(vv[0])
 #parents = Astx(vv[1])
 #schemaast = Astx(vv[2])
 @if(pre == 1 || pre == 0){
  Arrx#arr = &Arrx
  @each _ e parents{
   #s = Str(e)
   #r = classGetx(def, s)
   @if(r == _){
    log(parents)
    die("class2obj: no class "+s)
   }
   arr.push(r)
  }
  #x = classNewx(arr)
  preSetx(x, def, name, cname)
 }
 @if(pre == 2 || pre == 0){ 
  #x = preGetx(def, name, cname)
  Cptx#schema = ast2dicx(schemaast, def, local, func);
  @if(vv.len() > 3){
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

blockmain2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, name Str)Cptx{
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
 preAst2blockx(v, d, l, func);

 ast2blockx(v, d, l, func, b);
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
  Cptx#b = blockmain2cptx(astb, tplmain, localx, x)
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
  enum: arrNewx(a, arrstrc)
  enumDic: dicNewx(d, _, dicuintc)
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
json2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #dic = Astx(ast[1])
 #r = ast2jsonx(dic, def, local, func)
 @return r
}
obj2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #c = classGetx(def, Str(ast[1]))
 @if(c == _){
   die("obj2cpt: no class "+Str(ast[1])) 
 }
 Cptx#schema = ast2dicx(Astx(ast[2]), def, local, func);
 #nf = getx(c, "new")
 #classnf = classc.dic["new"]
 @if(nf.id2 == classnf.id2 && !schema.fmid){
  #x = defx(c, schema.dic) 
 }@else{
  #x = callNewx(nf, [c, schema])  
 }
 @return x 
}
op2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #op = Str(ast[1])
// Str#cname = "Op"+ucfirst(op)
 
 #args = Astx(ast[2])
 Cptx#arg0 = ast2cptx(Astx(args[0]), def, local, func)
 #t0 = typepredx(arg0)

 @if(t0.id == unknownc.id){
  t0 = cptc
 }
 #f = getx(t0, op);
 @if(f == _ || f.id == nullv.id){
  log(strx(arg0)) 
  log(strx(t0))
  die("Op not find "+op)
 }
 @if(args.len() == 1){
  @if(op == "not"){
   @if(!inClassx(t0, boolc)){
    @return callNewx(getx(t0, "eq"), [arg0, defaultx(t0)])
   }
  }
  @return callNewx(f, [arg0])
 }@else{
  Cptx#arg1 = ast2cptx(Astx(args[1]), def, local, func)
  arg1 = convertx(arg1, t0)
  @return callNewx(f, [arg0, arg1])
 }
 @return _
}

itemsget2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, v Cptx)Cptx{
 Cptx#items = ast2cptx(Astx(ast[1]), def, local, func)
 #itemstc = mustTypepredx(items)
 Cptx#key = ast2cptx(Astx(ast[2]), def, local, func)
 
 @if(v == _){
  #getf = mustGetx(itemstc, "get")
  #getc = callNewx(getf, [items, key], callidc) 
  @return getc
 }
 #setf = mustGetx(itemstc, "set")

 #lit = getx(itemstc, "itemsType")
 @if(lit != _ && lit.id != cptv.id){
  @return callNewx(setf, [items, key, convertx(v, classx(lit))])
 }
 #lefto = callNewx(setf, [items, key, v])
  
 #predt = typepredx(v)  
  
 @if(inClassx(classx(items), idstatec)){//a[1] = 1->change Arr#a to Arr_Int#a
  Cptx#s = items.class
  Str#str = items.str
  Cptx#itemst = s.dic[str]
  Cptx#itemstt = aliasGetx(itemst.obj)
  @if(!itemstt.fbitems){
   @return lefto
  }
  @if(itemst.farg){
   @return lefto
  }
  #it = getx(itemst, "itemsType")
  @if(predt.id != unknownc.id && predt.id != cptc.id){ 
   @if(it.id == cptv.id){
    itemst.obj = itemsDefx(itemstt, predt)
    itemst.pred = itemst.obj
    @if(itemst.val != _){
     //cached init right expr a = {}/[]
     #oo = Cptx(itemst.val)
     convertx(oo, itemst.obj)
    }
   }@elif(!inClassx(predt, classx(it))){
    die("TODO convert items assign: "+predt.name + " is not "+classx(it).name);
   }
  }
 }
 @return lefto
}
err2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #err = strNewx(Str(ast[1]), errc)
 @if(ast.len() > 2){
  #msg = ast2cptx(Astx(ast[2]), def, local, func)
 }@else{
  #msg = strNewx("")
 }
 @if(func == _){
  @return callNewx(defmain.dic["throw"], [err, msg])
 }
 @return objNewx(ctrlerrc, {  
  ctrlArgs: arrNewx([err, msg, func])
 })
}
return2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 @if(func == _){
  log(ast)
  die("return outside func")
 }
 #ret = getx(func, "funcReturn")
 @if(ast.len() > 1){
  #arg = ast2cptx(Astx(ast[1]), def, local, func)

  @if(ret.id == emptyc.id){
   die("func "+func.name+" should not return value")
  }
  #arg = convertx(arg, ret)
 }@else{
  @if(ret.id == emptyc.id){
   #arg = emptyv
  }@else{
   #arg = nullv  
  }
 }
 @return defx(ctrlreturnc, {
  ctrlArg: arg
 })
}
objget2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, v Cptx)Cptx{
 Cptx#obj = ast2cptx(Astx(ast[1]), def, local, func)
 @if(obj.type == T##OBJ || obj.type == T##CALL || obj.type == T##ID){
  #getc = callNewx(defmain.dic["get"], [obj, strNewx(Str(ast[2]))], callidc)
  @if(v == _){
   @return getc
  }
  #lpredt = typepredx(getc)
  @return callNewx(defmain.dic["set"], [obj, strNewx(Str(ast[2])), convertx(v, lpredt)], callidc)
 }@else{
 //TODO objget for other type
  @return
 }
}
if2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, block Cptx)Cptx{
 #v = Astx(ast[1])
 Cptx#a = ast2arrx(v, def, local, func)
 Arrx#args = a.arr;
 #l = args.len()
 @for #i=0; i < l - 1;i+=2{
  #t = typepredx(args[i])
  @if(t.id == unknownc.id){
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
  Cptx#d = args[l - 1]
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
 @if(et.id == unknownc.id){
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
    local.dic[key] = intNewx(0, uintc)
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
  ctrlArgs: arrNewx([
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
  ctrlArgs: arrNewx([
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
itemdef2cptx ->(ast Astx, def Cptx, name Str, pre Int)Cptx{
 @if(pre){
  #re = classDefx(def, name)
  @return re
 }

 #x = classGetx(def, Str(ast[1]))
 #it = classGetx(def, Str(ast[2]))
 @if(x == _){
  die("itemdef error, items "+Str(ast[1]));
 }
 @if(it == _){
  die("itemdef error, itemsType "+Str(ast[2]));
 }
 #c = itemsDefx(x, it)
 #re = def.dic[name]
 @if(!re){
  @return aliasDefx(def, name, c)  
 }
 parentMakex(re, [aliasc, c])
 @return re
}
funcproto2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, name Str)Cptx{
 #x = subFunc2cptx(ast, def, local, func, 1)  
 @return aliasDefx(def, name, x)   
}
def2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx, pre Int)Cptx{
 #name = Str(ast[1])
 #v = Astx(ast[2])
//pre 1 2 3 0 three times
//when 1 -> new class, enum/tpl/blockmain/type
//when 2 -> itemsdef
//when 3 -> class specify/func def
//when 0 -> other/func specify
 //['def', 'a', ['func', [cname, ]] ]
 #c = Str(v[0])
 #id = name
 @if(c == "class" || c == "func" || c == "handler"){
  #vv = Astx(v[1])
  #cname = Str(vv[0])
  @if(cname){
   #id = cname+"_"+name
  }
 }
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
   @return blockmain2cptx(v, def, local, func, id)
  }@elif(c == "class"){
   @return class2cptx(v, def, local, func, name, pre)  
  }@elif(c == "alias"){
   @return alias2cptx(v, def, id)
  }@elif(c == "itemdef"){
   @return itemdef2cptx(v, def, id, pre)  
  }@else{
   @return _
  }
 }

 @if(pre == 12){
  @if(c == "itemdef"){
   @return itemdef2cptx(v, def, id)
  }@else{
   @return _
  }  
 }
 
 @if(pre == 2){
  @if(c == "class"){
   @return class2cptx(v, def, local, func, name, pre)
  }@elif(c == "func"){
   #dfd = def.dic[id]
   @if(dfd != _){
    die("func def twice "+id)
   }
   @return func2cptx(v, def, local, func, name, pre)
  }@elif(c == "funcproto"){  
   @return funcproto2cptx(v, def, local, func, id)   
  }@else{
   @return _
  }
 }
 //pre 0
 //only func and handler can be defined individually 
 @if(c == "func"){
  @return func2cptx(v, def, local, func, name)  
 }

 ///others
 #dfd = def.dic[id]
 @if(dfd != _){
  @return dfd
 }

 Cptx#r = ast2cptx(v, def, local, func, id)
 @if(r.name == ""){
  #t = typepredx(r)
  @if(t.id == unknownc.id){
   log(id)
   log(v)
   die("global var must know type")
  }
  def.dic[id] = defx(t);
  #ip = idNewx(def, id, idglobalc)
  #af = classGetx(idglobalc, "assign")
  @return callNewx(af, [ip, r], callrawc)
 }
 @return r
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
    Cptx#lefto = idNewx(def, name, idglobalc)
   }
  }
 }
 @if(lefto == _){
  Cptx#lefto = ast2cptx(left, def, local, func)
 }

 @if(inClassx(classx(lefto), idstatec)){ //#a = 1  set a type Int
  Cptx#s = lefto.class
  Str#idstr = lefto.str
  #type = s.dic[idstr]
  @if(type == _ || type.id == nullv.id){//only set in not like Str#a
   @if(predt == _){
    s.dic[idstr] = cptv
   }@else{
    s.dic[idstr] = defx(predt)
    #lpredt = predt;
    @if(predt.fbitems){
     //a = {}/[];cache init right expr for future a itemsType change
     s.dic[idstr].val = righto
    }
   }
  }
 }
 //for exp: Uint#a = 1
 @if(!lpredt){
  lpredt = typepredx(lefto)
 }
 #righto = convertx(righto, lpredt)
 
 #f = getx(lefto, "assign")
 @if(f == _){
  log(lefto)
  die("no assign")
 }
 @return callNewx(f, [lefto, righto], callrawc)
}
call2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #v = Astx(ast[1])
 Cptx#f = ast2cptx(v, def, local, func)

 #f = preExecx(f)
 #astarr = Astx(ast[2])
 @if(f.type == T##CLASS){
  @if(astarr.len() == 0){
   @return callNewx(defmain.dic["type"], [f], callrawc)
  }
  @return convertx(ast2cptx(Astx(astarr[0]), def, local, func), f)
 }
 #vt = getx(f, "funcVarTypes")
 #arrx = &Arrx
 @each i e astarr{
  Cptx#ee = ast2cptx(Astx(e), def, local, func)
  @if(vt){
   ee = convertx(ee, classx(vt.arr[i]))
  }
  ee = preExecx(ee)  
  arrx.push(ee)
 }
 //TODO if f is funcproto check type
 @if(f.fraw){
  @return callNewx(f, arrx, callrawc) 
 }
 @return callNewx(f, arrx)
 
}
callmethod2cptx ->(ast Astx, def Cptx, local Cptx, func Cptx)Cptx{
 Cptx#oo = ast2cptx(Astx(ast[1]), def, local, func)

 #to = typepredx(oo)
 @if(to.id == unknownc.id){
  log(strx(oo))
  die("cannot typepred obj")
 }
 
 #f = getx(to, Str(ast[2]))
 
 @if(f == _){
  log(strx(oo))
  log(strx(to))
  log(Str(ast[2]))  
  die("no method")
 }  
 #astarr = Astx(ast[3]) 
 #vt = getx(f, "funcVarTypes") 
 #arrx = malloc(astarr.len() + 1, Cptx)
 arrx[0] = oo
 @each i e astarr{
  Cptx#ee = ast2cptx(Astx(e), def, local, func)
  @if(vt){
   ee = convertx(ee, classx(vt.arr[i+1]))
  }
  ee = preExecx(ee)  
  arrx[i+1] = ee
 }
 
 @if(f.fraw){
  @return callNewx(f, arrx, callrawc) 
 }
 @return callNewx(f, arrx)
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
   def2cptx(eee, def, local, func, 12)
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
 #dicl = dicNewx(&Dicx, _, dicuintc)
 //TODO read def function and breakpoints first
 #i = 0;
 @each _ e ast{
  #ee = Astx(e)
  #idpre = Str(Astx(ee[0])[0])
  @if(ee.len() == 2){
   dicl.dic[Str(ee[1])] = intNewx(i, uintc)
  }
  @if(idpre == "if"){
   Cptx#c = if2cptx(Astx(ee[0]), def, local, func, x)
  }@elif(idpre == "each"){
   Cptx#c = each2cptx(Astx(ee[0]), def, local, func, x)
  }@elif(idpre == "for"){
   Cptx#c = for2cptx(Astx(ee[0]), def, local, func, x)
  }@else{
   Cptx#c = subAst2cptx(Astx(ee[0]), def, local, func)  
  }
  @if(c == _){
   @continue
  }
  c.ast = Astx(ee[0])  
  arr.push(c)
  i++  
 }
 x.dic["blockVal"] = arrNewx(arr)
 x.dic["blockStateDef"] = local
 x.dic["blockLabels"] = dicl
 
 x.dic["blockScope"] = def
 @return x
}

ast2arrx ->(asts Astx, def Cptx, local Cptx, func Cptx, it Cptx, il Int)Cptx{
 @if(il == 0){
  #arrx = malloc(asts.len(), Cptx)
 }@else{
  #arrx = malloc(il, Cptx) 
 }
 #callable = @false;
 @each i e asts{
  Cptx#ee = ast2cptx(Astx(e), def, local, func)
  @if(ee.fmid){
   callable = @true;
  }
  @if(it == _){
   it = typepredx(ee)
  }    
  arrx[i] = ee
 }

 @if(!callable){
  @each i v arrx{
   @if(v != _){
    arrx[i] = preExecx(v)
   }
  }
 }
 #l = arrx.len()
 @if(il == -1){
  il = l
 }

 #c = itemsDefx(arrc, it, il, callable) 
 #r = arrNewx(arrx, c)  
 @if(callable){
  r.fmid = @true
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
 @if(il == -1){
  il = arrx.len()
 }
 #c = itemsDefx(dicc, it, il, callable) 
 #r = dicNewx(dicx, arrx, c)   
 @if(callable){
  r.fmid = @true
 }
 @return r;
}
ast2jsonx ->(asts Astx, def Cptx, local Cptx, func Cptx)Cptx{
 #dicx = &Dicx
 #arrx = &Arrx 
 #callable = @false;
 @each _ eo asts{
  #e = Astx(eo)
  #k = Str(e[1]) 
  #vv = Astx(e[0])
  #key = Str(vv[0])
  @if(key == "dic"){
   vv[0] = "json"
  }@elif(key == "arr"){
   vv[0] = "jsonarr"  
  }
  Cptx#ee = ast2cptx(vv, def, local, func)  
  #ee = ast2cptx(Astx(vv), def, local, func)
  #t = typepredx(ee)
  @if(inClassx(t, dicc) && !inClassx(t, jsonc)){
   #ee = convertx(ee, jsonc)
  }@elif(inClassx(t, arrc) && !inClassx(t, jsonarrc)){
   #ee = convertx(ee, jsonarrc)  
  }
  @if(ee.fmid){
   callable = @true;
  }
  arrx.push(strNewx(k))
  dicx[k] = ee;
 }
 @if(!callable){
  @each k2 v dicx{
   dicx[k2] = preExecx(v)
  }
 }
 #r = dicNewx(dicx, arrx, jsonc)
 @if(callable){
  r.fmid = @true
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
  @return blockmain2cptx(ast, def, local, func, name)
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
  @return idlocal2cptx(ast, def, local, func)
 }@elif(t == "idcond"){
  @return idNewx(_, Str(ast[1]), idcondc)
 }@elif(t == "idlib"){
  @return defmain.dic[Str(ast[1])]
 }@elif(t == "id"){
  @return id2cptx(ast, def, local, func)
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
 }@elif(t == "handler"){
  @return handler2cptx(ast, def, local, func, name)    
 }@elif(t == "op"){
  @return op2cptx(ast, def, local, func)
 }@elif(t == "itemsget"){
  @return itemsget2cptx(ast, def, local, func)
 }@elif(t == "objget"){
  @return objget2cptx(ast, def, local, func)
 }@elif(t == "return"){
  @return return2cptx(ast, def, local, func)
 }@elif(t == "err"){
  @return err2cptx(ast, def, local, func)    
 }@elif(t == "break"){
  @return objNewx(ctrlbreakc)
 }@elif(t == "continue"){
  @return objNewx(ctrlcontinuec)    
 }@elif(t == "str"){
  #x = strNewx(Str(ast[1]))
  x.fast = @true
  @return x
 }@elif(t == "byte"){
  #x = intNewx(Bytes(Str(ast[1]))[0], bytec)
  x.str = Str(ast[1])
  x.fast = @true
  @return x
 }@elif(t == "bytes"){
  #x = bytesNewx(Bytes(Str(ast[1])))
  x.fast = @true
  @return x
 }@elif(t == "float"){
  #x = floatNewx(Float(Str(ast[1])))
  x.fast = @true
  @return x  
 }@elif(t == "int"){ 
  #x = intNewx(Str(ast[1]))
  x.fast = @true
  @return x  
 }@elif(t == "dic"){
  @if(ast.len() > 2){
   @if(ast[2] != _){
    #it = classGetx(def, Str(ast[2]))
   }
   @if(ast[3] != _){   
    #il = Int(Str(ast[3]))
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
    #il = Int(Str(ast[3]))
   }
  }
  #x = ast2arrx(Astx(ast[1]), def, local, func, it, il)
  x.fast = @true
  @return x
 }@elif(t == "json"){
  #x = json2cptx(ast, def, local, func)
  x.fast = @true
  @return x  
 }@elif(t == "jsonarr"){ 
 }@elif(t == "obj"){
  #x = obj2cptx(ast, def, local, func)
  x.fast = @true
  @return x
 }@elif(t == "fs"){
  @return fsv
 }@elif(t == "net"){
  @return netv
 }@elif(t == "stdin"){
  @return stdinv
 }@elif(t == "stdout"){
  @return stdoutv
 }@elif(t == "stderr"){
  @return stderrv
 }@elif(t == "soul"){
  @return soulv
 }@elif(t == "world"){
  @return worldv
// }@elif(t == "root"){
//  @return rootv
 }@elif(t == "main"){
  @return defmain
 }@else{
  log(ast)
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
