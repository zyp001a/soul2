s = &ServerHttp
s.use("/", -->{
 #0.pipe(#1)
})
s.listen(1234)


c = &ClientHttp
#res = c.post("localhost:1234", "026")
log(res)

s.close()