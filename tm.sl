@exec {
 Self => Human
 Human => Animal
 read -> Human(s Str){  
 }
 self = &Self
 @for s=read(stdin()) {
  #cpts = self.read(s)
  self.think(cpts)
  self.do(stdout())
 }
}