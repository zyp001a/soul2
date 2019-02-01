//comm / io / api
Cpt =>{
 origin: Lang
}

tryparse ->(str Bytes, sl Soul)Cpt{
 @each _ parse sl.lang{
  #r = @catch(parse(str), #err)
  @if(!err){
   @return r
  }
 }
 @err1 "cannot parse"
}

do ->Soul(c Class, sl Soul, t Time, r Str){
 #cpt = @catch(tryparse(str, sl), #err)
 #env = Env{
  execScope: @this.ctx
 }
 execx(cpt, env)
 @this.history.push({time: t, rec: r)
}


conn ->Soul{
 @for #r = @this.read() {
  @soul.do(Receive, @this, time(), r)
 }
}
send ->Soul(str Str){
 @soul.do(Send, @this, time(), str)
}
@each _ sl @world{
 @go ->{
  sl.conn()
  tryevolve()
 }()
}

//behavior / decision / mid
execx ->(){
 
}

//express / expectation / out

//assumpt / test / evolve / monitor
//fill goal
//data cumulated
//learn much concept -> new goal (full understanding
tryevolve ->(){
 @each _ g @soul.goals{
  @if(g.filled()){
   
  }
 }
}