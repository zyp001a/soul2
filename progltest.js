#!/usr/bin/env node
var fs = require("fs")
var p = require("./progl-parser");
var t = require("./tpl-parser");
var str = fs.readFileSync(process.argv[2]).toString()
console.log(p.parse(str, t.parse, p.parse))
