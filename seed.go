package main
import "strings"
import "io/ioutil"
import "log"
import "os"
import "runtime/debug"
import "fmt"
import "sort"
import "os/exec"
import "encoding/json"
import "strconv"
import "path/filepath"
const (
  TCPT = 0
  TOBJ = 1
  TCLASS = 2
  TTOBJ = 3
  TINT = 4
  TFLOAT = 5
  TNUMBIG = 6
  TSTR = 7
  TARR = 8
  TDIC = 9
  TJSON = 10
  TNATIVE = 11
  TID = 12
  TCALL = 13
)
type Funcx func(*[]*Cptx, *Cptx) *Cptx
type Dicx map[string]*Cptx
type Arrx *[]*Cptx
type Astx []interface{}
type Cptx struct {
  _arr *[]*Cptx
  _ast []interface{}
  _class *Cptx
  _ctype uint8
  _dic map[string]*Cptx
  _farg bool
  _fast bool
  _fbitems bool
  _fbnum bool
  _fdefault bool
  _fmid bool
  _fprop bool
  _fraw bool
  _fscope bool
  _fstatic bool
  _id uint
  _int int
  _name string
  _obj *Cptx
  _pred *Cptx
  _str string
  _type uint8
  _val interface{}
}
var _version int
var _uidi uint
var __indentx string
var _inClassCache map[string]int
var _root map[string]*Cptx
var _defns *Cptx
var _defmain *Cptx
var _execns *Cptx
var _execmain *Cptx
var _tplmain *Cptx
var __osArgs *Cptx
var _cptc *Cptx
var _cptv *Cptx
var _emptyc *Cptx
var _emptyv *Cptx
var _unknownc *Cptx
var _unknownv *Cptx
var _nullc *Cptx
var _nullv *Cptx
var _objc *Cptx
var _classc *Cptx
var _tobjc *Cptx
var _midc *Cptx
var _valc *Cptx
var _numc *Cptx
var _intc *Cptx
var _uintc *Cptx
var _floatc *Cptx
var _bytec *Cptx
var _boolc *Cptx
var _numbigc *Cptx
var _truev *Cptx
var _falsev *Cptx
var _itemsc *Cptx
var _itemslimitedc *Cptx
var _arrc *Cptx
var _staticarrc *Cptx
var _dicc *Cptx
var _bytesc *Cptx
var _strc *Cptx
var _arrstrc *Cptx
var _dicstrc *Cptx
var _dicuintc *Cptx
var _dicclassc *Cptx
var _arrclassc *Cptx
var _enumc *Cptx
var _timec *Cptx
var _jsonc *Cptx
var _jsonarrc *Cptx
var _bufferc *Cptx
var _pathxc *Cptx
var _filexc *Cptx
var _dirxc *Cptx
var _funcc *Cptx
var _funcprotoc *Cptx
var _nativec *Cptx
var _funcnativec *Cptx
var _blockc *Cptx
var _blockmainc *Cptx
var _funcblockc *Cptx
var _funcclosurec *Cptx
var _functplc *Cptx
var _handlerc *Cptx
var _routerc *Cptx
var _routersubc *Cptx
var _handlerstandalonec *Cptx
var _handlerembeddedc *Cptx
var _msgc *Cptx
var _nodec *Cptx
var _inetc *Cptx
var _inetv *Cptx
var _serverc *Cptx
var _serverhttpc *Cptx
var _serverhttpsc *Cptx
var _clientc *Cptx
var _clienthttpc *Cptx
var _clienthttpsc *Cptx
var _filec *Cptx
var _fsc *Cptx
var _fsv *Cptx
var _dirc *Cptx
var _schemac *Cptx
var _dbmsc *Cptx
var _callc *Cptx
var _arrcallc *Cptx
var _callpassrefc *Cptx
var _callrawc *Cptx
var _idc *Cptx
var _callidc *Cptx
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
var _opcmpc *Cptx
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
func uidx() uint{
  _uidi = _uidi + 1
  return _uidi
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
  _tmp44169 := _o;
  for _tmp44176 := uint(0); _tmp44176 < uint(len((*_tmp44169))); _tmp44176 ++ {
    _e = (*_tmp44169)[_tmp44176]
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
  _tmp45151 := _arr;
  for _i = uint(0); _i < uint(len((*_tmp45151))); _i ++ {
    _x = (*_tmp45151)[_i]
    if(_i != 0 && _x != ""){
      _r += "\n"
      _r += __indentx
    }
    _r += _x
  }
  return _r
}
func copyCptFromAstx(_v *Cptx) *Cptx{
  var _x *Cptx
  if(_v._fast){
    _x = copyx(_v)
    _x._fast = false
    return _x
  }
  return _v
}
func escapex(_s string) string{
  return strings.Replace(strings.Replace(strings.Replace(strings.Replace(strings.Replace(_s, "\\", "\\\\", -1), "\n", "\\n", -1), "\t", "\\t", -1), "\r", "\\r", -1), "\"", "\\\"", -1)
}
func _Filex_write(f string, s string){
 err := ioutil.WriteFile(f, []byte(s), 0666);
 if(err != nil){
  debug.PrintStack();log.Fatal(err);os.Exit(1)

 }
}
func dirWritex(_d string, _dic map[string]*Cptx) {
  var _k string
  var _v *Cptx
  var _x string
  for _k, _v = range _dic {
    if(_v._type == TSTR){
      _x = _d + _k
      _Filex_write(_x, _v._str)
    }else{
      fmt.Println(dic2strx(_dic, 0))
      fmt.Println("wrong dic for dirWrite");debug.PrintStack();os.Exit(1)
    }
  }
}
func _Arr_Str_sort(c *[]string)[]string{
 sort.Strings(*c)
 return *c
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
  _tmp47040 := _Arr_Str_sort(_keys(_c._dic));
  for _tmp47047 := uint(0); _tmp47047 < uint(len(_tmp47040)); _tmp47047 ++ {
    _k = _tmp47040[_tmp47047]
    if(_o._dic[_k] == nil){
      (*_o._arr) = append((*_o._arr), strNewx(_k, nil))
      _o._dic[_k] = _c._dic[_k]
    }
  }
  _tmp47575 := _c._arr;
  for _tmp47582 := uint(0); _tmp47582 < uint(len((*_tmp47575))); _tmp47582 ++ {
    _v = (*_tmp47575)[_tmp47582]
    appendClassx(_o, _v)
  }
}
func ifcheckx(_r *Cptx) bool{
  if(_r._type == TINT){
    return _r._int != 0
  }
  return _r._id != _nullv._id
}
func parentMakex(_o *Cptx, _parentarr *[]*Cptx) {
  var _ctype uint8
  var _e *Cptx
  if(_parentarr != nil){
    _ctype = _o._ctype
    _tmp48284 := _parentarr;
    for _tmp48291 := uint(0); _tmp48291 < uint(len((*_tmp48284))); _tmp48291 ++ {
      _e = (*_tmp48284)[_tmp48291]
      if(_e._id == 0){
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
func routex(_o *Cptx, _scope *Cptx, _name string) *Cptx{
  var _dic map[string]*Cptx
  _dic = _scope._dic
  _dic[_name] = _o
  _o._name = _name
  _o._class = _scope
  return _o
}
func passx(_v *Cptx) *Cptx{
  if(inClassx(classx(_v), _valc, nil)){
    return copyx(_v)
  }
  return _v
}
func nullOrx(_x *Cptx) *Cptx{
  if(_x == nil){
    return _nullv
  }
  return _x
}
func aliasGetx(_c *Cptx) *Cptx{
  if(_c._arr == nil){
    fmt.Println(strx(_c, 0))
    fmt.Println("alias wrong cpt");debug.PrintStack();os.Exit(1)
  }
  if(len((*_c._arr)) > 1){
    if((*_c._arr)[0]._id == _aliasc._id){
      return aliasGetx((*_c._arr)[1])
    }
  }
  return _c
}
func funcSetClosurex(_func *Cptx) {
  (*_func._obj._arr)[1] = _funcclosurec
}
func funcSetOpx(_func *Cptx, _op *Cptx) {
  (*_func._obj._arr) = append((*_func._obj._arr), _op)
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
func valuesx(_o *Cptx) *Cptx{
  var _arr *[]*Cptx
  var _c *Cptx
  var _it *Cptx
  var _k *Cptx
  var _v *Cptx
  _arr = &[]*Cptx{}
  _tmp51438 := _o._arr;
  for _tmp51445 := uint(0); _tmp51445 < uint(len((*_tmp51438))); _tmp51445 ++ {
    _k = (*_tmp51438)[_tmp51445]
    _v = _o._dic[_k._str]
    (*_arr) = append((*_arr), _v)
  }
  _it = getx(_o, "itemsType")
  if(_it == nil){
    _c = _arrc
  }else{
    _c = itemsDefx(_arrc, classx(_it), false)
  }
  return arrNewx(_arr, _c)
}
func prepareArgsx(_args *[]*Cptx, _f *Cptx, _env *Cptx) *[]*Cptx{
  var _arg *Cptx
  var _argdef *Cptx
  var _argsx *[]*Cptx
  var _i uint
  var _t *Cptx
  var _vartypes *[]*Cptx
  var _x *Cptx
  _argsx = &[]*Cptx{}
  if(!inClassx(classx(_f), _functplc, nil)){
    _vartypes = getx(_f, "funcVarTypes")._arr
    _tmp52416 := _vartypes;
    for _i = uint(0); _i < uint(len((*_tmp52416))); _i ++ {
      _argdef = (*_tmp52416)[_i]
      if(int(_i) < len((*_args))){
        _t = passx(execx((*_args)[_i], _env, 0))
      }else{
        _t = copyx(_argdef)
      }
      (*_argsx) = append((*_argsx), _t)
    }
  }else{
    _tmp52916 := _args;
    for _tmp52923 := uint(0); _tmp52923 < uint(len((*_tmp52916))); _tmp52923 ++ {
      _arg = (*_tmp52916)[_tmp52923]
      _x = passx(execx(_arg, _env, 0))
      (*_argsx) = append((*_argsx), _x)
    }
  }
  return _argsx
}
func prepareArgsRefx(_args *[]*Cptx, _f *Cptx, _env *Cptx) *[]*Cptx{
  var _arg *Cptx
  var _argdef *Cptx
  var _argsx *[]*Cptx
  var _i uint
  var _t *Cptx
  var _vartypes *[]*Cptx
  var _x *Cptx
  _argsx = &[]*Cptx{}
  if(!inClassx(classx(_f), _functplc, nil)){
    _vartypes = getx(_f, "funcVarTypes")._arr
    _tmp53677 := _vartypes;
    for _i = uint(0); _i < uint(len((*_tmp53677))); _i ++ {
      _argdef = (*_tmp53677)[_i]
      if(int(_i) < len((*_args))){
        _t = execx((*_args)[_i], _env, 0)
      }else{
        _t = _argdef
      }
      (*_argsx) = append((*_argsx), _t)
    }
  }else{
    _tmp54079 := _args;
    for _tmp54086 := uint(0); _tmp54086 < uint(len((*_tmp54079))); _tmp54086 ++ {
      _arg = (*_tmp54079)[_tmp54086]
      _x = passx(execx(_arg, _env, 0))
      (*_argsx) = append((*_argsx), _x)
    }
  }
  return _argsx
}
func classNewx(_arr *[]*Cptx, _dic map[string]*Cptx) *Cptx{
  var _r *Cptx
  _r = &Cptx{
    _type: TCLASS,  
    _ctype: TOBJ,  
    _fstatic: true,  
    _id: uidx(),  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  _r._dic = dicOrx(_dic)
  parentMakex(_r, _arr)
  return _r
}
func strNewx(_x string, _c *Cptx) *Cptx{
  return &Cptx{
    _type: TSTR,  
    _obj: _c,  
    _str: _x,  
    _ctype: TCPT,  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id: 0,  
    _int: 0,  
    _name: "",  
  }
}
func intNewx(_x int, _c *Cptx) *Cptx{
  return &Cptx{
    _type: TINT,  
    _obj: _c,  
    _int: _x,  
    _ctype: TCPT,  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id: 0,  
    _name: "",  
    _str: "",  
  }
}
func arrNewx(_val *[]*Cptx, _class *Cptx) *Cptx{
  var _x *Cptx
  _x = &Cptx{
    _type: TARR,  
    _id: uidx(),  
    _obj: _class,  
    _arr: arrOrx(_val),  
    _ctype: TCPT,  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  return _x
}
func dicNewx(_dic map[string]*Cptx, _arr *[]*Cptx, _class *Cptx) *Cptx{
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
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  if(_arr == nil){
    if(_dic != nil){
      for _k, _ = range _dic {
        (*_r._arr) = append((*_r._arr), strNewx(_k, nil))
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
  _x._fscope = true
  _x._name = "Scope_" + _ns._str + "_" + _name
  _x._str = _ns._str + "/" + _name
  if(_ns._dic[_name] == nil){
    (*_ns._arr) = append((*_ns._arr), strNewx(_name, nil))
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
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
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
func tobjNewx(_class *Cptx) *Cptx{
  var _x *Cptx
  _x = &Cptx{
    _type: TTOBJ,  
    _id: uidx(),  
    _obj: _class,  
    _ctype: TCPT,  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  return _x
}
func scopeObjNewx(_class *Cptx) *Cptx{
  if(_class._obj != nil){
    return _class._obj
  }
  return objNewx(_class, nil)
}
func floatNewx(_x float64, _c *Cptx) *Cptx{
  return &Cptx{
    _type: TFLOAT,  
    _obj: _c,  
    _val: _x,  
    _ctype: TCPT,  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id: 0,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
}
func nativeNewx(_f func(*[]*Cptx, *Cptx) *Cptx) *Cptx{
  return &Cptx{
    _type: TNATIVE,  
    _id: uidx(),  
    _val: _f,  
    _ctype: TCPT,  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
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
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
}
func idNewx(_def *Cptx, _key string, _obj *Cptx) *Cptx{
  var _x *Cptx
  _x = &Cptx{
    _type: TID,  
    _id: uidx(),  
    _obj: _obj,  
    _class: _def,  
    _str: _key,  
    _ctype: TCPT,  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _int: 0,  
    _name: "",  
  }
  if(_obj != nil && !inClassx(_obj, _idclassc, nil)){
    _x._fmid = true
  }
  return _x
}
func funcNewx(_val func(*[]*Cptx, *Cptx) *Cptx, _argtypes *[]*Cptx, _return *Cptx) *Cptx{
  var _arr *[]*Cptx
  var _fp *Cptx
  var _v *Cptx
  var _x *Cptx
  if(_return == nil){
    _return = _emptyc
  }
  _arr = &[]*Cptx{}
  _tmp62881 := _argtypes;
  for _tmp62888 := uint(0); _tmp62888 < uint(len((*_tmp62881))); _tmp62888 ++ {
    _v = (*_tmp62881)[_tmp62888]
    (*_arr) = append((*_arr), defx(_v, nil))
  }
  _fp = fpDefx(_arr, _return)
  if(_val != nil){
    _x = classNewx(&[]*Cptx{_fp, _funcnativec}, nil)
    _x._dic["funcNative"] = nativeNewx(_val)
  }else{
    _x = classNewx(&[]*Cptx{_fp}, nil)
  }
  return objNewx(_x, nil)
}
func boolNewx(_x bool) *Cptx{
  if(_x){
    return _truev
  }
  return _falsev
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
func bnumDefx(_name string, _class *Cptx) *Cptx{
  var _x *Cptx
  _x = curryDefx(_defmain, _name, _class, nil)
  _x._fbnum = true
  return _x
}
func itemsChangeBasicx(_v *Cptx, _nb *Cptx) *Cptx{
  var _ob *Cptx
  if(_v._fmid){
    fmt.Println("cannot change basic for mid");debug.PrintStack();os.Exit(1)
  }
  if(_v._type != _nb._ctype){
    fmt.Println("cannot change between ARR DIC JSON");debug.PrintStack();os.Exit(1)
  }
  _ob = itemsGetBasicx(classx(_v))
  _v._obj = itemsDefx(_ob, classx(getx(_v, "itemsType")), false)
  return _v
}
func itemsGetBasicx(_c *Cptx) *Cptx{
  var _r *Cptx
  var _v *Cptx
  if(_c._fbitems){
    return _c
  }
  _tmp65751 := _c._arr;
  for _tmp65758 := uint(0); _tmp65758 < uint(len((*_tmp65751))); _tmp65758 ++ {
    _v = (*_tmp65751)[_tmp65758]
    _r = itemsGetBasicx(_v)
    if(_r != nil){
      return _r
    }
  }
  return nil
}
func itemsDefx(_class *Cptx, _type *Cptx, _mid bool) *Cptx{
  var _n string
  var _r *Cptx
  if(!_class._fbitems){
    fmt.Println("item def first arg error");debug.PrintStack();os.Exit(1)
  }
  if(_type != nil && _type._id != _cptc._id){
    _type = aliasGetx(_type)
    _n = _class._name + "_" + _type._name
    if(_n == "Arr_Byte"){
      _n = "Bytes"
    }
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
    return classNewx(&[]*Cptx{_r, _midc}, nil)
  }
  return _r
}
func fpDefx(_types *[]*Cptx, _return *Cptx) *Cptx{
  var _n string
  var _v *Cptx
  var _x *Cptx
  _n = "FuncProto"
  _tmp67288 := _types;
  for _tmp67295 := uint(0); _tmp67295 < uint(len((*_tmp67288))); _tmp67295 ++ {
    _v = (*_tmp67288)[_tmp67295]
    _n += "_" + aliasGetx(classx(_v))._name
  }
  _n += "__" + _return._name
  _x = classGetx(_defmain, _n)
  if(_x == nil){
    _x = curryDefx(_defmain, _n, _funcprotoc, map[string]*Cptx{
      "funcVarTypes": arrNewx(_types, nil),
      "funcReturn": _return,
    })
  }
  return _x
}
func aliasDefx(_scope *Cptx, _key string, _class *Cptx) *Cptx{
  var _x *Cptx
  _x = classDefx(_scope, _key, &[]*Cptx{_aliasc, _class}, nil)
  return _x
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
  _class._class._dic[_fn._name] = _fn
  _fn._str = _name
  return _fn
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
func execDefx(_name string, _f func(*[]*Cptx, *Cptx) *Cptx) *Cptx{
  var _fn *Cptx
  _fn = funcNewx(_f, &[]*Cptx{_cptc}, _cptc)
  routex(_fn, _execmain, _name)
  return _fn
}
func _Path_exists(s string) bool{
 _, err := os.Stat(s);
 return !os.IsNotExist(err)
}
func _Filex_readAll(s string)string{
 r, err := ioutil.ReadFile(s)
 if(err != nil){
  debug.PrintStack();log.Fatal(err);os.Exit(1)

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
    _fc = _Filex_readAll(_f)
    _arr = _Str_split(_fc, " ")
    _tmp71088 := _arr;
    for _tmp71095 := uint(0); _tmp71095 < uint(len((*_tmp71088))); _tmp71095 ++ {
      _v = (*_tmp71088)[_tmp71095]
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
  fmt.Println(string(out))
  debug.PrintStack();log.Fatal(err);os.Exit(1)

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
    _str = _Filex_readAll(_f)
    if(_Path_timeMod(_f) > _Path_timeMod(_fcache)){
      _jstr = _osCmd("./sl-reader", _key + " := " + _str)
      _Filex_write(_fcache, _jstr)
    }else{
      _jstr = _Filex_readAll(_fcache)
    }
  }else if(_Path_exists(_f2)){
    _str = "@`" + _Filex_readAll(_f2) + "` '" + _fstr + "t'"
    if(_Path_timeMod(_f2) > _Path_timeMod(_f2cache)){
      _jstr = _osCmd("./sl-reader", _key + " := " + _str)
      _Filex_write(_f2cache, _jstr)
    }else{
      _jstr = _Filex_readAll(_f2cache)
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
  if(_scope._fscope){
    _r = dbGetx(_scope, _key)
    if(_r != nil){
      _scope._dic[_key] = _r
      return _r
    }
  }
  _tmp74029 := _scope._arr;
  for _tmp74036 := uint(0); _tmp74036 < uint(len((*_tmp74029))); _tmp74036 ++ {
    _v = (*_tmp74029)[_tmp74036]
    _k = strconv.FormatUint(uint64(_v._id), 10)
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
      _scope._dic[_key] = _emptyv
    }
    return nil
  }else if(_r._id == _emptyv._id){
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
  _tmp75951 := _v._arr;
  for _tmp75958 := uint(0); _tmp75958 < uint(len((*_tmp75951))); _tmp75958 ++ {
    _vv = (*_tmp75951)[_tmp75958]
    _r = subMethodGetx(_scope, _vv, _key)
    if(_r != nil){
      return _r
    }
  }
  return _r
}
func methodGetx(_scope *Cptx, _o *Cptx, _key string) *Cptx{
  var _p *[]*Cptx
  var _r *Cptx
  var _v *Cptx
  _r = classGetx(_scope, _o._name + "_" + _key)
  if(_r != nil){
    return _r
  }
  _p = _o._arr
  _tmp76655 := _p;
  for _tmp76662 := uint(0); _tmp76662 < uint(len((*_tmp76655))); _tmp76662 ++ {
    _v = (*_tmp76655)[_tmp76662]
    _r = subMethodGetx(_scope, _v, _key)
    if(_r != nil){
      return _r
    }
  }
  _r = subMethodGetx(_scope, _classc, _key)
  if(_r != nil){
    return _r
  }
  _r = subMethodGetx(_scope, _cptc, _key)
  if(_r != nil){
    return _r
  }
  return nil
}
func classRawx(_t uint8) *Cptx{
  if(_t == TCPT){
    return _cptc
  }else if(_t == TOBJ){
    return _objc
  }else if(_t == TCLASS){
    return _classc
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
  }else if(_t == TNATIVE){
    return _nativec
  }else if(_t == TCALL){
    return _callc
  }else if(_t == TID){
    return _idc
  }else{
    fmt.Println("NOTYPE");debug.PrintStack();os.Exit(1)
  }
  return nil
}
func inClassx(_c *Cptx, _t *Cptx, _cache map[string]interface{}) bool{
  var _k string
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
  if(_c._id != 0 && _c._id == _t._id){
    return true
  }
  _key = strconv.FormatUint(uint64(_c._id), 10) + "_" + strconv.FormatUint(uint64(_t._id), 10)
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
  _tmp79599 := _c._arr;
  for _tmp79606 := uint(0); _tmp79606 < uint(len((*_tmp79599))); _tmp79606 ++ {
    _v = (*_tmp79599)[_tmp79606]
    _k = strconv.FormatUint(uint64(_v._id), 10)
    if(_cache[_k] != nil){
      continue
    }
    _cache[_k] = 1
    if(inClassx(_v, _t, _cache)){
      _inClassCache[_key] = 1
      return true
    }
  }
  _inClassCache[_key] = 2
  return false
}
func parentClassGetx(_o *Cptx, _key string) *Cptx{
  var _d map[string]*Cptx
  var _r *Cptx
  var _v *Cptx
  if(_o._arr == nil){
    return nil
  }
  _tmp80397 := _o._arr;
  for _tmp80404 := uint(0); _tmp80404 < uint(len((*_tmp80397))); _tmp80404 ++ {
    _v = (*_tmp80397)[_tmp80404]
    _d = _v._dic
    _r = _d[_key]
    if(_r != nil){
      return _v
    }
    _r = parentClassGetx(_v, _key)
    if(_r != nil){
      return _r
    }
  }
  return nil
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
func defaultx(_t *Cptx) *Cptx{
  var _tar *Cptx
  if(_t._ctype == TINT){
    _tar = intNewx(0, nil)
  }else if(_t._ctype == TFLOAT){
    _tar = floatNewx(0, nil)
  }else if(_t._ctype == TNUMBIG){
  }else if(_t._ctype == TSTR){
    _tar = strNewx("", nil)
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
    if(_class._obj != nil && _class._obj._fstatic){
      return _class._obj
    }
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
        if(_pt._id == _unknownc._id || _pt._id == _cptc._id){
          continue
        }
        if(!inClassx(_pt, classx(_t), nil)){
          fmt.Println(_class._name)
          fmt.Println(_k)
          fmt.Println(strx(_v, 0))
          fmt.Println(strx(_pt, 0))
          fmt.Println(strx(classx(_t), 0))
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
  }else if(_class._ctype == TINT){
    _x = intNewx(0, nil)
  }else if(_class._ctype == TFLOAT){
    _x = floatNewx(0, nil)
  }else if(_class._ctype == TNUMBIG){
    _x = _nullv
    fmt.Println("no numbig");debug.PrintStack();os.Exit(1)
  }else if(_class._ctype == TSTR){
    _x = strNewx("", nil)
  }else if(_class._ctype == TNATIVE){
    _x = nativeNewx(nil)
  }else if(_class._ctype == TCALL){
    _x = callNewx(nil, nil, nil)
    _x._obj = _class
    _x._fdefault = true
  }else if(_class._ctype == TID){
    _x = idNewx(nil, "", nil)
    _x._fdefault = true
  }else if(_class._ctype == TDIC){
    _x = dicNewx(nil, nil, nil)
    _x._fdefault = true
  }else if(_class._ctype == TARR){
    _x = arrNewx(nil, nil)
    _x._fdefault = true
  }else{
    fmt.Println("unknown class type");debug.PrintStack();os.Exit(1)
    return nil
  }
  _x._obj = _class
  return _x
}
func copyx(_o *Cptx) *Cptx{
  var _x *Cptx
  if(_o._fstatic){
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
    _fast: _o._fast,  
    _farg: _o._farg,  
    _fbitems: _o._fbitems,  
    _fbnum: _o._fbnum,  
    _fscope: _o._fscope,  
    _fraw: _o._fraw,  
    _name: _o._name,  
    _id: uidx(),  
    _class: _o._class,  
    _obj: _o._obj,  
    _pred: _o._pred,  
    _dic: dicCopyx(_o._dic),  
    _arr: arrCopyx(_o._arr),  
    _str: _o._str,  
    _int: _o._int,  
    _val: _o._val,  
    _fstatic: false,  
  }
  return _x
}
func eqx(_l *Cptx, _r *Cptx) bool{
  var _t uint8
  if(_l._type != _r._type){
    return false
  }
  _t = _l._type
  if(_t == TCPT){
    return true
  }else if(_t == TOBJ){
    return _l._id == _r._id
  }else if(_t == TCLASS){
    return _l._id == _r._id
  }else if(_t == TDIC){
    return _l._id == _r._id
  }else if(_t == TARR){
    return _l._id == _r._id
  }else if(_t == TNATIVE){
    return _l._id == _r._id
  }else if(_t == TCALL){
    return _l._id == _r._id
  }else if(_t == TID){
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
  return copyCptFromAstx(_val)
}
func typepredx(_o *Cptx) *Cptx{
  var _x *Cptx
  if(_o._pred != nil){
    return _o._pred
  }
  _x = subTypepredx(_o)
  if(_x == nil){
    _x = _unknownc
  }
  _o._pred = _x
  return _x
}
func _Str_isInt(v string)bool{
 _, err := strconv.Atoi(v);
 return err == nil
}
func subTypepredx(_o *Cptx) *Cptx{
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
  var _t uint8
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
      if(_at0._id == _unknownc._id || _at0._id == _cptv._id){
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
    if(inClassx(_f._obj, _opassignc, nil)){
      _arg1 = (*_args)[1]
      return typepredx(_arg1)
    }
    if(inClassx(_f._obj, _opcmpc, nil)){
      return _boolc
    }
    if(inClassx(_f._obj, _op2c, nil)){
      _arg0 = (*_args)[0]
      return typepredx(_arg0)
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
      if(_ret._id == _emptyc._id){
        return _cptc
      }
      return _ret
    }
    if(inClassx(_f._obj, _midc, nil)){
      return nil
    }
    return nil
  }else if(_t == TID){
    if(inClassx(_o._obj, _idstatec, nil)){
      _id = _o._str
      if(_Str_isInt(_id)){
        return _cptc
      }
      _s = _o._class
      _r = _s._dic[_id]
      if(_r == nil){
        fmt.Println(strx(_s, 0))
        fmt.Println(_id)
        fmt.Println("not defined in idstate, may use #1 #2 like");debug.PrintStack();os.Exit(1)
        return _r
      }
      return typepredx(_r)
    }
    if(inClassx(_o._obj, _idclassc, nil)){
      _s = _o._class
      return classx(_s)
    }
    fmt.Println("wrong id: " + _o._str);debug.PrintStack();os.Exit(1)
    return nil
  }else if(_t == TOBJ){
    return _o._obj
  }else if(_t == TCLASS){
    return _classc
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
  _s = ""
  if(len((*_a)) > 1){
    _s += "\n"
    _tmp96218 := _a;
    for _tmp96225 := uint(0); _tmp96225 < uint(len((*_tmp96218))); _tmp96225 ++ {
      _v = (*_tmp96218)[_tmp96225]
      _s += indx(strx(_v, _i + 1), 0) + "\n"
    }
  }else{
    _tmp96454 := _a;
    for _tmp96461 := uint(0); _tmp96461 < uint(len((*_tmp96454))); _tmp96461 ++ {
      _v = (*_tmp96454)[_tmp96461]
      _s += strx(_v, _i + 1)
    }
  }
  return _s
}
func parent2strx(_d *[]*Cptx) string{
  var _s string
  var _v *Cptx
  _s = ""
  _tmp96832 := _d;
  for _tmp96839 := uint(0); _tmp96839 < uint(len((*_tmp96832))); _tmp96839 ++ {
    _v = (*_tmp96832)[_tmp96839]
    if(_v._name != ""){
      _s += _v._name + " "
    }else{
      _s += "~" + strconv.FormatUint(uint64(_v._id), 10) + " "
    }
  }
  return _s
}
func strx(_o *Cptx, _i int) string{
  var _s string
  var _t uint8
  if(_i > 3 && _o._id > 0){
    return "~" + strconv.FormatUint(uint64(_o._id), 10)
  }
  _t = _o._type
  if(_t == TCPT){
    return "&Cpt"
  }else if(_t == TOBJ){
    _s = ""
    if(_o._name != ""){
      _s += _o._name + " = "
    }else{
      _s += "~" + strconv.FormatUint(uint64(_o._id), 10) + " = "
    }
    if(_o._obj._name != ""){
      _s += "&" + _o._obj._name
    }else{
      _s += "&~" + strconv.FormatUint(uint64(_o._obj._id), 10)
    }
    _s += dic2strx(_o._dic, _i)
    return _s
  }else if(_t == TCLASS){
    _s = ""
    if(_o._name != ""){
      _s += _o._name + " = "
    }else{
      _s += "~" + strconv.FormatUint(uint64(_o._id), 10) + " = "
    }
    _s += "@class " + parent2strx(_o._arr) + " " + dic2strx(_o._dic, _i)
    return _s
  }else if(_t == TINT){
    return strconv.Itoa(_o._int)
  }else if(_t == TFLOAT){
    return strconv.FormatFloat(float64(_o._val.(float64)), 'f', -1, 64)
  }else if(_t == TSTR){
    return "\"" + escapex(_o._str) + "\""
  }else if(_t == TNATIVE){
    return "&Native"
  }else if(_t == TCALL){
    return strx(_o._class, 0) + "(" + arr2strx(_o._arr, _i) + ")"
  }else if(_t == TID){
    return "&ID " + _o._str
  }else if(_t == TDIC){
    return dic2strx(_o._dic, _i)
  }else if(_t == TARR){
    return "[" + arr2strx(_o._arr, _i) + "]"
  }else{
    fmt.Println(_o._obj)
    fmt.Println(_o)
    fmt.Println("cpt2str unknown");debug.PrintStack();os.Exit(1)
    return ""
  }
}
func tplCallx(_func *Cptx, _args *[]*Cptx, _env *Cptx) *Cptx{
  var _b *Cptx
  var _i uint
  var _localx *Cptx
  var _nstate *Cptx
  var _ostate *Cptx
  var _stack *[]*Cptx
  var _v *Cptx
  _b = _func._dic["funcTplBlock"]
  if(_b == nil){
    return strNewx("", nil)
  }
  _localx = _b._dic["blockStateDef"]
  _nstate = objNewx(_localx, nil)
  _nstate._fdefault = false
  _nstate._int = 2
  _tmp100573 := _args;
  for _i = uint(0); _i < uint(len((*_tmp100573))); _i ++ {
    _v = (*_tmp100573)[_i]
    _nstate._dic[strconv.FormatUint(uint64(_i), 10)] = _v
  }
  _stack = _env._dic["envStack"]._arr
  _ostate = _env._dic["envLocal"]
  if(_func._dic["funcTplPath"] != nil){
    _ostate._str = _func._dic["funcTplPath"]._str
  }else{
    _ostate._str = "Tpl: " + _func._name
  }
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
    _nstate._fdefault = false
    _nstate._int = 2
    _stack = _env._dic["envStack"]._arr
    _ostate = _env._dic["envLocal"]
    _ostate._str = "Block:" + _func._name
    (*_stack) = append((*_stack), _ostate)
    _env._dic["envLocal"] = _nstate
    _vars = _func._dic["funcVars"]._arr
    _tmp103257 := _args;
    for _i = uint(0); _i < uint(len((*_tmp103257))); _i ++ {
      _arg = (*_tmp103257)[_i]
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
  var _k string
  var _key string
  var _r *Cptx
  var _v *Cptx
  if(_c._id == 0){
    fmt.Println(strx(_c, 0))
    fmt.Println("no id");debug.PrintStack();os.Exit(1)
  }
  _key = strconv.FormatUint(uint64(_c._id), 10)
  _r = _execsp._dic[_key]
  if(_r != nil){
    return _r
  }
  if(_c._name != ""){
    _exect = classGetx(_execsp, _c._name)
    if(_exect != nil){
      _execsp._dic[_key] = _exect
      return _exect
    }
  }
  if(_c._arr != nil){
    _tmp105616 := _c._arr;
    for _tmp105623 := uint(0); _tmp105623 < uint(len((*_tmp105616))); _tmp105623 ++ {
      _v = (*_tmp105616)[_tmp105623]
      _k = strconv.FormatUint(uint64(_v._id), 10)
      if(_cache[_k] != nil){
        return nil
      }
      _cache[_k] = 1
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
  return subBlockExecx(_o._dic["blockVal"]._arr, _env, _stt)
}
func subBlockExecx(_arr *[]*Cptx, _env *Cptx, _stt uint) *Cptx{
  var _i uint
  var _r *Cptx
  var _v *Cptx
  _tmp107443 := _arr;
  for _i = uint(0); _i < uint(len((*_tmp107443))); _i ++ {
    _v = (*_tmp107443)[_i]
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
  if(_o._type == TID && inClassx(classx(_o), _idclassc, nil)){
    return _o._class
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
func tobj2objx(_to *Cptx) *Cptx{
  return objNewx(_to._obj, nil)
}
func convertx(_val *Cptx, _to *Cptx) *Cptx{
  var _from *Cptx
  var _r *Cptx
  if(_val == nil){
    fmt.Println("convertx val null");debug.PrintStack();os.Exit(1)
  }
  if(_val._id == _nullv._id){
    return _val
  }
  if(_to == nil || _to._id == _cptc._id){
    return _val
  }
  _from = typepredx(_val)
  if(_from._id == _unknownc._id){
    return _val
  }
  _from = aliasGetx(_from)
  _to = aliasGetx(_to)
  if(_from._id == _to._id){
    return _val
  }
  if(_from._id == _cptc._id){
    return callNewx(_defmain._dic["as"], &[]*Cptx{_val, _to}, nil)
  }
  if(_from._fbnum && _to._fbnum){
    if(_val._fmid){
      return callNewx(_defmain._dic["numConvert"], &[]*Cptx{_val, _to}, nil)
    }
    _val._obj = _to
    _val._pred = _to
    _to._obj = _val
    return _val
  }
  if(inClassx(_from, _to, nil)){
    return _val
  }
  if(_to._ctype == _from._ctype){
    if(!_val._fmid){
      if(inClassx(_to, _from, nil)){
        _val._obj = _to
        _val._pred = _to
        _to._obj = _val
        return _val
      }else if(_val._type == TARR || _val._type == TDIC){
        if(_to._fbitems){
          return itemsChangeBasicx(_val, _to)
        }
      }
    }
  }
  if(_to._name == ""){
    fmt.Println("class with no name");debug.PrintStack();os.Exit(1)
  }
  _r = getx(_from, "to" + _to._name)
  if(_r == nil){
    fmt.Println(strx(_val, 0))
    fmt.Println(strx(_from, 0))
    fmt.Println(strx(_to, 0))
    fmt.Println("to" + _to._name)
    fmt.Println("convert func not defined");debug.PrintStack();os.Exit(1)
  }
  return callNewx(_r, &[]*Cptx{_val}, nil)
}
func sendx(_scope *Cptx, _arr *[]*Cptx) *[]*Cptx{
  var _arrx *[]*Cptx
  var _assignf *Cptx
  var _f *Cptx
  var _fread *Cptx
  var _from *Cptx
  var _fromt *Cptx
  var _fwrite *Cptx
  var _i int
  var _l int
  var _msgt *Cptx
  var _ncall *Cptx
  var _to *Cptx
  var _tomsgt *Cptx
  var _tot *Cptx
  _arrx = &[]*Cptx{}
  _l = len((*_arr))
  for _i = 0; _i < _l - 1; _i = _i + 1 {
    _from = (*_arr)[_i]
    _to = (*_arr)[_i + 1]
    _fromt = typepredx(_from)
    _tot = typepredx(_to)
    if(_fromt._id == _unknownc._id){
      fmt.Println(_arr)
      fmt.Println(_i)
      fmt.Println("send from type not defined");debug.PrintStack();os.Exit(1)
    }
    if(_tot._id == _unknownc._id){
      fmt.Println(_arr)
      fmt.Println(_i)
      fmt.Println("send to type not defined");debug.PrintStack();os.Exit(1)
    }
    if(_fromt._name == ""){
      fmt.Println(strx(_from, 0))
      fmt.Println(strx(_fromt, 0))
      fmt.Println("send from type no name");debug.PrintStack();os.Exit(1)
    }
    if(_tot._name == ""){
      fmt.Println(strx(_to, 0))
      fmt.Println(strx(_tot, 0))
      fmt.Println("send to type no name");debug.PrintStack();os.Exit(1)
    }
    if(!inClassx(_fromt, _handlerc, nil)){
      _tomsgt = classx(classGetx(_tot, "handlerMsgInType"))
      if(!inClassx(_fromt, _tomsgt, nil)){
        fmt.Println(strx(_fromt, 0))
        fmt.Println(strx(_tomsgt, 0))
        fmt.Println("cannot send to toVal");debug.PrintStack();os.Exit(1)
      }
      _fwrite = methodGetx(_scope, _tot, "write")
      (*_arrx) = append((*_arrx), callNewx(_fwrite, &[]*Cptx{_to, _from}, nil))
      continue
    }
    if(!inClassx(_tot, _handlerc, nil)){
      if(_to._type != TID){
        fmt.Println(strx(_to, 0))
        fmt.Println(strx(_tot, 0))
        fmt.Println("cannot assign to from handler");debug.PrintStack();os.Exit(1)
      }
      _msgt = classx(classGetx(_fromt, "handlerMsgOutType"))
      if(_tot._id == _nullc._id){
        _tot = _msgt
        _to._class._dic[_to._str] = _msgt
      }else{
        if(!inClassx(_msgt, _tot, nil)){
          fmt.Println(strx(_msgt, 0))
          fmt.Println(strx(_tot, 0))
          fmt.Println("cannot send to fromVal");debug.PrintStack();os.Exit(1)
        }
      }
      _fread = methodGetx(_scope, _fromt, "read")
      _assignf = getx(_to, "assign")
      _ncall = callNewx(_assignf, &[]*Cptx{_to, callNewx(_fread, &[]*Cptx{_from}, nil)}, _callrawc)
      (*_arrx) = append((*_arrx), _ncall)
      continue
    }
    if(_msgt == nil){
      _msgt = classx(classGetx(_fromt, "handlerMsgOutType"))
    }
    if(_tomsgt == nil){
      _tomsgt = classx(classGetx(_fromt, "handlerMsgInType"))
    }
    if(!inClassx(_msgt, _tomsgt, nil)){
      fmt.Println(strx(_msgt, 0))
      fmt.Println(strx(_tomsgt, 0))
      fmt.Println("cannot send to");debug.PrintStack();os.Exit(1)
    }
    _f = methodGetx(_scope, _fromt, "pipe" + _tot._name)
    if(_f != nil){
      (*_arrx) = append((*_arrx), callNewx(_f, &[]*Cptx{_from, _to}, nil))
      continue
    }
    fmt.Println(_arr)
    fmt.Println(_i)
    fmt.Println("cannot send, not function matched");debug.PrintStack();os.Exit(1)
  }
  return _arrx
}
func diex(_str string, _env *Cptx) {
  var _v *Cptx
  _tmp117168 := _env._dic["envStack"]._arr;
  for _tmp117175 := uint(0); _tmp117175 < uint(len((*_tmp117168))); _tmp117175 ++ {
    _v = (*_tmp117168)[_tmp117175]
    fmt.Println(_v._str)
  }
  fmt.Println(_str);debug.PrintStack();os.Exit(1)
}
func id2cptx(_id string, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _p *Cptx
  var _r *Cptx
  _r = getx(_local, _id)
  if(_r != nil){
    _r = _local._dic[_id]
    if(_r != nil){
      return idNewx(_local, _id, _idlocalc)
    }else{
      if(_func != nil){
        funcSetClosurex(_func)
      }
      _p = parentClassGetx(_local, _id)
      if(_p == nil){
        fmt.Println(strx(_local, 0))
        fmt.Println(_id)
        fmt.Println("no parent");debug.PrintStack();os.Exit(1)
      }
      return idNewx(_p, _id, _idparentc)
    }
  }
  _r = classGetx(_def, _id)
  if(_r != nil){
    if(_r._name == ""){
      return idNewx(_def, _id, _idglobalc)
    }else{
      return idNewx(_r, _id, _idclassc)
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
    "envStack": arrNewx(nil, nil),
    "envExec": _execsp,
    "envBlock": _b,
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
    (*_funcVars) = append((*_funcVars), strNewx("$self", nil))
    _x = defx(_class, nil)
    if(!_x._fstatic){
      _x._farg = true
    }
    (*_funcVarTypes) = append((*_funcVarTypes), _x)
    _nlocal._dic["$self"] = _x
  }
  _args = _v[1].([]interface{})
  _tmp120464 := _args;
  for _tmp120471 := uint(0); _tmp120471 < uint(len(_tmp120464)); _tmp120471 ++ {
    _arg = _tmp120464[_tmp120471]
    _argdef = _arg.([]interface{})
    _varid = _argdef[0].(string)
    (*_funcVars) = append((*_funcVars), strNewx(_varid, nil))
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
    _ret = _emptyc
  }
  _fp = fpDefx(_funcVarTypes, _ret)
  if(_isproto > 0){
    return _fp
  }
  _cx = classNewx(&[]*Cptx{_fp, _funcblockc}, nil)
  _x = objNewx(_cx, nil)
  _x._dic["funcVars"] = arrNewx(_funcVars, _arrstrc)
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
  _x._dic["funcBlock"] = ast2blockx(_v[3].([]interface{}), _def, _x._val.(*Cptx), _x, nil)
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
    _tmp124363 := _parents;
    for _tmp124370 := uint(0); _tmp124370 < uint(len(_tmp124363)); _tmp124370 ++ {
      _e = _tmp124363[_tmp124370]
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
  _b = objNewx(_blockmainc, nil)
  _b._fdefault = false
  if(_name != ""){
    routex(_b, _def, _name)
  }
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
  ast2blockx(_v, _d, _l, nil, _b)
  if(len(_ast) == 4){
    _b._dic["blockPath"] = strNewx(_ast[3].(string), nil)
  }
  return _b
}
func tpl2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _name string) *Cptx{
  var _astb []interface{}
  var _b *Cptx
  var _localx *Cptx
  var _x *Cptx
  if(_name == ""){
    fmt.Println("tpl no name");debug.PrintStack();os.Exit(1)
  }
  _x = defx(_functplc, nil)
  routex(_x, _def, _name)
  _astb = _Str_toJsonArr(_ast[1].(string))
  if(len(_astb) != 0){
    _localx = classNewx(nil, nil)
    _b = blockmain2cptx(_astb, _tplmain, _localx, "")
    _x._dic["funcTplBlock"] = _b
  }
  if(len(_ast) == 3){
    _x._dic["funcTplPath"] = strNewx(_ast[2].(string), nil)
  }
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
    "enum": arrNewx(_a, _arrstrc),
    "enumDic": dicNewx(_d, nil, _dicuintc),
  })
  _arr = _ast[1].([]interface{})
  _tmp129057 := _arr;
  for _i = uint(0); _i < uint(len(_tmp129057)); _i ++ {
    _v = _tmp129057[_i]
    (*_a) = append((*_a), strNewx(_v.(string), nil))
    _ii = intNewx(int(_i), nil)
    _ii._obj = _c
    _c._obj = _ii
    _d[_v.(string)] = _ii
  }
  return _c
}
func send2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _arr *Cptx
  _arr = ast2arrx(_ast[1].([]interface{}), _def, _local, _func, nil, 0)
  return callNewx(_defmain._dic["send"], &[]*Cptx{_arr}, _callrawc)
}
func obj2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _c *Cptx
  var _schema *Cptx
  var _x *Cptx
  _c = classGetx(_def, _ast[1].(string))
  if(_c == nil){
    fmt.Println("obj2cpt: no class " + _ast[1].(string));debug.PrintStack();os.Exit(1)
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
  if(_t0._id == _unknownc._id){
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
    _arg1 = convertx(_arg1, _t0)
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
  if(_itemstc._id == _unknownc._id){
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
    return callNewx(_getf, &[]*Cptx{_items, _key}, _callidc)
  }
  _setf = getx(_itemstc, "set")
  if(_setf == nil){
    fmt.Println("no setf");debug.PrintStack();os.Exit(1)
  }
  _lefto = callNewx(_setf, &[]*Cptx{_items, _key, _v}, nil)
  _predt = typepredx(_v)
  if(inClassx(classx(_items), _idstatec, nil)){
    _s = _items._class
    _str = _items._str
    _itemst = _s._dic[_str]
    _itemstt = aliasGetx(_itemst._obj)
    if(_itemst._farg){
      return _lefto
    }
    _it = getx(_itemst, "itemsType")
    if(_predt._id != _unknownc._id && _predt._id != _cptc._id){
      if(_it._id == _cptv._id){
        _itemst._obj = itemsDefx(_itemstt, _predt, false)
        _itemst._pred = _itemst._obj
        if(_itemst._val != nil){
          _oo = _itemst._val.(*Cptx)
          convertx(_oo, _itemst._obj)
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
    if(_ret._id == _emptyc._id){
      fmt.Println("func " + _func._name + " should not return value");debug.PrintStack();os.Exit(1)
    }
  }else{
    if(_ret._id == _emptyc._id){
      _arg = _emptyv
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
  if(_obj._type == TOBJ || _obj._type == TCALL || _obj._type == TID){
    if(_v == nil){
      return callNewx(_defmain._dic["get"], &[]*Cptx{_obj, strNewx(_ast[2].(string), nil)}, _callidc)
    }else{
      return callNewx(_defmain._dic["set"], &[]*Cptx{_obj, strNewx(_ast[2].(string), nil), _v}, _callidc)
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
    if(_t._id == _unknownc._id){
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
  if(_et._id == _unknownc._id){
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
        _local._dic[_key] = strNewx("", nil)
      }
    }else if(inClassx(_et, _arrc, nil)){
      if(_r != nil){
        if(classx(_r)._id != _uintc._id){
          fmt.Println("each key id defined " + _key);debug.PrintStack();os.Exit(1)
        }
      }else{
        _local._dic[_key] = intNewx(0, _uintc)
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
  _bl = ast2blockx(_v[3].([]interface{}), _def, _local, _func, nil)
  _bl._dic["blockParent"] = _block
  return defx(_ctrleachc, map[string]*Cptx{
    "ctrlArgs": arrNewx(&[]*Cptx{strNewx(_key, nil), strNewx(_val, nil), _expr, _bl}, nil),
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
  _bl = ast2blockx(_v[3].([]interface{}), _def, _local, _func, nil)
  return defx(_ctrlforc, map[string]*Cptx{
    "ctrlArgs": arrNewx(&[]*Cptx{_start, _check, _inc, _bl}, nil),
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
  return aliasDefx(_def, _name, itemsDefx(_x, _it, false))
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
    if(_t._id == _unknownc._id){
      fmt.Println(_id)
      fmt.Println(_v)
      fmt.Println("global var must know type");debug.PrintStack();os.Exit(1)
    }
    _def._dic[_id] = defx(_t, nil)
    _ip = idNewx(_def, _id, _idglobalc)
    _af = classGetx(_idglobalc, "assign")
    return callNewx(_af, &[]*Cptx{_ip, _r}, _callrawc)
  }
  return _r
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
        return callNewx(_ff, &[]*Cptx{_lefto, _righto}, _callpassrefc)
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
        _lefto = idNewx(_def, _name, _idglobalc)
      }
    }
  }
  if(_lefto == nil){
    _lefto = ast2cptx(_left, _def, _local, _func, "")
  }
  if(inClassx(classx(_lefto), _idstatec, nil)){
    _s = _lefto._class
    _idstr = _lefto._str
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
  _righto = convertx(_righto, _lpredt)
  _f = getx(_lefto, "assign")
  return callNewx(_f, &[]*Cptx{_lefto, _righto}, _callrawc)
}
func call2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _arrx *[]*Cptx
  var _astarr []interface{}
  var _e interface{}
  var _ee *Cptx
  var _f *Cptx
  var _i uint
  var _v []interface{}
  var _vt *Cptx
  _v = _ast[1].([]interface{})
  _f = ast2cptx(_v, _def, _local, _func, "")
  _f = preExecx(_f)
  _astarr = _ast[2].([]interface{})
  if(_f._type == TCLASS){
    if(len(_astarr) == 0){
      return callNewx(_defmain._dic["type"], &[]*Cptx{_f}, _callrawc)
    }
    return convertx(ast2cptx(_astarr[0].([]interface{}), _def, _local, _func, ""), _f)
  }
  _vt = getx(_f, "funcVarTypes")
  _arrx = &[]*Cptx{}
  _tmp154988 := _astarr;
  for _i = uint(0); _i < uint(len(_tmp154988)); _i ++ {
    _e = _tmp154988[_i]
    _ee = ast2cptx(_e.([]interface{}), _def, _local, _func, "")
    if(_vt != nil){
      _ee = convertx(_ee, classx((*_vt._arr)[_i]))
    }
    _ee = preExecx(_ee)
    (*_arrx) = append((*_arrx), _ee)
  }
  if(_f._fraw){
    return callNewx(_f, _arrx, _callrawc)
  }
  return callNewx(_f, _arrx, nil)
}
func callmethod2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _arr *Cptx
  var _f *Cptx
  var _oo *Cptx
  var _to *Cptx
  _oo = ast2cptx(_ast[1].([]interface{}), _def, _local, _func, "")
  _to = typepredx(_oo)
  if(_to._id == _unknownc._id){
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
  return callNewx(_f, _arr._arr, nil)
}
func preAst2blockx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) {
  var _e interface{}
  var _ee []interface{}
  var _eee []interface{}
  var _i uint
  var _idpre string
  _tmp157305 := _ast;
  for _i = uint(0); _i < uint(len(_tmp157305)); _i ++ {
    _e = _tmp157305[_i]
    _ee = _e.([]interface{})
    _eee = _ee[0].([]interface{})
    _idpre = _eee[0].(string)
    if(_idpre == "def"){
      def2cptx(_eee, _def, _local, _func, 1)
    }
  }
  _tmp157713 := _ast;
  for _i = uint(0); _i < uint(len(_tmp157713)); _i ++ {
    _e = _tmp157713[_i]
    _ee = _e.([]interface{})
    _eee = _ee[0].([]interface{})
    _idpre = _eee[0].(string)
    if(_idpre == "def"){
      def2cptx(_eee, _def, _local, _func, 2)
    }
  }
}
func ast2blockx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _block *Cptx) *Cptx{
  var _arr *[]*Cptx
  var _c *Cptx
  var _dicl *Cptx
  var _e interface{}
  var _ee []interface{}
  var _i int
  var _idpre string
  var _x *Cptx
  _arr = &[]*Cptx{}
  if(_block != nil){
    _x = _block
  }else{
    _x = objNewx(_blockc, nil)
    _x._fdefault = false
  }
  _dicl = dicNewx(map[string]*Cptx{
  }, nil, _dicuintc)
  _i = 0
  _tmp158745 := _ast;
  for _tmp158752 := uint(0); _tmp158752 < uint(len(_tmp158745)); _tmp158752 ++ {
    _e = _tmp158745[_tmp158752]
    _ee = _e.([]interface{})
    _idpre = _ee[0].([]interface{})[0].(string)
    if(len(_ee) == 2){
      _dicl._dic[_ee[1].(string)] = intNewx(_i, _uintc)
    }
    if(_idpre == "if"){
      _c = if2cptx(_ee[0].([]interface{}), _def, _local, _func, _x)
    }else if(_idpre == "each"){
      _c = each2cptx(_ee[0].([]interface{}), _def, _local, _func, _x)
    }else if(_idpre == "for"){
      _c = for2cptx(_ee[0].([]interface{}), _def, _local, _func, _x)
    }else if(_idpre == "send"){
      _c = send2cptx(_ee[0].([]interface{}), _def, _local, _func)
    }else{
      _c = subAst2cptx(_ee[0].([]interface{}), _def, _local, _func, "")
    }
    if(_c == nil){
      continue
    }
    _c._ast = _ee[0].([]interface{})
    (*_arr) = append((*_arr), _c)
    _i = _i + 1
  }
  _x._dic["blockVal"] = arrNewx(_arr, nil)
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
  _tmp161024 := _asts;
  for _tmp161031 := uint(0); _tmp161031 < uint(len(_tmp161024)); _tmp161031 ++ {
    _e = _tmp161024[_tmp161031]
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
    _tmp161511 := _arrx;
    for _i = uint(0); _i < uint(len((*_tmp161511))); _i ++ {
      _v = (*_tmp161511)[_i]
      (*_arrx)[_i] = preExecx(_v)
    }
  }
  if(_it != nil && _it._id != _unknownc._id || _callable){
    _c = itemsDefx(_arrc, _it, _callable)
    _r = arrNewx(_arrx, _c)
    if(_callable){
      _r._fmid = true
    }
  }else{
    _r = arrNewx(_arrx, nil)
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
  _tmp162743 := _asts;
  for _tmp162750 := uint(0); _tmp162750 < uint(len(_tmp162743)); _tmp162750 ++ {
    _eo = _tmp162743[_tmp162750]
    _e = _eo.([]interface{})
    _k = _e[1].(string)
    _ee = ast2cptx(_e[0].([]interface{}), _def, _local, _func, "")
    if(_ee._fmid){
      _callable = true
    }
    if(_it == nil){
      _it = typepredx(_ee)
    }
    (*_arrx) = append((*_arrx), strNewx(_k, nil))
    _dicx[_k] = _ee
  }
  if(!_callable){
    for _k, _v = range _dicx {
      _dicx[_k] = preExecx(_v)
    }
  }
  if(_it != nil && _it._id != _unknownc._id || _callable){
    _c = itemsDefx(_dicc, _it, _callable)
    _r = dicNewx(_dicx, _arrx, _c)
    if(_callable){
      _r._fmid = true
    }
  }else{
    _r = dicNewx(_dicx, _arrx, nil)
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
  debug.PrintStack();log.Fatal(e);os.Exit(1)

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
    return ast2blockx(_ast[1].([]interface{}), _def, _local, _func, nil)
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
    return idNewx(_local, _id, _idlocalc)
  }else if(_t == "id"){
    _id = _ast[1].(string)
    _x = id2cptx(_id, _def, _local, _func)
    if(_x == nil){
      fmt.Println(strx(_local, 0))
      fmt.Println(strx(_def, 0))
      fmt.Println("id not defined " + _id);debug.PrintStack();os.Exit(1)
    }
    return _x
  }else if(_t == "call"){
    return call2cptx(_ast, _def, _local, _func)
  }else if(_t == "callmethod"){
    return callmethod2cptx(_ast, _def, _local, _func)
  }else if(_t == "assign"){
    return assign2cptx(_ast, _def, _local, _func)
  }else if(_t == "def"){
    return def2cptx(_ast, _def, _local, _func, 0)
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
  }else if(_t == "str"){
    _x = strNewx(_ast[1].(string), nil)
    _x._fast = true
    return _x
  }else if(_t == "byte"){
  }else if(_t == "bytes"){
    _x = strNewx(_ast[1].(string), _bytesc)
    _x._fast = true
    return _x
  }else if(_t == "float"){
    _x = floatNewx(_lf(strconv.ParseFloat(_ast[1].(string), 64)).(float64), nil)
    _x._fast = true
    return _x
  }else if(_t == "int"){
    _x = intNewx(_lf(strconv.Atoi(_ast[1].(string))).(int), nil)
    _x._fast = true
    return _x
  }else if(_t == "dic"){
    if(len(_ast) > 2){
      if(_ast[2] != nil){
        _it = classGetx(_def, _ast[2].(string))
      }
      if(_ast[3] != nil){
        _il = _lf(strconv.Atoi(_ast[3].(string))).(int)
      }
    }
    _x = ast2dicx(_ast[1].([]interface{}), _def, _local, _func, _it, _il)
    _x._fast = true
    return _x
  }else if(_t == "arr"){
    if(len(_ast) > 2){
      if(_ast[2] != nil){
        _it = classGetx(_def, _ast[2].(string))
      }
      if(_ast[3] != nil){
        _il = _lf(strconv.Atoi(_ast[3].(string))).(int)
      }
    }
    _x = ast2arrx(_ast[1].([]interface{}), _def, _local, _func, _it, _il)
    _x._fast = true
    return _x
  }else if(_t == "obj"){
    _x = obj2cptx(_ast, _def, _local, _func)
    _x._fast = true
    return _x
  }else if(_t == "fs"){
    return _fsv
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
func main(){
  var _assignf *Cptx
  var _defsp string
  var _execsp string
  var _fc string
  var _idstateassignf *Cptx
  var _main *Cptx
  var _osargs *[]string
  _version = 100
  _uidi = 1
  __indentx = " "
  _inClassCache = map[string]int{
  }
  _root = map[string]*Cptx{
  }
  _defns = nsNewx("def")
  _defmain = scopeNewx(_defns, "main")
  _execns = nsNewx("exec")
  _execmain = scopeNewx(_execns, "main")
  _tplmain = classNewx(&[]*Cptx{_defmain}, nil)
  _cptc = classNewx(nil, nil)
  routex(_cptc, _defmain, "Cpt")
  _cptc._ctype = TCPT
  _cptc._fdefault = true
  _cptv = &Cptx{
    _type: TCPT,  
    _fdefault: true,  
    _fstatic: true,  
    _id: uidx(),  
    _ctype: TCPT,  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  _emptyc = classDefx(_defmain, "Empty", nil, nil)
  _emptyv = objNewx(_emptyc, nil)
  _emptyv._fstatic = true
  _unknownc = classDefx(_defmain, "Unknown", nil, nil)
  _unknownv = objNewx(_unknownc, nil)
  _unknownv._fstatic = true
  _nullc = classDefx(_defmain, "Null", nil, nil)
  _nullv = objNewx(_nullc, nil)
  _nullv._fstatic = true
  _objc = classNewx(nil, nil)
  routex(_objc, _defmain, "Obj")
  _objc._ctype = TOBJ
  _classc = classNewx(nil, nil)
  routex(_classc, _defmain, "Class")
  _classc._ctype = TCLASS
  _tobjc = classNewx(nil, nil)
  routex(_tobjc, _defmain, "TObj")
  _tobjc._ctype = TTOBJ
  _midc = classDefx(_defmain, "Mid", nil, nil)
  _valc = classDefx(_defmain, "Val", nil, nil)
  _numc = classDefx(_defmain, "Num", &[]*Cptx{_valc}, nil)
  _intc = bnumDefx("Int", _numc)
  _intc._ctype = TINT
  _uintc = bnumDefx("Uint", _intc)
  _floatc = bnumDefx("Float", _numc)
  _floatc._ctype = TFLOAT
  _bytec = curryDefx(_defmain, "Byte", _intc, nil)
  _boolc = bnumDefx("Bool", _uintc)
  bnumDefx("Int16", _intc)
  bnumDefx("Int32", _intc)
  bnumDefx("Int64", _intc)
  bnumDefx("Uint8", _uintc)
  bnumDefx("Uint16", _uintc)
  bnumDefx("Uint32", _uintc)
  bnumDefx("Uint64", _uintc)
  bnumDefx("Float32", _floatc)
  bnumDefx("Float64", _floatc)
  _numbigc = curryDefx(_defmain, "NumBig", _numc, nil)
  _numbigc._ctype = TNUMBIG
  _truev = &Cptx{
    _type: TINT,  
    _obj: _boolc,  
    _int: 1,  
    _id: uidx(),  
    _ctype: TCPT,  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
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
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _name: "",  
    _str: "",  
  }
  _itemsc = classDefx(_defmain, "Items", nil, map[string]*Cptx{
    "itemsType": _cptc,
  })
  _itemslimitedc = classDefx(_defmain, "ItemsLimited", &[]*Cptx{_itemsc}, map[string]*Cptx{
    "itemsLimitedLength": _uintc,
  })
  _arrc = curryDefx(_defmain, "Arr", _itemsc, nil)
  _arrc._ctype = TARR
  _arrc._fbitems = true
  _staticarrc = curryDefx(_defmain, "StaticArr", _arrc, nil)
  _staticarrc._fbitems = true
  _dicc = curryDefx(_defmain, "Dic", _itemsc, nil)
  _dicc._ctype = TDIC
  _dicc._fbitems = true
  _bytesc = itemsDefx(_arrc, _bytec, false)
  _bytesc._ctype = TSTR
  (*_bytesc._arr) = append((*_bytesc._arr), _valc)
  _strc = curryDefx(_defmain, "Str", _bytesc, nil)
  _arrstrc = itemsDefx(_arrc, _strc, false)
  _dicstrc = itemsDefx(_dicc, _strc, false)
  _dicuintc = itemsDefx(_dicc, _uintc, false)
  _dicclassc = itemsDefx(_dicc, _classc, false)
  _arrclassc = itemsDefx(_arrc, _classc, false)
  _enumc = classDefx(_defmain, "Enum", &[]*Cptx{_uintc}, map[string]*Cptx{
    "enum": _arrstrc,
    "enumDic": _dicuintc,
  })
  _timec = classDefx(_defmain, "Time", &[]*Cptx{_uintc}, nil)
  _jsonc = classDefx(_defmain, "Json", &[]*Cptx{_dicc}, nil)
  _jsonarrc = classDefx(_defmain, "JsonArr", &[]*Cptx{_arrc}, nil)
  _jsonarrc._fbitems = true
  _bufferc = classDefx(_defmain, "Buffer", &[]*Cptx{_strc}, nil)
  _pathxc = classDefx(_defmain, "Pathx", nil, map[string]*Cptx{
    "path": _strc,
  })
  _filexc = classDefx(_defmain, "Filex", &[]*Cptx{_pathxc}, nil)
  _dirxc = classDefx(_defmain, "Dirx", &[]*Cptx{_pathxc}, nil)
  _funcc = classDefx(_defmain, "Func", nil, nil)
  _funcprotoc = classDefx(_defmain, "FuncProto", &[]*Cptx{_funcc}, map[string]*Cptx{
    "funcVarTypes": _arrc,
    "funcReturn": _classc,
  })
  _nativec = classDefx(_defmain, "Native", nil, nil)
  _nativec._ctype = TNATIVE
  _funcnativec = classDefx(_defmain, "FuncNative", &[]*Cptx{_funcprotoc}, map[string]*Cptx{
    "funcNative": _nativec,
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
    "funcTplBlock": _blockc,
    "funcTplPath": _strc,
  })
  _handlerc = classDefx(_defmain, "Handler", nil, map[string]*Cptx{
    "handlerMsgOutType": _classc,
    "handlerMsgInType": _classc,
  })
  _routerc = classDefx(_defmain, "Router", &[]*Cptx{_itemsc, _handlerc}, map[string]*Cptx{
    "itemsType": _handlerc,
  })
  _routersubc = classDefx(_defmain, "RouterSub", &[]*Cptx{_routerc}, map[string]*Cptx{
    "routerParent": _routerc,
    "routerPathPrefix": _strc,
  })
  _routerc._fbitems = true
  _routerc._dic["routerRoot"] = defx(_routerc, nil)
  _handlerstandalonec = classDefx(_defmain, "HandlerStandalone", &[]*Cptx{_handlerc}, nil)
  _handlerembeddedc = classDefx(_defmain, "HandlerEmbedded", &[]*Cptx{_handlerc}, map[string]*Cptx{
    "handlerRouter": _routerc,
    "handlerPath": _strc,
  })
  _msgc = classDefx(_defmain, "Msg", nil, map[string]*Cptx{
    "msgSrc": _handlerc,
    "msgContent": _cptc,
    "msgModTime": _timec,
    "msgSendTime": _timec,
  })
  _nodec = classDefx(_defmain, "Node", &[]*Cptx{_routerc}, nil)
  _inetc = classDefx(_defmain, "Inet", &[]*Cptx{_routerc}, map[string]*Cptx{
    "itemsType": _nodec,
  })
  _inetv = defx(_inetc, nil)
  _serverc = classDefx(_defmain, "Server", &[]*Cptx{_nodec}, map[string]*Cptx{
    "serverPort": _intc,
  })
  _serverhttpc = curryDefx(_defmain, "ServerHttp", _serverc, map[string]*Cptx{
    "serverPort": intNewx(80, nil),
  })
  _serverhttpsc = curryDefx(_defmain, "ServerHttps", _serverhttpc, map[string]*Cptx{
    "serverPort": intNewx(443, nil),
  })
  _clientc = classDefx(_defmain, "Client", &[]*Cptx{_nodec}, nil)
  _clienthttpc = curryDefx(_defmain, "ClientHttp", _clientc, nil)
  _clienthttpsc = curryDefx(_defmain, "ClientHttps", _clienthttpc, nil)
  _filec = classDefx(_defmain, "File", &[]*Cptx{_handlerembeddedc}, map[string]*Cptx{
    "handlerMsgInType": _bytesc,
    "handlerMsgOutType": _bytesc,
  })
  _fsc = classDefx(_defmain, "Fs", &[]*Cptx{_nodec}, map[string]*Cptx{
    "itemsType": _filec,
  })
  _fsv = defx(_fsc, nil)
  _dirc = classDefx(_defmain, "Dir", &[]*Cptx{_routersubc}, map[string]*Cptx{
    "routerParent": _fsc,
  })
  _schemac = curryDefx(_defmain, "Schema", _handlerc, nil)
  _dbmsc = classDefx(_defmain, "Dbms", &[]*Cptx{_nodec}, map[string]*Cptx{
    "itemsType": _schemac,
  })
  _callc = classDefx(_defmain, "Call", &[]*Cptx{_midc}, nil)
  _callc._ctype = TCALL
  _arrcallc = itemsDefx(_arrc, _callc, false)
  _callpassrefc = curryDefx(_defmain, "CallPassRef", _callc, nil)
  _callrawc = curryDefx(_defmain, "CallRaw", _callc, nil)
  _idc = classDefx(_defmain, "Id", nil, nil)
  _callidc = classDefx(_defmain, "CallId", &[]*Cptx{_callc, _idc}, nil)
  _idc._ctype = TID
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
  _opcmpc = classDefx(_defmain, "OpCmp", &[]*Cptx{_op2c}, nil)
  _opgetc = curryDefx(_defmain, "OpGet", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(0, nil),
  })
  _opnotc = curryDefx(_defmain, "OpNot", _op1c, map[string]*Cptx{
    "opPrecedence": intNewx(10, nil),
  })
  _opmultiplyc = curryDefx(_defmain, "OpMultiply", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(20, nil),
  })
  _opdividec = curryDefx(_defmain, "OpDivide", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(20, nil),
  })
  _opmodc = curryDefx(_defmain, "OpMod", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(20, nil),
  })
  _opaddc = curryDefx(_defmain, "OpAdd", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(30, nil),
  })
  _opsubtractc = curryDefx(_defmain, "OpSubtract", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(30, nil),
  })
  _opgec = curryDefx(_defmain, "OpGe", _opcmpc, map[string]*Cptx{
    "opPrecedence": intNewx(40, nil),
  })
  _oplec = curryDefx(_defmain, "OpLe", _opcmpc, map[string]*Cptx{
    "opPrecedence": intNewx(40, nil),
  })
  _opgtc = curryDefx(_defmain, "OpGt", _opcmpc, map[string]*Cptx{
    "opPrecedence": intNewx(40, nil),
  })
  _opltc = curryDefx(_defmain, "OpLt", _opcmpc, map[string]*Cptx{
    "opPrecedence": intNewx(40, nil),
  })
  _opeqc = curryDefx(_defmain, "OpEq", _opcmpc, map[string]*Cptx{
    "opPrecedence": intNewx(50, nil),
  })
  _opnec = curryDefx(_defmain, "OpNe", _opcmpc, map[string]*Cptx{
    "opPrecedence": intNewx(50, nil),
  })
  _opandc = curryDefx(_defmain, "OpAnd", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(60, nil),
  })
  _oporc = curryDefx(_defmain, "OpOr", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(70, nil),
  })
  _opassignc = curryDefx(_defmain, "OpAssign", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(80, nil),
  })
  _opconcatc = curryDefx(_defmain, "OpConcat", _op2c, map[string]*Cptx{
    "opPrecedence": intNewx(80, nil),
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
  })
  funcDefx(_defmain, "getEnv", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _env
  }, nil, _envc)
  funcDefx(_defmain, "getExec", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _env._dic["envExec"]
  }, nil, _classc)
  funcDefx(_defmain, "osCmd", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p *Cptx
    _o = (*_x)[0]
    _p = (*_x)[1]
    return strNewx(_osCmd(_o._str, _p._str), nil)
  }, &[]*Cptx{_strc, _strc}, _strc)
  funcDefx(_defmain, "osArgs", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _aa *[]string
    var _i uint
    var _v string
    if(__osArgs == nil){
      _x = &[]*Cptx{}
      _aa = &os.Args
      _tmp174263 := _aa;
      for _i = uint(0); _i < uint(len((*_tmp174263))); _i ++ {
        _v = (*_tmp174263)[_i]
        if(_i == 0){
          continue
        }
        (*_x) = append((*_x), strNewx(_v, nil))
      }
      __osArgs = arrNewx(_x, _arrstrc)
    }
    return __osArgs
  }, nil, _arrstrc)
  funcDefx(_defmain, "osEnvGet", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(os.Getenv(_o._str), nil)
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
  funcDefx(_defmain, "getPropFlag", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return boolNewx(_o._fprop)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "getMidFlag", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return boolNewx(_o._fmid)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "getName", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(_o._name, nil)
  }, &[]*Cptx{_cptc}, _strc)
  funcDefx(_defmain, "getId", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(strconv.FormatUint(uint64(_o._id), 10), nil)
  }, &[]*Cptx{_cptc}, _strc)
  funcDefx(_defmain, "getNote", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(_o._str, nil)
  }, &[]*Cptx{_cptc}, _strc)
  funcDefx(_defmain, "setIndent", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    __indentx = _o._str
    return _nullv
  }, &[]*Cptx{_strc}, nil)
  funcDefx(_defmain, "sendImpl", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _arr *[]*Cptx
    var _o *Cptx
    var _s *Cptx
    _s = (*_x)[0]
    _o = (*_x)[1]
    _arr = sendx(_s, _o._arr)
    return arrNewx(_arr, nil)
  }, &[]*Cptx{_classc, _arrc}, _arrc)
  funcDefx(_defmain, "methodGet", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _f *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _f = (*_x)[1]
    return nullOrx(methodGetx(_o, _f._class, _f._str))
  }, &[]*Cptx{_classc, _funcc}, _cptc)
  funcDefx(_defmain, "send", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _arr *[]*Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _arr = sendx(_defmain, _o._arr)
    subBlockExecx(_arr, _env, 0)
    return _nullv
  }, &[]*Cptx{_arrc}, nil)
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
    _c = (*_x)[1]
    if(_o._type != TINT && _o._type != TFLOAT || _c._ctype != TINT && _c._ctype != TFLOAT){
      fmt.Println(strx(_o, 0))
      fmt.Println(strx(_c, 0))
      fmt.Println("numConvert between float int big");debug.PrintStack();os.Exit(1)
    }
    if(_o._type == _c._ctype){
      _o._obj = _c
      return _o
    }
    if(_o._type == TINT){
      return floatNewx(float64(_o._int), _c)
    }
    if(_o._type == TFLOAT){
      return intNewx(int(_o._val.(float64)), _c)
    }
    return _nullv
  }, &[]*Cptx{_cptc, _classc}, _cptc)
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
    return typepredx(_l)
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
    return strNewx(strconv.FormatUint(uint64(uidx()), 10), nil)
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
    diex(_o._str, _env)
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
    return strNewx(indx(_o._str, _f._int), nil)
  }, &[]*Cptx{_strc, _intc}, _strc)
  funcDefx(_defmain, "exec", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return execx(_l, _env, 1)
  }, &[]*Cptx{_cptc}, _cptc)
  funcDefx(_defmain, "parseSend", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return execx(_l, _env, 1)
  }, &[]*Cptx{_cptc}, _cptc)
  funcDefx(_defmain, "blockExec", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return blockExecx(_l, _env, 0)
  }, &[]*Cptx{_blockc}, _cptc)
  funcDefx(_defmain, "opp", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _f *Cptx
    var _main int
    var _o *Cptx
    var _op *Cptx
    var _ret *Cptx
    var _sub int
    _o = (*_x)[0]
    _op = (*_x)[1]
    _ret = execx(_o, _env, 1)
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
      return strNewx("(" + _ret._str + ")", nil)
    }
    return _ret
  }, &[]*Cptx{_cptc, _opc, _envc}, _strc)
  funcDefx(_defmain, "call", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _a *Cptx
    var _f *Cptx
    _f = (*_x)[0]
    _a = (*_x)[1]
    if(_f == nil || _f._id == _nullv._id){
      fmt.Println(strx(_a, 0))
      fmt.Println("call() error");debug.PrintStack();os.Exit(1)
    }
    if(!inClassx(classx(_f), _funcc, nil)){
      fmt.Println(strx(_f, 0))
      fmt.Println("not func");debug.PrintStack();os.Exit(1)
    }
    return callx(_f, _a._arr, _env)
  }, &[]*Cptx{_funcc, _arrc}, _cptc)
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
    return copyx(arrNewx(_o._arr, _arrstrc))
  }, &[]*Cptx{_dicc}, _arrstrc)
  funcDefx(_defmain, "callFunc", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return _o._class
  }, &[]*Cptx{_callc}, _funcc)
  funcDefx(_defmain, "callArgs", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return arrNewx(_o._arr, nil)
  }, &[]*Cptx{_callc}, _arrc)
  funcDefx(_defmain, "idStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(_o._str, nil)
  }, &[]*Cptx{_callc}, _strc)
  funcDefx(_defmain, "idState", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return _o._class
  }, &[]*Cptx{_callc}, _cptc)
  funcDefx(_defmain, "idVal", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return _o._class
  }, &[]*Cptx{_callc}, _cptc)
  methodDefx(_aliasc, "getClass", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return aliasGetx(_o)
  }, nil, _classc)
  methodDefx(_pathxc, "timeMod", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _intc)
  methodDefx(_pathxc, "timeMod", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _intc)
  methodDefx(_pathxc, "exists", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._dic["path"]._str
    return boolNewx(_Path_exists(_p))
  }, &[]*Cptx{_strc}, _boolc)
  methodDefx(_pathxc, "resolve", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._dic["path"]._str
    return strNewx(_lf(filepath.Abs(_p)).(string), nil)
  }, &[]*Cptx{_strc}, _strc)
  methodDefx(_filexc, "write", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _d *Cptx
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _d = (*_x)[1]
    _p = _o._dic["path"]._str
    _Filex_write(_p, _d._str)
    return _nullv
  }, &[]*Cptx{_strc}, nil)
  methodDefx(_filexc, "readAll", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._dic["path"]._str
    return strNewx(_Filex_readAll(_p), nil)
  }, nil, _strc)
  methodDefx(_dirxc, "write", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _d *Cptx
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _d = (*_x)[1]
    _p = _o._dic["path"]._str
    dirWritex(_p, _d._dic)
    return _nullv
  }, &[]*Cptx{_dicc}, nil)
  methodDefx(_dirxc, "writeFile", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _f *Cptx
    var _o *Cptx
    var _s *Cptx
    _o = (*_x)[0]
    _f = (*_x)[1]
    _s = (*_x)[2]
    _Filex_write(_o._dic["path"]._str + _f._str, _s._str)
    return _nullv
  }, &[]*Cptx{_strc, _strc}, nil)
  methodDefx(_dirxc, "makeAll", func(_x *[]*Cptx, _env *Cptx) *Cptx{
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
    _tmp199790 := _Arr_Str_sort(_keys(_o._dic));
    for _tmp199797 := uint(0); _tmp199797 < uint(len(_tmp199790)); _tmp199797 ++ {
      _k = _tmp199790[_tmp199797]
      (*_arrx) = append((*_arrx), strNewx(_k, nil))
    }
    return dicNewx(_o._dic, _arrx, nil)
  }, nil, _dicc)
  methodDefx(_classc, "schema", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _arrx *[]*Cptx
    var _k string
    var _o *Cptx
    _o = (*_x)[0]
    _arrx = &[]*Cptx{}
    _tmp200394 := _Arr_Str_sort(_keys(_o._dic));
    for _tmp200401 := uint(0); _tmp200401 < uint(len(_tmp200394)); _tmp200401 ++ {
      _k = _tmp200394[_tmp200401]
      (*_arrx) = append((*_arrx), strNewx(_k, nil))
    }
    return dicNewx(_o._dic, _arrx, nil)
  }, nil, _dicc)
  methodDefx(_classc, "parents", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return arrNewx(arrCopyx(_o._arr), _arrclassc)
  }, nil, _arrc)
  methodDefx(_intc, "toStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(strconv.Itoa(_o._int), nil)
  }, &[]*Cptx{_intc}, _strc)
  methodDefx(_floatc, "toStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(strconv.FormatFloat(float64(_o._val.(float64)), 'f', -1, 64), nil)
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
    _tmp202183 := _xx;
    for _tmp202190 := uint(0); _tmp202190 < uint(len((*_tmp202183))); _tmp202190 ++ {
      _v = (*_tmp202183)[_tmp202190]
      (*_y) = append((*_y), strNewx(_v, nil))
    }
    return arrNewx(_y, _arrstrc)
  }, &[]*Cptx{_strc, _strc}, _arrstrc)
  methodDefx(_strc, "replace", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _fr *Cptx
    var _o *Cptx
    var _to *Cptx
    _o = (*_x)[0]
    _fr = (*_x)[1]
    _to = (*_x)[2]
    return strNewx(strings.Replace(_o._str, _fr._str, _to._str, -1), nil)
  }, &[]*Cptx{_strc, _strc}, _strc)
  methodDefx(_strc, "toPathx", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._str
    return objNewx(_filexc, map[string]*Cptx{
      "path": strNewx(_lf(filepath.Abs(_p)).(string), nil),
    })
  }, nil, _filexc)
  methodDefx(_strc, "toFilex", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._str
    return objNewx(_filexc, map[string]*Cptx{
      "path": strNewx(_lf(filepath.Abs(_p)).(string), nil),
    })
  }, nil, _filexc)
  methodDefx(_strc, "toDirx", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._str
    return objNewx(_dirxc, map[string]*Cptx{
      "path": strNewx(_lf(filepath.Abs(_p)).(string) + "/", nil),
    })
  }, nil, _dirxc)
  methodDefx(_strc, "toJsonArr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _jsonarrc)
  methodDefx(_strc, "toJson", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _jsonc)
  methodDefx(_strc, "toInt", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(_lf(strconv.Atoi(_o._str)).(int), nil)
  }, nil, _intc)
  methodDefx(_strc, "toFloat", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return floatNewx(_lf(strconv.ParseFloat(_o._str, 64)).(float64), nil)
  }, nil, _floatc)
  methodDefx(_strc, "escape", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _s string
    _s = (*_x)[0]._str
    return strNewx(escapex(_s), nil)
  }, &[]*Cptx{_strc}, _strc)
  methodDefx(_strc, "isInt", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _s string
    _s = (*_x)[0]._str
    return boolNewx(_Str_isInt(_s))
  }, &[]*Cptx{_strc}, _boolc)
  methodDefx(_fsc, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _s *Cptx
    _o = (*_x)[0]
    _s = (*_x)[1]
    return objNewx(_filec, map[string]*Cptx{
      "handlerRouter": _o,
      "handlerPath": _s,
    })
  }, &[]*Cptx{_strc}, _filec)
  methodDefx(_filec, "write", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _d *Cptx
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _d = (*_x)[1]
    _p = _o._dic["handlerPath"]._str
    _Filex_write(_p, _d._str)
    return _nullv
  }, &[]*Cptx{_bytesc}, nil)
  methodDefx(_filec, "read", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._dic["handlerPath"]._str
    return strNewx(_Filex_readAll(_p), _bytesc)
  }, nil, _bytesc)
  methodDefx(_filec, "rm", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _p string
    _o = (*_x)[0]
    _p = _o._dic["handlerPath"]._str
    os.Remove(_p)
    return _nullv
  }, nil, nil)
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
    return intNewx(len((*_o._arr)), nil)
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
    (*_o._arr)[_i._int] = copyCptFromAstx(_v)
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
    _tmp210891 := _o._arr;
    for _i = uint(0); _i < uint(len((*_tmp210891))); _i ++ {
      _v = (*_tmp210891)[_i]
      if(_i != 0){
        _s += _sep._str
      }
      _s += _v._str
    }
    return strNewx(_s, nil)
  }, &[]*Cptx{_strc}, _strc)
  methodDefx(_jsonc, "len", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(len((*_o._arr)), nil)
  }, nil, _intc)
  methodDefx(_dicc, "len", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(len((*_o._arr)), nil)
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
    _o._dic[_i._str] = copyCptFromAstx(_v)
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
  _assignf = opDefx(_idlocalc, "assign", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _local *Cptx
    var _r *Cptx
    var _str string
    var _v *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    _v = execx(_r, _env, 0)
    _local = _env._dic["envLocal"]
    _str = _l._str
    _local._dic[_str] = copyCptFromAstx(_v)
    return _v
  }, _cptc, _cptc, _opassignc)
  _assignf._fraw = true
  _idstateassignf = opDefx(_idstatec, "assign", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _k string
    var _l *Cptx
    var _o *Cptx
    var _r *Cptx
    var _v *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    _v = execx(_r, _env, 0)
    _k = _l._str
    _o = _l._class._obj
    _o._dic[_k] = copyCptFromAstx(_v)
    return _v
  }, _cptc, _cptc, _opassignc)
  _idstateassignf._fraw = true
  opDefx(_strc, "add", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return strNewx(_l._str + _r._str, nil)
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
    return intNewx(_l._int + _r._int, nil)
  }, _intc, _intc, _opaddc)
  opDefx(_intc, "subtract", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return intNewx(_l._int - _r._int, nil)
  }, _intc, _intc, _opsubtractc)
  opDefx(_intc, "multiply", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return intNewx(_l._int * _r._int, nil)
  }, _intc, _intc, _opmultiplyc)
  opDefx(_intc, "divide", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return intNewx(_l._int / _r._int, nil)
  }, _intc, _intc, _opdividec)
  opDefx(_intc, "mod", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    var _r *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    return intNewx(_l._int % _r._int, nil)
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
      return intNewx(_l._int + _r._int, nil)
    }
    if(_l._type == TFLOAT){
      return floatNewx(_l._val.(float64) + _r._val.(float64), nil)
    }
    if(_l._type == TSTR){
      return strNewx(_l._str + _r._str, nil)
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
    var _nenv *Cptx
    _nenv = (*_x)[0]
    __indentx = " "
    if(_nenv._int == 1){
      return _nenv
    }
    _nenv._int = 1
    if(_nenv._dic["envExec"]._id == _execmain._id){
      return blockExecx(_nenv._dic["envBlock"], _nenv, 0)
    }
    return execx(_nenv, _nenv, 1)
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
  execDefx("Arr_Call", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    _c = (*_x)[0]
    return subBlockExecx(_c._arr, _env, 0)
  })
  execDefx("CallPassRef", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _args *[]*Cptx
    var _argsx *[]*Cptx
    var _c *Cptx
    var _f *Cptx
    _c = (*_x)[0]
    _f = _c._class
    _args = _c._arr
    _argsx = prepareArgsRefx(_args, _f, _env)
    return callx(_c._class, _argsx, _env)
  })
  execDefx("CallRaw", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _args *[]*Cptx
    var _c *Cptx
    _c = (*_x)[0]
    _args = _c._arr
    return callx(_c._class, _args, _env)
  })
  execDefx("Null", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return (*_x)[0]
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
      _c = itemsDefx(_dicc, classx(_it), false)
      return dicNewx(_d, arrCopyx(_o._arr), _c)
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
      _tmp231798 := _o._arr;
      for _i = uint(0); _i < uint(len((*_tmp231798))); _i ++ {
        _v = (*_tmp231798)[_i]
        (*_a) = append((*_a), execx(_v, _env, 0))
      }
      _c = itemsDefx(_arrc, classx(_it), false)
      return arrNewx(_a, _c)
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
      _tmp236102 := _da._arr;
      for _tmp236109 := uint(0); _tmp236109 < uint(len((*_tmp236102))); _tmp236109 ++ {
        _kc = (*_tmp236102)[_tmp236109]
        _k = _kc._str
        _v = _da._dic[_k]
        if(_key != ""){
          _local[_key] = strNewx(_k, nil)
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
      _tmp237112 := _da._arr;
      for _i = uint(0); _i < uint(len((*_tmp237112))); _i ++ {
        _v = (*_tmp237112)[_i]
        if(_key != ""){
          _local[_key] = intNewx(int(_i), _uintc)
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
    }else if(_da._id == _nullv._id){
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
    return _c._class
  })
  execDefx("IdLocal", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _k string
    var _l *Cptx
    var _r *Cptx
    _c = (*_x)[0]
    _l = _env._dic["envLocal"]
    _k = _c._str
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
    _k = _c._str
    _o = _c._class._obj
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
    _fc = _Filex_readAll((*_osargs)[1])
    _execsp = "main"
    _defsp = "main"
    if(len((*_osargs)) > 2){
      _execsp = (*_osargs)[2]
    }
    if(len((*_osargs)) > 3){
      _defsp = (*_osargs)[3]
    }
    _main = progl2cptx("@env " + _execsp + " | " + _defsp + " {" + _fc + "}'" + (*_osargs)[1] + "'", _defmain, nil)
    execx(_main, _main, 2)
  }
}
