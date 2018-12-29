dic2strx ->(d Dicx, i Int)Str{
 #s = "{\n"
 @each k v d{  
  s += indx(k + ":" + strx(v, i+1)) + "\n"
 }
 @return s + "}"
}

arr2strx ->(a Arrx, i Int)Str{
 #s = "["
 @if(a.len() > 1){
  s+="\n"
  @each _ v a{
   s+=indx(strx(v, i+1))+"\n"
  }
 }@else{
  @each _ v a{
   s += strx(v, i+1)
  }
 }
 @return s + "]"
}


parent2strx ->(d Arrx)Str{
 #s = ""
 @each _ v d{
  @if(v.name != ""){
   s+= v.name + " "
  }@else{
   s+= "~" + v.id + " "  
  }
 }
 @return s
}

strx ->(o Cptx, i Int)Str{
 @if(i > 3 && o.id != ""){
  @return "~"+o.id
 }
 T#t = o.type
 @if(t == T##CPT){
  @return "&Cpt"
 }@elif(t == T##OBJ){
  Str#s = "" 
  @if(o.name != ""){
   #s += o.name + " = "
  }@else{
   s += "~" + o.id + " = "
  }

  @if(o.obj.name != ""){
   s += "&"+o.obj.name
  }@else{
   s += "&~" + o.obj.id
  }
//  @if(!o.fdefault){//TODO check fdefault!!!!!!
   s += dic2strx(o.dic, i)
//  }
  @return s
 }@elif(t == T##CLASS){
  Str#s = "" 
  @if(o.name != ""){
   #s += o.name + " = "
  }@else{
   #s += "~"+o.id + " = "  
  }
  s+="@class "+ parent2strx(o.arr)+" "+dic2strx(o.dic, i)  
  @return s
 }@elif(t == T##NULL){
  @return "_"
 }@elif(t == T##INT){
  @return Str(o.int)
 }@elif(t == T##FLOAT){
  @return Str(Float(o.val))
 }@elif(t == T##STR){
  @return '"'+ escapex(o.str) + '"'
 }@elif(t == T##NATIVE){
  @return "&Native"
 }@elif(t == T##CALL){
  @return "CALL"
 }@elif(t == T##FUNC){
  @return "&ValFunc"
 }@elif(t == T##BLOCK){
  @return "&ValFunc"
 }@elif(t == T##DIC){
  @return dic2strx(o.dic, i)
 }@elif(t == T##ARR){
  @return arr2strx(o.arr, i)
 }@else{
  log(o.obj)
  log(o)
  die("cpt2str unknown")
  @return ""
 }
}
