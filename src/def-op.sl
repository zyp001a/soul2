opDefx(arrc, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 @return o.arr[e.int]
},intc, cptc, opgetc)
opDefx(dicc, "get", ->(x Arrx, env Cptx)Cptx{
 Cptx#o = x[0]
 Cptx#e = x[1]
 #r = o.dic[e.str]
 @return nullOrx(r)
},strc, cptc, opgetc)
opDefx(jsonc, "get", ->(x Arrx, env Cptx)Cptx{
// Cptx#o = x[0]
// Cptx#e = x[1]
 //TODO
 @return nullv
},strc, cptc, opgetc)

opDefx(idlocalc, "assign", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];

 #v = execx(r, env)
 Cptx#local = env.dic["envLocal"]
 #str = l.dic["idStr"]
 local.dic[str.str] = dynEnsure(v)
 @return v
}, cptc, cptc, opassignc)

opDefx(idstatec, "assign", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 #v = execx(r, env)
 Str#k = l.dic["idStr"].str
 Cptx#o = l.dic["idState"].obj
 o.dic[k] = dynEnsure(v)
 @return v
}, cptc, cptc, opassignc)

opDefx(strc, "add", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return strNewx(l.str + r.str)
}, strc, strc, opaddc)
opDefx(strc, "eq", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.str == r.str)
}, strc, boolc, opeqc)
opDefx(strc, "ne", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.str != r.str)
}, strc, boolc, opnec)
opDefx(strc, "concat", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 l.str += r.str
 @return l
}, strc, strc, opconcatc)

opDefx(intc, "add", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int + r.int)
}, intc, intc, opaddc)
opDefx(intc, "subtract", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int - r.int)
}, intc, intc, opsubtractc)

opDefx(intc, "multiply", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int * r.int)
}, intc, intc, opmultiplyc)

opDefx(intc, "divide", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int / r.int)
}, intc, intc, opdividec)
opDefx(intc, "mod", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return intNewx(l.int % r.int)
}, intc, intc, opmodc)
opDefx(intc, "eq", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int == r.int)
}, intc, boolc, opeqc)
opDefx(intc, "ne", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int != r.int)
}, intc, boolc, opnec)
opDefx(intc, "lt", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int < r.int)
}, intc, boolc, opltc)
opDefx(intc, "gt", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int > r.int)
}, intc, boolc, opgtc)
opDefx(intc, "le", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int <= r.int)
}, intc, boolc, oplec)
opDefx(intc, "ge", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int >= r.int)
}, intc, boolc, opgec)

opDefx(boolc, "and", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int != 0 && r.int != 0)
}, boolc, boolc, opandc)
opDefx(boolc, "or", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(l.int !=0 || r.int != 0)
}, boolc, boolc, oporc)

opDefx(cptc, "add", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @if(l.type != r.type){
  log(strx(l)) 
  die("add: wrong type")
 }
 @if(l.type == T##INT){ 
  @return intNewx(l.int + r.int)
 }
 @if(l.type == T##FLOAT){ 
  @return floatNewx(Float(l.val) + Float(r.val))
 }
 @if(l.type == T##STR){ 
  @return strNewx(l.str + r.str)
 }
 log(strx(l))
 die("cannot add")
 @return nullv
}, cptc, cptc, opaddc)
opDefx(cptc, "not", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 @if(l.type != T##INT){
  log(strx(l)) 
  die("not wrong type")
 }
 @return boolNewx(l.int == 0)
}, _, boolc, opnotc)
opDefx(cptc, "ne", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(!eqx(l, r))
}, cptc, boolc, opnec)
opDefx(cptc, "eq", ->(x Arrx, env Cptx)Cptx{
 Cptx#l = x[0];
 Cptx#r = x[1];
 @return boolNewx(eqx(l, r))
}, cptc, boolc, opeqc)
