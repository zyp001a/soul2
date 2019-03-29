package main
import "strings"
import "sort"
import "fmt"
import "os"
import "runtime/debug"
import "strconv"
import "io/ioutil"
import "log"
import "os/exec"
import "encoding/json"
import "bytes"
const (
  TCPT = 0
  TOBJ = 1
  TCLASS = 2
  TTOBJ = 3
  TINT = 4
  TFLOAT = 5
  TNUMBIG = 6
  TSTR = 7
  TBYTES = 8
  TARR = 9
  TDIC = 10
  TID = 11
  TCALL = 12
)
type Funcx func(*[]*Cptx, *Cptx) *Cptx
type Dicx map[string]*Cptx
type Arrx *[]*Cptx
type Astx []interface{}
type Cptx struct {
  _arr *[]*Cptx
  _ast []interface{}
  _bytes []byte
  _class *Cptx
  _ctype uint8
  _dic map[string]*Cptx
  _farg bool
  _fast bool
  _fbitems bool
  _fbnum bool
  _fdefault bool
  _fdefmain bool
  _fmid bool
  _fprop bool
  _fraw bool
  _fscope bool
  _fstatic bool
  _id uint
  _id2 uint
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
var _scopec *Cptx
var _nativec *Cptx
var _midc *Cptx
var _aliasc *Cptx
var _valc *Cptx
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
var _dicc *Cptx
var _bytesc *Cptx
var _strc *Cptx
var _arrstrc *Cptx
var _dicstrc *Cptx
var _dicuintc *Cptx
var _dicclassc *Cptx
var _arrclassc *Cptx
var _errc *Cptx
var _rawc *Cptx
var _pathc *Cptx
var _enumc *Cptx
var _timec *Cptx
var _jsonc *Cptx
var _jsonarrc *Cptx
var _stackc *Cptx
var _queuec *Cptx
var _funcc *Cptx
var _funcprotoc *Cptx
var _funcvarsc *Cptx
var _funcnativec *Cptx
var _blockc *Cptx
var _blockmainc *Cptx
var _signalc *Cptx
var _continuec *Cptx
var _breakc *Cptx
var _gotoc *Cptx
var _returnc *Cptx
var _funcblockc *Cptx
var _funcerrc *Cptx
var _funcstdc *Cptx
var _handlerc *Cptx
var _funcclosurec *Cptx
var _functplc *Cptx
var _channelc *Cptx
var _streamc *Cptx
var _bufferc *Cptx
var _builderstrc *Cptx
var _routerc *Cptx
var _routerrootedc *Cptx
var _ipc *Cptx
var _ip6c *Cptx
var _pathfsc *Cptx
var _dirc *Cptx
var _fsv *Cptx
var _schemac *Cptx
var _dbmsc *Cptx
var _procc *Cptx
var _netc *Cptx
var _netv *Cptx
var _stdinc *Cptx
var _stdoutc *Cptx
var _stderrc *Cptx
var _stdinv *Cptx
var _stdoutv *Cptx
var _stderrv *Cptx
var _soulc *Cptx
var _soulsubc *Cptx
var _soulv *Cptx
var _souldicc *Cptx
var _worldv *Cptx
var _protocolc *Cptx
var _httpc *Cptx
var _httpsc *Cptx
var _serverc *Cptx
var _clientc *Cptx
var _reqc *Cptx
var _respc *Cptx
var _serverhttpc *Cptx
var _clienthttpc *Cptx
var _handlerhttpc *Cptx
var _callc *Cptx
var _arrcallc *Cptx
var _callpassrefc *Cptx
var _callrawc *Cptx
var _idc *Cptx
var _callidc *Cptx
var _idstatec *Cptx
var _idlocalc *Cptx
var _idparentc *Cptx
var _idglobalc *Cptx
var _idargc *Cptx
var _idclassc *Cptx
var _idcondc *Cptx
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
var _ctrlerrc *Cptx
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
  return nil
}
func arrOrx(_x *[]*Cptx) *[]*Cptx{
  if(_x == nil){
    return &[]*Cptx{}
  }else{
    return _x
  }
  return nil
}
func arrCopyx(_o *[]*Cptx) *[]*Cptx{
  var _e *Cptx
  var _n *[]*Cptx
  if(_o == nil){
    return nil
  }
  _n = &[]*Cptx{}
  _tmp44626 := _o;
  for _tmp44629 := uint(0); _tmp44629 < uint(len((*_tmp44626))); _tmp44629 ++ {
    _e = (*_tmp44626)[_tmp44629]
    (*_n) = append((*_n), _e)
  }
  return _n
}
func byteCopyx(_o []byte) []byte{
  var _e byte
  var _i uint
  var _n []byte
  if(_o == nil){
    return nil
  }
  _n = make([]byte, uint(len(_o)))
  _tmp45171 := _o;
  for _i = uint(0); _i < uint(len(_tmp45171)); _i ++ {
    _e = _tmp45171[_i]
    _n[_i] = _e
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
    _r = _r + __indentx
  }
  _tmp46103 := _arr;
  for _i = uint(0); _i < uint(len((*_tmp46103))); _i ++ {
    _x = (*_tmp46103)[_i]
    if(_i != 0 && _x != ""){
      _r = _r + "\n"
      _r = _r + __indentx
    }
    _r = _r + _x
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
  _tmp47168 := _Arr_Str_sort(_keys(_c._dic));
  for _tmp47171 := uint(0); _tmp47171 < uint(len(_tmp47168)); _tmp47171 ++ {
    _k = _tmp47168[_tmp47171]
    if(_o._dic[_k] == nil){
      (*_o._arr) = append((*_o._arr), strNewx(_k, nil))
      _o._dic[_k] = _c._dic[_k]
    }
  }
  _tmp47674 := _c._arr;
  for _tmp47677 := uint(0); _tmp47677 < uint(len((*_tmp47674))); _tmp47677 ++ {
    _v = (*_tmp47674)[_tmp47677]
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
    _tmp48281 := _parentarr;
    for _tmp48284 := uint(0); _tmp48284 < uint(len((*_tmp48281))); _tmp48284 ++ {
      _e = (*_tmp48281)[_tmp48284]
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
func propx(_o *Cptx, _scope *Cptx, _name string) *Cptx{
  var _dic map[string]*Cptx
  _o._fprop = true
  _o._name = _scope._name + "_" + _name
  _o._str = _name
  _dic = _scope._dic
  _dic[_name] = _o
  _o._class = _scope
  return _o
}
func routex(_o *Cptx, _scope *Cptx, _name string) *Cptx{
  var _dic map[string]*Cptx
  _dic = _scope._dic
  _dic[_name] = _o
  _o._name = _name
  _o._class = _scope
  return _o
}
func preGetx(_def *Cptx, _name string, _cname string) *Cptx{
  var _r *Cptx
  if(_cname != ""){
    _r = _def._dic[_cname + "_" + _name]
  }else{
    _r = _def._dic[_name]
  }
  return _r
}
func preSetx(_o *Cptx, _def *Cptx, _name string, _cname string) *Cptx{
  var _c *Cptx
  if(_cname != ""){
    _c = getx(_def, _cname)
    propx(_o, _c, _name)
  }else{
    routex(_o, _def, _name)
  }
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
  if(uint(len((*_c._arr))) > 1){
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
  _tmp52167 := _o._arr;
  for _tmp52170 := uint(0); _tmp52170 < uint(len((*_tmp52167))); _tmp52170 ++ {
    _k = (*_tmp52167)[_tmp52170]
    _v = _o._dic[_k._str]
    (*_arr) = append((*_arr), _v)
  }
  _it = getx(_o, "itemsType")
  if(_it == nil){
    _c = _arrc
  }else{
    _c = itemsDefx(_arrc, classx(_it), 0, false)
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
  if(inClassx(classx(_f), _funcvarsc, nil)){
    _vartypes = getx(_f, "funcVarTypes")._arr
    _tmp53045 := _vartypes;
    for _i = uint(0); _i < uint(len((*_tmp53045))); _i ++ {
      _argdef = (*_tmp53045)[_i]
      if(_i < uint(len((*_args)))){
        _t = passx(execx((*_args)[_i], _env, 0))
      }else{
        _t = copyx(_argdef)
      }
      (*_argsx) = append((*_argsx), _t)
    }
  }else{
    _tmp53448 := _args;
    for _tmp53451 := uint(0); _tmp53451 < uint(len((*_tmp53448))); _tmp53451 ++ {
      _arg = (*_tmp53448)[_tmp53451]
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _id2: 0,  
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id: 0,  
    _id2: 0,  
    _int: 0,  
    _name: "",  
  }
}
func bytesNewx(_x []byte, _c *Cptx) *Cptx{
  var _r *Cptx
  _r = &Cptx{
    _type: TBYTES,  
    _obj: _c,  
    _bytes: _x,  
    _ctype: TCPT,  
    _farg: false,  
    _fast: false,  
    _fbitems: false,  
    _fbnum: false,  
    _fdefault: false,  
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id: 0,  
    _id2: 0,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  if(_x == nil){
    _r._bytes = []byte("")
  }
  return _r
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id: 0,  
    _id2: 0,  
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id2: 0,  
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id2: 0,  
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
  if(_scopec != nil){
    _x._obj = _scopec
  }
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id2: 0,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  if(_dic == nil || uint(len(_dic)) == 0){
    _x._fdefault = true
  }
  _class._val = _x
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id2: 0,  
    _int: 0,  
    _name: "",  
    _str: "",  
  }
  return _x
}
func scopeObjNewx(_class *Cptx) *Cptx{
  if(_class._val != nil){
    return _class._val.(*Cptx)
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id: 0,  
    _id2: 0,  
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
    _fdefmain: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id2: 0,  
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id2: 0,  
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
  var _y *Cptx
  if(_return == nil){
    _return = _emptyc
  }
  _arr = &[]*Cptx{}
  _tmp61380 := _argtypes;
  for _tmp61383 := uint(0); _tmp61383 < uint(len((*_tmp61380))); _tmp61383 ++ {
    _v = (*_tmp61380)[_tmp61383]
    (*_arr) = append((*_arr), defx(_v, nil))
  }
  _fp = fpDefx(_arr, _return)
  if(_val != nil){
    _x = classNewx(&[]*Cptx{_fp, _funcnativec}, nil)
    _y = objNewx(_x, nil)
    _y._val = _val
  }else{
    _x = classNewx(&[]*Cptx{_fp}, nil)
    _y = objNewx(_x, nil)
  }
  _y._id2 = uidx()
  return _y
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
  if(_class == nil){
    _x = classNewx(&[]*Cptx{}, _schema)
  }else{
    _x = classNewx(&[]*Cptx{_class}, _schema)
  }
  routex(_x, _scope, _name)
  return _x
}
func bnumDefx(_name string, _class *Cptx) *Cptx{
  var _x *Cptx
  _x = curryDefx(_defmain, _name, _class, nil)
  _x._fbnum = true
  return _x
}
func getNamex(_x *Cptx) string{
  var _r string
  var _v *Cptx
  if(_x._name != ""){
    return _x._name
  }
  _tmp63616 := _x._arr;
  for _tmp63619 := uint(0); _tmp63619 < uint(len((*_tmp63616))); _tmp63619 ++ {
    _v = (*_tmp63616)[_tmp63619]
    _r = getNamex(_v)
    if(_r != ""){
      return _r
    }
  }
  return ""
}
func itemsChangeBasicx(_v *Cptx, _nb *Cptx) *Cptx{
  var _l int
  var _ob *Cptx
  var _r *Cptx
  if(_v._fmid){
    fmt.Println("cannot change basic for mid");debug.PrintStack();os.Exit(1)
  }
  if(_v._type != _nb._ctype){
    fmt.Println("cannot change between ARR DIC JSON");debug.PrintStack();os.Exit(1)
  }
  _ob = itemsGetBasicx(classx(_v))
  _r = getx(_v, "itemsLimitedLen")
  if(_r == nil){
    _l = 0
  }else{
    _l = _r._int
  }
  _v._obj = itemsDefx(_ob, classx(getx(_v, "itemsType")), _l, false)
  return _v
}
func itemsGetBasicx(_c *Cptx) *Cptx{
  var _r *Cptx
  var _v *Cptx
  if(_c._fbitems){
    return _c
  }
  _tmp64782 := _c._arr;
  for _tmp64785 := uint(0); _tmp64785 < uint(len((*_tmp64782))); _tmp64785 ++ {
    _v = (*_tmp64782)[_tmp64785]
    _r = itemsGetBasicx(_v)
    if(_r != nil){
      return _r
    }
  }
  return nil
}
func itemsDefx(_class *Cptx, _type *Cptx, _len int, _mid bool) *Cptx{
  var _n string
  var _r *Cptx
  if(!_class._fbitems){
    fmt.Println("item def first arg error");debug.PrintStack();os.Exit(1)
  }
  if(_type != nil){
    _type = aliasGetx(_type)
    if(_type._id != _cptc._id && _type._id != _unknownc._id){
      _n = _class._name + "_" + _type._name
      if(_n == "StaticArr_Byte"){
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
  }else{
    _r = _class
  }
  _r._str = _r._name
  if(!_mid && _len == 0){
    return _r
  }
  _r = classNewx(&[]*Cptx{_r}, nil)
  _r._str = _r._name
  if(_len > 0){
    (*_r._arr) = append((*_r._arr), classNewx(&[]*Cptx{_itemslimitedc}, map[string]*Cptx{
      "itemsLimitedLen": intNewx(_len, _uintc),
    }))
    _r._str = _r._str + "_" + strconv.Itoa(_len)
  }
  if(_mid){
    (*_r._arr) = append((*_r._arr), _midc)
  }
  return _r
}
func fpDefx(_types *[]*Cptx, _return *Cptx) *Cptx{
  var _n string
  var _v *Cptx
  var _x *Cptx
  _n = "FuncProto"
  _tmp66950 := _types;
  for _tmp66953 := uint(0); _tmp66953 < uint(len((*_tmp66950))); _tmp66953 ++ {
    _v = (*_tmp66950)[_tmp66953]
    _n = _n + "__" + aliasGetx(classx(_v))._name
  }
  if(_return == nil){
    _return = _emptyc
  }
  _n = _n + "__" + _return._name
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
func handlerDefx(_class *Cptx) *Cptx{
  var _x *Cptx
  _x = classNewx(&[]*Cptx{_class, _handlerc}, nil)
  _x._str = _class._name
  return _x
}
func methodDefx(_class *Cptx, _name string, _val func(*[]*Cptx, *Cptx) *Cptx, _argtypes *[]*Cptx, _return *Cptx) *Cptx{
  var _fn *Cptx
  if(_argtypes != nil){
    (*_argtypes) = append([]*Cptx{_class}, (*_argtypes)...)
  }else{
    _argtypes = &[]*Cptx{_class}
  }
  _fn = funcNewx(_val, _argtypes, _return)
  propx(_fn, _class, _name)
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
func _exists(s string) bool{
 _, err := os.Stat(s);
 return !os.IsNotExist(err)
}
func _checkErr2(x []interface{}, f func(string, string)bool)interface{}{
 if(x[1] != nil){
  e := x[1].(error)
  if(f != nil){
   if(!f("", e.Error())){
    return x[0]
   }
  }
  log.Fatal(e)
  os.Exit(1)  
 }
 return x[0]
}
func _arg2arr(a ...interface{}) []interface{} {
  return a
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
  if(_exists(_f)){
    _fc = string(_checkErr2(_arg2arr(ioutil.ReadFile(_f)), nil).([]byte))
    _arr = _Str_split(_fc, " ")
    _tmp70511 := _arr;
    for _tmp70514 := uint(0); _tmp70514 < uint(len((*_tmp70511))); _tmp70514 ++ {
      _v = (*_tmp70511)[_tmp70514]
      (*_s._arr) = append((*_s._arr), nsGetx(_ns, _v))
    }
  }
  return _s
}
func _stat(s string) map[string]uint{
 ss, err := os.Stat(s);
 if(err != nil){
  return nil
 }
 x := map[string]uint{
  "size": uint(ss.Size()),
  "timeMod": uint(ss.ModTime().Unix()),
 }
 return x
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
func _checkErr(e error, f func(string, string)bool){
 if(e != nil){
  if(f != nil){ 
   if(!f("", e.Error())){
    return
   }
  }
  log.Fatal(e)
  os.Exit(1)  
 }
}
func _Str_toJsonArr(x string)[]interface{}{
 var res []interface{};
 json.Unmarshal([]byte(x), &res);
 return res;
}
func dbGetx(_scope *Cptx, _key string) *Cptx{
  var _ast []interface{}
  var _f map[string]uint
  var _f2 map[string]uint
  var _f2cache map[string]uint
  var _fcache map[string]uint
  var _fstr string
  var _jstr string
  var _r *Cptx
  var _str string
  _fstr = os.Getenv("HOME") + "/soul2/db/" + _scope._str + "/" + _key + ".sl"
  _f = _stat(_fstr)
  _f2 = _stat(_fstr + "t")
  _fcache = _stat(_fstr + ".cache")
  _f2cache = _stat(_fstr + "t.cache")
  if(_f != nil){
    _str = string(_checkErr2(_arg2arr(ioutil.ReadFile(_fstr)), nil).([]byte))
    if(_f["timeMod"] > _fcache["timeMod"]){
      _jstr = _osCmd(os.Getenv("HOME") + "/soul2/sl-reader", _key + " := " + _str)
      _checkErr(ioutil.WriteFile(_fstr + ".cache", []byte(_jstr), 0666), nil)
    }else{
      _jstr = string(_checkErr2(_arg2arr(ioutil.ReadFile(_fstr + ".cache")), nil).([]byte))
    }
  }else if(_f2 != nil){
    _str = "@`" + string(_checkErr2(_arg2arr(ioutil.ReadFile(_fstr + "t")), nil).([]byte)) + "` '" + _fstr + "t'"
    if(_f2["timeMod"] > _f2cache["timeMod"]){
      _jstr = _osCmd(os.Getenv("HOME") + "/soul2/sl-reader", _key + " := " + _str)
      _checkErr(ioutil.WriteFile(_fstr + "t.cache", []byte(_jstr), 0666), nil)
    }else{
      _jstr = string(_checkErr2(_arg2arr(ioutil.ReadFile(_fstr + "t.cache")), nil).([]byte))
    }
  }else{
    return nil
  }
  _ast = _Str_toJsonArr(_jstr)
  if(uint(len(_ast)) == 0){
    fmt.Println(_fstr)
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
  _tmp73844 := _scope._arr;
  for _tmp73847 := uint(0); _tmp73847 < uint(len((*_tmp73844))); _tmp73847 ++ {
    _v = (*_tmp73844)[_tmp73847]
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
  if(_r._name != _scope._name + "_" + _key){
    _o = copyx(_r)
    _o._class = _scope
    _o._name = _scope._name + "_" + _key
    _scope._dic[_key] = _o
    _o._class = _scope
    return _o
  }
  return _r
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
func subPropGetx(_scope *Cptx, _v *Cptx, _key string) *Cptx{
  var _r *Cptx
  var _vv *Cptx
  _r = classGetx(_scope, _v._name + "_" + _key)
  if(_r != nil){
    return _r
  }
  _tmp75808 := _v._arr;
  for _tmp75811 := uint(0); _tmp75811 < uint(len((*_tmp75808))); _tmp75811 ++ {
    _vv = (*_tmp75808)[_tmp75811]
    _r = subPropGetx(_scope, _vv, _key)
    if(_r != nil){
      return _r
    }
  }
  return _r
}
func mustPropGetx(_scope *Cptx, _o *Cptx, _key string) *Cptx{
  var _r *Cptx
  _r = propGetx(_scope, _o, _key)
  if(_r == nil){
    fmt.Println(_scope)
    fmt.Println("no method " + _o._name + "_" + _key);debug.PrintStack();os.Exit(1)
  }
  return _r
}
func propGetx(_scope *Cptx, _o *Cptx, _key string) *Cptx{
  var _p *[]*Cptx
  var _r *Cptx
  var _v *Cptx
  if(_o._name != ""){
    _r = classGetx(_scope, _o._name + "_" + _key)
    if(_r != nil){
      return _r
    }
  }
  _p = _o._arr
  _tmp76896 := _p;
  for _tmp76899 := uint(0); _tmp76899 < uint(len((*_tmp76896))); _tmp76899 ++ {
    _v = (*_tmp76896)[_tmp76899]
    _r = subPropGetx(_scope, _v, _key)
    if(_r != nil){
      return _r
    }
  }
  _r = subPropGetx(_scope, _classc, _key)
  if(_r != nil){
    return _r
  }
  _r = subPropGetx(_scope, _cptc, _key)
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
  }else if(_t == TBYTES){
    return _bytesc
  }else if(_t == TDIC){
    return _dicc
  }else if(_t == TARR){
    return _arrc
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
  _tmp79690 := _c._arr;
  for _tmp79693 := uint(0); _tmp79693 < uint(len((*_tmp79690))); _tmp79693 ++ {
    _v = (*_tmp79690)[_tmp79693]
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
  _tmp80413 := _o._arr;
  for _tmp80416 := uint(0); _tmp80416 < uint(len((*_tmp80413))); _tmp80416 ++ {
    _v = (*_tmp80413)[_tmp80416]
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
  if(_t == nil){
    return _nullv
  }
  if(_t._ctype == TINT){
    _tar = intNewx(0, _t)
  }else if(_t._ctype == TFLOAT){
    _tar = floatNewx(0, _t)
  }else if(_t._ctype == TNUMBIG){
  }else if(_t._ctype == TSTR){
    _tar = strNewx("", _t)
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
    if(_class._val != nil){
      _r = _class._val.(*Cptx)
      if(_r._fstatic){
        return _r
      }
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
      if(uint(len(_dic)) != 0){
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
    _x._obj = _class
  }else if(_class._ctype == TBYTES){
    _x = bytesNewx(nil, nil)
    _x._obj = _class
    _x._fdefault = true
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
    _fdefmain: _o._fdefmain,  
    _name: _o._name,  
    _id: uidx(),  
    _id2: _o._id2,  
    _class: _o._class,  
    _obj: _o._obj,  
    _pred: _o._pred,  
    _dic: dicCopyx(_o._dic),  
    _arr: arrCopyx(_o._arr),  
    _str: _o._str,  
    _bytes: byteCopyx(_o._bytes),  
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
  return false
}
func mustGetx(_o *Cptx, _key string) *Cptx{
  var _r *Cptx
  _r = getx(_o, _key)
  if(_r == nil){
    fmt.Println(_key + " not found!");debug.PrintStack();os.Exit(1)
  }
  return _r
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
  var _x *Cptx
  _x = copyCptFromAstx(_val)
  _o._dic[_key] = _x
  return _x
}
func mustTypepredx(_o *Cptx) *Cptx{
  var _r *Cptx
  _r = typepredx(_o)
  if(_r._id == _unknownc._id){
    fmt.Println(strx(_o, 0))
    fmt.Println(strx(_r, 0))
    fmt.Println("unknown type");debug.PrintStack();os.Exit(1)
  }
  return _r
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
  var _x *Cptx
  _t = _o._type
  if(_t == TCALL){
    _f = _o._class
    _args = _o._arr
    if(_f == nil){
      return _callc
    }
    if(_f._id2 != 0 && _f._id2 == _classc._dic["new"]._id2){
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
    if(_f._id == _defmain._dic["strConvert"]._id){
      _arg1 = (*_args)[1]
      return _arg1
    }
    if(_f._id == _defmain._dic["implConvert"]._id){
      _arg1 = (*_args)[1]
      return _arg1
    }
    if(_f._id == _defmain._dic["type"]._id){
      _arg0 = (*_args)[0]
      return _arg0
    }
    if(_f._id == _defmain._dic["malloc"]._id){
      _arg1 = (*_args)[1]
      return itemsDefx(_staticarrc, _arg1, 0, false)
    }
    if(_f._id == _defmain._dic["call"]._id){
      _arg0 = (*_args)[0]
      _f = typepredx(_arg0)
      if(_f._id == _unknownc._id){
        return _f
      }
      _ret = getx(_f, "funcReturn")
      if(_ret == nil){
        return _cptc
      }
      if(_ret._id == _emptyc._id){
        return _cptc
      }
      return _ret
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
      _at0 = mustTypepredx(_arg0)
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
    if(inClassx(_o._obj, _idargc, nil)){
      _s = _o._class
      _x = _s._dic["@args"]
      if(_x == nil){
        return _cptc
      }
      _r = (*_x._arr)[_o._int]
      if(_r == nil){
        fmt.Println(strx(_s, 0))
        fmt.Println(_id)
        fmt.Println("not defined in idarg");debug.PrintStack();os.Exit(1)
        return _r
      }
      return typepredx(_r)
    }
    if(inClassx(_o._obj, _idcondc, nil)){
      if(_o._str == "ctx"){
        return _dicc
      }
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
  return nil
}
func dic2strx(_d map[string]*Cptx, _i int) string{
  var _k string
  var _s string
  var _v *Cptx
  _s = "{\n"
  for _k, _v = range _d {
    _s = _s + indx(_k + ":" + strx(_v, _i + 1), 0) + "\n"
  }
  return _s + "}"
}
func arr2strx(_a *[]*Cptx, _i int) string{
  var _s string
  var _v *Cptx
  _s = ""
  if(uint(len((*_a))) > 1){
    _s = _s + "\n"
    _tmp98534 := _a;
    for _tmp98537 := uint(0); _tmp98537 < uint(len((*_tmp98534))); _tmp98537 ++ {
      _v = (*_tmp98534)[_tmp98537]
      _s = _s + indx(strx(_v, _i + 1), 0) + "\n"
    }
  }else{
    _tmp98769 := _a;
    for _tmp98772 := uint(0); _tmp98772 < uint(len((*_tmp98769))); _tmp98772 ++ {
      _v = (*_tmp98769)[_tmp98772]
      _s = _s + strx(_v, _i + 1)
    }
  }
  return _s
}
func parent2strx(_d *[]*Cptx) string{
  var _s string
  var _v *Cptx
  _s = ""
  _tmp99094 := _d;
  for _tmp99097 := uint(0); _tmp99097 < uint(len((*_tmp99094))); _tmp99097 ++ {
    _v = (*_tmp99094)[_tmp99097]
    if(_v._name != ""){
      _s = _s + _v._name + " "
    }else{
      _s = _s + "~" + strconv.FormatUint(uint64(_v._id), 10) + " "
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
      _s = _s + _o._name + " = "
    }else{
      _s = _s + "~" + strconv.FormatUint(uint64(_o._id), 10) + " = "
    }
    if(_o._obj._name != ""){
      _s = _s + "&" + _o._obj._name
    }else{
      _s = _s + "&~" + strconv.FormatUint(uint64(_o._obj._id), 10)
    }
    _s = _s + dic2strx(_o._dic, _i)
    return _s
  }else if(_t == TCLASS){
    _s = ""
    if(_o._name != ""){
      _s = _s + _o._name + " = "
    }else{
      _s = _s + "~" + strconv.FormatUint(uint64(_o._id), 10) + " = "
    }
    _s = _s + "@class " + parent2strx(_o._arr) + " " + dic2strx(_o._dic, _i)
    return _s
  }else if(_t == TINT){
    return strconv.Itoa(_o._int)
  }else if(_t == TFLOAT){
    return strconv.FormatFloat(float64(_o._val.(float64)), 'f', -1, 64)
  }else if(_t == TSTR){
    return "\"" + escapex(_o._str) + "\""
  }else if(_t == TBYTES){
    return "@" + string(_o._bytes)
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
  return ""
}
func tplCallx(_func *Cptx, _args *[]*Cptx, _env *Cptx) *Cptx{
  var _b *Cptx
  var _ctx *Cptx
  var _ctxn *Cptx
  var _k string
  var _localx *Cptx
  var _nstate *Cptx
  var _ostate *Cptx
  var _r *Cptx
  var _stack *[]*Cptx
  var _v *Cptx
  _b = _func._dic["funcTplBlock"]
  if(_b == nil){
    return strNewx("", nil)
  }
  _localx = _b._dic["blockStateDef"]
  _nstate = objNewx(_localx, nil)
  _nstate._fdefault = false
  _nstate._fdefmain = true
  _nstate._dic["@args"] = arrNewx(_args, nil)
  _stack = _env._dic["envStack"]._arr
  _ostate = _env._dic["envLocal"]
  _ctx = _ostate._dic["@ctx"]
  _ctxn = dicNewx(nil, nil, nil)
  _nstate._dic["@ctx"] = _ctxn
  if(_ctx != nil && !_ctx._fdefault){
    for _k, _v = range _ctx._dic {
      (*_ctxn._arr) = append((*_ctxn._arr), strNewx(_k, nil))
      _ctxn._dic[_k] = _v
    }
  }
  (*_stack) = append((*_stack), _ostate)
  if(_func._dic["funcTplPath"] != nil){
    _nstate._str = _func._dic["funcTplPath"]._str
  }else{
    _nstate._str = "Tpl: " + _func._name
  }
  _env._dic["envLocal"] = _nstate
  _r = blockExecx(_b, _env, 0)
  _env._dic["envLocal"] = (*_stack)[uint(len((*_stack))) - 1]
  (*_stack) = (*_stack)[:len((*_stack))-1]
  if(_r._id == _nullv._id){
    return _nstate._dic["$str"]
  }else{
    return _r
  }
  return nil
}
func callx(_func *Cptx, _args *[]*Cptx, _env *Cptx) *Cptx{
  var _block *Cptx
  var _ctx *Cptx
  var _nstate *Cptx
  var _ostate *Cptx
  var _r *Cptx
  var _stack *[]*Cptx
  if(_func == nil || _func._obj == nil){
    fmt.Println(arr2strx(_args, 0))
    fmt.Println(strx(_func, 0))
    fmt.Println("func not defined");debug.PrintStack();os.Exit(1)
  }
  if(inClassx(_func._obj, _funcnativec, nil)){
    return _func._val.(func(*[]*Cptx, *Cptx) *Cptx)(_args, _env)
  }
  if(inClassx(_func._obj, _functplc, nil)){
    return tplCallx(_func, _args, _env)
  }
  if(inClassx(_func._obj, _funcblockc, nil)){
    _block = _func._dic["funcBlock"]
    _nstate = objNewx(_block._dic["blockStateDef"], nil)
    _nstate._fdefault = false
    _nstate._fdefmain = true
    _stack = _env._dic["envStack"]._arr
    _ostate = _env._dic["envLocal"]
    _ctx = _ostate._dic["@ctx"]
    if(_ctx != nil){
      _nstate._dic["@ctx"] = _ctx
    }
    (*_stack) = append((*_stack), _ostate)
    _nstate._str = "Block:" + _func._name
    _env._dic["envLocal"] = _nstate
    _nstate._dic["@args"] = arrNewx(_args, nil)
    _r = blockExecx(_block, _env, 0)
    _env._dic["envLocal"] = (*_stack)[uint(len((*_stack))) - 1]
    (*_stack) = (*_stack)[:len((*_stack))-1]
    if(inClassx(classx(_r), _signalc, nil)){
      if(_r._obj._id == _returnc._id){
        return _r._dic["return"]
      }
      if(_r._obj._id == _errc._id){
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
func autoReturnx(_bl *Cptx, _x *Cptx) {
  var _arr *[]*Cptx
  var _fr *Cptx
  var _r *Cptx
  _fr = mustGetx(_x, "funcReturn")
  if(_fr._id != _emptyc._id){
    _r = defaultx(_fr)
  }else{
    return 
  }
  _arr = _bl._dic["blockVal"]._arr
  if(uint(len((*_arr))) == 0 || classx((*_arr)[uint(len((*_arr))) - 1])._id != _ctrlreturnc._id){
    (*_arr) = append((*_arr), defx(_ctrlreturnc, map[string]*Cptx{
      "ctrlArg": _r,
    }))
  }
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
    _tmp109262 := _c._arr;
    for _tmp109265 := uint(0); _tmp109265 < uint(len((*_tmp109262))); _tmp109265 ++ {
      _v = (*_tmp109262)[_tmp109265]
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
  var _l *Cptx
  var _r *Cptx
  var _v *Cptx
  _l = _env._dic["envLocal"]
  _tmp110952 := _arr;
  for _i = uint(0); _i < uint(len((*_tmp110952))); _i ++ {
    _v = (*_tmp110952)[_i]
    if(_stt != 0 && _stt < _i){
      continue
    }
    _l._int = int(_i)
    _l._ast = _v._ast
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
  var _r *Cptx
  var _sp *Cptx
  _l = _env._dic["envLocal"]
  if(_flag == 1){
    _sp = _env._dic["envExec"]
  }else if(_flag == 2){
    _sp = _execmain
  }else if(_l._fdefmain){
    _sp = _execmain
  }else{
    _sp = _env._dic["envExec"]
  }
  _ex = execGetx(_o, _sp)
  if(_ex == nil){
    fmt.Println("exec: unknown type " + classx(_o)._name);debug.PrintStack();os.Exit(1)
  }
  _r = callx(_ex, &[]*Cptx{_o}, _env)
  if(_r == nil){
    diex("exec return null", _env)
  }
  return _r
}
func tobj2objx(_to *Cptx) *Cptx{
  return objNewx(_to._obj, nil)
}
func convertx(_val *Cptx, _to *Cptx) *Cptx{
  var _f *Cptx
  var _from *Cptx
  var _name string
  var _r *Cptx
  if(_val == nil){
    fmt.Println("convertx val null");debug.PrintStack();os.Exit(1)
  }
  if(_val._id == _nullv._id){
    return _val
  }
  if(_to == nil || _to._id == _cptc._id || _to._id == _unknownc._id){
    return _val
  }
  _from = typepredx(_val)
  _from = aliasGetx(_from)
  _to = aliasGetx(_to)
  if(_from._id == _to._id){
    return _val
  }
  if(_from._id == _cptc._id || _from._id == _unknownc._id){
    return callNewx(_defmain._dic["as"], &[]*Cptx{_val, _to}, nil)
  }
  if(_from._fbnum && _to._fbnum){
    if(_val._fmid){
      return callNewx(_defmain._dic["numConvert"], &[]*Cptx{_val, _to}, nil)
    }
    _val._obj = _to
    _val._pred = _to
    _to._val = _val
    return _val
  }
  if(_to._ctype == _from._ctype && _from._ctype == TSTR){
    if(!_val._fmid){
      return strNewx(_val._str, _to)
    }
    return callNewx(_defmain._dic["strConvert"], &[]*Cptx{_val, _to}, nil)
  }
  if(inClassx(_from, _to, nil)){
    if(_to._ctype == _from._ctype && _to._ctype == TOBJ){
      if(!inClassx(_to, _funcc, nil)){
        return callNewx(_defmain._dic["implConvert"], &[]*Cptx{_val, _to}, nil)
      }
    }
    return _val
  }
  if(_to._ctype == _from._ctype){
    if(!_val._fmid){
      if(inClassx(_to, _from, nil)){
        _val._obj = _to
        _val._pred = _to
        _to._val = _val
        return _val
      }else if(_val._type == TARR || _val._type == TDIC){
        if(_to._fbitems){
          return itemsChangeBasicx(_val, _to)
        }
      }
    }
    if(_from._ctype == TARR || _from._ctype == TDIC){
      if(_from._str == "Static" + _to._str){
        _f = getx(_staticarrc, "toArr")
        return callNewx(_f, &[]*Cptx{_val}, nil)
      }
      if("Static" + _from._str == _to._str){
        _f = getx(_arrc, "toStaticArr")
        return callNewx(_f, &[]*Cptx{_val}, nil)
      }
    }
  }
  _name = getNamex(_to)
  if(_name == ""){
    fmt.Println("class with no name");debug.PrintStack();os.Exit(1)
  }
  _r = getx(_from, "to" + _name)
  if(_r == nil){
    fmt.Println(strx(_val, 0))
    fmt.Println(_val._fmid)
    fmt.Println("from.ctype " + strconv.FormatUint(uint64(_from._ctype), 10))
    fmt.Println("to.ctype " + strconv.FormatUint(uint64(_to._ctype), 10))
    fmt.Println("to in from?")
    fmt.Println(inClassx(_to, _from, nil))
    fmt.Println("from in to?")
    fmt.Println(inClassx(_from, _to, nil))
    fmt.Println(strx(_from, 0))
    fmt.Println(strx(_to, 0))
    fmt.Println("to" + _name)
    fmt.Println("convert func not defined");debug.PrintStack();os.Exit(1)
  }
  return callNewx(_r, &[]*Cptx{_val}, nil)
}
func byte2strx(_b byte) string{
  var _c []byte
  _c = make([]byte, 1)
  _c[0] = _b
  return string(_c)
}
func diex(_str string, _env *Cptx) {
  var _l *Cptx
  var _v *Cptx
  _tmp117903 := _env._dic["envStack"]._arr;
  for _tmp117906 := uint(0); _tmp117906 < uint(len((*_tmp117903))); _tmp117906 ++ {
    _v = (*_tmp117903)[_tmp117906]
    fmt.Println(_v._str + ":" + strconv.Itoa(_v._int))
  }
  _l = _env._dic["envLocal"]
  fmt.Println(_l._str + ":" + strconv.Itoa(_l._int))
  fmt.Println(_l._ast)
  fmt.Println(_str);debug.PrintStack();os.Exit(1)
}
func dicSetx(_o *Cptx, _key string, _val *Cptx) *Cptx{
  if(_o._dic[_key] == nil){
    (*_o._arr) = append((*_o._arr), strNewx(_key, nil))
  }
  _o._dic[_key] = _val
  return _val
}
func id2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _i uint
  var _id string
  var _p *Cptx
  var _r *Cptx
  var _stro *Cptx
  var _varts *Cptx
  _id = _ast[1].(string)
  if(_id == "$"){
    return _soulv
  }
  if(_func != nil){
    _varts = getx(_func, "funcVars")
    if(_varts != nil){
      _tmp119177 := _varts._arr;
      for _i = uint(0); _i < uint(len((*_tmp119177))); _i ++ {
        _stro = (*_tmp119177)[_i]
        if(_id == _stro._str){
          _r = idNewx(_local, _stro._str, _idargc)
          _r._int = int(_i)
          return _r
        }
      }
    }
  }
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
  fmt.Println(strx(_local, 0))
  fmt.Println("id not defined " + _id);debug.PrintStack();os.Exit(1)
  return nil
}
func _Str_isInt(v string)bool{
 _, err := strconv.Atoi(v);
 return err == nil
}
func idlocal2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _cc *Cptx
  var _i uint
  var _id string
  var _idi int
  var _r *Cptx
  var _stro *Cptx
  var _type *Cptx
  var _val *Cptx
  var _vars *Cptx
  var _varts *Cptx
  _id = _ast[1].(string)
  _val = _local._dic[_id]
  _cc = _idlocalc
  if(_Str_isInt(_id)){
    if(_func == nil){
      diex("idarg #d not func!!! " + _id, nil)
    }
    _idi = _checkErr2(_arg2arr(strconv.Atoi(_id)), nil).(int)
    _vars = getx(_func, "funcVars")
    if(_vars != nil){
      if(_idi >= int(uint(len((*_vars._arr))))){
        fmt.Println("#" + _id + " not defined");debug.PrintStack();os.Exit(1)
      }
      _id = (*_vars._arr)[_idi]._str
    }else{
      _id = ""
    }
    _r = idNewx(_local, _id, _idargc)
    _r._int = _idi
    return _r
  }
  if(_func != nil){
    _varts = getx(_func, "funcVars")
    if(_varts != nil){
      _tmp122096 := _varts._arr;
      for _i = uint(0); _i < uint(len((*_tmp122096))); _i ++ {
        _stro = (*_tmp122096)[_i]
        if(_id == _stro._str){
          _r = idNewx(_local, _stro._str, _idargc)
          _r._int = int(_i)
          return _r
        }
      }
    }
  }
  if(_val == nil){
    if(uint(len(_ast)) > 2){
      _type = classGetx(_def, _ast[2].(string))
      if(_type == nil){
        fmt.Println("wrong type " + _ast[2].(string));debug.PrintStack();os.Exit(1)
      }
    }else{
      _type = _nullc
    }
    _local._dic[_id] = defx(_type, nil)
  }
  _r = idNewx(_local, _id, _cc)
  return _r
}
func env2cptx(_ast []interface{}, _def *Cptx, _local *Cptx) *Cptx{
  var _b *Cptx
  var _execsp *Cptx
  var _l *Cptx
  var _v []interface{}
  var _x *Cptx
  _v = _ast[2].([]interface{})
  _b = ast2cptx(_v, _def, _local, nil, "")
  _execsp = nsGetx(_execns, _ast[1].(string))
  if(_execsp == nil){
    fmt.Println("no execsp");debug.PrintStack();os.Exit(1)
  }
  _l = scopeObjNewx(_b._dic["blockStateDef"])
  _l._str = "Env " + _execsp._str
  _x = defx(_envc, map[string]*Cptx{
    "envLocal": _l,
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
  var _cname string
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
  _cname = _v[0].(string)
  _funcVars = &[]*Cptx{}
  _funcVarTypes = &[]*Cptx{}
  _nlocal = classNewx(&[]*Cptx{_local}, nil)
  if(_cname != ""){
    _class = classGetx(_def, _cname)
    (*_funcVars) = append((*_funcVars), strNewx("@this", nil))
    _x = defx(_class, nil)
    if(!_x._fstatic){
      _x._farg = true
    }
    (*_funcVarTypes) = append((*_funcVarTypes), _x)
    _nlocal._dic["@this"] = _x
  }
  _args = _v[1].([]interface{})
  _tmp125086 := _args;
  for _tmp125089 := uint(0); _tmp125089 < uint(len(_tmp125086)); _tmp125089 ++ {
    _arg = _tmp125086[_tmp125089]
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
      _varval = _unknownv
    }
    if(!_varval._fstatic){
      _varval._farg = true
    }
    (*_funcVarTypes) = append((*_funcVarTypes), _varval)
  }
  _nlocal._dic["@args"] = arrNewx(_funcVarTypes, nil)
  if(uint(len(_v)) > 2 && _v[2] != nil){
    _ret = classGetx(_def, _v[2].(string))
  }else{
    _ret = _emptyc
  }
  _fp = fpDefx(_funcVarTypes, _ret)
  if(_isproto > 0){
    return _fp
  }
  _cx = classNewx(&[]*Cptx{_fp, _funcstdc}, nil)
  _x = objNewx(_cx, nil)
  _x._dic["funcVars"] = arrNewx(_funcVars, _arrstrc)
  _x._val = _nlocal
  return _x
}
func func2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string, _pre int) *Cptx{
  var _ab *Cptx
  var _bl *Cptx
  var _cname string
  var _nlocal *Cptx
  var _v []interface{}
  var _x *Cptx
  if(_pre != 0 && _name == ""){
    fmt.Println("def must have name");debug.PrintStack();os.Exit(1)
  }
  _v = _ast[1].([]interface{})
  _cname = _v[0].(string)
  if(_name != ""){
    _x = preGetx(_def, _name, _cname)
    if(_x == nil){
      _x = subFunc2cptx(_ast, _def, _local, _func, 0)
      preSetx(_x, _def, _name, _cname)
    }
  }else{
    if(_cname != ""){
      fmt.Println("anoymous function cannot be method");debug.PrintStack();os.Exit(1)
    }
    _x = subFunc2cptx(_ast, _def, _local, _func, 0)
  }
  if(_pre != 0){
    return _x
  }
  _nlocal = _x._val.(*Cptx)
  _bl = ast2blockx(_v[3].([]interface{}), _def, _nlocal, _x, nil)
  autoReturnx(_bl, _x)
  _x._dic["funcBlock"] = _bl
  if(_v[4] != nil){
    _ab = preExecx(ast2cptx(_v[4].([]interface{}), _def, _local, _x, ""))
    _x._dic["funcErrFunc"] = _ab
  }else if(_func != nil){
    _x._dic["funcErrFunc"] = _func._dic["funcErrFunc"]
  }else{
    _x._dic["funcErrFunc"] = _defmain._dic["throw"]
  }
  return _x
}
func handler2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string) *Cptx{
  var _ab *Cptx
  var _blockast []interface{}
  var _v []interface{}
  var _x *Cptx
  _v = _ast[1].([]interface{})
  _blockast = _v[0].([]interface{})
  _x = objNewx(_handlerc, nil)
  _x._val = _blockast
  if(_v[1] != nil){
    _ab = preExecx(ast2cptx(_v[1].([]interface{}), _def, _local, _x, ""))
    _x._dic["funcErrFunc"] = _ab
  }else if(_func != nil){
    _x._dic["funcErrFunc"] = _func._dic["funcErrFunc"]
  }else{
    _x._dic["funcErrFunc"] = _defmain._dic["throw"]
  }
  return _x
}
func class2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string, _pre int) *Cptx{
  var _arr *[]*Cptx
  var _cname string
  var _e interface{}
  var _k string
  var _parents []interface{}
  var _r *Cptx
  var _s string
  var _schema *Cptx
  var _schemaast []interface{}
  var _v *Cptx
  var _vv []interface{}
  var _x *Cptx
  _vv = _ast[1].([]interface{})
  _cname = _vv[0].(string)
  _parents = _vv[1].([]interface{})
  _schemaast = _vv[2].([]interface{})
  if(_pre == 1 || _pre == 0){
    _arr = &[]*Cptx{}
    _tmp130905 := _parents;
    for _tmp130908 := uint(0); _tmp130908 < uint(len(_tmp130905)); _tmp130908 ++ {
      _e = _tmp130905[_tmp130908]
      _s = _e.(string)
      _r = classGetx(_def, _s)
      if(_r == nil){
        fmt.Println(_parents)
        fmt.Println("class2obj: no class " + _s);debug.PrintStack();os.Exit(1)
      }
      (*_arr) = append((*_arr), _r)
    }
    _x = classNewx(_arr, nil)
    preSetx(_x, _def, _name, _cname)
  }
  if(_pre == 2 || _pre == 0){
    _x = preGetx(_def, _name, _cname)
    _schema = ast2dicx(_schemaast, _def, _local, _func, nil, 0)
    if(uint(len(_vv)) > 3){
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
func blockmain2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string) *Cptx{
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
  if(_d._val == nil){
    objNewx(_d, nil)
  }
  preAst2blockx(_v, _d, _l, _func)
  ast2blockx(_v, _d, _l, _func, _b)
  if(uint(len(_ast)) == 4){
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
  if(uint(len(_astb)) != 0){
    _localx = classNewx(nil, nil)
    _b = blockmain2cptx(_astb, _tplmain, _localx, _x, "")
    _x._dic["funcTplBlock"] = _b
  }
  if(uint(len(_ast)) == 3){
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
  _tmp135264 := _arr;
  for _i = uint(0); _i < uint(len(_tmp135264)); _i ++ {
    _v = _tmp135264[_i]
    (*_a) = append((*_a), strNewx(_v.(string), nil))
    _ii = intNewx(int(_i), nil)
    _ii._obj = _c
    _c._val = _ii
    _d[_v.(string)] = _ii
  }
  return _c
}
func json2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _dic []interface{}
  var _r *Cptx
  _dic = _ast[1].([]interface{})
  _r = ast2jsonx(_dic, _def, _local, _func)
  return _r
}
func obj2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _c *Cptx
  var _classnf *Cptx
  var _nf *Cptx
  var _schema *Cptx
  var _x *Cptx
  _c = classGetx(_def, _ast[1].(string))
  if(_c == nil){
    fmt.Println("obj2cpt: no class " + _ast[1].(string));debug.PrintStack();os.Exit(1)
  }
  _schema = ast2dicx(_ast[2].([]interface{}), _def, _local, _func, nil, 0)
  _nf = getx(_c, "new")
  _classnf = _classc._dic["new"]
  if(_nf._id2 == _classnf._id2 && !_schema._fmid){
    _x = defx(_c, _schema._dic)
  }else{
    _x = callNewx(_nf, &[]*Cptx{_c, _schema}, nil)
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
  if(uint(len(_args)) == 1){
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
  var _getc *Cptx
  var _getf *Cptx
  var _it *Cptx
  var _items *Cptx
  var _itemst *Cptx
  var _itemstc *Cptx
  var _itemstt *Cptx
  var _key *Cptx
  var _lefto *Cptx
  var _lit *Cptx
  var _oo *Cptx
  var _predt *Cptx
  var _s *Cptx
  var _setf *Cptx
  var _str string
  _items = ast2cptx(_ast[1].([]interface{}), _def, _local, _func, "")
  _itemstc = mustTypepredx(_items)
  _key = ast2cptx(_ast[2].([]interface{}), _def, _local, _func, "")
  if(_v == nil){
    _getf = mustGetx(_itemstc, "get")
    _getc = callNewx(_getf, &[]*Cptx{_items, _key}, _callidc)
    return _getc
  }
  _setf = mustGetx(_itemstc, "set")
  _lit = getx(_itemstc, "itemsType")
  if(_lit != nil && _lit._id != _cptv._id){
    return callNewx(_setf, &[]*Cptx{_items, _key, convertx(_v, classx(_lit))}, nil)
  }
  _lefto = callNewx(_setf, &[]*Cptx{_items, _key, _v}, nil)
  _predt = typepredx(_v)
  if(inClassx(classx(_items), _idstatec, nil)){
    _s = _items._class
    _str = _items._str
    _itemst = _s._dic[_str]
    _itemstt = aliasGetx(_itemst._obj)
    if(!_itemstt._fbitems){
      return _lefto
    }
    if(_itemst._farg){
      return _lefto
    }
    _it = getx(_itemst, "itemsType")
    if(_predt._id != _unknownc._id && _predt._id != _cptc._id){
      if(_it._id == _cptv._id){
        _itemst._obj = itemsDefx(_itemstt, _predt, 0, false)
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
func err2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _err *Cptx
  var _msg *Cptx
  _err = strNewx(_ast[1].(string), _errc)
  if(uint(len(_ast)) > 2){
    _msg = ast2cptx(_ast[2].([]interface{}), _def, _local, _func, "")
  }else{
    _msg = strNewx("", nil)
  }
  if(_func == nil){
    return callNewx(_defmain._dic["throw"], &[]*Cptx{_err, _msg}, nil)
  }
  return objNewx(_ctrlerrc, map[string]*Cptx{
    "ctrlArgs": arrNewx(&[]*Cptx{_err, _msg, _func}, nil),
  })
}
func return2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _arg *Cptx
  var _ret *Cptx
  if(_func == nil){
    fmt.Println(_ast)
    fmt.Println("return outside func");debug.PrintStack();os.Exit(1)
  }
  _ret = getx(_func, "funcReturn")
  if(uint(len(_ast)) > 1){
    _arg = ast2cptx(_ast[1].([]interface{}), _def, _local, _func, "")
    if(_ret._id == _emptyc._id){
      fmt.Println("func " + _func._name + " should not return value");debug.PrintStack();os.Exit(1)
    }
    _arg = convertx(_arg, _ret)
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
  var _getc *Cptx
  var _lpredt *Cptx
  var _obj *Cptx
  _obj = ast2cptx(_ast[1].([]interface{}), _def, _local, _func, "")
  if(_obj._type == TOBJ || _obj._type == TCALL || _obj._type == TID){
    _getc = callNewx(_defmain._dic["get"], &[]*Cptx{_obj, strNewx(_ast[2].(string), nil)}, _callidc)
    if(_v == nil){
      return _getc
    }
    _lpredt = typepredx(_getc)
    return callNewx(_defmain._dic["set"], &[]*Cptx{_obj, strNewx(_ast[2].(string), nil), convertx(_v, _lpredt)}, _callidc)
  }else{
    return nil
  }
  return nil
}
func if2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _block *Cptx) *Cptx{
  var _a *Cptx
  var _args *[]*Cptx
  var _d *Cptx
  var _i int
  var _l uint
  var _t *Cptx
  var _v []interface{}
  _v = _ast[1].([]interface{})
  _a = ast2arrx(_v, _def, _local, _func, nil, 0)
  _args = _a._arr
  _l = uint(len((*_args)))
  for _i = 0; _i < int(_l - 1); _i = _i + 2 {
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
  if(_n == "Class" || _n == "Obj"){
    fmt.Println("no alias for this");debug.PrintStack();os.Exit(1)
  }
  _x = classGetx(_def, _n)
  if(_x == nil){
    fmt.Println("alias error " + _ast[1].(string));debug.PrintStack();os.Exit(1)
  }
  return aliasDefx(_def, _name, _x)
}
func itemdef2cptx(_ast []interface{}, _def *Cptx, _name string, _pre int) *Cptx{
  var _c *Cptx
  var _it *Cptx
  var _re *Cptx
  var _x *Cptx
  if(_pre != 0){
    _re = classDefx(_def, _name, nil, nil)
    return _re
  }
  _x = classGetx(_def, _ast[1].(string))
  _it = classGetx(_def, _ast[2].(string))
  if(_x == nil){
    fmt.Println("itemdef error, items " + _ast[1].(string));debug.PrintStack();os.Exit(1)
  }
  if(_it == nil){
    fmt.Println("itemdef error, itemsType " + _ast[2].(string));debug.PrintStack();os.Exit(1)
  }
  _c = itemsDefx(_x, _it, 0, false)
  _re = _def._dic[_name]
  if(_re == nil){
    return aliasDefx(_def, _name, _c)
  }
  parentMakex(_re, &[]*Cptx{_aliasc, _c})
  return _re
}
func funcproto2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string) *Cptx{
  var _x *Cptx
  _x = subFunc2cptx(_ast, _def, _local, _func, 1)
  return aliasDefx(_def, _name, _x)
}
func def2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _pre int) *Cptx{
  var _af *Cptx
  var _c string
  var _cname string
  var _dfd *Cptx
  var _id string
  var _ip *Cptx
  var _name string
  var _r *Cptx
  var _t *Cptx
  var _v []interface{}
  var _vv []interface{}
  _name = _ast[1].(string)
  _v = _ast[2].([]interface{})
  _c = _v[0].(string)
  _id = _name
  if(_c == "class" || _c == "func" || _c == "handler"){
    _vv = _v[1].([]interface{})
    _cname = _vv[0].(string)
    if(_cname != ""){
      _id = _cname + "_" + _name
    }
  }
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
      return blockmain2cptx(_v, _def, _local, _func, _id)
    }else if(_c == "class"){
      return class2cptx(_v, _def, _local, _func, _name, _pre)
    }else if(_c == "alias"){
      return alias2cptx(_v, _def, _id)
    }else if(_c == "itemdef"){
      return itemdef2cptx(_v, _def, _id, _pre)
    }else{
      return nil
    }
  }
  if(_pre == 12){
    if(_c == "itemdef"){
      return itemdef2cptx(_v, _def, _id, 0)
    }else{
      return nil
    }
  }
  if(_pre == 2){
    if(_c == "class"){
      return class2cptx(_v, _def, _local, _func, _name, _pre)
    }else if(_c == "func"){
      _dfd = _def._dic[_id]
      if(_dfd != nil){
        fmt.Println("func def twice " + _id);debug.PrintStack();os.Exit(1)
      }
      return func2cptx(_v, _def, _local, _func, _name, _pre)
    }else if(_c == "funcproto"){
      return funcproto2cptx(_v, _def, _local, _func, _id)
    }else{
      return nil
    }
  }
  if(_c == "func"){
    return func2cptx(_v, _def, _local, _func, _name, 0)
  }
  _dfd = _def._dic[_id]
  if(_dfd != nil){
    return _dfd
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
  if(uint(len(_v)) > 2){
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
  if(_leftt == "id" && uint(len(_v)) == 2){
    _name = _left[1].(string)
    if(getx(_local, _name) == nil){
      if(getx(_def._val.(*Cptx), _name) == nil){
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
        if(_predt._fbitems){
          _s._dic[_idstr]._val = _righto
        }
      }
    }
  }
  if(_lpredt == nil){
    _lpredt = typepredx(_lefto)
  }
  _righto = convertx(_righto, _lpredt)
  _f = getx(_lefto, "assign")
  if(_f == nil){
    fmt.Println(_lefto)
    fmt.Println("no assign");debug.PrintStack();os.Exit(1)
  }
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
    if(uint(len(_astarr)) == 0){
      return callNewx(_defmain._dic["type"], &[]*Cptx{_f}, _callrawc)
    }
    return convertx(ast2cptx(_astarr[0].([]interface{}), _def, _local, _func, ""), _f)
  }
  _vt = getx(_f, "funcVarTypes")
  _arrx = &[]*Cptx{}
  if(_vt != nil && uint(len(_astarr)) > uint(len((*_vt._arr)))){
    fmt.Println(_f)
    fmt.Println("pass more args than def");debug.PrintStack();os.Exit(1)
  }
  _tmp162519 := _astarr;
  for _i = uint(0); _i < uint(len(_tmp162519)); _i ++ {
    _e = _tmp162519[_i]
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
  var _arrx []*Cptx
  var _astarr []interface{}
  var _e interface{}
  var _ee *Cptx
  var _f *Cptx
  var _i uint
  var _oo *Cptx
  var _to *Cptx
  var _vt *Cptx
  _oo = ast2cptx(_ast[1].([]interface{}), _def, _local, _func, "")
  _to = typepredx(_oo)
  if(_to._id == _unknownc._id){
    fmt.Println(strx(_oo, 0))
    fmt.Println("cannot typepred obj");debug.PrintStack();os.Exit(1)
  }
  _f = getx(_to, _ast[2].(string))
  if(_f == nil){
    fmt.Println(strx(_oo, 0))
    fmt.Println(strx(_to, 0))
    fmt.Println(_ast[2].(string))
    fmt.Println("no method");debug.PrintStack();os.Exit(1)
  }
  _astarr = _ast[3].([]interface{})
  _vt = getx(_f, "funcVarTypes")
  _arrx = make([]*Cptx, uint(len(_astarr)) + 1)
  _arrx[0] = _oo
  _tmp164432 := _astarr;
  for _i = uint(0); _i < uint(len(_tmp164432)); _i ++ {
    _e = _tmp164432[_i]
    _ee = ast2cptx(_e.([]interface{}), _def, _local, _func, "")
    if(_vt != nil){
      _ee = convertx(_ee, classx((*_vt._arr)[_i + 1]))
    }
    _ee = preExecx(_ee)
    _arrx[_i + 1] = _ee
  }
  if(_f._fraw){
    return callNewx(_f, &_arrx, _callrawc)
  }
  return callNewx(_f, &_arrx, nil)
}
func preAst2blockx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) {
  var _e interface{}
  var _ee []interface{}
  var _eee []interface{}
  var _i uint
  var _idpre string
  _tmp165505 := _ast;
  for _i = uint(0); _i < uint(len(_tmp165505)); _i ++ {
    _e = _tmp165505[_i]
    _ee = _e.([]interface{})
    _eee = _ee[0].([]interface{})
    _idpre = _eee[0].(string)
    if(_idpre == "def"){
      def2cptx(_eee, _def, _local, _func, 1)
    }
  }
  _tmp165890 := _ast;
  for _i = uint(0); _i < uint(len(_tmp165890)); _i ++ {
    _e = _tmp165890[_i]
    _ee = _e.([]interface{})
    _eee = _ee[0].([]interface{})
    _idpre = _eee[0].(string)
    if(_idpre == "def"){
      def2cptx(_eee, _def, _local, _func, 12)
    }
  }
  _tmp166275 := _ast;
  for _i = uint(0); _i < uint(len(_tmp166275)); _i ++ {
    _e = _tmp166275[_i]
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
  _tmp167208 := _ast;
  for _tmp167211 := uint(0); _tmp167211 < uint(len(_tmp167208)); _tmp167211 ++ {
    _e = _tmp167208[_tmp167211]
    _ee = _e.([]interface{})
    _idpre = _ee[0].([]interface{})[0].(string)
    if(uint(len(_ee)) == 2){
      _dicl._dic[_ee[1].(string)] = intNewx(_i, _uintc)
    }
    if(_idpre == "if"){
      _c = if2cptx(_ee[0].([]interface{}), _def, _local, _func, _x)
    }else if(_idpre == "each"){
      _c = each2cptx(_ee[0].([]interface{}), _def, _local, _func, _x)
    }else if(_idpre == "for"){
      _c = for2cptx(_ee[0].([]interface{}), _def, _local, _func, _x)
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
  var _arrx []*Cptx
  var _c *Cptx
  var _callable bool
  var _e interface{}
  var _ee *Cptx
  var _i uint
  var _l uint
  var _r *Cptx
  var _v *Cptx
  if(_il == 0){
    _arrx = make([]*Cptx, uint(len(_asts)))
  }else{
    _arrx = make([]*Cptx, uint(_il))
  }
  _callable = false
  _tmp169399 := _asts;
  for _i = uint(0); _i < uint(len(_tmp169399)); _i ++ {
    _e = _tmp169399[_i]
    _ee = ast2cptx(_e.([]interface{}), _def, _local, _func, "")
    if(_ee._fmid){
      _callable = true
    }
    if(_it == nil){
      _it = typepredx(_ee)
    }
    _arrx[_i] = _ee
  }
  if(!_callable){
    _tmp169853 := _arrx;
    for _i = uint(0); _i < uint(len(_tmp169853)); _i ++ {
      _v = _tmp169853[_i]
      if(_v != nil){
        _arrx[_i] = preExecx(_v)
      }
    }
  }
  _l = uint(len(_arrx))
  if(_il == -1){
    _il = int(_l)
  }
  _c = itemsDefx(_arrc, _it, _il, _callable)
  _r = arrNewx(&_arrx, _c)
  if(_callable){
    _r._fmid = true
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
  _tmp170898 := _asts;
  for _tmp170901 := uint(0); _tmp170901 < uint(len(_tmp170898)); _tmp170901 ++ {
    _eo = _tmp170898[_tmp170901]
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
  if(_il == -1){
    _il = int(uint(len((*_arrx))))
  }
  _c = itemsDefx(_dicc, _it, _il, _callable)
  _r = dicNewx(_dicx, _arrx, _c)
  if(_callable){
    _r._fmid = true
  }
  return _r
}
func ast2jsonx(_asts []interface{}, _def *Cptx, _local *Cptx, _func *Cptx) *Cptx{
  var _arrx *[]*Cptx
  var _callable bool
  var _dicx map[string]*Cptx
  var _e []interface{}
  var _ee *Cptx
  var _eo interface{}
  var _k string
  var _k2 string
  var _key string
  var _r *Cptx
  var _t *Cptx
  var _v *Cptx
  var _vv []interface{}
  _dicx = map[string]*Cptx{
  }
  _arrx = &[]*Cptx{}
  _callable = false
  _tmp172506 := _asts;
  for _tmp172509 := uint(0); _tmp172509 < uint(len(_tmp172506)); _tmp172509 ++ {
    _eo = _tmp172506[_tmp172509]
    _e = _eo.([]interface{})
    _k = _e[1].(string)
    _vv = _e[0].([]interface{})
    _key = _vv[0].(string)
    if(_key == "dic"){
      _vv[0] = "json"
    }else if(_key == "arr"){
      _vv[0] = "jsonarr"
    }
    _ee = ast2cptx(_vv, _def, _local, _func, "")
    _ee = ast2cptx(_vv, _def, _local, _func, "")
    _t = typepredx(_ee)
    if(inClassx(_t, _dicc, nil) && !inClassx(_t, _jsonc, nil)){
      _ee = convertx(_ee, _jsonc)
    }else if(inClassx(_t, _arrc, nil) && !inClassx(_t, _jsonarrc, nil)){
      _ee = convertx(_ee, _jsonarrc)
    }
    if(_ee._fmid){
      _callable = true
    }
    (*_arrx) = append((*_arrx), strNewx(_k, nil))
    _dicx[_k] = _ee
  }
  if(!_callable){
    for _k2, _v = range _dicx {
      _dicx[_k2] = preExecx(_v)
    }
  }
  _r = dicNewx(_dicx, _arrx, _jsonc)
  if(_callable){
    _r._fmid = true
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
func subAst2cptx(_ast []interface{}, _def *Cptx, _local *Cptx, _func *Cptx, _name string) *Cptx{
  var _dic map[string]*Cptx
  var _en *Cptx
  var _il int
  var _it *Cptx
  var _r *Cptx
  var _t string
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
    return blockmain2cptx(_ast, _def, _local, _func, _name)
  }else if(_t == "class" || _t == "classx"){
    return class2cptx(_ast, _def, _local, _func, _name, 0)
  }else if(_t == "alias"){
    return alias2cptx(_ast, _def, _name)
  }else if(_t == "itemdef"){
    return itemdef2cptx(_ast, _def, _name, 0)
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
    return idlocal2cptx(_ast, _def, _local, _func)
  }else if(_t == "idcond"){
    return idNewx(nil, _ast[1].(string), _idcondc)
  }else if(_t == "idlib"){
    return _defmain._dic[_ast[1].(string)]
  }else if(_t == "id"){
    return id2cptx(_ast, _def, _local, _func)
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
  }else if(_t == "handler"){
    return handler2cptx(_ast, _def, _local, _func, _name)
  }else if(_t == "op"){
    return op2cptx(_ast, _def, _local, _func)
  }else if(_t == "itemsget"){
    return itemsget2cptx(_ast, _def, _local, _func, nil)
  }else if(_t == "objget"){
    return objget2cptx(_ast, _def, _local, _func, nil)
  }else if(_t == "return"){
    return return2cptx(_ast, _def, _local, _func)
  }else if(_t == "err"){
    return err2cptx(_ast, _def, _local, _func)
  }else if(_t == "break"){
    return objNewx(_ctrlbreakc, nil)
  }else if(_t == "continue"){
    return objNewx(_ctrlcontinuec, nil)
  }else if(_t == "str"){
    _x = strNewx(_ast[1].(string), nil)
    _x._fast = true
    return _x
  }else if(_t == "byte"){
    _x = intNewx(int([]byte(_ast[1].(string))[0]), _bytec)
    _x._str = _ast[1].(string)
    _x._fast = true
    return _x
  }else if(_t == "bytes"){
    _x = bytesNewx([]byte(_ast[1].(string)), nil)
    _x._fast = true
    return _x
  }else if(_t == "float"){
    _x = floatNewx(_checkErr2(_arg2arr(strconv.ParseFloat(_ast[1].(string), 64)), nil).(float64), nil)
    _x._fast = true
    return _x
  }else if(_t == "int"){
    _x = intNewx(_checkErr2(_arg2arr(strconv.Atoi(_ast[1].(string))), nil).(int), nil)
    _x._fast = true
    return _x
  }else if(_t == "dic"){
    if(uint(len(_ast)) > 2){
      if(_ast[2] != nil){
        _it = classGetx(_def, _ast[2].(string))
      }
      if(_ast[3] != nil){
        _il = _checkErr2(_arg2arr(strconv.Atoi(_ast[3].(string))), nil).(int)
      }
    }
    _x = ast2dicx(_ast[1].([]interface{}), _def, _local, _func, _it, _il)
    _x._fast = true
    return _x
  }else if(_t == "arr"){
    if(uint(len(_ast)) > 2){
      if(_ast[2] != nil){
        _it = classGetx(_def, _ast[2].(string))
      }
      if(_ast[3] != nil){
        _il = _checkErr2(_arg2arr(strconv.Atoi(_ast[3].(string))), nil).(int)
      }
    }
    _x = ast2arrx(_ast[1].([]interface{}), _def, _local, _func, _it, _il)
    _x._fast = true
    return _x
  }else if(_t == "json"){
    _x = json2cptx(_ast, _def, _local, _func)
    _x._fast = true
    return _x
  }else if(_t == "jsonarr"){
  }else if(_t == "obj"){
    _x = obj2cptx(_ast, _def, _local, _func)
    _x._fast = true
    return _x
  }else if(_t == "fs"){
    return _fsv
  }else if(_t == "net"){
    return _netv
  }else if(_t == "stdin"){
    return _stdinv
  }else if(_t == "stdout"){
    return _stdoutv
  }else if(_t == "stderr"){
    return _stderrv
  }else if(_t == "soul"){
    return _soulv
  }else if(_t == "world"){
    return _worldv
  }else if(_t == "main"){
    return _defmain
  }else{
    fmt.Println(_ast)
    fmt.Println("ast2cptx: " + _t + " is not defined");debug.PrintStack();os.Exit(1)
  }
  return nil
}
func progl2cptx(_str string, _def *Cptx, _local *Cptx) *Cptx{
  var _ast []interface{}
  var _r *Cptx
  _ast = _Str_toJsonArr(_osCmd(os.Getenv("HOME") + "/soul2/sl-reader", _str))
  if(uint(len(_ast)) == 0){
    fmt.Println("progl2cpt: wrong grammar");debug.PrintStack();os.Exit(1)
  }
  _r = ast2cptx(_ast, _def, _local, nil, "")
  return _r
}
func _checkErrAndReturn(e error, r interface{}, f func(string, string)bool)interface{}{
 if(e != nil){
  if(f != nil){ 
   if(!f("", e.Error())){
    return r
   }
  }
  log.Fatal(e)
  os.Exit(1)  
 }
 return r
}
func main(){
  var _assignf *Cptx
  var _defsp string
  var _execsp string
  var _fc string
  var _idargassignf *Cptx
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _id2: 0,  
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
  _scopec = classDefx(_defmain, "Scope", &[]*Cptx{_classc}, nil)
  _execmain._obj = _scopec
  _defmain._obj = _scopec
  _nativec = classDefx(_defmain, "Native", nil, nil)
  _midc = classDefx(_defmain, "Mid", nil, nil)
  _aliasc = classDefx(_defmain, "Alias", nil, nil)
  _valc = classDefx(_defmain, "Val", nil, nil)
  _numc = classDefx(_defmain, "Num", &[]*Cptx{_valc}, nil)
  _intc = bnumDefx("Int", _numc)
  _intc._ctype = TINT
  _uintc = bnumDefx("Uint", _intc)
  _floatc = bnumDefx("Float", _numc)
  _floatc._ctype = TFLOAT
  _boolc = bnumDefx("Bool", _uintc)
  _bytec = bnumDefx("Byte", _intc)
  bnumDefx("Int16", _intc)
  bnumDefx("Int32", _intc)
  bnumDefx("Int64", _intc)
  bnumDefx("Uint8", _uintc)
  bnumDefx("Uint16", _uintc)
  bnumDefx("Uint32", _uintc)
  bnumDefx("Uint64", _uintc)
  bnumDefx("Float32", _floatc)
  bnumDefx("Float64", _floatc)
  _numbigc = classDefx(_defmain, "NumBig", &[]*Cptx{_numc, _nativec}, nil)
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id2: 0,  
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
    _fdefmain: false,  
    _fmid: false,  
    _fprop: false,  
    _fraw: false,  
    _fscope: false,  
    _fstatic: false,  
    _id2: 0,  
    _name: "",  
    _str: "",  
  }
  _itemsc = classDefx(_defmain, "Items", nil, map[string]*Cptx{
    "itemsType": _cptc,
  })
  _itemslimitedc = classDefx(_defmain, "ItemsLimited", &[]*Cptx{_itemsc}, map[string]*Cptx{
    "itemsLimitedLen": _uintc,
  })
  _arrc = curryDefx(_defmain, "Arr", _itemsc, nil)
  _arrc._ctype = TARR
  _arrc._fbitems = true
  _arrc._str = _arrc._name
  _staticarrc = curryDefx(_defmain, "StaticArr", _arrc, nil)
  _staticarrc._fbitems = true
  _staticarrc._str = _staticarrc._name
  _dicc = curryDefx(_defmain, "Dic", _itemsc, nil)
  _dicc._ctype = TDIC
  _dicc._fbitems = true
  _dicc._str = _dicc._name
  _bytesc = itemsDefx(_staticarrc, _bytec, 0, false)
  _bytesc._ctype = TBYTES
  _strc = curryDefx(_defmain, "Str", nil, nil)
  _strc._ctype = TSTR
  _arrstrc = itemsDefx(_arrc, _strc, 0, false)
  _dicstrc = itemsDefx(_dicc, _strc, 0, false)
  _dicuintc = itemsDefx(_dicc, _uintc, 0, false)
  _dicclassc = itemsDefx(_dicc, _classc, 0, false)
  _arrclassc = itemsDefx(_arrc, _classc, 0, false)
  _errc = classDefx(_defmain, "Err", &[]*Cptx{_strc}, nil)
  _rawc = classDefx(_defmain, "Raw", &[]*Cptx{_strc}, nil)
  _pathc = classDefx(_defmain, "Path", &[]*Cptx{_strc}, nil)
  _enumc = classDefx(_defmain, "Enum", &[]*Cptx{_uintc}, map[string]*Cptx{
    "enum": _arrstrc,
    "enumDic": _dicuintc,
  })
  _timec = classDefx(_defmain, "Time", &[]*Cptx{_uintc}, nil)
  _jsonc = classDefx(_defmain, "Json", &[]*Cptx{_dicc}, nil)
  _jsonarrc = classDefx(_defmain, "JsonArr", &[]*Cptx{_arrc}, nil)
  _stackc = classDefx(_defmain, "Stack", &[]*Cptx{_arrc}, nil)
  _stackc._fbitems = true
  _queuec = classDefx(_defmain, "Queue", &[]*Cptx{_arrc}, nil)
  _queuec._fbitems = true
  _funcc = classDefx(_defmain, "Func", nil, nil)
  _funcprotoc = classDefx(_defmain, "FuncProto", &[]*Cptx{_funcc}, map[string]*Cptx{
    "funcVarTypes": _arrc,
    "funcReturn": _classc,
  })
  _funcvarsc = classDefx(_defmain, "FuncVars", &[]*Cptx{_funcprotoc}, map[string]*Cptx{
    "funcVars": _arrstrc,
  })
  _funcnativec = classDefx(_defmain, "FuncNative", &[]*Cptx{_funcvarsc, _nativec}, nil)
  _blockc = classDefx(_defmain, "Block", nil, map[string]*Cptx{
    "blockVal": _arrc,
    "blockStateDef": _classc,
    "blockLabels": _dicuintc,
    "blockScope": _classc,
    "blockPath": _strc,
  })
  _blockc._dic["blockParent"] = defx(_blockc, nil)
  _blockmainc = curryDefx(_defmain, "BlockMain", _blockc, nil)
  _signalc = classDefx(_defmain, "Signal", nil, nil)
  _continuec = curryDefx(_defmain, "Continue", _signalc, nil)
  _breakc = curryDefx(_defmain, "Break", _signalc, nil)
  _gotoc = classDefx(_defmain, "Goto", &[]*Cptx{_signalc}, map[string]*Cptx{
    "goto": _uintc,
  })
  _returnc = classDefx(_defmain, "Return", &[]*Cptx{_signalc}, map[string]*Cptx{
    "return": _cptc,
  })
  _funcblockc = classDefx(_defmain, "FuncBlock", &[]*Cptx{_funcc}, map[string]*Cptx{
    "funcBlock": _blockc,
  })
  _funcerrc = classDefx(_defmain, "FuncErr", &[]*Cptx{_funcc}, map[string]*Cptx{
    "funcErrFunc": fpDefx(&[]*Cptx{defx(_errc, nil), defx(_strc, nil)}, _boolc),
  })
  _funcstdc = classDefx(_defmain, "FuncStd", &[]*Cptx{_funcblockc, _funcvarsc, _funcerrc}, nil)
  _handlerc = classDefx(_defmain, "Handler", &[]*Cptx{_funcerrc}, nil)
  _funcclosurec = curryDefx(_defmain, "FuncClosure", _funcstdc, nil)
  _functplc = classDefx(_defmain, "FuncTpl", &[]*Cptx{_funcc}, map[string]*Cptx{
    "funcTplBlock": _blockc,
    "funcTplPath": _strc,
  })
  _channelc = classDefx(_defmain, "Channel", &[]*Cptx{_nativec}, nil)
  _streamc = classDefx(_defmain, "Stream", &[]*Cptx{_nativec}, map[string]*Cptx{
    "streamReadable": _boolc,
    "streamWritable": _boolc,
  })
  _bufferc = classDefx(_defmain, "Buffer", &[]*Cptx{_streamc}, nil)
  _builderstrc = classDefx(_defmain, "BuilderStr", &[]*Cptx{_nativec}, nil)
  _routerc = classDefx(_defmain, "Router", &[]*Cptx{_itemsc}, map[string]*Cptx{
    "itemsType": _bytesc,
    "routerPath": _pathc,
  })
  _routerc._fbitems = true
  _routerrootedc = classDefx(_defmain, "RouterRooted", &[]*Cptx{_routerc}, nil)
  _routerrootedc._dic["routerRoot"] = defx(_routerrootedc, nil)
  _ipc = classDefx(_defmain, "Ip", &[]*Cptx{_pathc}, nil)
  _ip6c = classDefx(_defmain, "Ip6", &[]*Cptx{_ipc}, nil)
  _pathfsc = curryDefx(_defmain, "PathFs", _pathc, nil)
  _dirc = classDefx(_defmain, "Dir", &[]*Cptx{_routerrootedc}, map[string]*Cptx{
    "routerPath": _pathfsc,
  })
  _fsv = defx(_dirc, map[string]*Cptx{
    "routerPath": strNewx("", _pathfsc),
  })
  _fsv._fstatic = true
  _fsv._dic["treeRoot"] = _fsv
  _schemac = curryDefx(_defmain, "Schema", _pathc, nil)
  _dbmsc = classDefx(_defmain, "Dbms", &[]*Cptx{_routerrootedc}, map[string]*Cptx{
    "itemsType": _schemac,
  })
  _procc = classDefx(_defmain, "Proc", &[]*Cptx{_routerc}, nil)
  _netc = classDefx(_defmain, "Net", &[]*Cptx{_routerc}, map[string]*Cptx{
    "routerPath": _ipc,
  })
  _netv = defx(_netc, nil)
  _netv._fstatic = true
  _stdinc = curryDefx(_defmain, "Stdin", _streamc, map[string]*Cptx{
    "streamReadable": boolNewx(true),
  })
  _stdoutc = curryDefx(_defmain, "Stdout", _streamc, map[string]*Cptx{
    "streamWritable": boolNewx(true),
  })
  _stderrc = curryDefx(_defmain, "Stderr", _streamc, map[string]*Cptx{
    "streamWritable": boolNewx(true),
  })
  _stdinv = defx(_stdinc, nil)
  _stdoutv = defx(_stdoutc, nil)
  _stderrv = defx(_stderrc, nil)
  _soulc = classDefx(_defmain, "Soul", nil, map[string]*Cptx{
    "soulIsSelf": _boolc,
    "soulFs": _dirc,
    "soulNet": _netc,
    "soulProc": _procc,
  })
  _soulsubc = curryDefx(_defmain, "SoulSub", _soulc, nil)
  _soulv = defx(_soulc, map[string]*Cptx{
    "soulIsSelf": boolNewx(true),
    "soulFs": _fsv,
    "soulNet": _netv,
  })
  _souldicc = itemsDefx(_dicc, _soulc, 0, false)
  _worldv = defx(_souldicc, nil)
  _soulv._dic["soulWorld"] = _worldv
  dicSetx(_worldv, "self", _soulv)
  _protocolc = classDefx(_defmain, "Protocol", nil, map[string]*Cptx{
    "protocolName": _strc,
    "protocolDefaultPort": _uintc,
  })
  _httpc = curryDefx(_defmain, "Http", _protocolc, map[string]*Cptx{
    "protocolName": strNewx("http", nil),
    "protocolDefaultPort": intNewx(80, _uintc),
  })
  _httpsc = curryDefx(_defmain, "Http", _protocolc, map[string]*Cptx{
    "protocolName": strNewx("https", nil),
    "protocolDefaultPort": intNewx(443, _uintc),
  })
  _serverc = classDefx(_defmain, "Server", nil, nil)
  _clientc = classDefx(_defmain, "Client", nil, nil)
  _reqc = classDefx(_defmain, "Req", &[]*Cptx{_streamc}, nil)
  _respc = classDefx(_defmain, "Resp", &[]*Cptx{_streamc}, nil)
  _serverhttpc = classDefx(_defmain, "ServerHttp", &[]*Cptx{_serverc, _httpc}, nil)
  _clienthttpc = classDefx(_defmain, "ClientHttp", &[]*Cptx{_clientc, _httpc}, nil)
  _handlerhttpc = aliasDefx(_defmain, "HandlerHttp", fpDefx(&[]*Cptx{defx(_reqc, nil), defx(_respc, nil)}, nil))
  _callc = classDefx(_defmain, "Call", &[]*Cptx{_midc}, nil)
  _callc._ctype = TCALL
  _arrcallc = itemsDefx(_arrc, _callc, 0, false)
  _callpassrefc = curryDefx(_defmain, "CallPassRef", _callc, nil)
  _callrawc = curryDefx(_defmain, "CallRaw", _callc, nil)
  _idc = classDefx(_defmain, "Id", nil, nil)
  _callidc = classDefx(_defmain, "CallId", &[]*Cptx{_callc, _idc}, nil)
  _idc._ctype = TID
  _idstatec = classDefx(_defmain, "IdState", &[]*Cptx{_idc, _midc}, map[string]*Cptx{
    "idState": _classc,
  })
  _idlocalc = curryDefx(_defmain, "IdLocal", _idstatec, nil)
  _idparentc = curryDefx(_defmain, "IdParent", _idstatec, nil)
  _idglobalc = curryDefx(_defmain, "IdGlobal", _idstatec, nil)
  _idargc = curryDefx(_defmain, "IdArg", _idc, nil)
  _idclassc = classDefx(_defmain, "IdClass", &[]*Cptx{_idc}, map[string]*Cptx{
    "idVal": _cptc,
  })
  _idcondc = classDefx(_defmain, "IdCond", &[]*Cptx{_idc}, nil)
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
  _ctrlerrc = curryDefx(_defmain, "CtrlErr", _ctrlargsc, nil)
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
  funcDefx(_defmain, "osEnvGet", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(os.Getenv(_o._str), nil)
  }, &[]*Cptx{_strc}, _strc)
  funcDefx(_defmain, "setIndent", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    __indentx = _o._str
    return _nullv
  }, &[]*Cptx{_strc}, nil)
  funcDefx(_defmain, "uid", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return strNewx(strconv.FormatUint(uint64(uidx()), 10), nil)
  }, nil, _strc)
  funcDefx(_defmain, "appendIfExists", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _app *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _app = (*_x)[1]
    if(_o._str == ""){
      return _o
    }
    _o._str = _o._str + _app._str
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
  funcDefx(_defmain, "execNative", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return execx(_l, _env, 0)
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
  funcDefx(_defmain, "getStaticFlag", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return boolNewx(_o._fstatic)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "getMidFlag", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return boolNewx(_o._fmid)
  }, &[]*Cptx{_cptc}, _boolc)
  funcDefx(_defmain, "getClass", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return nullOrx(_o._class)
  }, &[]*Cptx{_cptc}, _classc)
  funcDefx(_defmain, "getPropName", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(_o._str, nil)
  }, &[]*Cptx{_cptc}, _strc)
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
  funcDefx(_defmain, "parseSend", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _l *Cptx
    _l = (*_x)[0]
    return execx(_l, _env, 1)
  }, &[]*Cptx{_cptc}, _cptc)
  funcDefx(_defmain, "keys", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return copyx(arrNewx(_o._arr, _arrstrc))
  }, &[]*Cptx{_dicc}, _arrstrc)
  funcDefx(_defmain, "propGet", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _o *Cptx
    var _s *Cptx
    _o = (*_x)[0]
    _c = (*_x)[1]
    _s = (*_x)[2]
    return nullOrx(propGetx(_o, _c, _s._str))
  }, &[]*Cptx{_classc, _classc, _strc}, _cptc)
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
    _r = mustGetx(_o, _e._str)
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
    return _v
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
  funcDefx(_defmain, "malloc", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _arr []*Cptx
    var _c *Cptx
    var _i *Cptx
    _i = (*_x)[0]
    _c = (*_x)[1]
    _arr = make([]*Cptx, uint(_i._int))
    return arrNewx(&_arr, itemsDefx(_staticarrc, _c, 0, false))
  }, &[]*Cptx{_uintc, _classc}, _staticarrc)
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
      diex("not func", _env)
    }
    return callx(_f, _a._arr, _env)
  }, &[]*Cptx{_cptc, _arrc}, _cptc)
  methodDefx(_cptc, "type", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return classRawx(_o._type)
  }, nil, _classc)
  methodDefx(_cptc, "istype", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _c = (*_x)[1]
    return boolNewx(classRawx(_o._type)._id == _c._id)
  }, &[]*Cptx{_classc}, _classc)
  funcDefx(_defmain, "as", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return _o
  }, &[]*Cptx{_cptc, _cptc}, _cptc)
  funcDefx(_defmain, "type", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_cptc}, _cptc)
  funcDefx(_defmain, "implConvert", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return _o
  }, &[]*Cptx{_cptc, _classc}, _cptc)
  funcDefx(_defmain, "strConvert", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _c = (*_x)[1]
    return strNewx(_o._str, _c)
  }, &[]*Cptx{_cptc, _classc}, _cptc)
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
      if(inClassx(_c, _bytec, nil)){
        _o._str = byte2strx(byte(_o._int))
      }
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
  funcDefx(_defmain, "throw", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    diex(_o._str, _env)
    return _nullv
  }, &[]*Cptx{_errc, _strc}, nil)
  funcDefx(_defmain, "print", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    fmt.Print(_o._str)
    return _nullv
  }, &[]*Cptx{_strc}, nil)
  funcDefx(_defmain, "lg", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    fmt.Print(_o._str)
    return _nullv
  }, &[]*Cptx{_strc}, nil)
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
  methodDefx(_classc, "schema", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _arrx *[]*Cptx
    var _k string
    var _o *Cptx
    _o = (*_x)[0]
    _arrx = &[]*Cptx{}
    _tmp207168 := _Arr_Str_sort(_keys(_o._dic));
    for _tmp207171 := uint(0); _tmp207171 < uint(len(_tmp207168)); _tmp207171 ++ {
      _k = _tmp207168[_tmp207171]
      (*_arrx) = append((*_arrx), strNewx(_k, nil))
    }
    return dicNewx(_o._dic, _arrx, nil)
  }, nil, _dicc)
  methodDefx(_classc, "parents", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return arrNewx(arrCopyx(_o._arr), _arrclassc)
  }, nil, _arrc)
  methodDefx(_classc, "new", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    return defx(_o, _e._dic)
  }, &[]*Cptx{_dicc}, _cptc)
  methodDefx(_aliasc, "getClass", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return aliasGetx(_o)
  }, nil, _classc)
  methodDefx(_objc, "toDic", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _arrx *[]*Cptx
    var _k string
    var _o *Cptx
    _o = (*_x)[0]
    _arrx = &[]*Cptx{}
    _tmp208585 := _Arr_Str_sort(_keys(_o._dic));
    for _tmp208588 := uint(0); _tmp208588 < uint(len(_tmp208585)); _tmp208588 ++ {
      _k = _tmp208585[_tmp208588]
      (*_arrx) = append((*_arrx), strNewx(_k, nil))
    }
    return dicNewx(_o._dic, _arrx, nil)
  }, nil, _dicc)
  methodDefx(_intc, "toStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(strconv.Itoa(_o._int), nil)
  }, &[]*Cptx{_intc}, _strc)
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
  methodDefx(_floatc, "toStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(strconv.FormatFloat(float64(_o._val.(float64)), 'f', -1, 64), nil)
  }, &[]*Cptx{_intc}, _strc)
  methodDefx(_bytec, "toStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(_o._str, nil)
  }, nil, _strc)
  methodDefx(_strc, "len", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _s *Cptx
    _s = (*_x)[0]
    return intNewx(int(uint(len(_s._str))), _uintc)
  }, nil, _uintc)
  methodDefx(_strc, "toBytes", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return bytesNewx([]byte(_o._str), nil)
  }, nil, _bytesc)
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
    _tmp215173 := _xx;
    for _tmp215176 := uint(0); _tmp215176 < uint(len((*_tmp215173))); _tmp215176 ++ {
      _v = (*_tmp215173)[_tmp215176]
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
  methodDefx(_strc, "toJsonArr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _jsonarrc)
  methodDefx(_strc, "toJson", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _jsonc)
  methodDefx(_strc, "toInt", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(_checkErr2(_arg2arr(strconv.Atoi(_o._str)), nil).(int), nil)
  }, nil, _intc)
  methodDefx(_strc, "toUint", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(_checkErr2(_arg2arr(strconv.Atoi(_o._str)), nil).(int), _uintc)
  }, nil, _intc)
  methodDefx(_strc, "toFloat", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return floatNewx(_checkErr2(_arg2arr(strconv.ParseFloat(_o._str, 64)), nil).(float64), nil)
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
  methodDefx(_arrc, "len", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(int(uint(len((*_o._arr)))), _uintc)
  }, nil, _uintc)
  methodDefx(_arrc, "set", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _i *Cptx
    var _o *Cptx
    var _v *Cptx
    _o = (*_x)[0]
    _i = (*_x)[1]
    _v = (*_x)[2]
    if(uint(len((*_o._arr))) <= uint(_i._int)){
      fmt.Println(arr2strx(_o._arr, 0))
      fmt.Println(_i._int)
      fmt.Println("arrset: index out of range");debug.PrintStack();os.Exit(1)
    }
    (*_o._arr)[_i._int] = copyCptFromAstx(_v)
    _o._fdefault = false
    return _v
  }, &[]*Cptx{_uintc, _cptc}, _cptc)
  opDefx(_arrc, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _ct *Cptx
    var _e *Cptx
    var _o *Cptx
    var _r *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    _r = (*_o._arr)[_e._int]
    if(_r == nil){
      _ct = classx(getx(_o, "itemsType"))
      _r = defaultx(_ct)
    }
    return _r
  }, _intc, _cptc, _opgetc)
  methodDefx(_arrc, "toStaticArr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _no *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _no = arrNewx(_o._arr, _o._obj)
    itemsChangeBasicx(_no, _arrc)
    return _no
  }, nil, _arrc)
  opDefx(_arrc, "add", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, _arrc, _arrc, _opaddc)
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
    _tmp222648 := _o._arr;
    for _i = uint(0); _i < uint(len((*_tmp222648))); _i ++ {
      _v = (*_tmp222648)[_i]
      if(_i != 0){
        _s = _s + _sep._str
      }
      _s = _s + _v._str
    }
    return strNewx(_s, nil)
  }, &[]*Cptx{_strc}, _strc)
  methodDefx(_staticarrc, "toArr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _no *Cptx
    var _o *Cptx
    _o = (*_x)[0]
    _no = arrNewx(_o._arr, _o._obj)
    itemsChangeBasicx(_no, _staticarrc)
    return _no
  }, nil, _staticarrc)
  methodDefx(_bytesc, "toStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return strNewx(string(_o._bytes), nil)
  }, nil, _strc)
  methodDefx(_bytesc, "set", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_strc, _bytec}, _bytec)
  opDefx(_bytesc, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _b byte
    var _e *Cptx
    var _o *Cptx
    var _r *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    _b = _o._bytes[_e._int]
    _r = intNewx(int(_b), _bytec)
    _r._str = byte2strx(_b)
    return _r
  }, _intc, _cptc, _opgetc)
  methodDefx(_dicc, "len", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return intNewx(int(uint(len((*_o._arr)))), _uintc)
  }, nil, _uintc)
  opDefx(_dicc, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _e *Cptx
    var _o *Cptx
    var _r *Cptx
    _o = (*_x)[0]
    _e = (*_x)[1]
    _r = _o._dic[_e._str]
    return nullOrx(_r)
  }, _strc, _cptc, _opgetc)
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
    _v = copyCptFromAstx(_v)
    _o._dic[_i._str] = _v
    _o._fdefault = false
    return _v
  }, &[]*Cptx{_strc, _cptc}, _cptc)
  methodDefx(_dicc, "has", func(_x *[]*Cptx, _env *Cptx) *Cptx{
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
  methodDefx(_dicstrc, "values", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return valuesx(_o)
  }, nil, _arrstrc)
  methodDefx(_dirc, "len", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_strc}, _uintc)
  methodDefx(_dirc, "has", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _falsev
  }, &[]*Cptx{_strc}, _boolc)
  opDefx(_dirc, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _s *Cptx
    _o = (*_x)[0]
    _s = (*_x)[1]
    return bytesNewx(_checkErr2(_arg2arr(ioutil.ReadFile(_o._dic["routerPath"]._str + _s._str)), nil).([]byte), nil)
  }, _strc, _bytesc, _opgetc)
  methodDefx(_dirc, "set", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _s *Cptx
    var _v *Cptx
    _o = (*_x)[0]
    _s = (*_x)[1]
    _v = (*_x)[2]
    _checkErr(ioutil.WriteFile(_o._dic["routerPath"]._str + _s._str, _v._bytes, 0666), nil)
    return _v
  }, &[]*Cptx{_strc, _bytesc}, _bytesc)
  methodDefx(_dirc, "sub", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _d string
    var _l uint
    var _np *Cptx
    var _o *Cptx
    var _s *Cptx
    _o = (*_x)[0]
    _d = _o._dic["routerPath"]._str
    _s = (*_x)[1]
    _l = uint(len(_s._str))
    if(_l == 0){
      fmt.Println(_s)
      diex("dir sub", _env)
    }
    if([]byte(_s._str)[_l - 1] != '/'){
      _s._str = _s._str + "/"
    }
    _np = strNewx(_d + _s._str, nil)
    _checkErr(os.MkdirAll(_np._str, 0777), nil)
    _s._obj = _pathfsc
    return objNewx(_dirc, map[string]*Cptx{
      "routerRoot": _o,
      "routerPath": _np,
    })
  }, &[]*Cptx{_strc}, _dirc)
  methodDefx(_dirc, "rm", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _d string
    var _o *Cptx
    var _s *Cptx
    _o = (*_x)[0]
    _d = _o._dic["routerPath"]._str
    _s = (*_x)[1]
    _checkErr(os.Remove(_d + _s._str), nil)
    return _nullv
  }, &[]*Cptx{_strc}, nil)
  methodDefx(_dirc, "open", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_strc, _strc}, _streamc)
  methodDefx(_dirc, "stat", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_strc}, _dicuintc)
  methodDefx(_dirc, "timeMod", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_strc}, _timec)
  methodDefx(_clienthttpc, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_streamc, _dicstrc}, _streamc)
  methodDefx(_clienthttpc, "getStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_strc, _dicstrc}, _strc)
  methodDefx(_clienthttpc, "post", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_strc, _streamc, _dicstrc}, _streamc)
  methodDefx(_clienthttpc, "postStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_strc, _strc, _dicstrc}, _strc)
  methodDefx(_serverhttpc, "listen", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_uintc}, _strc)
  methodDefx(_serverhttpc, "close", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_uintc}, _strc)
  methodDefx(_serverhttpc, "use", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_strc, _handlerhttpc}, _strc)
  methodDefx(_clientc, "send", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_strc, _streamc}, _streamc)
  methodDefx(_jsonc, "toStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _strc)
  methodDefx(_jsonarrc, "toStr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _strc)
  methodDefx(_streamc, "readAll", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, _bytesc)
  methodDefx(_streamc, "write", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_bytesc}, nil)
  methodDefx(_stdoutc, "write", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _s *Cptx
    _s = (*_x)[1]
    fmt.Print(string(_s._bytes))
    return _nullv
  }, &[]*Cptx{_bytesc}, nil)
  methodDefx(_bufferc, "readAll", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    _o = (*_x)[0]
    return bytesNewx(_o._val.(*bytes.Buffer).Bytes(), nil)
  }, nil, _bytesc)
  methodDefx(_bufferc, "write", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _o *Cptx
    var _s *Cptx
    _o = (*_x)[0]
    _s = (*_x)[1]
    _o._val.(*bytes.Buffer).Write(_s._bytes)
    return _nullv
  }, &[]*Cptx{_bytesc}, nil)
  methodDefx(_bufferc, "clear", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, nil, nil)
  methodDefx(_bufferc, "new", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _r *Cptx
    _r = objNewx(_bufferc, nil)
    _r._val = new(bytes.Buffer)
    return _r
  }, nil, _bufferc)
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
    _v = copyCptFromAstx(_v)
    _local._dic[_str] = _v
    return _v
  }, _cptc, _cptc, _opassignc)
  _assignf._fraw = true
  _idargassignf = opDefx(_idargc, "assign", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _i int
    var _l *Cptx
    var _local *Cptx
    var _r *Cptx
    var _v *Cptx
    _l = (*_x)[0]
    _r = (*_x)[1]
    _v = execx(_r, _env, 0)
    _local = _env._dic["envLocal"]
    _i = _l._int
    _v = copyCptFromAstx(_v)
    (*_local._dic["@args"]._arr)[_i] = _v
    return _v
  }, _cptc, _cptc, _opassignc)
  _idargassignf._fraw = true
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
    _o = _l._class._val.(*Cptx)
    _v = copyCptFromAstx(_v)
    _o._dic[_k] = _v
    return _v
  }, _cptc, _cptc, _opassignc)
  _idstateassignf._fraw = true
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
  methodDefx(_soulc, "main", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return nil
  }, nil, nil)
  methodDefx(_scopec, "get", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return nil
  }, nil, nil)
  methodDefx(_classc, "genCall", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _args *[]*Cptx
    var _execsp *Cptx
    var _func *Cptx
    var _o *Cptx
    var _r *Cptx
    _execsp = (*_x)[0]
    _o = (*_x)[1]
    _func = _o._class
    _args = _o._arr
    _r = propGetx(_execsp, _func._class, _func._str)
    if(_r != nil){
      return callx(_r, _args, _env)
    }
    return strNewx("", nil)
  }, &[]*Cptx{_callc}, _strc)
  methodDefx(_soulc, "getCmdArgs", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _aa *[]string
    var _i uint
    var _v string
    if(__osArgs == nil){
      _x = &[]*Cptx{}
      _aa = &os.Args
      _tmp238469 := _aa;
      for _i = uint(0); _i < uint(len((*_tmp238469))); _i ++ {
        _v = (*_tmp238469)[_i]
        if(_i == 0){
          continue
        }
        (*_x) = append((*_x), strNewx(_v, nil))
      }
      __osArgs = arrNewx(_x, _arrstrc)
    }
    return _nullv
  }, nil, _arrstrc)
  methodDefx(_soulc, "exit", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    return _nullv
  }, &[]*Cptx{_intc}, nil)
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
    var _r *Cptx
    var _v *Cptx
    _c = (*_x)[0]
    _tmp240533 := _c._arr;
    for _tmp240536 := uint(0); _tmp240536 < uint(len((*_tmp240533))); _tmp240536 ++ {
      _v = (*_tmp240533)[_tmp240536]
      _r = execx(_v, _env, 0)
      if(inClassx(classx(_r), _signalc, nil)){
        return _r
      }
    }
    return _nullv
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
  execDefx("Str", func(_x *[]*Cptx, _env *Cptx) *Cptx{
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
      _c = itemsDefx(_dicc, classx(_it), 0, false)
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
      _tmp243245 := _o._arr;
      for _i = uint(0); _i < uint(len((*_tmp243245))); _i ++ {
        _v = (*_tmp243245)[_i]
        (*_a) = append((*_a), execx(_v, _env, 0))
      }
      _c = itemsDefx(_arrc, classx(_it), 0, false)
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
  execDefx("CtrlErr", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _args *[]*Cptx
    var _code *Cptx
    var _func *Cptx
    var _msg *Cptx
    var _r *Cptx
    _args = (*_x)[0]._dic["ctrlArgs"]._arr
    _code = (*_args)[0]
    _msg = (*_args)[1]
    _func = (*_args)[2]._dic["funcErrFunc"]
    _r = callx(_func, &[]*Cptx{_code, _msg}, _env)
    if(_r._int != 0){
      return _nullv
    }
    return defx(_returnc, map[string]*Cptx{
      "return": defaultx((*_args)[2]._dic["funcReturn"]),
    })
  })
  execDefx("CtrlIf", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _args *[]*Cptx
    var _c *Cptx
    var _i int
    var _l int
    var _r *Cptx
    _c = (*_x)[0]
    _args = _c._dic["ctrlArgs"]._arr
    _l = int(uint(len((*_args))))
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
    var _ct *Cptx
    var _da *Cptx
    var _i int
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
      _tmp248178 := _da._arr;
      for _tmp248181 := uint(0); _tmp248181 < uint(len((*_tmp248178))); _tmp248181 ++ {
        _kc = (*_tmp248178)[_tmp248181]
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
      _ct = classx(getx(_da, "itemsType"))
      for _i = 0; _i < int(uint(len((*_da._arr)))); _i = _i + 1 {
        _v = (*_da._arr)[_i]
        if(_v == nil){
          _v = defaultx(_ct)
        }
        if(_key != ""){
          _local[_key] = intNewx(_i, _uintc)
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
  execDefx("IdCond", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _k string
    var _l *Cptx
    var _r *Cptx
    _c = (*_x)[0]
    _l = _env._dic["envLocal"]
    _k = "@" + _c._str
    _r = _l._dic[_k]
    return nullOrx(_r)
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
    return nullOrx(_r)
  })
  execDefx("IdArg", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _i int
    var _l *Cptx
    var _r *Cptx
    _c = (*_x)[0]
    _l = _env._dic["envLocal"]
    _i = _c._int
    _r = _l._dic["@args"]
    if(_i < int(uint(len((*_r._arr))))){
      return nullOrx((*_r._arr)[_i])
    }
    return _nullv
  })
  execDefx("IdState", func(_x *[]*Cptx, _env *Cptx) *Cptx{
    var _c *Cptx
    var _k string
    var _o *Cptx
    var _r *Cptx
    _c = (*_x)[0]
    _k = _c._str
    _o = _c._class._val.(*Cptx)
    _r = _o._dic[_k]
    if(_r == nil){
      return _nullv
    }
    return _r
  })
  _osargs = &os.Args
  if(uint(len((*_osargs))) == 1){
    fmt.Println("./soul3 [FILE] [EXECFLAG] [DEFFLAG]")
    os.Exit(0)
  }else{
    _fc = string(_checkErr2(_arg2arr(ioutil.ReadFile((*_osargs)[1])), nil).([]byte))
    _execsp = "main"
    _defsp = "main"
    if(uint(len((*_osargs))) > 2){
      _execsp = (*_osargs)[2]
    }
    if(uint(len((*_osargs))) > 3){
      _defsp = (*_osargs)[3]
    }
    _main = progl2cptx("@env " + _execsp + " | " + _defsp + " {" + _fc + "}'" + (*_osargs)[1] + "'", _defmain, nil)
    execx(_main, _main, 2)
  }
}
