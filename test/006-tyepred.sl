addx = @(l Int, r Int)Int{
 @return l + r
}
log(addx(addx(0, 2), 3))