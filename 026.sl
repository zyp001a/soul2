b = &ServerHttp{
 serverPort: 1234
}
b.use("/", ->(in StreamHttp, out StreamHttp){
 in.pipe(out)
})
b.open()//b = impl(@inet["localhost:1234"])


c = &ClientHttp
#res = c.send(@inet["localhost:1234"], "026")
log(res)

b.close()