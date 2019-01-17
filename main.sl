@load "src/core"
/////24 main func
#osargs = @soul.getCmdArgs()
@if(osargs.len() == 1){
 log("./soul3 [FILE] [EXECFLAG] [DEFFLAG]")
 @soul.exit(0)
}@else{
 Str#fc = @fs[osargs[1]]
 Str#execsp = "main"
 Str#defsp = "main"
 @if(osargs.len() > 2){
  #execsp = osargs[2] 
 }
 @if(osargs.len() > 3){
  #defsp = osargs[3] 
 }
 #main = progl2cptx("@env "+execsp+" | " + defsp + " {"+fc+"}'"+osargs[1]+"'", defmain)
 execx(main, main, 2)
}