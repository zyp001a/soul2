a -->{
 @in >> @out
 //read ReadStream 
}
b = &ServerHttp{
 serverPort: 1234
}
b["/"] = a
b.open()

c = &ClientHttp
"026" >> c >> b >> #d
//c.bridge(026, tmp)
//b.bridge(tmp, d)
log(d)

