b = &ServerHttp{
 serverPort: 1234
}
b["/"] = ->(req StreamHttp, res StreamHttp){
 req.pipe(res)
}
b.open()

c = &ClientHttp
#res = c.send(@inet["localhost"], "026")
log("res")

b.close()