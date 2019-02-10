#code = @env golang {
 server := &ServerHttp
 server.use("/", -->{
  
 })
 s.listen(1234)
}
code.runBg()