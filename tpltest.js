#!/usr/bin/env node
var fs = require("fs")
var t = require("./tpl-parser");
var str = fs.readFileSync(process.argv[2]).toString()
console.log(t.parse(str))
