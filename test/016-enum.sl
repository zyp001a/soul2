T = @enum A B C
#x = T->A
@if(x == T->A){
 log("016")
}
@if(x == T->B){
 log("error")
}