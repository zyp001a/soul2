@fs["a"] = "024"
#x = @fs["a"]
log(Str(x))
@fs.rm("a")

#c = @fs.open("b", "w")
c.write("1")
c.close()
#d = @fs.open("b", "r")
#x = d.readAll()
log(Str(x))
@fs.rm("b")

#dir = @fs.sub("test")
dir["a"] = "123"
#y = dir["a"]
log(Str(y))
dir.rm("a")