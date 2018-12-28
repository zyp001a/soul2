package main
import "strconv"
import "strings"
import "io/ioutil"
import "log"
import "os"
import "fmt"
import "runtime/debug"
import "sort"
import "os/exec"
import "encoding/json"
import "path/filepath"
const (
  TCPT = 0
  TOBJ = 1
  TCLASS = 2
  TNULL = 3
  TINT = 4
  TFLOAT = 5
  TNUMBIG = 6
  TSTR = 7
  TDIC = 8
  TARR = 9
  TVALFUNC = 10
  TCALL = 11
  TFUNC = 12
  TBLOCK = 13
  TID = 14
  TIF = 15
  TFOR = 16
  TEACH = 17
  TCTRL = 18
)
type Funcx func(*[]*Cptx, *Cptx) *Cptx
type Dicx map[string]*Cptx
type Arrx *[]*Cptx
type Astx []interface{}
type Cptx struct {
  _arr *[]*Cptx
  _ast []interface{}
  _class *Cptx
  _ctype uint
  _dic map[string]*Cptx
  _farg bool
  _fdefault bool
  _fmid bool
  _fprop bool
  _fstatic bool
  _func func(*[]*Cptx, *Cptx) *Cptx
  _id string
  _int int
  _name string
  _obj *Cptx
  _str string
  _type uint
  _val interface{}
}
var _version int
var _uidi uint
var _inClassCache map[string]int
var _root map[string]*Cptx
var __indentx string
var _defns *Cptx
var _defmain *Cptx
var _cptc *Cptx
var _cptv *Cptx
var _objc *Cptx
var _classc *Cptx
var _emptyclassgetc *Cptx
var _emptyclassgetv *Cptx
var _valc *Cptx
var _nullv *Cptx
var _nullc *Cptx
var _zerointv *Cptx
var _zerofloatv *Cptx
var _numc *Cptx
var _intc *Cptx
var _uintc *Cptx
var _floatc *Cptx
var _boolc *Cptx
var _bytec *Cptx
var _numbigc *Cptx
var _truev *Cptx
var _falsev *Cptx
var _itemsc *Cptx
var _itemslimitedc *Cptx
var _arrc *Cptx
var _staticarrc *Cptx
var _midc *Cptx
var _arrbytec *Cptx
var _dicc *Cptx
var _zerostrv *Cptx
var _strc *Cptx
var _arrstrc *Cptx
var _dicstrc *Cptx
var _dicuintc *Cptx
var _dicclassc *Cptx
var _arrclassc *Cptx
var _enumc *Cptx
var _bufferc *Cptx
var _jsonc *Cptx
var _jsonarrc *Cptx
var _pointerc *Cptx
var _pathc *Cptx
var _filec *Cptx
var _dirc *Cptx
var _emptyreturnc *Cptx
var _emptyreturnv *Cptx
var _funcc *Cptx
var _funcprotoc *Cptx
var _valfuncc *Cptx
var _funcnativec *Cptx
var _blockc *Cptx
var _blockmainc *Cptx
var _funcblockc *Cptx
var _funcclosurec *Cptx
var _functplc *Cptx
var _callc *Cptx
var _callrawc *Cptx
var _calltypec *Cptx
var _callassignc *Cptx
var _callmethodc *Cptx
var _callreflectc *Cptx
var _idc *Cptx
var _idstrc *Cptx
var _idstatec *Cptx
var _idlocalc *Cptx
var _idparentc *Cptx
var _idglobalc *Cptx
var _idclassc *Cptx
var _aliasc *Cptx
var _opc *Cptx
var _op1c *Cptx
var _op2c *Cptx
var _opgetc *Cptx
var _opnotc *Cptx
var _opmultiplyc *Cptx
var _opdividec *Cptx
var _opmodc *Cptx
var _opaddc *Cptx
var _opsubtractc *Cptx
var _opgec *Cptx
var _oplec *Cptx
var _opgtc *Cptx
var _opltc *Cptx
var _opeqc *Cptx
var _opnec *Cptx
var _opandc *Cptx
var _oporc *Cptx
var _opassignc *Cptx
var _opconcatc *Cptx
var _signalc *Cptx
var _continuec *Cptx
var _breakc *Cptx
var _gotoc *Cptx
var _returnc *Cptx
var _errorc *Cptx
var _ctrlc *Cptx
var _ctrlargc *Cptx
var _ctrlargsc *Cptx
var _ctrlifc *Cptx
var _ctrlforc *Cptx
var _ctrleachc *Cptx
var _ctrlwhilec *Cptx
var _ctrlbreakc *Cptx
var _ctrlcontinuec *Cptx
var _ctrlgotoc *Cptx
var _ctrlreturnc *Cptx
var _ctrlerrorc *Cptx
var _envc *Cptx
var _execns *Cptx
var _execmain *Cptx
var _tplmain *Cptx
var __osArgs *Cptx
func uidx() string{
  var _r string
  _r = strconv.FormatUint(uint64(_uidi), 10)
  _uidi = _uidi + 1
  return _r
}
func dicOrx(_x map[string]*Cptx) map[string]*Cptx{
  if(_x == nil){
    return map[string]*Cptx{
    }
  }else{
    return _x
  }
}
func arrOrx(_x *[]*Cptx) *[]*Cptx{
  if(_x == nil){
    return &[]*Cptx{}
  }else{
    return _x
  }
}
func arrCopyx(_o *[]*Cptx) *[]*Cptx{
  var _e *Cptx
  var _n *[]*Cptx
  if(_o == nil){
    return nil
  }
  _n = &[]*Cptx{}
  _tmp47899 := _o;
  for _tmp47900 := uint(0); _tmp47900 < uint(len((*_tmp47899))); _tmp47900 ++ {
    _e = (*_tmp47899)[_tmp47900]
    (*_n) = append((*_n), _e)
  }
  return _n
}
func dicCopyx(_o map[string]*Cptx) map[string]*Cptx{
  var _k string
  var _n map[string]*Cptx
  var _v *Cptx
  if(_o == nil){
    return nil
  }
  _n = map[string]*Cptx{
  }
  for _k, _v = range _o {
    _n[_k] = _v
  }
  return _n
}
func _Str_split(s string, sep string) *[]string {
 tmp:=strings.Split(s, sep);
 return &tmp;
}
func indx(_s string, _first int) string{
  var _arr *[]string
  var _i uint
  var _r string
  var _x string
  if(_s == ""){
    return _s
  }
  _arr = _Str_split(_s, "\n")
  _r = ""
  if(_first == 0){
    _r += __indentx
  }
  _tmp57955 := _arr;
  for _i = uint(0); _i < uint(len((*_tmp57955))); _i ++ {
    _x = (*_tmp57955)[_i]
    if(_i != 0 && _x != ""){
      _r += "\n"
      _r += __indentx
    }
    _r += _x
  }
  return _r
}
func escapex(_s string) string{
  return strings.Replace(strings.Replace(strings.Replace(strings.Replace(strings.Replace(_s, "\\", "\\\\", -1), "\n", "\\n", -1), "\t", "\\t", -1), "\r", "\\r", -1), "\"", "\\\"", -1)
}
func _File_write(f string, s string){
 err := ioutil.WriteFile(f, []byte(s), 0666);
 if(err != nil){
  log.Fatal(err);os.Exit(1)

 }
}
func dirWritex(_d string, _dic map[string]*Cptx) {
  var _k string
  var _v *Cptx
  var _x string
  for _k, _v = range _dic {
    if(_v._type == TSTR){
      _x = _d + _k
      _File_write(_x, _v._str)
    }else if(_v._type == TDIC){
      dirWritex(_d + _k, _v._dic)
    }else{
      fmt.Println(dic2strx(_dic, 0))
      fmt.Println("wrong dic for dirWrite");debug.PrintStack();os.Exit(1)
    }
  }
}
func _Arr_Str_sort(c *[]string)*[]string{
 sort.Strings(*c)
 return c
}
func _keys(dic map[string]*Cptx)*[]string{
 keys := make([]string, 0, len(dic))
 for k, _ := range dic {
  keys = append(keys, k)
 }
 return &keys
}

