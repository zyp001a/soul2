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
			["ES", "return $$ = '|{#$str = ``;$str += `' + $1 + '`;@return $str;}'"]
		],
		"ES": [
			["E", "$$ = $1"],
			["ES E", "$$ = $1 + $2"],			
		],
		"E": [
			["GET", "$$ = '`;$str += (' + $1 + ');$str += `'"],
			["INS", "$$ = '`;' + $1 + ';$str += `'"],
			["EXEC", "$$ = '`;$str += exec(#' + $1 + ', #$env);$str += `'"],
			["EXEC2", "$$ = '`);$str += exec(#0.' + $1 + ', #$env);$str += `'"],			
//			["MACRO", "$$ = '`);' + $1 + ';push(#$arr, `'"],
			["RAW", "$$ = $1"],
		],
  }
};
var options = {};
var code = new jison.Generator(grammar, options).generate();
var filename = "tpl-parser.js";
fs.writeFileSync(filename, code);


