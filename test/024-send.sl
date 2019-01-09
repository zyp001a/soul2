@"0" >> @fs["a"]
@fs["a"] >> @fs["b"]
@fs["b"] >> #b
log(b)

@"24" >> @fs["a"] >> #b
log(b)

@fs["a"].rm()
@fs["b"].rm()