func appendClassx(_o *Cptx, _c *Cptx) {
  var _k string
  var _v *Cptx
  _tmp75106 := _Arr_Str_sort(_keys(_c._dic));
  for _tmp75107 := uint(0); _tmp75107 < uint(len((*_tmp75106))); _tmp75107 ++ {
    _k = (*_tmp75106)[_tmp75107]
    if(_o._dic[_k] == nil){
      (*_o._arr) = append((*_o._arr), strNewx(_k))
      _o._dic[_k] = _c._dic[_k]
    }
  }
  _tmp80089 := _c._arr;
  for _tmp80090 := uint(0); _tmp80090 < uint(len((*_tmp80089))); _tmp80090 ++ {
    _v = (*_tmp80089)[_tmp80090]
    appendClassx(_o, _v)
  }
}
func ifcheckx(_r *Cptx) bool{
  if(_r._type == TINT){
    return _r._int != 0
  }
  return _r._type != TNULL
}
func parentMakex(_o *Cptx, _parentarr *[]*Cptx) {
  var _ctype uint
  var _e *Cptx
  if(_parentarr != nil){
    _ctype = _o._ctype
    _tmp87923 := _parentarr;
    for _tmp87924 := uint(0); _tmp87924 < uint(len((*_tmp87923))); _tmp87924 ++ {
      _e = (*_tmp87923)[_tmp87924]
      if(_e._id == ""){
        fmt.Println("no id");debug.PrintStack();os.Exit(1)
      }
      if(_e._ctype > _ctype){
        _ctype = _e._ctype
      }
    }
    _o._arr = _parentarr
    _o._ctype = _ctype
  }else{
    if(_o._arr == nil){
      _o._arr = &[]*Cptx{}
    }
  }
}
func classNewx(_arr *[]*Cptx, _dic map[string]*Cptx) *Cptx{
  var _r *Cptx
  _r = &Cptx{
    _type: TCLASS,  
    _ctype: TOBJ,  
    _id: uidx(),  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  _r._dic = dicOrx(_dic)
  parentMakex(_r, _arr)
  return _r
}
func strNewx(_x string) *Cptx{
  return &Cptx{
    _type: TSTR,  
    _str: _x,  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _id: "",  
    _int: 0,  
    _name: "",  
  }
}
func intNewx(_x int) *Cptx{
  return &Cptx{
    _type: TINT,  
    _int: _x,  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _id: "",  
    _name: "",  
    _str: "",  
  }
}
func arrNewx(_class *Cptx, _val *[]*Cptx) *Cptx{
  var _x *Cptx
  _x = &Cptx{
    _type: TARR,  
    _id: uidx(),  
    _obj: _class,  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  if(_val != nil){
    _x._arr = _val
  }else{
    _x._arr = &[]*Cptx{}
  }
  return _x
}
func dicNewx(_class *Cptx, _dic map[string]*Cptx, _arr *[]*Cptx) *Cptx{
  var _k string
  var _r *Cptx
  _r = &Cptx{
    _type: TDIC,  
    _obj: _class,  
    _id: uidx(),  
    _dic: dicOrx(_dic),  
    _arr: arrOrx(_arr),  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  if(_arr == nil){
    if(_dic != nil){
      for _k, _ = range _dic {
        (*_r._arr) = append((*_r._arr), strNewx(_k))
      }
    }else{
      _r._arr = &[]*Cptx{}
    }
  }else{
    _r._arr = _arr
  }
  return _r
}
func nsNewx(_name string) *Cptx{
  var _x *Cptx
  _x = dicNewx(nil, nil, nil)
  _x._name = "Ns_" + _name
  _x._str = _name
  return _x
}
func scopeNewx(_ns *Cptx, _name string) *Cptx{
  var _x *Cptx
  _x = classNewx(nil, nil)
  _x._name = "Scope_" + _ns._str + "_" + _name
  _x._str = _ns._str + "/" + _name
  if(_ns._dic[_name] == nil){
    (*_ns._arr) = append((*_ns._arr), strNewx(_name))
  }
  _ns._dic[_name] = _x
  return _x
}
func objNewx(_class *Cptx, _dic map[string]*Cptx) *Cptx{
  var _x *Cptx
  if(_class._ctype != TOBJ){
    fmt.Println("objNew error, should use def");debug.PrintStack();os.Exit(1)
  }
  _x = &Cptx{
    _type: TOBJ,  
    _id: uidx(),  
    _dic: dicOrx(_dic),  
    _obj: _class,  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  if(_dic == nil || len(_dic) == 0){
    _x._fdefault = true
  }
  _class._obj = _x
  return _x
}
func scopeObjNewx(_class *Cptx) *Cptx{
  if(_class._obj != nil){
    return _class._obj
  }
  return objNewx(_class, nil)
}
func routex(_o *Cptx, _scope *Cptx, _name string) *Cptx{
  var _dic map[string]*Cptx
  _dic = _scope._dic
  _dic[_name] = _o
  _o._name = _name
  _o._class = _scope
  return _o
}
func classDefx(_scope *Cptx, _name string, _parents *[]*Cptx, _schema map[string]*Cptx) *Cptx{
  var _k string
  var _v *Cptx
  var _x *Cptx
  _x = classNewx(_parents, nil)
  for _k, _v = range _schema {
    if(_v == nil){
      fmt.Println(_name)
      fmt.Println(_k);debug.PrintStack();os.Exit(1)
    }
    _x._dic[_k] = defx(_v, nil)
  }
  routex(_x, _scope, _name)
  return _x
}
func curryDefx(_scope *Cptx, _name string, _class *Cptx, _schema map[string]*Cptx) *Cptx{
  var _x *Cptx
  _x = classNewx(&[]*Cptx{_class}, _schema)
  routex(_x, _scope, _name)
  return _x
}
func _Path_exists(s string) bool{
 _, err := os.Stat(s);
 return !os.IsNotExist(err)
}
func _File_readAll(s string)string{
 r, err := ioutil.ReadFile(s)
 if(err != nil){
  log.Fatal(err);os.Exit(1)

 }
 return string(r)
}

func nsGetx(_ns *Cptx, _key string) *Cptx{
  var _arr *[]string
  var _f string
  var _fc string
  var _s *Cptx
  var _v string
  _s = _ns._dic[_key]
  if(_s != nil){
    return _s
  }
  _s = scopeNewx(_ns, _key)
  _f = os.Getenv("HOME") + "/soul2/db/" + _ns._str + "/" + _key + ".slp"
  if(_Path_exists(_f)){
    _fc = _File_readAll(_f)
    _arr = _Str_split(_fc, " ")
    _tmp170815 := _arr;
    for _tmp170816 := uint(0); _tmp170816 < uint(len((*_tmp170815))); _tmp170816 ++ {
      _v = (*_tmp170815)[_tmp170816]
      (*_s._arr) = append((*_s._arr), nsGetx(_ns, _v))
    }
  }
  return _s
}
func _Path_timeMod(name string)int{
 x, err := os.Stat(name);
 if(os.IsNotExist(err)){
  return -1
 }
 return int(x.ModTime().Unix())
}
func _osCmd(cmdstr string, sin string) string {
 cmd:= exec.Command("/bin/bash", "-c", cmdstr);
 if(sin != ""){
  cmd.Stdin = strings.NewReader(sin)
 };
 cmd.Stderr = os.Stderr;
 out, err := cmd.Output();
 if(err!= nil){
  log.Fatal(err);os.Exit(1)

 }
 return string(out);
}
func _Str_toJsonArr(x string)[]interface{}{
 var res []interface{};
 json.Unmarshal([]byte(x), &res);
 return res;
}
func dbGetx(_scope *Cptx, _key string) *Cptx{
  var _ast []interface{}
  var _f string
  var _f2 string
  var _f2cache string
  var _fcache string
  var _fstr string
  var _jstr string
  var _r *Cptx
  var _str string
  _fstr = os.Getenv("HOME") + "/soul2/db/" + _scope._str + "/" + _key + ".sl"
  _f = _fstr
  _f2 = _fstr + "t"
  _fcache = _fstr + ".cache"
  _f2cache = _fstr + "t.cache"
  if(_Path_exists(_f)){
    _str = _File_readAll(_f)
    if(_Path_timeMod(_f) > _Path_timeMod(_fcache)){
      _jstr = _osCmd("./sl-reader", _key + " := " + _str)
      _File_write(_fcache, _jstr)
    }else{
      _jstr = _File_readAll(_fcache)
    }
  }else if(_Path_exists(_f2)){
    _str = "@`" + _File_readAll(_f2) + "` '" + _fstr + "t'"
    if(_Path_timeMod(_f2) > _Path_timeMod(_f2cache)){
      _jstr = _osCmd("./sl-reader", _key + " := " + _str)
      _File_write(_f2cache, _jstr)
    }else{
      _jstr = _File_readAll(_f2cache)
    }
  }else{
    return nil
  }
  _ast = _Str_toJsonArr(_jstr)
  if(len(_ast) == 0){
    fmt.Println("dbGetx: wrong grammar");debug.PrintStack();os.Exit(1)
  }
  _r = ast2cptx(_ast, _scope, classNewx(nil, nil), nil, "")
  return _r
}
func subClassGetx(_scope *Cptx, _key string, _cache map[string]interface{}) *Cptx{
  var _k string
  var _r *Cptx
  var _v *Cptx
  _r = _scope._dic[_key]
  if(_r != nil){
    return _r
  }
  if(_scope._str != ""){
    _r = dbGetx(_scope, _key)
    if(_r != nil){
      _scope._dic[_key] = _r
      return _r
    }
  }
  _tmp204319 := _scope._arr;
  for _tmp204320 := uint(0); _tmp204320 < uint(len((*_tmp204319))); _tmp204320 ++ {
    _v = (*_tmp204319)[_tmp204320]
    _k = _v._id
    if(_cache[_k] != nil){
      continue
    }
    _cache[_k] = 1
    _r = subClassGetx(_v, _key, _cache)
    if(_r != nil){
      return _r
    }
  }
  return nil
}
func propDefx(_scope *Cptx, _key string, _r *Cptx) *Cptx{
  var _o *Cptx
  _o = copyx(_r)
  _o._class = _scope
  _o._name = _scope._name + "_" + _key
  return _o
}
func classGetx(_scope *Cptx, _key string) *Cptx{
  var _r *Cptx
  _r = subClassGetx(_scope, _key, map[string]interface{}{
  })
  if(_r == nil){
    if(_scope._str != ""){
      _scope._dic[_key] = _emptyclassgetv
    }
    return nil
  }else if(_r._id == _emptyclassgetv._id){
    return nil
  }
  if(_r._fprop){
    return propDefx(_scope, _key, _r)
  }
  return _r
}
func subMethodGetx(_scope *Cptx, _v *Cptx, _key string) *Cptx{
  var _r *Cptx
  var _vv *Cptx
  _r = classGetx(_scope, _v._name + "_" + _key)
  if(_r != nil){
    return _r
  }
  _tmp225188 := _v._arr;
  for _tmp225189 := uint(0); _tmp225189 < uint(len((*_tmp225188))); _tmp225189 ++ {
    _vv = (*_tmp225188)[_tmp225189]
    _r = subMethodGetx(_scope, _vv, _key)
    if(_r != nil){
      return _r
    }
  }
  return _r
}
func methodGetx(_scope *Cptx, _func *Cptx) *Cptx{
  var _o *Cptx
  var _p *[]*Cptx
  var _r *Cptx
  var _v *Cptx
  _r = classGetx(_scope, _func._name)
  if(_r != nil){
    return _r
  }
  _o = _func._class
  _p = _o._arr
  _tmp232801 := _p;
  for _tmp232802 := uint(0); _tmp232802 < uint(len((*_tmp232801))); _tmp232802 ++ {
    _v = (*_tmp232801)[_tmp232802]
    _r = subMethodGetx(_scope, _v, _func._str)
    if(_r != nil){
      return _r
    }
  }
  _r = subMethodGetx(_scope, _classc, _func._str)
  if(_r != nil){
    return _r
  }
  _r = subMethodGetx(_scope, _cptc, _func._str)
  if(_r != nil){
    return _r
  }
  return nil
}
func nullOrx(_x *Cptx) *Cptx{
  if(_x == nil){
    return _nullv
  }
  return _x
}
func isnull(_o *Cptx) bool{
  return _o._type == TNULL
}
func uintNewx(_x int) *Cptx{
  return &Cptx{
    _type: TINT,  
    _obj: _uintc,  
    _int: _x,  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _id: "",  
    _name: "",  
    _str: "",  
  }
}
func boolNewx(_x bool) *Cptx{
  if(_x){
    return _truev
  }
  return _falsev
}
func floatNewx(_x float64) *Cptx{
  return &Cptx{
    _type: TFLOAT,  
    _val: _x,  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _id: "",  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
}
func itemDefx(_class *Cptx, _type *Cptx, _mid bool) *Cptx{
  var _n string
  var _r *Cptx
  if(_type != nil && _type._id != _cptc._id){
    _type = aliasGetx(_type)
    _n = _class._name + "_" + _type._name
    _r = classGetx(_defmain, _n)
    if(_r == nil){
      _r = classDefx(_defmain, _n, &[]*Cptx{_class}, map[string]*Cptx{
        "itemsType": _type,
      })
    }
  }else{
    _r = _class
  }
  if(_mid){
    return classDefx(_defmain, _n, &[]*Cptx{_r, _midc}, nil)
  }
  return _r
}
func fpDefx(_types *[]*Cptx, _return *Cptx) *Cptx{
  var _n string
  var _v *Cptx
  var _x *Cptx
  _n = "FuncProto"
  _tmp329506 := _types;
  for _tmp329507 := uint(0); _tmp329507 < uint(len((*_tmp329506))); _tmp329507 ++ {
    _v = (*_tmp329506)[_tmp329507]
    _n += "_" + aliasGetx(classx(_v))._name
  }
  _n += "__" + _return._name
  _x = classGetx(_defmain, _n)
  if(_x == nil){
    _x = curryDefx(_defmain, _n, _funcprotoc, map[string]*Cptx{
      "funcVarTypes": arrNewx(_arrc, _types),
      "funcReturn": _return,
    })
  }
  return _x
}
func funcSetClosurex(_func *Cptx) {
  (*_func._obj._arr)[1] = _funcclosurec
}
func aliasDefx(_scope *Cptx, _key string, _class *Cptx) *Cptx{
  var _x *Cptx
  _x = classDefx(_scope, _key, &[]*Cptx{_aliasc, _class}, nil)
  return _x
}
func aliasGetx(_c *Cptx) *Cptx{
  if(_c._arr == nil){
    fmt.Println(strx(_c, 0))
    fmt.Println("wrong cpt");debug.PrintStack();os.Exit(1)
  }
  if(len((*_c._arr)) > 1){
    if((*_c._arr)[0]._id == _aliasc._id){
      return aliasGetx((*_c._arr)[1])
    }
  }
  return _c
}
func valfuncNewx(_f func(*[]*Cptx, *Cptx) *Cptx) *Cptx{
  return &Cptx{
    _type: TVALFUNC,  
    _id: uidx(),  
    _val: _f,  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
}
func callNewx(_func *Cptx, _args *[]*Cptx, _obj *Cptx) *Cptx{
  return &Cptx{
    _type: TCALL,  
    _id: uidx(),  
    _fmid: true,  
    _obj: _obj,  
    _class: _func,  
    _arr: arrOrx(_args),  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fprop: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
}
func funcNewx(_val func(*[]*Cptx, *Cptx) *Cptx, _argtypes *[]*Cptx, _return *Cptx) *Cptx{
  var _arr *[]*Cptx
  var _fp *Cptx
  var _v *Cptx
  var _x *Cptx
  if(_return == nil){
    _return = _emptyreturnc
  }
  _arr = &[]*Cptx{}
  _tmp464214 := _argtypes;
  for _tmp464215 := uint(0); _tmp464215 < uint(len((*_tmp464214))); _tmp464215 ++ {
    _v = (*_tmp464214)[_tmp464215]
    (*_arr) = append((*_arr), defx(_v, nil))
  }
  _fp = fpDefx(_arr, _return)
  if(_val != nil){
    _x = classNewx(&[]*Cptx{_fp, _funcnativec}, nil)
    _x._dic["funcNative"] = valfuncNewx(_val)
  }else{
    _x = classNewx(&[]*Cptx{_fp}, nil)
  }
  return objNewx(_x, nil)
}
func funcDefx(_scope *Cptx, _name string, _val func(*[]*Cptx, *Cptx) *Cptx, _argtypes *[]*Cptx, _return *Cptx) *Cptx{
  var _fn *Cptx
  _fn = funcNewx(_val, arrOrx(_argtypes), _return)
  routex(_fn, _scope, _name)
  return _fn
}
func methodDefx(_class *Cptx, _name string, _val func(*[]*Cptx, *Cptx) *Cptx, _argtypes *[]*Cptx, _return *Cptx) *Cptx{
  var _fn *Cptx
  if(_argtypes != nil){
    (*_argtypes) = append([]*Cptx{_class}, (*_argtypes)...)
  }else{
    _argtypes = &[]*Cptx{_class}
  }
  _fn = funcNewx(_val, _argtypes, _return)
  _fn._fprop = true
  _class._dic[_name] = _fn
  _fn._name = _class._name + "_" + _name
  _fn._str = _name
  return _fn
}
func funcSetOpx(_func *Cptx, _op *Cptx) {
  (*_func._obj._arr) = append((*_func._obj._arr), _op)
}
func opDefx(_class *Cptx, _name string, _val func(*[]*Cptx, *Cptx) *Cptx, _arg *Cptx, _return *Cptx, _op *Cptx) *Cptx{
  var _argt *[]*Cptx
  var _func *Cptx
  _argt = &[]*Cptx{}
  if(_arg != nil){
    (*_argt) = append((*_argt), _arg)
  }
  _func = methodDefx(_class, _name, _val, _argt, _return)
  funcSetOpx(_func, _op)
  return _func
}
func classRawx(_t uint) *Cptx{
  if(_t == TCPT){
    return _cptc
  }else if(_t == TOBJ){
    return _objc
  }else if(_t == TCLASS){
    return _classc
  }else if(_t == TNULL){
    return _nullc
  }else if(_t == TINT){
    return _intc
  }else if(_t == TFLOAT){
    return _floatc
  }else if(_t == TNUMBIG){
    return _numbigc
  }else if(_t == TSTR){
    return _strc
  }else if(_t == TDIC){
    return _dicc
  }else if(_t == TARR){
    return _arrc
  }else if(_t == TVALFUNC){
    return _valfuncc
  }else if(_t == TCALL){
    return _callc
  }else if(_t == TFUNC){
    return _funcc
  }else if(_t == TBLOCK){
    return _blockc
  }else{
    fmt.Println("NOTYPE");debug.PrintStack();os.Exit(1)
  }
  return nil
}
func typex(_o *Cptx) string{
  return ""
}
func classx(_o *Cptx) *Cptx{
  if(_o._type == TCLASS){
    return _o
  }
  if(_o._obj != nil){
    return _o._obj
  }
  return classRawx(_o._type)
}
func inClassx(_c *Cptx, _t *Cptx, _cache map[string]interface{}) bool{
  var _key string
  var _r int
  var _v *Cptx
  if(_c._type != TCLASS){
    fmt.Println(strx(_c, 0))
    fmt.Println("inClass: left not class");debug.PrintStack();os.Exit(1)
  }
  if(_t._type != TCLASS){
    fmt.Println(strx(_t, 0))
    fmt.Println("inClass: right not class");debug.PrintStack();os.Exit(1)
  }
  if(_t._id == _cptc._id){
    return true
  }
  if(_t._id == _objc._id && _c._ctype == TOBJ){
    return true
  }
  if(_c._id != "" && _c._id == _t._id){
    return true
  }
  _key = _c._id + "_" + _t._id
  _r = _inClassCache[_key]
  if(_r == 1){
    return true
  }
  if(_r == 2){
    return false
  }
  if(_cache == nil){
    _cache = map[string]interface{}{
    }
  }
  _tmp521407 := _c._arr;
  for _tmp521408 := uint(0); _tmp521408 < uint(len((*_tmp521407))); _tmp521408 ++ {
    _v = (*_tmp521407)[_tmp521408]
    if(_cache[_v._id] != nil){
      continue
    }
    _cache[_v._id] = 1
    if(inClassx(_v, _t, _cache)){
      _inClassCache[_key] = 1
      return true
    }
  }
  _inClassCache[_key] = 2
  return false
}
func defaultx(_t *Cptx) *Cptx{
  var _tar *Cptx
  if(_t._ctype == TINT){
    _tar = _zerointv
  }else if(_t._ctype == TFLOAT){
    _tar = _zerofloatv
  }else if(_t._ctype == TNUMBIG){
  }else if(_t._ctype == TSTR){
    _tar = _zerostrv
  }else{
    _tar = _nullv
  }
  return _tar
}
func defx(_class *Cptx, _dic map[string]*Cptx) *Cptx{
  var _k string
  var _pt *Cptx
  var _r *Cptx
  var _t *Cptx
  var _v *Cptx
  var _x *Cptx
  if(_class._ctype == TCPT){
    return _cptv
  }else if(_class._ctype == TOBJ){
    if(_dic != nil){
      for _k, _v = range _dic {
        _t = classGetx(_class, _k)
        if(_t == nil){
          fmt.Println("defx: not in " + _class._name + " " + _k);debug.PrintStack();os.Exit(1)
        }
        if(_v == nil){
          fmt.Println(_k)
          fmt.Println("defx: dic val null");debug.PrintStack();os.Exit(1)
        }
        _pt = typepredx(_v)
        if(_pt == nil || _pt._id == _cptc._id){
          continue
        }
        if(!inClassx(_pt, classx(_t), nil)){
          fmt.Println(_class._name)
          fmt.Println(_k)
          fmt.Println(strx(_v, 0))
          fmt.Println(strx(_pt, 0))
          fmt.Println(strx(_t, 0))
          fmt.Println("defx: type error");debug.PrintStack();os.Exit(1)
        }
      }
      _r = objNewx(_class, _dic)
      if(len(_dic) != 0){
        _r._fdefault = false
      }
    }else{
      _r = objNewx(_class, nil)
    }
    if(_midc != nil){
      if(inClassx(_class, _midc, nil)){
        _r._fmid = true
      }
    }
    return _r
  }else if(_class._ctype == TCLASS){
    return _cptc
  }else if(_class._ctype == TNULL){
    return _nullv
  }else if(_class._ctype == TINT){
    _x = intNewx(0)
    if(_class._name != "Int"){
      _x._obj = _class
    }
  }else if(_class._ctype == TFLOAT){
    _x = floatNewx(0)
    if(_class._name != "Float"){
      _x._obj = _class
    }
  }else if(_class._ctype == TNUMBIG){
    _x = _nullv
  }else if(_class._ctype == TSTR){
    _x = strNewx("")
    if(_class._name != "Str"){
      _x._obj = _class
    }
  }else if(_class._ctype == TVALFUNC){
    _x = valfuncNewx(nil)
  }else if(_class._ctype == TCALL){
    _x = callNewx(nil, nil, nil)
    _x._fdefault = true
  }else if(_class._ctype == TFUNC){
    _x = _nullv
  }else if(_class._ctype == TBLOCK){
    _x = _nullv
  }else if(_class._ctype == TDIC){
    _x = dicNewx(_class, nil, nil)
    _x._fdefault = true
  }else if(_class._ctype == TARR){
    _x = arrNewx(_class, nil)
    _x._fdefault = true
  }else{
    fmt.Println("unknown class type");debug.PrintStack();os.Exit(1)
    return nil
  }
  return _x
}
func copyx(_o *Cptx) *Cptx{
  var _x *Cptx
  if(_o._type == TCPT){
    return _o
  }
  if(_o._type == TNULL){
    return _o
  }
  if(_o._type == TCLASS){
    return _o
  }
  _x = &Cptx{
    _type: _o._type,  
    _ctype: _o._ctype,  
    _fmid: _o._fmid,  
    _fdefault: _o._fdefault,  
    _fprop: _o._fprop,  
    _name: _o._name,  
    _id: uidx(),  
    _class: _o._class,  
    _obj: _o._obj,  
    _dic: dicCopyx(_o._dic),  
    _arr: arrCopyx(_o._arr),  
    _str: _o._str,  
    _int: _o._int,  
    _val: _o._val,  
    _farg: false,  
    _fstatic: false,  
  }
  return _x
}
func eqx(_l *Cptx, _r *Cptx) bool{
  var _t uint
  if(_l._type != _r._type){
    return false
  }
  _t = _l._type
  if(_t == TCPT){
    return true
  }else if(_t == TNULL){
    return true
  }else if(_t == TOBJ){
    return _l._id == _r._id
  }else if(_t == TCLASS){
    return _l._id == _r._id
  }else if(_t == TDIC){
    return _l._id == _r._id
  }else if(_t == TARR){
    return _l._id == _r._id
  }else if(_t == TVALFUNC){
    return _l._id == _r._id
  }else if(_t == TCALL){
    return _l._id == _r._id
  }else if(_t == TFUNC){
    return _l._id == _r._id
  }else if(_t == TBLOCK){
    return _l._id == _r._id
  }else if(_t == TINT){
    return _l._int == _r._int
  }else if(_t == TFLOAT){
    return _l._val.(float64) == _r._val.(float64)
  }else if(_t == TNUMBIG){
    return true
  }else if(_t == TSTR){
    return _l._str == _r._str
  }else{
    fmt.Println(_t)
    fmt.Println("wrong type");debug.PrintStack();os.Exit(1)
    return false
  }
}
func getParentx(_o *Cptx, _key string) *Cptx{
  var _d map[string]*Cptx
  var _r *Cptx
  var _v *Cptx
  if(_o._arr == nil){
    return nil
  }
  _tmp604236 := _o._arr;
  for _tmp604237 := uint(0); _tmp604237 < uint(len((*_tmp604236))); _tmp604237 ++ {
    _v = (*_tmp604236)[_tmp604237]
    _d = _v._dic
    _r = _d[_key]
    if(_r != nil){
      return _v
    }
    _r = getParentx(_v, _key)
    if(_r != nil){
      return _r
    }
  }
  return nil
}
func objGetLocalx(_o *Cptx, _key string) *Cptx{
  var _r *Cptx
  _r = _o._dic[_key]
  if(_r != nil){
    return _r
  }
  if(_o._obj == nil){
    fmt.Println(strx(_o, 0))
    fmt.Println("local with no def");debug.PrintStack();os.Exit(1)
  }
  _r = classGetx(_o._obj, _key)
  if(_r != nil){
    return _r
  }
  return nil
}
func getx(_o *Cptx, _key string) *Cptx{
  var _r *Cptx
  if(_o._type == TCLASS){
    _r = classGetx(_o, _key)
    if(_r != nil){
      return _r
    }
    _r = classGetx(_classc, _key)
    if(_r != nil){
      return _r
    }
  }else if(_o._type == TOBJ){
    _r = _o._dic[_key]
    if(_r != nil){
      return _r
    }
    _r = classGetx(_o._obj, _key)
    if(_r != nil){
      return _r
    }
    _r = classGetx(_objc, _key)
    if(_r != nil){
      return _r
    }
  }else{
    _r = classGetx(classx(_o), _key)
    if(_r != nil){
      return _r
    }
  }
  return classGetx(_cptc, _key)
}
func setx(_o *Cptx, _key string, _val *Cptx) *Cptx{
  return _val
}
func _Str_isInt(v string)bool{
 _, err := strconv.Atoi(v);
 return err == nil
}
func typepredx(_o *Cptx) *Cptx{
  var _arg0 *Cptx
  var _arg1 *Cptx
  var _args *[]*Cptx
  var _at0 *Cptx
  var _cg *Cptx
  var _f *Cptx
  var _id string
  var _r *Cptx
  var _ret *Cptx
  var _s *Cptx
  var _t uint
  _t = _o._type
  if(_t == TCALL){
    _f = _o._class
    _args = _o._arr
    if(_f == nil){
      return _callc
    }
    if(_f._id == _defmain._dic["new"]._id){
      _arg0 = (*_args)[0]
      return _arg0
    }
    if(_f._id == _defmain._dic["as"]._id){
      _arg1 = (*_args)[1]
      return _arg1
    }
    if(_f._id == _defmain._dic["numConvert"]._id){
      _arg1 = (*_args)[1]
      return _arg1
    }
    if(_f._id == _defmain._dic["type"]._id){
      _arg0 = (*_args)[0]
      return _arg0
    }
    if(_f._id == _defmain._dic["get"]._id){
      _arg0 = (*_args)[0]
      _arg1 = (*_args)[1]
      _at0 = typepredx(_arg0)
      if(_at0 == nil || _at0._id == _cptv._id){
        return nil
      }
      _cg = getx(_at0, _arg1._str)
      if(_cg == nil){
        return nil
        fmt.Println(strx(_arg0, 0))
        fmt.Println(strx(_at0, 0))
        fmt.Println("typepred: cannot pred obj get, key is " + _arg1._str);debug.PrintStack();os.Exit(1)
      }
      return classx(_cg)
    }
    if(inClassx(_f._obj, _opgetc, nil)){
      _arg0 = (*_args)[0]
      _at0 = typepredx(_arg0)
      _r = getx(_at0, "itemsType")
      if(_r != nil){
        return classx(_r)
      }else{
        return _cptc
      }
    }
    if(inClassx(_f._obj, _functplc, nil)){
      return _strc
    }
    if(inClassx(_f._obj, _funcc, nil)){
      _ret = getx(_f, "funcReturn")
      if(_ret == nil){
        fmt.Println(strx(_f, 0))
        fmt.Println("no return");debug.PrintStack();os.Exit(1)
      }
      if(_ret._id == _emptyreturnc._id){
        return _cptc
      }
      return _ret
    }
    if(inClassx(_f._obj, _midc, nil)){
      return nil
    }
    return nil
  }else if(_t == TOBJ){
    if(inClassx(_o._obj, _idstatec, nil)){
      _id = _o._dic["idStr"]._str
      if(_Str_isInt(_id)){
        return _cptc
      }
      _s = _o._dic["idState"]
      _r = getx(_s, _id)
      if(_r == nil){
        fmt.Println(strx(_s, 0))
        fmt.Println(_id)
        fmt.Println("not defined in idstate, may use #1 #2 like");debug.PrintStack();os.Exit(1)
        return _r
      }
      return typepredx(_r)
    }
    if(inClassx(_o._obj, _idclassc, nil)){
      _s = _o._dic["idVal"]
      return typepredx(_s)
    }
    return _o._obj
  }else{
    return classx(_o)
  }
}
func dic2strx(_d map[string]*Cptx, _i int) string{
  var _k string
  var _s string
  var _v *Cptx
  _s = "{\n"
  for _k, _v = range _d {
    _s += indx(_k + ":" + strx(_v, _i + 1), 0) + "\n"
  }
  return _s + "}"
}
func arr2strx(_a *[]*Cptx, _i int) string{
  var _s string
  var _v *Cptx
  _s = "["
  if(len((*_a)) > 1){
    _s += "\n"
    _tmp685704 := _a;
    for _tmp685705 := uint(0); _tmp685705 < uint(len((*_tmp685704))); _tmp685705 ++ {
      _v = (*_tmp685704)[_tmp685705]
      _s += indx(strx(_v, _i + 1), 0) + "\n"
    }
  }else{
    _tmp687968 := _a;
    for _tmp687969 := uint(0); _tmp687969 < uint(len((*_tmp687968))); _tmp687969 ++ {
      _v = (*_tmp687968)[_tmp687969]
      _s += strx(_v, _i + 1)
    }
  }
  return _s + "]"
}
func parent2strx(_d *[]*Cptx) string{
  var _s string
  var _v *Cptx
  _s = ""
  _tmp692542 := _d;
  for _tmp692543 := uint(0); _tmp692543 < uint(len((*_tmp692542))); _tmp692543 ++ {
    _v = (*_tmp692542)[_tmp692543]
    if(_v._name != ""){
      _s += _v._name + " "
    }else{
      _s += "~" + _v._id + " "
    }
  }
  return _s
}
func strx(_o *Cptx, _i int) string{
  var _s string
  var _t uint
  if(_i > 3 && _o._id != ""){
    return "~" + _o._id
  }
  _t = _o._type
  if(_t == TCPT){
    return "&Cpt"
  }else if(_t == TOBJ){
    _s = ""
    if(_o._name != ""){
      _s += _o._name + " = "
    }
    if(_o._obj._name != ""){
      _s += "&" + _o._obj._name
    }else{
      _s += "&~" + _o._obj._id
    }
    if(!_o._fdefault){
      _s += dic2strx(_o._dic, _i)
    }
    return _s
  }else if(_t == TCLASS){
    _s = ""
    if(_o._name != ""){
      _s += _o._name + " = "
    }else{
      _s += "~" + _o._id + " = "
    }
    _s += "@class " + parent2strx(_o._arr) + " " + dic2strx(_o._dic, _i)
    return _s
  }else if(_t == TNULL){
    return "_"
  }else if(_t == TINT){
    return strconv.Itoa(_o._int)
  }else if(_t == TFLOAT){
    return strconv.FormatFloat(float64(_o._val.(float64)), 'f', -1, 64)
  }else if(_t == TSTR){
    return "\"" + escapex(_o._str) + "\""
  }else if(_t == TVALFUNC){
    return "&ValFunc"
  }else if(_t == TCALL){
    return "CALL"
  }else if(_t == TFUNC){
    return "&ValFunc"
  }else if(_t == TBLOCK){
    return "&ValFunc"
  }else if(_t == TDIC){
    return dic2strx(_o._dic, _i)
  }else if(_t == TARR){
    return arr2strx(_o._arr, _i)
  }else{
    fmt.Println(_o._obj)
    fmt.Println(_o)
    fmt.Println("cpt2str unknown");debug.PrintStack();os.Exit(1)
    return ""
  }
}
func tplCallx(_func *Cptx, _args *[]*Cptx, _env *Cptx) *Cptx{
  var _ast []interface{}
  var _b *Cptx
  var _i uint
  var _localx *Cptx
  var _nstate *Cptx
  var _ostate *Cptx
  var _stack *[]*Cptx
  var _v *Cptx
  _ast = _Str_toJsonArr(_func._dic["funcTplAst"]._str)
  if(len(_ast) == 0){
    return strNewx("")
  }
  _localx = classNewx(nil, nil)
  _localx._dic["$env"] = _env
  _localx._dic["$this"] = _func
  _tmp735093 := _args;
  for _i = uint(0); _i < uint(len((*_tmp735093))); _i ++ {
    _v = (*_tmp735093)[_i]
    _localx._dic[strconv.FormatUint(uint64(_i), 10)] = _v
  }
  _b = ast2cptx(_ast, _tplmain, _localx, nil, "")
  _nstate = objNewx(_localx, nil)
  _nstate._int = 2
  _stack = _env._dic["envStack"]._arr
  _ostate = _env._dic["envLocal"]
  (*_stack) = append((*_stack), _ostate)
  _env._dic["envLocal"] = _nstate
  blockExecx(_b, _env, 0)
  _env._dic["envLocal"] = (*_stack)[len((*_stack)) - 1]
  (*_stack) = (*_stack)[:len((*_stack))-1]
  return _nstate._dic["$str"]
}
func callx(_func *Cptx, _args *[]*Cptx, _env *Cptx) *Cptx{
  var _arg *Cptx
  var _block *Cptx
  var _i uint
  var _nstate *Cptx
  var _ostate *Cptx
  var _r *Cptx
  var _stack *[]*Cptx
  var _vars *[]*Cptx
  if(_func == nil || _func._obj == nil){
    fmt.Println(arr2strx(_args, 0))
    fmt.Println(strx(_func, 0))
    fmt.Println("func not defined");debug.PrintStack();os.Exit(1)
  }
  if(inClassx(_func._obj, _funcnativec, nil)){
    return getx(_func, "funcNative")._val.(func(*[]*Cptx, *Cptx) *Cptx)(_args, _env)
  }
  if(inClassx(_func._obj, _functplc, nil)){
    return tplCallx(_func, _args, _env)
  }
  if(inClassx(_func._obj, _funcblockc, nil)){
    _block = _func._dic["funcBlock"]
    _nstate = objNewx(_block._dic["blockStateDef"], nil)
    _nstate._int = 2
    _stack = _env._dic["envStack"]._arr
    _ostate = _env._dic["envLocal"]
    (*_stack) = append((*_stack), _ostate)
    _env._dic["envLocal"] = _nstate
    _vars = _func._dic["funcVars"]._arr
    _tmp764042 := _args;
    for _i = uint(0); _i < uint(len((*_tmp764042))); _i ++ {
      _arg = (*_tmp764042)[_i]
      _nstate._dic[(*_vars)[_i]._str] = _arg
    }
    _r = blockExecx(_block, _env, 0)
    _env._dic["envLocal"] = (*_stack)[len((*_stack)) - 1]
    (*_stack) = (*_stack)[:len((*_stack))-1]
    if(inClassx(classx(_r), _signalc, nil)){
      if(_r._obj._id == _returnc._id){
        return _r._dic["return"]
      }
      if(_r._obj._id == _errorc._id){
      }
      if(_r._obj._id == _breakc._id){
        fmt.Println("break in function!");debug.PrintStack();os.Exit(1)
      }
      if(_r._obj._id == _continuec._id){
        fmt.Println("continue in function!");debug.PrintStack();os.Exit(1)
      }
    }
    return _r
  }
  fmt.Println(strx(_func._obj, 0))
  fmt.Println("callx: unknown func");debug.PrintStack();os.Exit(1)
  return _nullv
}
func classExecGetx(_c *Cptx, _execsp *Cptx, _cache map[string]interface{}) *Cptx{
  var _exect *Cptx
  var _r *Cptx
  var _v *Cptx
  if(_c._id == ""){
    fmt.Println(strx(_c, 0))
    fmt.Println("no id");debug.PrintStack();os.Exit(1)
  }
  _r = _execsp._dic[_c._id]
  if(_r != nil){
    return _r
  }
  if(_c._name != ""){
    _exect = classGetx(_execsp, _c._name)
    if(_exect != nil){
      _execsp._dic[_c._id] = _exect
      return _exect
    }
  }
  if(_c._arr != nil){
    _tmp790060 := _c._arr;
    for _tmp790061 := uint(0); _tmp790061 < uint(len((*_tmp790060))); _tmp790061 ++ {
      _v = (*_tmp790060)[_tmp790061]
      if(_cache[_v._id] != nil){
        return nil
      }
      _cache[_v._id] = 1
      _exect = classExecGetx(_v, _execsp, _cache)
      if(_exect != nil){
        return _exect
      }
    }
  }
  return nil
}
func execGetx(_c *Cptx, _execsp *Cptx) *Cptx{
  var _exect *Cptx
  var _t *Cptx
  if(_c._type == TCLASS){
    _exect = classExecGetx(_classc, _execsp, map[string]interface{}{
    })
    if(_exect != nil){
      return _exect
    }
  }else{
    _t = classx(_c)
    _exect = classExecGetx(_t, _execsp, map[string]interface{}{
    })
    if(_exect != nil){
      return _exect
    }
    if(_c._type == TOBJ){
      _exect = classExecGetx(_objc, _execsp, map[string]interface{}{
      })
      if(_exect != nil){
        return _exect
      }
    }
  }
  return nil
}
func blockExecx(_o *Cptx, _env *Cptx, _stt uint) *Cptx{
  var _b *Cptx
  var _i uint
  var _r *Cptx
  var _v *Cptx
  _b = _o._dic["blockVal"]
  _tmp807493 := _b._arr;
  for _i = uint(0); _i < uint(len((*_tmp807493))); _i ++ {
    _v = (*_tmp807493)[_i]
    if(_stt != 0 && _stt < _i){
      continue
    }
    _r = execx(_v, _env, 0)
    if(inClassx(classx(_r), _signalc, nil)){
      return _r
    }
  }
  return _nullv
}
func preExecx(_o *Cptx) *Cptx{
  if(inClassx(classx(_o), _idclassc, nil)){
    return _o._dic["idVal"]
  }
  return _o
}
func execx(_o *Cptx, _env *Cptx, _flag int) *Cptx{
  var _ex *Cptx
  var _l *Cptx
  var _sp *Cptx
  _l = _env._dic["envLocal"]
  if(_flag == 1){
    _sp = _env._dic["envExec"]
  }else if(_flag == 2){
    _sp = _execmain
  }else if(_l._int == 1){
    _sp = _env._dic["envExec"]
  }else if(_l._int == 2){
    _sp = _execmain
  }else{
    _sp = _env._dic["envExec"]
  }
  _ex = execGetx(_o, _sp)
  if(_ex == nil){
    fmt.Println("exec: unknown type " + classx(_o)._name);debug.PrintStack();os.Exit(1)
  }
  return callx(_ex, &[]*Cptx{_o}, _env)
}
func checkid(_id string, _local *Cptx, _func *Cptx) *Cptx{
  var _r *Cptx
  _r = getx(_local, _id)
  if(_r != nil){
    _r = _local._dic[_id]
    if(_r == nil){
      fmt.Println("checkid: " + _id + " used in parent block");debug.PrintStack();os.Exit(1)
    }
    return _r
  }
  return nil
}
func id2cptx(_id string, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _p *Cptx
  var _r *Cptx
  _r = getx(_local, _id)
  if(_r != nil){
    _r = _local._dic[_id]
    if(_r != nil){
      return defx(_idlocalc, map[string]*Cptx{
        "idStr": strNewx(_id),
        "idState": _local,
      })
    }else{
      if(_func != nil){
        funcSetClosurex(_func)
      }
      _p = getParentx(_local, _id)
      if(_p == nil){
        fmt.Println(strx(_local, 0))
        fmt.Println(_id)
        fmt.Println("no parent");debug.PrintStack();os.Exit(1)
      }
      return defx(_idparentc, map[string]*Cptx{
        "idStr": strNewx(_id),
        "idState": _p,
      })
    }
  }
  _r = classGetx(_def, _id)
  if(_r != nil){
    if(_r._name == ""){
      return defx(_idglobalc, map[string]*Cptx{
        "idStr": strNewx(_id),
        "idState": _def,
      })
    }else{
      return defx(_idclassc, map[string]*Cptx{
        "idStr": strNewx(_id),
        "idVal": _r,
      })
    }
  }
  return nil
}
func env2cptx(_ast []interface{}, _def *Cptx, _local *Cptx) *Cptx{
  var _b *Cptx
  var _execsp *Cptx
  var _v []interface{}
  var _x *Cptx
  _v = _ast[2].([]interface{})
  _b = ast2cptx(_v, _def, _local, nil, "")
  _execsp = nsGetx(_execns, _ast[1].(string))
  if(_execsp == nil){
    fmt.Println("no execsp");debug.PrintStack();os.Exit(1)
  }
  _x = defx(_envc, map[string]*Cptx{
    "envLocal": scopeObjNewx(_b._dic["blockStateDef"]),
    "envStack": arrNewx(_arrc, &[]*Cptx{}),
    "envExec": _execsp,
    "envBlock": _b,
    "envActive": _falsev,
  })
  return _x
}
func subFunc2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _isproto int) *Cptx{
  var _arg interface{}
  var _argdef []interface{}
  var _args []interface{}
  var _class *Cptx
  var _cx *Cptx
  var _fp *Cptx
  var _funcVarTypes *[]*Cptx
  var _funcVars *[]*Cptx
  var _nlocal *Cptx
  var _ret *Cptx
  var _t *Cptx
  var _v []interface{}
  var _varid string
  var _varval *Cptx
  var _x *Cptx
  _v = _ast[1].([]interface{})
  _funcVars = &[]*Cptx{}
  _funcVarTypes = &[]*Cptx{}
  _nlocal = classNewx(&[]*Cptx{_local}, nil)
  if(_v[0] != nil){
    _class = classGetx(_def, _v[0].(string))
    (*_funcVars) = append((*_funcVars), strNewx("$self"))
    _x = defx(_class, nil)
    if(!_x._fstatic){
      _x._farg = true
    }
    (*_funcVarTypes) = append((*_funcVarTypes), _x)
    _nlocal._dic["$self"] = _x
  }
  _args = _v[1].([]interface{})
  _tmp875337 := _args;
  for _tmp875338 := uint(0); _tmp875338 < uint(len(_tmp875337)); _tmp875338 ++ {
    _arg = _tmp875337[_tmp875338]
    _argdef = _arg.([]interface{})
    _varid = _argdef[0].(string)
    (*_funcVars) = append((*_funcVars), strNewx(_varid))
    if(_argdef[2] != nil){
      _varval = ast2cptx(_argdef[2].([]interface{}), _def, _local, _func, "")
    }else if(_argdef[1] != nil){
      _t = classGetx(_def, _argdef[1].(string))
      if(_t == nil){
        fmt.Println("func2cptx: arg type not defined " + _argdef[1].(string));debug.PrintStack();os.Exit(1)
      }
      _varval = defx(_t, nil)
    }else{
      _varval = _cptv
    }
    if(!_varval._fstatic){
      _varval._farg = true
    }
    (*_funcVarTypes) = append((*_funcVarTypes), _varval)
    _nlocal._dic[_varid] = _varval
  }
  if(len(_v) > 2 && _v[2] != nil){
    _ret = classGetx(_def, _v[2].(string))
  }else{
    _ret = _emptyreturnc
  }
  _fp = fpDefx(_funcVarTypes, _ret)
  if(_isproto > 0){
    return _fp
  }
  _cx = classNewx(&[]*Cptx{_fp, _funcblockc}, nil)
  _x = objNewx(_cx, nil)
  _x._dic["funcVars"] = arrNewx(_arrstrc, _funcVars)
  _x._val = _nlocal
  return _x
}
func func2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string, _pre int) *Cptx{
  var _v []interface{}
  var _x *Cptx
  if(_pre != 0 && _name == ""){
    fmt.Println("def must have name");debug.PrintStack();os.Exit(1)
  }
  if(_name != ""){
    _x = _def._dic[_name]
    if(_x == nil){
      _x = subFunc2cptx(_ast, _def, _local, _func, 0)
      routex(_x, _def, _name)
    }
  }else{
    _x = subFunc2cptx(_ast, _def, _local, _func, 0)
  }
  if(_pre != 0){
    return _x
  }
  _v = _ast[1].([]interface{})
  _x._dic["funcBlock"] = ast2blockx(_v[3].([]interface{}), _def, _x._val.(*Cptx), _x)
  if(_v[4] != nil){
    fmt.Println("TODO alterblock");debug.PrintStack();os.Exit(1)
  }
  return _x
}
func class2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string, _pre int) *Cptx{
  var _arr *[]*Cptx
  var _c string
  var _e interface{}
  var _k string
  var _parents []interface{}
  var _r *Cptx
  var _s string
  var _schema *Cptx
  var _v *Cptx
  var _x *Cptx
  if(_pre == 1 || _pre == 0){
    _parents = _ast[1].([]interface{})
    _arr = &[]*Cptx{}
    _tmp925047 := _parents;
    for _tmp925048 := uint(0); _tmp925048 < uint(len(_tmp925047)); _tmp925048 ++ {
      _e = _tmp925047[_tmp925048]
      _s = _e.(string)
      _r = classGetx(_def, _s)
      if(_r == nil){
        fmt.Println("class2obj: no class " + _s);debug.PrintStack();os.Exit(1)
      }
      (*_arr) = append((*_arr), _r)
    }
    _x = classNewx(_arr, nil)
    routex(_x, _def, _name)
  }
  if(_pre == 2 || _pre == 0){
    _x = _def._dic[_name]
    _schema = ast2dicx(_ast[2].([]interface{}), _def, _local, _func, nil, 0)
    _c = _ast[0].(string)
    if(_c == "classx"){
      for _k, _v = range _schema._dic {
        _x._dic[_k] = _v
      }
    }else{
      for _k, _v = range _schema._dic {
        _x._dic[_k] = defx(_v, nil)
      }
    }
  }
  return _x
}
func blockmain2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _name string) *Cptx{
  var _b *Cptx
  var _d *Cptx
  var _l *Cptx
  var _scopename string
  var _v []interface{}
  _scopename = _ast[2].(string)
  if(_scopename != ""){
    _d = classNewx(&[]*Cptx{nsGetx(_defns, _scopename)}, nil)
    _l = classNewx(nil, nil)
  }else{
    if(_local == nil){
      fmt.Println("no local for blockmain");debug.PrintStack();os.Exit(1)
    }
    _d = _def
    _l = _local
  }
  _v = _ast[1].([]interface{})
  if(_d._obj == nil){
    objNewx(_d, nil)
  }
  preAst2blockx(_v, _d, _l, nil)
  _b = ast2blockx(_v, _d, _l, nil)
  _b._obj = _blockmainc
  _blockmainc._obj = _b
  if(len(_ast) == 4){
    _b._dic["blockPath"] = strNewx(_ast[3].(string))
  }
  if(_name != ""){
    routex(_b, _def, _name)
  }
  return _b
}
func tpl2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _name string) *Cptx{
  var _x *Cptx
  if(_name == ""){
    fmt.Println("tpl no name");debug.PrintStack();os.Exit(1)
  }
  _x = defx(_functplc, map[string]*Cptx{
    "funcTplAst": strNewx(_ast[1].(string)),
  })
  if(len(_ast) == 3){
    _x._dic["funcTplPath"] = strNewx(_ast[2].(string))
  }
  routex(_x, _def, _name)
  return _x
}
func enum2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _name string) *Cptx{
  var _a *[]*Cptx
  var _arr []interface{}
  var _c *Cptx
  var _d map[string]*Cptx
  var _i uint
  var _ii *Cptx
  var _v interface{}
  if(_name == ""){
    fmt.Println("enum no name");debug.PrintStack();os.Exit(1)
  }
  _a = &[]*Cptx{}
  _d = map[string]*Cptx{
  }
  _c = curryDefx(_def, _name, _enumc, map[string]*Cptx{
    "enum": arrNewx(_arrstrc, _a),
    "enumDic": dicNewx(_dicuintc, _d, nil),
  })
  _arr = _ast[1].([]interface{})
  _tmp978748 := _arr;
  for _i = uint(0); _i < uint(len(_tmp978748)); _i ++ {
    _v = _tmp978748[_i]
    (*_a) = append((*_a), strNewx(_v.(string)))
    _ii = intNewx(int(_i))
    _ii._obj = _c
    _c._obj = _ii
    _d[_v.(string)] = _ii
  }
  return _c
}
func obj2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _c *Cptx
  var _schema *Cptx
  var _x *Cptx
  _c = classGetx(_def, _ast[1].(string))
  if(_c == nil){
    fmt.Println("obj2obj: no class " + _ast[1].(string));debug.PrintStack();os.Exit(1)
  }
  _schema = ast2dicx(_ast[2].([]interface{}), _def, _local, _func, nil, 0)
  if(_schema._fmid){
    _x = callNewx(_defmain._dic["new"], &[]*Cptx{_c, _schema}, nil)
  }else{
    _x = defx(_c, _schema._dic)
  }
  return _x
}
func op2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _arg0 *Cptx
  var _arg1 *Cptx
  var _args []interface{}
  var _f *Cptx
  var _op string
  var _t0 *Cptx
  _op = _ast[1].(string)
  _args = _ast[2].([]interface{})
  _arg0 = ast2cptx(_args[0].([]interface{}), _def, _local, _func, "")
  _t0 = typepredx(_arg0)
  if(_t0 == nil){
    _t0 = _cptc
  }
  _f = getx(_t0, _op)
  if(_f == nil || _f._id == _nullv._id){
    fmt.Println(strx(_arg0, 0))
    fmt.Println(strx(_t0, 0))
    fmt.Println("Op not find " + _op);debug.PrintStack();os.Exit(1)
  }
  if(len(_args) == 1){
    if(_op == "not"){
      if(!inClassx(_t0, _boolc, nil)){
        return callNewx(getx(_t0, "eq"), &[]*Cptx{_arg0, defaultx(_t0)}, nil)
      }
    }
    return callNewx(_f, &[]*Cptx{_arg0}, nil)
  }else{
    _arg1 = ast2cptx(_args[1].([]interface{}), _def, _local, _func, "")
    return callNewx(_f, &[]*Cptx{_arg0, _arg1}, nil)
  }
  return nil
}
func itemsget2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _v *Cptx) *Cptx{
  var _getf *Cptx
  var _it *Cptx
  var _items *Cptx
  var _itemst *Cptx
  var _itemstc *Cptx
  var _itemstt *Cptx
  var _key *Cptx
  var _lefto *Cptx
  var _oo *Cptx
  var _predt *Cptx
  var _s *Cptx
  var _setf *Cptx
  var _str string
  _items = ast2cptx(_ast[1].([]interface{}), _def, _local, _func, "")
  _itemstc = typepredx(_items)
  if(_itemstc == nil){
    fmt.Println(strx(_items, 0))
    fmt.Println("don't known dic or arr");debug.PrintStack();os.Exit(1)
  }
  _key = ast2cptx(_ast[2].([]interface{}), _def, _local, _func, "")
  if(_v == nil){
    _getf = getx(_itemstc, "get")
    if(_getf == nil){
      fmt.Println(strx(_items, 0))
      fmt.Println(strx(_itemstc, 0))
      fmt.Println("no getf");debug.PrintStack();os.Exit(1)
    }
    return callNewx(_getf, &[]*Cptx{_items, _key}, nil)
  }
  _setf = getx(_itemstc, "set")
  if(_setf == nil){
    fmt.Println("no setf");debug.PrintStack();os.Exit(1)
  }
  _lefto = callNewx(_setf, &[]*Cptx{_items, _key, _v}, nil)
  _predt = typepredx(_v)
  if(inClassx(classx(_items), _idstatec, nil)){
    _s = _items._dic["idState"]
    _str = _items._dic["idStr"]._str
    _itemst = _s._dic[_str]
    _itemstt = aliasGetx(_itemst._obj)
    if(_itemst._farg){
      return _lefto
    }
    _it = getx(_itemst, "itemsType")
    if(_predt != nil && _predt._id != _cptc._id){
      if(_it._id == _cptv._id){
        _itemst._obj = itemDefx(_itemstt, _predt, false)
        if(_itemst._val != nil){
          _oo = _itemst._val.(*Cptx)
          convertx(_itemstt, _itemst._obj, _oo)
        }
      }else if(!inClassx(_predt, classx(_it), nil)){
        fmt.Println("TODO convert items assign: " + _predt._name + " is not " + classx(_it)._name);debug.PrintStack();os.Exit(1)
      }
    }
  }
  return _lefto
}
func return2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _v *Cptx) *Cptx{
  var _arg *Cptx
  var _ret *Cptx
  if(_func == nil){
    fmt.Println(_ast)
    fmt.Println("return outside func");debug.PrintStack();os.Exit(1)
  }
  _ret = getx(_func, "funcReturn")
  if(len(_ast) > 1){
    _arg = ast2cptx(_ast[1].([]interface{}), _def, _local, _func, "")
    if(_ret._id == _emptyreturnc._id){
      fmt.Println("func " + _func._name + " should not return value");debug.PrintStack();os.Exit(1)
    }
  }else{
    if(_ret._id == _emptyreturnc._id){
      _arg = _emptyreturnv
    }else{
      _arg = _nullv
    }
  }
  return defx(_ctrlreturnc, map[string]*Cptx{
    "ctrlArg": _arg,
  })
}
func objget2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _v *Cptx) *Cptx{
  var _obj *Cptx
  _obj = ast2cptx(_ast[1].([]interface{}), _def, _local, _func, "")
  if(_obj._type == TOBJ || _obj._type == TCALL){
    if(_v == nil){
      return callNewx(_defmain._dic["get"], &[]*Cptx{_obj, strNewx(_ast[2].(string))}, nil)
    }else{
      return callNewx(_defmain._dic["set"], &[]*Cptx{_obj, strNewx(_ast[2].(string)), _v}, nil)
    }
  }else{
    return nil
  }
}
func if2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _block *Cptx) *Cptx{
  var _a *Cptx
  var _args *[]*Cptx
  var _d *Cptx
  var _i int
  var _l int
  var _t *Cptx
  var _v []interface{}
  _v = _ast[1].([]interface{})
  _a = ast2arrx(_v, _def, _local, _func, nil, 0)
  _args = _a._arr
  _l = len((*_args))
  for _i = 0; _i < _l - 1; _i = _i + 2 {
    _t = typepredx((*_args)[_i])
    if(_t == nil){
      fmt.Println(strx((*_args)[_i], 0))
      fmt.Println("if: typepred error");debug.PrintStack();os.Exit(1)
    }
    if(!inClassx(_t, _boolc, nil)){
      (*_args)[_i] = callNewx(getx(_t, "ne"), &[]*Cptx{(*_args)[_i], defaultx(_t)}, nil)
    }
    _d = (*_args)[_i + 1]
    _d._dic["blockParent"] = _block
  }
  if(_l % 2 == 1){
    _d = (*_args)[_l - 1]
    _d._dic["blockParent"] = _block
  }
  return defx(_ctrlifc, map[string]*Cptx{
    "ctrlArgs": _a,
  })
}
func each2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _block *Cptx) *Cptx{
  var _bl *Cptx
  var _et *Cptx
  var _expr *Cptx
  var _it *Cptx
  var _key string
  var _r *Cptx
  var _v []interface{}
  var _val string
  _v = _ast[1].([]interface{})
  _key = _v[0].(string)
  _val = _v[1].(string)
  _expr = ast2cptx(_v[2].([]interface{}), _def, _local, _func, "")
  _et = typepredx(_expr)
  if(_et == nil){
    fmt.Println("no type for each");debug.PrintStack();os.Exit(1)
  }
  if(_key != ""){
    _r = checkid(_key, _local, _func)
    if(inClassx(_et, _dicc, nil)){
      if(_r != nil){
        if(classx(_r)._id != _strc._id){
          fmt.Println("each key id defined " + _key);debug.PrintStack();os.Exit(1)
        }
      }else{
        _local._dic[_key] = strNewx("")
      }
    }else if(inClassx(_et, _arrc, nil)){
      if(_r != nil){
        if(classx(_r)._id != _uintc._id){
          fmt.Println("each key id defined " + _key);debug.PrintStack();os.Exit(1)
        }
      }else{
        _local._dic[_key] = uintNewx(0)
      }
    }else{
      fmt.Println(strx(_et, 0))
      fmt.Println("TODO: items other than dic or arr");debug.PrintStack();os.Exit(1)
    }
  }
  if(_val != ""){
    _it = getx(_et, "itemsType")
    _r = checkid(_val, _local, _func)
    if(_it == nil){
      _it = _cptv
    }
    if(_r != nil){
      if(classx(_r)._id != classx(_it)._id){
        fmt.Println(classx(_r)._name)
        fmt.Println(classx(_it)._name)
        fmt.Println("each val id defined " + _val);debug.PrintStack();os.Exit(1)
      }
    }else{
      _local._dic[_val] = _it
    }
  }
  _bl = ast2blockx(_v[3].([]interface{}), _def, _local, _func)
  _bl._dic["blockParent"] = _block
  return defx(_ctrleachc, map[string]*Cptx{
    "ctrlArgs": arrNewx(_arrc, &[]*Cptx{strNewx(_key), strNewx(_val), _expr, _bl}),
  })
}
func for2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _block *Cptx) *Cptx{
  var _bl *Cptx
  var _check *Cptx
  var _inc *Cptx
  var _start *Cptx
  var _t *Cptx
  var _v []interface{}
  _v = _ast[1].([]interface{})
  if(_v[0] != nil){
    _start = ast2cptx(_v[0].([]interface{}), _def, _local, _func, "")
  }else{
    _start = _nullv
  }
  _check = ast2cptx(_v[1].([]interface{}), _def, _local, _func, "")
  _t = typepredx(_check)
  if(!inClassx(_t, _boolc, nil)){
    _check = callNewx(getx(_t, "ne"), &[]*Cptx{_check, defaultx(_t)}, nil)
  }
  if(_v[2] != nil){
    _inc = ast2cptx(_v[2].([]interface{}), _def, _local, _func, "")
  }else{
    _inc = _nullv
  }
  _bl = ast2blockx(_v[3].([]interface{}), _def, _local, _func)
  return defx(_ctrlforc, map[string]*Cptx{
    "ctrlArgs": arrNewx(_arrc, &[]*Cptx{_start, _check, _inc, _bl}),
  })
  return nil
}
func alias2cptx(_ast []interface{}, _def *Cptx, _name string) *Cptx{
  var _n string
  var _x *Cptx
  _n = _ast[1].(string)
  if(_n == "Class" || _n == "Obj" || _n == "Cpt"){
    fmt.Println("no alias for this");debug.PrintStack();os.Exit(1)
  }
  _x = classGetx(_def, _n)
  if(_x == nil){
    fmt.Println("alias error " + _ast[1].(string));debug.PrintStack();os.Exit(1)
  }
  return aliasDefx(_def, _name, _x)
}
func itemdef2cptx(_ast []interface{}, _def *Cptx, _name string) *Cptx{
  var _it *Cptx
  var _x *Cptx
  _x = classGetx(_def, _ast[1].(string))
  _it = classGetx(_def, _ast[2].(string))
  if(_x == nil){
    fmt.Println("itemdef error, items " + _ast[1].(string));debug.PrintStack();os.Exit(1)
  }
  if(_it == nil){
    fmt.Println("itemdef error, itemsType " + _ast[2].(string));debug.PrintStack();os.Exit(1)
  }
  return aliasDefx(_def, _name, itemDefx(_x, _it, false))
}
func funcproto2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string) *Cptx{
  var _x *Cptx
  _x = subFunc2cptx(_ast, _def, _local, _func, 1)
  return aliasDefx(_def, _name, _x)
}
func def2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _pre int) *Cptx{
  var _af *Cptx
  var _c string
  var _dfd *Cptx
  var _id string
  var _ip *Cptx
  var _r *Cptx
  var _t *Cptx
  var _v []interface{}
  _id = _ast[1].(string)
  _v = _ast[2].([]interface{})
  _c = _v[0].(string)
  if(_pre == 1){
    _dfd = _def._dic[_id]
    if(_dfd != nil){
      fmt.Println("class def twice " + _id);debug.PrintStack();os.Exit(1)
    }
    if(_c == "enum"){
      return enum2cptx(_v, _def, _local, _id)
    }else if(_c == "tpl"){
      return tpl2cptx(_v, _def, _local, _id)
    }else if(_c == "blockmain"){
      return blockmain2cptx(_v, _def, _local, _id)
    }else if(_c == "class" || _c == "classx"){
      return class2cptx(_v, _def, _local, _func, _id, _pre)
    }else if(_c == "alias"){
      return alias2cptx(_v, _def, _id)
    }else if(_c == "itemdef"){
      return itemdef2cptx(_v, _def, _id)
    }else{
      return nil
    }
  }
  if(_pre == 2){
    if(_c == "class" || _c == "classx"){
      return class2cptx(_v, _def, _local, _func, _id, _pre)
    }else if(_c == "funcproto"){
      return funcproto2cptx(_v, _def, _local, _func, _id)
    }else if(_c == "func"){
      _dfd = _def._dic[_id]
      if(_dfd != nil){
        fmt.Println("func def twice " + _id);debug.PrintStack();os.Exit(1)
      }
      return func2cptx(_v, _def, _local, _func, _id, _pre)
    }else{
      return nil
    }
  }
  if(_c != "func"){
    _dfd = _def._dic[_id]
    if(_dfd != nil){
      return _dfd
    }
  }
  _r = ast2cptx(_v, _def, _local, _func, _id)
  if(_r._name == ""){
    _t = typepredx(_r)
    if(_t == nil){
      fmt.Println(_id)
      fmt.Println(_v)
      fmt.Println("global var must know type");debug.PrintStack();os.Exit(1)
    }
    _def._dic[_id] = defx(_t, nil)
    _ip = defx(_idglobalc, map[string]*Cptx{
      "idStr": strNewx(_id),
      "idState": _def,
    })
    _af = classGetx(_idglobalc, "assign")
    return callNewx(_af, &[]*Cptx{_ip, _r}, _callassignc)
  }
  return _r
}
func convertx(_from *Cptx, _to *Cptx, _val *Cptx) *Cptx{
  if(_to._id == _from._id){
    return nil
  }
  if(_from._id == _cptc._id){
    return callNewx(_defmain._dic["as"], &[]*Cptx{_val, _to}, nil)
  }
  if(_to._ctype != _from._ctype){
    return nil
  }
  if(inClassx(classx(_val), _midc, nil)){
    if(_to._ctype == TINT || _to._ctype == TFLOAT){
      return callNewx(_defmain._dic["numConvert"], &[]*Cptx{_val, _to}, nil)
    }
    return nil
  }
  _val._obj = _to
  _to._obj = _val
  return _val
}
func assign2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _f *Cptx
  var _ff *Cptx
  var _idstr string
  var _left []interface{}
  var _lefto *Cptx
  var _leftt string
  var _lpredt *Cptx
  var _name string
  var _op string
  var _predt *Cptx
  var _right []interface{}
  var _righto *Cptx
  var _s *Cptx
  var _type *Cptx
  var _v []interface{}
  _v = _ast[1].([]interface{})
  _left = _v[0].([]interface{})
  _right = _v[1].([]interface{})
  _leftt = _left[0].(string)
  _righto = ast2cptx(_right, _def, _local, _func, "")
  _predt = typepredx(_righto)
  if(len(_v) > 2){
    _op = _v[2].(string)
    if(_op == "add"){
      _lefto = ast2cptx(_left, _def, _local, _func, "")
      _lpredt = typepredx(_lefto)
      _ff = getx(_lpredt, "concat")
      if(_ff != nil){
        return callNewx(_ff, &[]*Cptx{_lefto, _righto}, nil)
      }
    }
    _ff = getx(_lpredt, _op)
    if(_ff == nil){
      fmt.Println("no op " + _lpredt._name + " " + _op)
    }
    _righto = callNewx(_ff, &[]*Cptx{_lefto, _righto}, nil)
  }
  if(_leftt == "objget"){
    _lefto = objget2cptx(_left, _def, _local, _func, _righto)
    return _lefto
  }
  if(_leftt == "itemsget"){
    _lefto = itemsget2cptx(_left, _def, _local, _func, _righto)
    return _lefto
  }
  if(_leftt == "id" && len(_v) == 2){
    _name = _left[1].(string)
    if(getx(_local, _name) == nil){
      if(getx(_def._obj, _name) == nil){
        _left[0] = "idlocal"
      }else{
        _lefto = defx(_idglobalc, map[string]*Cptx{
          "idStr": strNewx(_name),
          "idState": _def,
        })
      }
    }
  }
  if(_lefto == nil){
    _lefto = ast2cptx(_left, _def, _local, _func, "")
  }
  if(inClassx(classx(_lefto), _idstatec, nil)){
    _s = _lefto._dic["idState"]
    _idstr = _lefto._dic["idStr"]._str
    _type = _s._dic[_idstr]
    if(_type == nil || _type._id == _nullv._id){
      if(_predt == nil){
        _s._dic[_idstr] = _cptv
      }else{
        _s._dic[_idstr] = defx(_predt, nil)
        _lpredt = _predt
        if(_predt._id == _dicc._id || _predt._id == _arrc._id){
          _s._dic[_idstr]._val = _righto
        }
      }
    }
  }
  _f = getx(_lefto, "assign")
  return callNewx(_f, &[]*Cptx{_lefto, _righto}, _callassignc)
}
func call2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _a0 *Cptx
  var _aa0 *Cptx
  var _arr *Cptx
  var _f *Cptx
  var _r *Cptx
  var _t *Cptx
  var _v []interface{}
  _v = _ast[1].([]interface{})
  _f = ast2cptx(_v, _def, _local, _func, "")
  if(classx(_f)._id == _idclassc._id){
    _f = _f._dic["idVal"]
  }
  _arr = ast2arrx(_ast[2].([]interface{}), _def, _local, _func, nil, 0)
  if(_f._type == TCLASS){
    _f = aliasGetx(_f)
    if(len((*_arr._arr)) == 0){
      return callNewx(_defmain._dic["type"], &[]*Cptx{_f}, _calltypec)
    }
    _a0 = (*_arr._arr)[0]
    _t = typepredx(_a0)
    if(_t == nil){
      fmt.Println(_a0)
      fmt.Println("convert from type not defined");debug.PrintStack();os.Exit(1)
    }
    _aa0 = convertx(_t, _f, _a0)
    if(_aa0 != nil){
      return _aa0
    }
    if(_f._name == ""){
      fmt.Println("class with no name");debug.PrintStack();os.Exit(1)
    }
    _r = getx(_t, "to" + _f._name)
    if(_r == nil){
      fmt.Println(strx(_t, 0))
      fmt.Println(strx(_a0, 0))
      fmt.Println("to" + _f._name)
      fmt.Println("convert func not defined");debug.PrintStack();os.Exit(1)
    }
    return callNewx(_r, _arr._arr, nil)
  }
  return callNewx(_f, _arr._arr, nil)
}
func callreflect2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  return _nullv
}
func callmethod2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _arr *Cptx
  var _f *Cptx
  var _oo *Cptx
  var _to *Cptx
  _oo = ast2cptx(_ast[1].([]interface{}), _def, _local, _func, "")
  _to = typepredx(_oo)
  if(_to == nil){
    fmt.Println(strx(_oo, 0))
    fmt.Println("cannot typepred obj");debug.PrintStack();os.Exit(1)
  }
  _arr = ast2arrx(_ast[3].([]interface{}), _def, _local, _func, nil, 0)
  _f = getx(_to, _ast[2].(string))
  if(_f == nil){
    fmt.Println(strx(_oo, 0))
    fmt.Println(strx(_to, 0))
    fmt.Println(_ast[2].(string))
    fmt.Println("no method");debug.PrintStack();os.Exit(1)
  }
  (*_arr._arr) = append([]*Cptx{_oo}, (*_arr._arr)...)
  return callNewx(_f, _arr._arr, _callmethodc)
}
func preAst2blockx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) {
  var _e interface{}
  var _ee []interface{}
  var _eee []interface{}
  var _i uint
  var _idpre string
  _tmp1326989 := _ast;
  for _i = uint(0); _i < uint(len(_tmp1326989)); _i ++ {
    _e = _tmp1326989[_i]
    _ee = _e.([]interface{})
    _eee = _ee[0].([]interface{})
    _idpre = _eee[0].(string)
    if(_idpre == "def"){
      def2cptx(_eee, _def, _local, _func, 1)
    }
  }
  _tmp1332369 := _ast;
  for _i = uint(0); _i < uint(len(_tmp1332369)); _i ++ {
    _e = _tmp1332369[_i]
    _ee = _e.([]interface{})
    _eee = _ee[0].([]interface{})
    _idpre = _eee[0].(string)
    if(_idpre == "def"){
      def2cptx(_eee, _def, _local, _func, 2)
    }
  }
}
func ast2blockx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _arr *[]*Cptx
  var _c *Cptx
  var _dicl *Cptx
  var _e interface{}
  var _ee []interface{}
  var _i int
  var _idpre string
  var _x *Cptx
  _arr = &[]*Cptx{}
  _x = objNewx(_blockc, nil)
  _dicl = dicNewx(_dicuintc, map[string]*Cptx{
  }, nil)
  _x._fdefault = false
  _i = 0
  _tmp1344972 := _ast;
  for _tmp1344973 := uint(0); _tmp1344973 < uint(len(_tmp1344972)); _tmp1344973 ++ {
    _e = _tmp1344972[_tmp1344973]
    _ee = _e.([]interface{})
    _idpre = _ee[0].([]interface{})[0].(string)
    if(_idpre == "if"){
      _c = if2cptx(_ee[0].([]interface{}), _def, _local, _func, _x)
    }else if(_idpre == "each"){
      _c = each2cptx(_ee[0].([]interface{}), _def, _local, _func, _x)
    }else if(_idpre == "for"){
      _c = for2cptx(_ee[0].([]interface{}), _def, _local, _func, _x)
    }else{
      _c = ast2cptx(_ee[0].([]interface{}), _def, _local, _func, "")
    }
    if(_c == nil){
      continue
    }
    (*_arr) = append((*_arr), _c)
    if(len(_ee) == 2){
      _dicl._dic[_ee[1].(string)] = uintNewx(_i)
    }
    _i = _i + 1
  }
  _x._dic["blockVal"] = arrNewx(_arrc, _arr)
  _x._dic["blockStateDef"] = _local
  _x._dic["blockLabels"] = _dicl
  _x._dic["blockScope"] = _def
  return _x
}
func ast2arrx(_asts []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _it *Cptx, _il int) *Cptx{
  var _arrx *[]*Cptx
  var _c *Cptx
  var _callable bool
  var _e interface{}
  var _ee *Cptx
  var _i uint
  var _r *Cptx
  var _v *Cptx
  _arrx = &[]*Cptx{}
  _callable = false
  _tmp1371493 := _asts;
  for _tmp1371494 := uint(0); _tmp1371494 < uint(len(_tmp1371493)); _tmp1371494 ++ {
    _e = _tmp1371493[_tmp1371494]
    _ee = ast2cptx(_e.([]interface{}), _def, _local, _func, "")
    if(_ee._fmid){
      _callable = true
    }
    if(_it == nil){
      _it = typepredx(_ee)
    }
    (*_arrx) = append((*_arrx), _ee)
  }
  if(!_callable){
    _tmp1376510 := _arrx;
    for _i = uint(0); _i < uint(len((*_tmp1376510))); _i ++ {
      _v = (*_tmp1376510)[_i]
      (*_arrx)[_i] = preExecx(_v)
    }
  }
  if(_it != nil || _callable){
    _c = itemDefx(_arrc, _it, _callable)
    _r = arrNewx(_c, _arrx)
    if(_callable){
      _r._fmid = true
    }
  }else{
    _r = arrNewx(_arrc, _arrx)
  }
  if(_il != 0){
    _r._int = _il
  }
  return _r
}
func ast2dicx(_asts []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _it *Cptx, _il int) *Cptx{
  var _arrx *[]*Cptx
  var _c *Cptx
  var _callable bool
  var _dicx map[string]*Cptx
  var _e []interface{}
  var _ee *Cptx
  var _eo interface{}
  var _k string
  var _r *Cptx
  var _v *Cptx
  _dicx = map[string]*Cptx{
  }
  _arrx = &[]*Cptx{}
  _callable = false
  _tmp1390203 := _asts;
  for _tmp1390204 := uint(0); _tmp1390204 < uint(len(_tmp1390203)); _tmp1390204 ++ {
    _eo = _tmp1390203[_tmp1390204]
    _e = _eo.([]interface{})
    _k = _e[1].(string)
    _ee = ast2cptx(_e[0].([]interface{}), _def, _local, _func, "")
    if(_ee._fmid){
      _callable = true
    }
    if(_it == nil){
      _it = typepredx(_ee)
    }
    (*_arrx) = append((*_arrx), strNewx(_k))
    _dicx[_k] = _ee
  }
  if(!_callable){
    for _k, _v = range _dicx {
      _dicx[_k] = preExecx(_v)
    }
  }
  if(_it != nil || _callable){
    _c = itemDefx(_dicc, _it, _callable)
    _r = dicNewx(_c, _dicx, _arrx)
    if(_callable){
      _r._fmid = true
    }
  }else{
    _r = dicNewx(_dicc, _dicx, _arrx)
  }
  if(_il != 0){
    _r._int = _il
  }
  return _r
}
func ast2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string) *Cptx{
  var _x *Cptx
  _x = subAst2cptx(_ast, _def, _local, _func, _name)
  if(_x != nil){
    _x._ast = _ast
  }
  return _x
}
//only leave first return value
func _lf(x interface{}, e error)interface{}{
 if(e != nil){
  log.Fatal(e);os.Exit(1)

 }
 return x
}
func subAst2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string) *Cptx{
  var _dic map[string]*Cptx
  var _en *Cptx
  var _id string
  var _il int
  var _it *Cptx
  var _r *Cptx
  var _t string
  var _type *Cptx
  var _val *Cptx
  var _x *Cptx
  if(_def == nil){
    fmt.Println("no def");debug.PrintStack();os.Exit(1)
  }
  _t = _ast[0].(string)
  if(_t == "env"){
    return env2cptx(_ast, _def, _local)
  }else if(_t == "enum"){
    return enum2cptx(_ast, _def, _local, _name)
  }else if(_t == "tpl"){
    return tpl2cptx(_ast, _def, _local, _name)
  }else if(_t == "blockmain"){
    return blockmain2cptx(_ast, _def, _local, "")
  }else if(_t == "class" || _t == "classx"){
    return class2cptx(_ast, _def, _local, _func, _name, 0)
  }else if(_t == "alias"){
    return alias2cptx(_ast, _def, _name)
  }else if(_t == "itemdef"){
    return itemdef2cptx(_ast, _def, _name)
  }else if(_t == "funcproto"){
    return funcproto2cptx(_ast, _def, _local, _func, _name)
  }else if(_t == "block"){
    return ast2blockx(_ast[1].([]interface{}), _def, _local, _func)
  }else if(_t == "str"){
    return strNewx(_ast[1].(string))
  }else if(_t == "float"){
    return floatNewx(_lf(strconv.ParseFloat(_ast[1].(string), 64)).(float64))
  }else if(_t == "int"){
    return intNewx(_lf(strconv.Atoi(_ast[1].(string))).(int))
  }else if(_t == "null"){
    return _nullv
  }else if(_t == "true"){
    return _truev
  }else if(_t == "false"){
    return _falsev
  }else if(_t == "idlocal"){
    _id = _ast[1].(string)
    _val = _local._dic[_id]
    if(_val == nil){
      if(len(_ast) > 2){
        _type = classGetx(_def, _ast[2].(string))
        if(_type == nil){
          fmt.Println("wrong type " + _ast[2].(string));debug.PrintStack();os.Exit(1)
        }
      }else{
        _type = _nullc
      }
      _local._dic[_id] = defx(_type, nil)
    }
    return defx(_idlocalc, map[string]*Cptx{
      "idStr": strNewx(_id),
      "idState": _local,
    })
  }else if(_t == "id"){
    _id = _ast[1].(string)
    _x = id2cptx(_id, _def, _local, _func)
    if(_x == nil){
      fmt.Println(_local)
      fmt.Println("id not defined " + _id);debug.PrintStack();os.Exit(1)
    }
    return _x
  }else if(_t == "call"){
    return call2cptx(_ast, _def, _local, _func)
  }else if(_t == "callmethod"){
    return callmethod2cptx(_ast, _def, _local, _func)
  }else if(_t == "callreflect"){
    return callreflect2cptx(_ast, _def, _local, _func)
  }else if(_t == "assign"){
    return assign2cptx(_ast, _def, _local, _func)
  }else if(_t == "def"){
    return def2cptx(_ast, _def, _local, _func, 0)
  }else if(_t == "dic"){
    if(len(_ast) > 2){
      if(_ast[2] != nil){
        _it = classGetx(_def, _ast[2].(string))
      }
      if(_ast[3] != nil){
        _il = _lf(strconv.Atoi(_ast[3].(string))).(int)
      }
    }
    return ast2dicx(_ast[1].([]interface{}), _def, _local, _func, _it, _il)
  }else if(_t == "arr"){
    if(len(_ast) > 2){
      if(_ast[2] != nil){
        _it = classGetx(_def, _ast[2].(string))
      }
      if(_ast[3] != nil){
        _il = _lf(strconv.Atoi(_ast[3].(string))).(int)
      }
    }
    return ast2arrx(_ast[1].([]interface{}), _def, _local, _func, _it, _il)
  }else if(_t == "enumget"){
    _en = classGetx(_def, _ast[1].(string))
    if(_en == nil){
      fmt.Println(_ast[1])
      fmt.Println("enum type not defined");debug.PrintStack();os.Exit(1)
    }
    _dic = _en._dic["enumDic"]._dic
    _r = _dic[_ast[2].(string)]
    if(_r == nil){
      fmt.Println(_ast[1])
      fmt.Println(_ast[2])
      fmt.Println("enum val not defined");debug.PrintStack();os.Exit(1)
    }
    return _r
  }else if(_t == "func"){
    return func2cptx(_ast, _def, _local, _func, _name, 0)
  }else if(_t == "obj"){
    return obj2cptx(_ast, _def, _local, _func)
  }else if(_t == "op"){
    return op2cptx(_ast, _def, _local, _func)
  }else if(_t == "itemsget"){
    return itemsget2cptx(_ast, _def, _local, _func, nil)
  }else if(_t == "objget"){
    return objget2cptx(_ast, _def, _local, _func, nil)
  }else if(_t == "return"){
    return return2cptx(_ast, _def, _local, _func, nil)
  }else if(_t == "break"){
    return objNewx(_ctrlbreakc, nil)
  }else if(_t == "continue"){
    return objNewx(_ctrlcontinuec, nil)
  }else{
    fmt.Println("ast2cptx: " + _t + " is not defined");debug.PrintStack();os.Exit(1)
  }
  return nil
}
func progl2cptx(_str string, _def *Cptx, _local *Cptx) *Cptx{
  var _ast []interface{}
  var _r *Cptx
  _ast = _Str_toJsonArr(_osCmd("./sl-reader", _str))
  if(len(_ast) == 0){
    fmt.Println("progl2cpt: wrong grammar");debug.PrintStack();os.Exit(1)
  }
  _r = ast2cptx(_ast, _def, _local, nil, "")
  return _r
}
func valuesx(_o *Cptx) *Cptx{
  var _arr *[]*Cptx
  var _c *Cptx
  var _it *Cptx
  var _k *Cptx
  var _v *Cptx
  _arr = &[]*Cptx{}
  _tmp1499551 := _o._arr;
  for _tmp1499552 := uint(0); _tmp1499552 < uint(len((*_tmp1499551))); _tmp1499552 ++ {
    _k = (*_tmp1499551)[_tmp1499552]
    _v = _o._dic[_k._str]
    (*_arr) = append((*_arr), _v)
  }
  _it = getx(_o, "itemsType")
  if(_it == nil){
    _c = _arrc
  }else{
    _c = itemDefx(_arrc, classx(_it), false)
  }
  return arrNewx(_c, _arr)
}
func execDefx(_name string, _f func(*[]*Cptx, *Cptx) *Cptx) *Cptx{
  var _fn *Cptx
  _fn = funcNewx(_f, &[]*Cptx{_cptc}, _cptc)
  routex(_fn, _execmain, _name)
  return _fn
}
func prepareArgsx(_args *[]*Cptx, _f *Cptx, _env *Cptx) *[]*Cptx{
  var _arg *Cptx
  var _argdef *Cptx
  var _argsx *[]*Cptx
  var _i uint
  var _t *Cptx
  var _vartypes *[]*Cptx
  _argsx = &[]*Cptx{}
  if(!inClassx(classx(_f), _functplc, nil)){
    _vartypes = getx(_f, "funcVarTypes")._arr
    _tmp2140560 := _vartypes;
    for _i = uint(0); _i < uint(len((*_tmp2140560))); _i ++ {
      _argdef = (*_tmp2140560)[_i]
      if(int(_i) < len((*_args))){
        _t = execx((*_args)[_i], _env, 0)
      }else{
        _t = copyx(_argdef)
      }
      (*_argsx) = append((*_argsx), _t)
    }
  }else{
    _tmp2145098 := _args;
    for _tmp2145099 := uint(0); _tmp2145099 < uint(len((*_tmp2145098))); _tmp2145099 ++ {
      _arg = (*_tmp2145098)[_tmp2145099]
      (*_argsx) = append((*_argsx), execx(_arg, _env, 0))
    }
  }
  return _argsx
}
func main(){
  var _defsp string
  var _execsp string
  var _fc string
  var _main *Cptx
  var _osargs *[]string
  _version = 100
  _uidi = 0
  _inClassCache = map[string]int{
  }
  _root = map[string]*Cptx{
  }
  __indentx = " "
  _defns = nsNewx("def")
  _defmain = scopeNewx(_defns, "main")
  _cptc = classNewx(nil, nil)
  routex(_cptc, _defmain, "Cpt")
  _cptc._ctype = TCPT
  _cptc._fdefault = true
  _cptc._fstatic = true
  _cptv = &Cptx{
    _type: TCPT,  
    _fdefault: true,  
    _fstatic: true,  
    _id: uidx(),  
    _ctype: TCPT,  
    _farg: false,  
    _fmid: false,  
    _fprop: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  _objc = classNewx(nil, nil)
  routex(_objc, _defmain, "Obj")
  _objc._ctype = TOBJ
  _classc = classNewx(nil, nil)
  routex(_classc, _defmain, "Class")
  _classc._ctype = TCLASS
  _emptyclassgetc = classDefx(_defmain, "EmptyClassGet", nil, nil)
  _emptyclassgetv = objNewx(_emptyclassgetc, nil)
  _valc = classDefx(_defmain, "Val", nil, map[string]*Cptx{
    "val": _cptc,
  })
  _nullv = &Cptx{
    _type: TNULL,  
    _fdefault: true,  
    _fstatic: true,  
    _id: uidx(),  
    _ctype: TCPT,  
    _farg: false,  
    _fmid: false,  
    _fprop: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  _nullc = curryDefx(_defmain, "Null", _valc, map[string]*Cptx{
    "val": _nullv,
  })
  _nullc._ctype = TNULL
  _zerointv = &Cptx{
    _int: 0,  
    _type: TINT,  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _id: "",  
    _name: "",  
    _str: "",  
  }
  _zerofloatv = &Cptx{
    _type: TFLOAT,  
    _val: 0,  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _id: "",  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  _numc = classDefx(_defmain, "Num", &[]*Cptx{_valc}, nil)
  _intc = classDefx(_defmain, "Int", &[]*Cptx{_numc}, map[string]*Cptx{
    "val": _zerointv,
  })
  _intc._ctype = TINT
  _uintc = classDefx(_defmain, "Uint", &[]*Cptx{_intc}, nil)
  _floatc = classDefx(_defmain, "Float", &[]*Cptx{_numc}, map[string]*Cptx{
    "val": _zerofloatv,
  })
  _floatc._ctype = TFLOAT
  _boolc = curryDefx(_defmain, "Bool", _intc, nil)
  _bytec = curryDefx(_defmain, "Byte", _intc, nil)
  curryDefx(_defmain, "Int16", _intc, nil)
  curryDefx(_defmain, "Int32", _intc, nil)
  curryDefx(_defmain, "Int64", _intc, nil)
  curryDefx(_defmain, "Uint8", _uintc, nil)
  curryDefx(_defmain, "Uint16", _uintc, nil)
  curryDefx(_defmain, "Uint32", _uintc, nil)
  curryDefx(_defmain, "Uint64", _uintc, nil)
  curryDefx(_defmain, "Float32", _floatc, nil)
  curryDefx(_defmain, "Float64", _floatc, nil)
  _numbigc = curryDefx(_defmain, "NumBig", _numc, nil)
  _numbigc._ctype = TNUMBIG
  _truev = &Cptx{
    _type: TINT,  
    _obj: _boolc,  
    _int: 1,  
    _id: uidx(),  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _name: "",  
    _str: "",  
  }
  _falsev = &Cptx{
    _type: TINT,  
    _obj: _boolc,  
    _int: 0,  
    _id: uidx(),  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _name: "",  
    _str: "",  
  }
  _itemsc = classDefx(_defmain, "Items", &[]*Cptx{_valc}, map[string]*Cptx{
    "itemsType": _cptc,
  })
  _itemslimitedc = classDefx(_defmain, "ItemsLimited", &[]*Cptx{_itemsc}, map[string]*Cptx{
    "itemsLimitedLength": _uintc,
  })
  _arrc = curryDefx(_defmain, "Arr", _itemsc, nil)
  _arrc._ctype = TARR
  _staticarrc = curryDefx(_defmain, "StaticArr", _arrc, nil)
  _midc = classDefx(_defmain, "Mid", nil, nil)
  _arrbytec = itemDefx(_arrc, _bytec, false)
  _dicc = curryDefx(_defmain, "Dic", _itemsc, nil)
  _dicc._ctype = TDIC
  _zerostrv = &Cptx{
    _str: "",  
    _type: TSTR,  
    _ctype: TCPT,  
    _farg: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fstatic: false,  
    _id: "",  
    _int: 0,  
    _name: "",  
  }
  _strc = curryDefx(_defmain, "Str", _valc, map[string]*Cptx{
    "val": _zerostrv,
  })
  _strc._ctype = TSTR
  _arrstrc = itemDefx(_arrc, _strc, false)
  _dicstrc = itemDefx(_dicc, _strc, false)
  _dicuintc = itemDefx(_dicc, _uintc, false)
  _dicclassc = itemDefx(_dicc, _classc, false)
  _arrclassc = itemDefx(_arrc, _classc, false)
  _enumc = classDefx(_defmain, "Enum", &[]*Cptx{_uintc}, map[string]*Cptx{
    "enum": _arrstrc,
    "enumDic": _dicuintc,
  })
  _bufferc = classDefx(_defmain, "Buffer", &[]*Cptx{_strc}, nil)
  _jsonc = classDefx(_defmain, "Json", &[]*Cptx{_dicc}, nil)
  _jsonarrc = classDefx(_defmain, "JsonArr", &[]*Cptx{_arrc}, nil)
  _pointerc = classDefx(_defmain, "Pointer", &[]*Cptx{_valc}, nil)
  _pathc = classDefx(_defmain, "Path", nil, map[string]*Cptx{
    "path": _strc,
  })
  _filec = classDefx(_defmain, "File", &[]*Cptx{_pathc}, nil)
  _dirc = classDefx(_defmain, "Dir", &[]*Cptx{_pathc}, nil)
  _emptyreturnc = classDefx(_defmain, "EmptyReturn", nil, nil)
  _emptyreturnv = objNewx(_emptyreturnc, nil)
  _funcc = classDefx(_defmain, "Func", nil, nil)
  _funcprotoc = classDefx(_defmain, "FuncProto", &[]*Cptx{_funcc}, map[string]*Cptx{
    "funcVarTypes": _arrc,
    "funcReturn": _classc,
  })
  _valfuncc = curryDefx(_defmain, "ValFunc", _valc, nil)
  _valfuncc._ctype = TVALFUNC
  _funcnativec = classDefx(_defmain, "FuncNative", &[]*Cptx{_funcprotoc}, map[string]*Cptx{
    "funcNative": _valfuncc,
  })
  _blockc = classDefx(_defmain, "Block", nil, map[string]*Cptx{
    "blockVal": _arrc,
    "blockStateDef": _classc,
    "blockLabels": _dicuintc,
    "blockScope": _classc,
    "blockPath": _strc,
  })
  _blockc._dic["blockParent"] = defx(_blockc, nil)
  _blockmainc = curryDefx(_defmain, "BlockMain", _blockc, nil)
  _funcblockc = classDefx(_defmain, "FuncBlock", &[]*Cptx{_funcprotoc}, map[string]*Cptx{
    "funcVars": _arrstrc,
    "funcBlock": _blockc,
  })
  _funcclosurec = curryDefx(_defmain, "FuncClosure", _funcblockc, nil)
  _functplc = classDefx(_defmain, "FuncTpl", &[]*Cptx{_funcc}, map[string]*Cptx{
    "funcTplAst": _strc,
    "funcTplPath": _strc,
  })
  _callc = classDefx(_defmain, "Call", &[]*Cptx{_midc}, nil)
  _callc._ctype = TCALL
  _callrawc = curryDefx(_defmain, "CallRaw", _callc, nil)
  _calltypec = curryDefx(_defmain, "CallType", _callrawc, nil)
  _callassignc = curryDefx(_defmain, "CallAssign", _callrawc, nil)
  _callmethodc = curryDefx(_defmain, "CallMethod", _callc, nil)
  _callreflectc = curryDefx(_defmain, "CallReflect", _callc, nil)
  _idc = classDefx(_defmain, "Id", nil, nil)
  _idstrc = classDefx(_defmain, "IdStr", &[]*Cptx{_idc}, map[string]*Cptx{
    "idStr": _strc,
  })
  _idstatec = classDefx(_defmain, "IdState", &[]*Cptx{_idstrc, _midc}, map[string]*Cptx{
    "idState": _classc,
  })
  _idlocalc = curryDefx(_defmain, "IdLocal", _idstatec, nil)
  _idparentc = curryDefx(_defmain, "IdParent", _idstatec, nil)
  _idglobalc = curryDefx(_defmain, "IdGlobal", _idstatec, nil)
  _idclassc = classDefx(_defmain, "IdClass", &[]*Cptx{_idstrc}, map[string]*Cptx{
    "idVal": _cptc,
  })
  _aliasc = classDefx(_defmain, "Alias", nil, nil)
  _opc = classDefx(_defmain, "Op", &[]*Cptx{_funcc}, map[string]*Cptx{
    "opPrecedence": _intc,
  })
  _op1c = classDefx(_defmain, "Op1", &[]*Cptx{_opc}, nil)
  _op2c = classDefx(_defmain, "Op2", &[]*Cptx{_opc}, nil)
  _opgetc = curryDefx(_defmain, "OpGet", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(0),
  })
  _opnotc = curryDefx(_defmain, "OpNot", _op1c, map[string]*Cptx{
    "opPrecedence": intNewx(10),
  })
  _opmultiplyc = curryDefx(_defmain, "OpMultiply", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(20),
  })
  _opdividec = curryDefx(_defmain, "OpDivide", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(20),
  })
  _opmodc = curryDefx(_defmain, "OpMod", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(20),
  })
  _opaddc = curryDefx(_defmain, "OpAdd", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(30),
  })
  _opsubtractc = curryDefx(_defmain, "OpSubtract", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(30),
  })
  _opgec = curryDefx(_defmain, "OpGe", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(40),
  })
  _oplec = curryDefx(_defmain, "OpLe", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(40),
  })
  _opgtc = curryDefx(_defmain, "OpGt", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(40),
  })
  _opltc = curryDefx(_defmain, "OpLt", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(40),
  })
  _opeqc = curryDefx(_defmain, "OpEq", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(50),
  })
  _opnec = curryDefx(_defmain, "OpNe", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(50),
  })
  _opandc = curryDefx(_defmain, "OpAnd", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(60),
  })
  _oporc = curryDefx(_defmain, "OpOr", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(70),
  })
  _opassignc = curryDefx(_defmain, "OpAssign", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(80),
  })
  _opconcatc = curryDefx(_defmain, "OpConcat", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(80),
  })
  _signalc = classDefx(_defmain, "Signal", nil, nil)
  _continuec = curryDefx(_defmain, "Continue", _signalc, nil)
  _breakc = curryDefx(_defmain, "Break", _signalc, nil)
  _gotoc = classDefx(_defmain, "Goto", &[]*Cptx{_signalc}, map[string]*Cptx{
    "goto": _uintc,
  })
  _returnc = classDefx(_defmain, "Return", &[]*Cptx{_signalc}, map[string]*Cptx{
    "return": _cptc,
  })
  _errorc = classDefx(_defmain, "Error", &[]*Cptx{_signalc}, map[string]*Cptx{
    "errorCode": _uintc,
    "errorMsg": _strc,
  })
  _ctrlc = classDefx(_defmain, "Ctrl", nil, nil)
  _ctrlargc = classDefx(_defmain, "CtrlArg", &[]*Cptx{_ctrlc}, map[string]*Cptx{
    "ctrlArg": _cptc,
  })
  _ctrlargsc = classDefx(_defmain, "CtrlArgs", &[]*Cptx{_ctrlc}, map[string]*Cptx{
    "ctrlArgs": _arrc,
  })
  _ctrlifc = curryDefx(_defmain, "CtrlIf", _ctrlargsc, nil)
  _ctrlforc = curryDefx(_defmain, "CtrlFor", _ctrlargsc, nil)
  _ctrleachc = curryDefx(_defmain, "CtrlEach", _ctrlargsc, nil)
  _ctrlwhilec = curryDefx(_defmain, "CtrlWhile", _ctrlargsc, nil)
  _ctrlbreakc = curryDefx(_defmain, "CtrlBreak", _ctrlc, nil)
  _ctrlcontinuec = curryDefx(_defmain, "CtrlContinue", _ctrlc, nil)
  _ctrlgotoc = curryDefx(_defmain, "CtrlGoto", _ctrlargc, nil)
  _ctrlreturnc = curryDefx(_defmain, "CtrlReturn", _ctrlargc, nil)
  _ctrlerrorc = curryDefx(_defmain, "CtrlError", _ctrlargsc, nil)
  _envc = classDefx(_defmain, "Env", nil, map[string]*Cptx{
    "envStack": _arrc,
    "envLocal": _objc,
    "envExec": _classc,
    "envBlock": _blockmainc,
    "envActive": _boolc,
  })
  _execns = nsNewx("exec")
  _execmain = scopeNewx(_execns, "main")
  _tplmain = classNewx(&[]*Cptx{_defmain}, nil)
  funcDefx(_defmain, "env", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _env
  }, nil, _envc)
  funcDefx(_defmain, "osCmd", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p *Cptx
    _o = (*_x)[0]
    _p = (*_x)[1]
    return strNewx(_osCmd(_o._str, _p._str))
  }, &[]*Cptx{_strc, _strc}, _strc)
  funcDefx(_defmain, "osArgs", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _aa *[]string
    var _i uint
    var _v string
    if(__osArgs == nil){
      _x = &[]*Cptx{}
      _aa = &os.Args
      _tmp1518172 := _aa;
      for _i = uint(0); _i < uint(len((*_tmp1518172))); _i ++ {
        _v = (*_tmp1518172)[_i]
        if(_i == 0){
          continue
        }
        (*_x) = append((*_x), strNewx(_v))
      }
      __osArgs = arrNewx(_arrstrc, _x)
    }
    return __osArgs
  }, nil, _arrstrc)
  funcDefx(_defmain, "osEnvGet", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(os.Getenv(_o._str))
  }, &[]*Cptx{_strc}, _strc)
  funcDefx(_defmain, "getArgFlag", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return boolNewx(_o._farg)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "getDefaultFlag", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return boolNewx(_o._fdefault)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "getMidFlag", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return boolNewx(_o._fmid)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "getName", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(_o._name)
  }, &[]*Cptx{_cptc}, _strc)
  funcDefx(_defmain, "getId", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(_o._id)
  }, &[]*Cptx{_cptc}, _strc)
  funcDefx(_defmain, "getNote", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(_o._str)
  }, &[]*Cptx{_cptc}, _strc)
  funcDefx(_defmain, "setIndent", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    __indentx = _o._str
    return _nullv
  }, &[]*Cptx{_strc}, nil)
  funcDefx(_defmain, "methodGet", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _f *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _f = (*_x)[1]
    return nullOrx(methodGetx(_o, _f))
  }, &[]*Cptx{_classc, _funcc}, _cptc)
  funcDefx(_defmain, "new", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    return defx(_o, _e._dic)
  }, &[]*Cptx{_classc, _dicc}, _cptc)
  funcDefx(_defmain, "as", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return _o
  }, &[]*Cptx{_cptc, _cptc}, _cptc)
  funcDefx(_defmain, "type", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_cptc}, _cptc)
  funcDefx(_defmain, "numConvert", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _c = (*_x)[0]
    if(_o._type != _c._ctype){
      fmt.Println("numConvert between float int big");debug.PrintStack();os.Exit(1)
    }
    _o._obj = _c
    return _o
  }, &[]*Cptx{_cptc, _cptc}, _cptc)
  funcDefx(_defmain, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    return nullOrx(getx(_o, _e._str))
  }, &[]*Cptx{_cptc, _strc}, _cptc)
  funcDefx(_defmain, "mustGet", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _o *Cptx
    var _r *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    _r = getx(_o, _e._str)
    if(_r == nil){
      fmt.Println(_e._str + " not found!");debug.PrintStack();os.Exit(1)
    }
    return _r
  }, &[]*Cptx{_cptc, _strc}, _cptc)
  funcDefx(_defmain, "set", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _o *Cptx
    var _r *Cptx
    var _v *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    _v = (*_x)[2]
    _r = setx(_o, _e._str, _v)
    if(_r != nil){
      return _r
    }
    _o._fdefault = false
    return _nullv
  }, &[]*Cptx{_cptc, _strc, _cptc}, _cptc)
  funcDefx(_defmain, "type", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return strNewx(typex(_l))
  }, &[]*Cptx{_cptc}, _strc)
  funcDefx(_defmain, "inClass", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(inClassx(_l, _r, nil))
  }, &[]*Cptx{_classc, _classc}, _boolc)
  funcDefx(_defmain, "class", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return classx(_l)
  }, &[]*Cptx{_cptc}, _cptc)
  funcDefx(_defmain, "typepred", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return nullOrx(typepredx(_l))
  }, &[]*Cptx{_cptc}, _classc)
  funcDefx(_defmain, "isCpt", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return boolNewx(_l._type == TCPT)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "isObj", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return boolNewx(_l._type == TOBJ)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "isClass", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return boolNewx(_l._type == TCLASS)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "isNull", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return boolNewx(_l._type == TNULL)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "isInt", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return boolNewx(_l._type == TINT)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "isFloat", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return boolNewx(_l._type == TFLOAT)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "isNumBig", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return boolNewx(_l._type == TNUMBIG)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "isStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return boolNewx(_l._type == TSTR)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "isArr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return boolNewx(_l._type == TARR)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "isDic", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return boolNewx(_l._type == TDIC)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "uid", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return strNewx(uidx())
  }, nil, _strc)
  funcDefx(_defmain, "log", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    fmt.Println(strx(_o, 0))
    return _nullv
  }, &[]*Cptx{_cptc}, nil)
  funcDefx(_defmain, "die", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    fmt.Println(_o._str);debug.PrintStack();os.Exit(1)
    return _nullv
  }, &[]*Cptx{_strc}, nil)
  funcDefx(_defmain, "print", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    fmt.Print(_o._str)
    return _nullv
  }, &[]*Cptx{_strc}, nil)
  funcDefx(_defmain, "appendIfExists", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _app *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _app = (*_x)[1]
    if(_o._str == ""){
      return _o
    }
    _o._str += _app._str
    return _o
  }, &[]*Cptx{_strc, _strc}, _strc)
  funcDefx(_defmain, "ind", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _f *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _f = (*_x)[1]
    return strNewx(indx(_o._str, _f._int))
  }, &[]*Cptx{_strc, _intc}, _strc)
  funcDefx(_defmain, "exec", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return execx(_l, _r, 1)
  }, &[]*Cptx{_cptc, _envc}, _cptc)
  funcDefx(_defmain, "opp", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _f *Cptx
    var _main int
    var _o *Cptx
    var _op *Cptx
    var _ret *Cptx
    var _sub int
    _o = (*_x)[0]
    _op = (*_x)[1]
    _e = (*_x)[2]
    _ret = execx(_o, _e, 1)
    if(_ret._type != TSTR){
      fmt.Println("opp: not used in tplCall");debug.PrintStack();os.Exit(1)
    }
    if(!inClassx(classx(_o), _callc, nil)){
      return _ret
    }
    _f = _o._class
    if(!inClassx(classx(_f), _opc, nil)){
      return _ret
    }
    _sub = getx(_f, "opPrecedence")._int
    _main = getx(_op, "opPrecedence")._int
    if(_sub > _main){
      return strNewx("(" + _ret._str + ")")
    }
    return _ret
  }, &[]*Cptx{_cptc, _opc, _envc}, _strc)
  funcDefx(_defmain, "call", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _a *Cptx
    var _e *Cptx
    var _f *Cptx
    _f = (*_x)[0]
    _a = (*_x)[1]
    _e = (*_x)[2]
    if(_e._fdefault){
      _e = _env
    }
    if(_f == nil || _f._id == _nullv._id){
      fmt.Println(strx(_a, 0))
      fmt.Println("call() error");debug.PrintStack();os.Exit(1)
    }
    if(!inClassx(classx(_f), _funcc, nil)){
      fmt.Println(strx(_f, 0))
      fmt.Println("not func");debug.PrintStack();os.Exit(1)
    }
    return callx(_f, _a._arr, _e)
  }, &[]*Cptx{_funcc, _arrc, _envc}, _cptc)
  funcDefx(_defmain, "tplCall", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _a *Cptx
    var _e *Cptx
    var _f *Cptx
    _f = (*_x)[0]
    _a = (*_x)[1]
    _e = (*_x)[2]
    if(_e._fdefault){
      _e = _env
    }
    return tplCallx(_f, _a._arr, _e)
  }, &[]*Cptx{_functplc, _arrc, _envc}, _cptc)
  funcDefx(_defmain, "keys", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return copyx(arrNewx(_arrstrc, _o._arr))
  }, &[]*Cptx{_dicc}, _arrstrc)
  funcDefx(_defmain, "callFunc", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return _o._class
  }, &[]*Cptx{_callc}, _funcc)
  funcDefx(_defmain, "callArgs", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return arrNewx(_arrc, _o._arr)
  }, &[]*Cptx{_callc}, _arrc)
  methodDefx(_aliasc, "getClass", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return aliasGetx(_o)
  }, nil, _classc)
  methodDefx(_pathc, "timeMod", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _intc)
  methodDefx(_pathc, "exists", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._dic["path"]._str
    return boolNewx(_Path_exists(_p))
  }, &[]*Cptx{_strc}, _boolc)
  methodDefx(_pathc, "resolve", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._dic["path"]._str
    return strNewx(_lf(filepath.Abs(_p)).(string))
  }, &[]*Cptx{_strc}, _strc)
  methodDefx(_filec, "write", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _d *Cptx
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _d = (*_x)[1]
    _p = _o._dic["path"]._str
    _File_write(_p, _d._str)
    return _nullv
  }, &[]*Cptx{_strc}, nil)
  methodDefx(_filec, "readAll", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._dic["path"]._str
    return strNewx(_File_readAll(_p))
  }, nil, _strc)
  methodDefx(_dirc, "write", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _d *Cptx
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _d = (*_x)[1]
    _p = _o._dic["path"]._str
    dirWritex(_p, _d._dic)
    return _nullv
  }, &[]*Cptx{_dicc}, nil)
  methodDefx(_dirc, "writeFile", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _f *Cptx
    var _o *Cptx
    var _s *Cptx
    _o = (*_x)[0]
    _f = (*_x)[1]
    _s = (*_x)[2]
    _File_write(_o._dic["path"]._str + _f._str, _s._str)
    return _nullv
  }, &[]*Cptx{_strc, _strc}, nil)
  methodDefx(_dirc, "makeAll", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p *Cptx
    var _pp string
    var _ps string
    _o = (*_x)[0]
    _p = (*_x)[1]
    _ps = _p._str
    if(_ps == ""){
      _ps = "0777"
    }
    _pp = _o._dic["path"]._str
    os.MkdirAll(_pp, 0777)
    return _nullv
  }, &[]*Cptx{_strc, _strc}, nil)
  methodDefx(_objc, "toDic", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _arrx *[]*Cptx
    var _k string
    var _o *Cptx
    _o = (*_x)[0]
    _arrx = &[]*Cptx{}
    _tmp1799570 := _Arr_Str_sort(_keys(_o._dic));
    for _tmp1799571 := uint(0); _tmp1799571 < uint(len((*_tmp1799570))); _tmp1799571 ++ {
      _k = (*_tmp1799570)[_tmp1799571]
      (*_arrx) = append((*_arrx), strNewx(_k))
    }
    return dicNewx(_dicc, _o._dic, _arrx)
  }, nil, _dicc)
  methodDefx(_classc, "schema", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _arrx *[]*Cptx
    var _k string
    var _o *Cptx
    _o = (*_x)[0]
    _arrx = &[]*Cptx{}
    _tmp1807184 := _Arr_Str_sort(_keys(_o._dic));
    for _tmp1807185 := uint(0); _tmp1807185 < uint(len((*_tmp1807184))); _tmp1807185 ++ {
      _k = (*_tmp1807184)[_tmp1807185]
      (*_arrx) = append((*_arrx), strNewx(_k))
    }
    return dicNewx(_dicc, _o._dic, _arrx)
  }, nil, _dicc)
  methodDefx(_classc, "parents", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return arrNewx(_arrclassc, arrCopyx(_o._arr))
  }, nil, _arrc)
  methodDefx(_intc, "toStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(strconv.Itoa(_o._int))
  }, &[]*Cptx{_intc}, _strc)
  methodDefx(_floatc, "toStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(strconv.FormatFloat(float64(_o._val.(float64)), 'f', -1, 64))
  }, &[]*Cptx{_intc}, _strc)
  methodDefx(_strc, "split", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _sep *Cptx
    var _v string
    var _xx *[]string
    var _y *[]*Cptx
    _o = (*_x)[0]
    _sep = (*_x)[1]
    _xx = _Str_split(_o._str, _sep._str)
    _y = &[]*Cptx{}
    _tmp1830077 := _xx;
    for _tmp1830078 := uint(0); _tmp1830078 < uint(len((*_tmp1830077))); _tmp1830078 ++ {
      _v = (*_tmp1830077)[_tmp1830078]
      (*_y) = append((*_y), strNewx(_v))
    }
    return arrNewx(_arrstrc, _y)
  }, &[]*Cptx{_strc, _strc}, _arrstrc)
  methodDefx(_strc, "replace", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _fr *Cptx
    var _o *Cptx
    var _to *Cptx
    _o = (*_x)[0]
    _fr = (*_x)[1]
    _to = (*_x)[2]
    return strNewx(strings.Replace(_o._str, _fr._str, _to._str, -1))
  }, &[]*Cptx{_strc, _strc}, _strc)
  methodDefx(_strc, "toPath", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._str
    return objNewx(_filec, map[string]*Cptx{
      "path": strNewx(_lf(filepath.Abs(_p)).(string)),
    })
  }, nil, _filec)
  methodDefx(_strc, "toFile", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._str
    return objNewx(_filec, map[string]*Cptx{
      "path": strNewx(_lf(filepath.Abs(_p)).(string)),
    })
  }, nil, _filec)
  methodDefx(_strc, "toDir", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._str
    return objNewx(_dirc, map[string]*Cptx{
      "path": strNewx(_lf(filepath.Abs(_p)).(string) + "/"),
    })
  }, nil, _dirc)
  methodDefx(_strc, "toJsonArr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _jsonarrc)
  methodDefx(_strc, "toJson", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _jsonc)
  methodDefx(_strc, "toInt", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(_lf(strconv.Atoi(_o._str)).(int))
  }, nil, _intc)
  methodDefx(_strc, "toFloat", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return floatNewx(_lf(strconv.ParseFloat(_o._str, 64)).(float64))
  }, nil, _floatc)
  methodDefx(_strc, "escape", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _s string
    _s = (*_x)[0]._str
    return strNewx(escapex(_s))
  }, &[]*Cptx{_strc}, _strc)
  methodDefx(_strc, "isInt", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _s string
    _s = (*_x)[0]._str
    return boolNewx(_Str_isInt(_s))
  }, &[]*Cptx{_strc}, _boolc)
  methodDefx(_arrc, "push", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    (*_o._arr) = append((*_o._arr), _e)
    return _nullv
  }, &[]*Cptx{_cptc}, nil)
  methodDefx(_arrc, "pop", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    (*_o._arr) = (*_o._arr)[:len((*_o._arr))-1]
    return _nullv
  }, nil, nil)
  methodDefx(_arrc, "unshift", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    (*_o._arr) = append([]*Cptx{_e}, (*_o._arr)...)
    return _nullv
  }, &[]*Cptx{_cptc}, nil)
  methodDefx(_arrc, "len", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(len((*_o._arr)))
  }, nil, _intc)
  methodDefx(_arrc, "set", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _i *Cptx
    var _o *Cptx
    var _v *Cptx
    _o = (*_x)[0]
    _i = (*_x)[1]
    _v = (*_x)[2]
    if(len((*_o._arr)) <= _i._int){
      fmt.Println(arr2strx(_o._arr, 0))
      fmt.Println(_i._int)
      fmt.Println("arrset: index out of range");debug.PrintStack();os.Exit(1)
    }
    (*_o._arr)[_i._int] = _v
    _o._fdefault = false
    return _v
  }, &[]*Cptx{_uintc, _cptc}, _cptc)
  methodDefx(_arrstrc, "sort", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _arrstrc)
  methodDefx(_arrstrc, "join", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _i uint
    var _o *Cptx
    var _s string
    var _sep *Cptx
    var _v *Cptx
    _o = (*_x)[0]
    _sep = (*_x)[1]
    _s = ""
    _tmp1915984 := _o._arr;
    for _i = uint(0); _i < uint(len((*_tmp1915984))); _i ++ {
      _v = (*_tmp1915984)[_i]
      if(_i != 0){
        _s += _sep._str
      }
      _s += _v._str
    }
    return strNewx(_s)
  }, &[]*Cptx{_strc}, _strc)
  methodDefx(_jsonc, "len", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(len((*_o._arr)))
  }, nil, _intc)
  methodDefx(_dicc, "len", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(len((*_o._arr)))
  }, nil, _intc)
  methodDefx(_dicc, "set", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _i *Cptx
    var _o *Cptx
    var _v *Cptx
    _o = (*_x)[0]
    _i = (*_x)[1]
    _v = (*_x)[2]
    if(_o._dic[_i._str] == nil){
      (*_o._arr) = append((*_o._arr), _i)
    }
    _o._dic[_i._str] = _v
    _o._fdefault = false
    return _v
  }, &[]*Cptx{_strc, _cptc}, _cptc)
  methodDefx(_dicc, "hasKey", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _i *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _i = (*_x)[1]
    if(_o._dic[_i._str] != nil){
      return _truev
    }
    return _falsev
  }, &[]*Cptx{_strc}, _boolc)
  methodDefx(_dicc, "appendClass", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _c = (*_x)[1]
    appendClassx(_o, _c)
    return _o
  }, &[]*Cptx{_classc}, _dicc)
  methodDefx(_dicc, "values", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return valuesx(_o)
  }, nil, _arrc)
  methodDefx(_dicstrc, "values", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return valuesx(_o)
  }, nil, _arrstrc)
  opDefx(_arrc, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    return (*_o._arr)[_e._int]
  }, _intc, _cptc, _opgetc)
  opDefx(_dicc, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _o *Cptx
    var _r *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    _r = _o._dic[_e._str]
    return nullOrx(_r)
  }, _strc, _cptc, _opgetc)
  opDefx(_jsonc, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, _strc, _cptc, _opgetc)
  opDefx(_idlocalc, "assign", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _local *Cptx
    var _r *Cptx
    var _str *Cptx
    var _v *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    _v = execx(_r, _env, 0)
    _local = _env._dic["envLocal"]
    _str = _l._dic["idStr"]
    _local._dic[_str._str] = _v
    return _v
  }, _cptc, _cptc, _opassignc)
  opDefx(_idparentc, "assign", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _k string
    var _l *Cptx
    var _o *Cptx
    var _r *Cptx
    var _v *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    _v = execx(_r, _env, 0)
    _k = _l._dic["idStr"]._str
    _o = _l._dic["idState"]._obj
    _o._dic[_k] = _v
    return _v
  }, _cptc, _cptc, _opassignc)
  opDefx(_idglobalc, "assign", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _k string
    var _l *Cptx
    var _o *Cptx
    var _r *Cptx
    var _v *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    _v = execx(_r, _env, 0)
    _k = _l._dic["idStr"]._str
    _o = _l._dic["idState"]._obj
    _o._dic[_k] = _v
    return _v
  }, _cptc, _cptc, _opassignc)
  opDefx(_strc, "add", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return strNewx(_l._str + _r._str)
  }, _strc, _strc, _opaddc)
  opDefx(_strc, "eq", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(_l._str == _r._str)
  }, _strc, _boolc, _opeqc)
  opDefx(_strc, "ne", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(_l._str != _r._str)
  }, _strc, _boolc, _opnec)
  opDefx(_strc, "concat", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    _l._str += _r._str
    return _l
  }, _strc, _strc, _opconcatc)
  opDefx(_intc, "add", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return intNewx(_l._int + _r._int)
  }, _intc, _intc, _opaddc)
  opDefx(_intc, "subtract", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return intNewx(_l._int - _r._int)
  }, _intc, _intc, _opsubtractc)
  opDefx(_intc, "multiply", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return intNewx(_l._int * _r._int)
  }, _intc, _intc, _opmultiplyc)
  opDefx(_intc, "divide", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return intNewx(_l._int / _r._int)
  }, _intc, _intc, _opdividec)
  opDefx(_intc, "mod", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return intNewx(_l._int % _r._int)
  }, _intc, _intc, _opmodc)
  opDefx(_intc, "eq", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(_l._int == _r._int)
  }, _intc, _boolc, _opeqc)
  opDefx(_intc, "ne", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(_l._int != _r._int)
  }, _intc, _boolc, _opnec)
  opDefx(_intc, "lt", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(_l._int < _r._int)
  }, _intc, _boolc, _opltc)
  opDefx(_intc, "gt", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(_l._int > _r._int)
  }, _intc, _boolc, _opgtc)
  opDefx(_intc, "le", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(_l._int <= _r._int)
  }, _intc, _boolc, _oplec)
  opDefx(_intc, "ge", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(_l._int >= _r._int)
  }, _intc, _boolc, _opgec)
  opDefx(_boolc, "and", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(_l._int != 0 && _r._int != 0)
  }, _boolc, _boolc, _opandc)
  opDefx(_boolc, "or", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(_l._int != 0 || _r._int != 0)
  }, _boolc, _boolc, _oporc)
  opDefx(_cptc, "add", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    if(_l._type != _r._type){
      fmt.Println(strx(_l, 0))
      fmt.Println("add: wrong type");debug.PrintStack();os.Exit(1)
    }
    if(_l._type == TINT){
      return intNewx(_l._int + _r._int)
    }
    if(_l._type == TFLOAT){
      return floatNewx(_l._val.(float64) + _r._val.(float64))
    }
    if(_l._type == TSTR){
      return strNewx(_l._str + _r._str)
    }
    fmt.Println(strx(_l, 0))
    fmt.Println("cannot add");debug.PrintStack();os.Exit(1)
    return _nullv
  }, _cptc, _cptc, _opaddc)
  opDefx(_cptc, "not", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    if(_l._type != TINT){
      fmt.Println(strx(_l, 0))
      fmt.Println("not wrong type");debug.PrintStack();os.Exit(1)
    }
    return boolNewx(_l._int == 0)
  }, nil, _boolc, _opnotc)
  opDefx(_cptc, "ne", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(!eqx(_l, _r))
  }, _cptc, _boolc, _opnec)
  opDefx(_cptc, "eq", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return boolNewx(eqx(_l, _r))
  }, _cptc, _boolc, _opeqc)
  execDefx("Env", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _a *Cptx
    var _nenv *Cptx
    _nenv = (*_x)[0]
    __indentx = " "
    _a = _nenv._dic["envActive"]
    if(_a._int == 1){
      return _nenv
    }
    _nenv._dic["envActive"] = _truev
    return execx(_nenv._dic["envBlock"], _nenv, 0)
  })
  execDefx("BlockMain", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _r *Cptx
    _o = (*_x)[0]
    _r = blockExecx(_o, _env, 0)
    return _r
  })
  execDefx("Call", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _args *[]*Cptx
    var _argsx *[]*Cptx
    var _c *Cptx
    var _f *Cptx
    _c = (*_x)[0]
    _f = execx(_c._class, _env, 0)
    _args = _c._arr
    if(_f == nil || _f._id == _nullv._id){
      fmt.Println(strx(_c, 0))
      fmt.Println("Call: empty func");debug.PrintStack();os.Exit(1)
    }
    _argsx = prepareArgsx(_args, _f, _env)
    return callx(_f, _argsx, _env)
  })
  execDefx("CallRaw", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _args *[]*Cptx
    var _c *Cptx
    _c = (*_x)[0]
    _args = _c._arr
    return callx(_c._class, _args, _env)
  })
  execDefx("Obj", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return (*_x)[0]
  })
  execDefx("Class", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return (*_x)[0]
  })
  execDefx("Val", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return (*_x)[0]
  })
  execDefx("Dic", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _d map[string]*Cptx
    var _it *Cptx
    var _k string
    var _o *Cptx
    var _v *Cptx
    _o = (*_x)[0]
    if(inClassx(classx(_o), _midc, nil)){
      _it = getx(_o, "itemsType")
      if(_it == nil){
        _it = _cptv
      }
      _d = map[string]*Cptx{
      }
      for _k, _v = range _o._dic {
        _d[_k] = execx(_v, _env, 0)
      }
      _c = itemDefx(_dicc, classx(_it), false)
      return dicNewx(_c, _d, arrCopyx(_o._arr))
    }
    return _o
  })
  execDefx("Arr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _a *[]*Cptx
    var _c *Cptx
    var _i uint
    var _it *Cptx
    var _o *Cptx
    var _v *Cptx
    _o = (*_x)[0]
    if(inClassx(classx(_o), _midc, nil)){
      _it = getx(_o, "itemsType")
      if(_it == nil){
        _it = _cptv
      }
      _a = &[]*Cptx{}
      _tmp2187251 := _o._arr;
      for _i = uint(0); _i < uint(len((*_tmp2187251))); _i ++ {
        _v = (*_tmp2187251)[_i]
        (*_a) = append((*_a), execx(_v, _env, 0))
      }
      _c = itemDefx(_arrc, classx(_it), false)
      return arrNewx(_c, _a)
    }
    return _o
  })
  execDefx("CtrlReturn", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _f *Cptx
    _c = (*_x)[0]
    _f = execx(_c._dic["ctrlArg"], _env, 0)
    return defx(_returnc, map[string]*Cptx{
      "return": _f,
    })
  })
  execDefx("CtrlBreak", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return objNewx(_breakc, nil)
  })
  execDefx("CtrlContinue", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return objNewx(_continuec, nil)
  })
  execDefx("CtrlIf", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _args *[]*Cptx
    var _c *Cptx
    var _i int
    var _l int
    var _r *Cptx
    _c = (*_x)[0]
    _args = _c._dic["ctrlArgs"]._arr
    _l = len((*_args))
    for _i = 0; _i < _l - 1; _i = _i + 2 {
      _r = execx((*_args)[_i], _env, 0)
      if(ifcheckx(_r)){
        return blockExecx((*_args)[_i + 1], _env, 0)
      }
    }
    if(_l % 2 == 1){
      return blockExecx((*_args)[_l - 1], _env, 0)
    }
    return _nullv
  })
  execDefx("CtrlFor", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _args *[]*Cptx
    var _c *Cptx
    var _r *Cptx
    _c = (*_x)[0]
    _args = _c._dic["ctrlArgs"]._arr
    execx((*_args)[0], _env, 0)
    for 1 != 0 {
      _c = execx((*_args)[1], _env, 0)
      if(!ifcheckx(_c)){
        break
      }
      _r = blockExecx((*_args)[3], _env, 0)
      if(inClassx(classx(_r), _signalc, nil)){
        if(_r._obj._id == _breakc._id){
          break
        }
        if(_r._obj._id == _continuec._id){
          continue
        }
        return _r
      }
      execx((*_args)[2], _env, 0)
    }
    return _nullv
  })
  execDefx("CtrlEach", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _args *[]*Cptx
    var _c *Cptx
    var _da *Cptx
    var _i uint
    var _k string
    var _kc *Cptx
    var _key string
    var _local map[string]*Cptx
    var _r *Cptx
    var _v *Cptx
    var _val string
    _c = (*_x)[0]
    _args = _c._dic["ctrlArgs"]._arr
    _da = execx((*_args)[2], _env, 0)
    _key = (*_args)[0]._str
    _val = (*_args)[1]._str
    _local = _env._dic["envLocal"]._dic
    if(_da._type == TDIC){
      _tmp2238262 := _da._arr;
      for _tmp2238263 := uint(0); _tmp2238263 < uint(len((*_tmp2238262))); _tmp2238263 ++ {
        _kc = (*_tmp2238262)[_tmp2238263]
        _k = _kc._str
        _v = _da._dic[_k]
        if(_key != ""){
          _local[_key] = strNewx(_k)
        }
        if(_val != ""){
          _local[_val] = _v
        }
        _r = blockExecx((*_args)[3], _env, 0)
        if(inClassx(classx(_r), _signalc, nil)){
          if(_r._obj._id == _breakc._id){
            break
          }
          if(_r._obj._id == _continuec._id){
            continue
          }
          return _r
        }
      }
    }else if(_da._type == TARR){
      _tmp2248217 := _da._arr;
      for _i = uint(0); _i < uint(len((*_tmp2248217))); _i ++ {
        _v = (*_tmp2248217)[_i]
        if(_key != ""){
          _local[_key] = uintNewx(int(_i))
        }
        if(_val != ""){
          _local[_val] = _v
        }
        _r = blockExecx((*_args)[3], _env, 0)
        if(inClassx(classx(_r), _signalc, nil)){
          if(_r._obj._id == _breakc._id){
            break
          }
          if(_r._obj._id == _continuec._id){
            continue
          }
          return _r
        }
      }
    }else if(_da._type == TNULL){
      return _nullv
    }else{
      fmt.Println(strx(_da, 0))
      fmt.Println(_da._type)
      fmt.Println(classx(_da)._ctype)
      fmt.Println("CtrlEach: type not defined");debug.PrintStack();os.Exit(1)
    }
    return _nullv
  })
  execDefx("IdClass", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    _c = (*_x)[0]
    return getx(_c, "idVal")
  })
  execDefx("IdLocal", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _k string
    var _l *Cptx
    var _r *Cptx
    _c = (*_x)[0]
    _l = _env._dic["envLocal"]
    _k = _c._dic["idStr"]._str
    _r = getx(_l, _k)
    if(_r == nil){
      return _nullv
    }
    return _r
  })
  execDefx("IdState", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _k string
    var _o *Cptx
    var _r *Cptx
    _c = (*_x)[0]
    _k = _c._dic["idStr"]._str
    _o = _c._dic["idState"]._obj
    _r = _o._dic[_k]
    if(_r == nil){
      return _nullv
    }
    return _r
  })
  _osargs = &os.Args
  if(len((*_osargs)) == 1){
    fmt.Println("./soul3 [FILE] [EXECFLAG] [DEFFLAG]")
  }else{
    _fc = _File_readAll((*_osargs)[1])
    _execsp = "main"
    _defsp = "main"
    if(len((*_osargs)) > 2){
      _execsp = (*_osargs)[2]
    }
    if(len((*_osargs)) > 3){
      _defsp = (*_osargs)[3]
    }
    _main = progl2cptx("@env " + _execsp + " | " + _defsp + " {" + _fc + "}'" + (*_osargs)[1] + "'", _defmain, nil)
    execx(_main._dic["envBlock"], _main, 0)
  }
}
