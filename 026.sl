s = &ServerHttp
s.use("/", ->(in Res, out Resp){
 in.pipe(out)
})
s.listen(1234)


c = &ClientHttp
#res = c.post("localhost:1234", "026")
log(res)

s.close()