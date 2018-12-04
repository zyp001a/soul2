var jison = require("jison");
var fs = require("fs");
var grammar = {
  "lex": {
		"macros":{},
    "rules": [
			["~=(\\\\.|[^\\\\\~])*~",	"yytext = yytext.substr(2,yyleng-3).replace(/\\\\~/g, '~'); return 'GET';"],
			//			["[\\t ]*~[^=](\\\\.|[^\\\\\~])*~[\\n\\r]*",	"yytext = yytext.replace(/^[\\t ]*~/, '').replace(/~[\\n\\r]*$/, '').replace(/\\\\~/g, '~'); return 'INS';"],
			["~[^=](\\\\.|[^\\\\\~])*~",	"yytext = yytext.replace(/^[\\t ]*~/, '').replace(/~[\\n\\r]*$/, '').replace(/\\\\~/g, '~'); return 'INS';"],			
			//			["~(\\\\.|[^\\\\\~])*~",	"yytext = yytext.substr(1,yyleng-2).replace(/\\\\~/g, '~'); return 'INS';"],
			["\\\\&", "yytext=yytext[1];return 'RAW'"],			
			["\\^[0-9]+", "yytext=yytext.substr(1);return 'EXEC'"],
			["\\^[A-Za-z_][A-Za-z0-9_]*", "yytext=yytext.substr(1);return 'EXEC2'"],			
//			["\\&[A-Z]+", "yytext=yytext.substr(1);return 'MACRO'"],			
			["(\\\\.|[^\\\\\~])", "return 'RAW';"]
		]
	},
  "start": "Start",
//	"parseParams": [""],
  "bnf": {
		"Start": [
			["ES", "return $$ = '|{#$arr = []Str;$arr.push(`' + $1 + '`);@return $arr.join(``);}'"]
		],
		"ES": [
			["E", "$$ = $1"],
			["ES E", "$$ = $1 + $2"],			
		],
		"E": [
			["GET", "$$ = '`);$arr.push(' + $1 + ');$arr.push(`'"],
			["INS", "$$ = '`);' + $1 + ';push(#$arr, `'"],
			["EXEC", "$$ = '`);$arr.push(exec(#' + $1 + ', #$env));$arr.push(`'"],
			["EXEC2", "$$ = '`);$arr.push(exec(#0.' + $1 + ', #$env));$arr.push(`'"],			
//			["MACRO", "$$ = '`);' + $1 + ';push(#$arr, `'"],
			["RAW", "$$ = $1"],
		],
  }
};
var options = {};
var code = new jison.Generator(grammar, options).generate();
var filename = "tpl-parser.js";
fs.writeFileSync(filename, code);


