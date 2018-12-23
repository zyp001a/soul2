var jison = require("jison");
var fs = require("fs");
var str1 = " + $1.replace(/\\^([A-Za-z0-9_]+) *([^\\^]*)\\^/g, function(m, n, o){ return 'call(mustGet(#$env.envExec, `' + n + '`), [' + o +'], #$env)'}) + "
var grammar = {
  "lex": {
		"macros":{},
    "rules": [
//			["~=(\\\\.|[^\\\\\~])+[\\n\\r]~",
//			 "yytext = yytext.substr(2,yyleng-4).replace(/\\\\~/g, '~'); return 'GET';"],			
			["~=(\\\\.|[^\\\\\~])+~",
			 "yytext = yytext.substr(2,yyleng-3).replace(/\\\\~/g, '~'); return 'GET';"],
			["~:(\\\\.|[^\\\\\~])+~[^\\n\\r]*[\\n\\r]+",
			 "yytext = yytext.replace(/~([^~]+)$/g, ',\"$1\"').substr(2).replace(/\\\\~/g, '~'); return 'GET2';"],
			["~(\\\\.|[^\\\\\~])*~",
			 "yytext = yytext.replace(/^[\\t ]*~/, '').replace(/~[\\n\\r]*$/, '').replace(/\\\\~/g, '~'); return 'INS';"],			
			["\\\\&", "yytext=yytext[1];return 'RAW'"],
			["\\^[0-9]+", "yytext=yytext.substr(1);return 'EXEC'"],
			["\\^[A-Za-z_][A-Za-z0-9_]*", "yytext=yytext.substr(1);return 'EXEC2'"],
			["(\\\\.|[^\\\\\~])", "return 'RAW';"]
		]
	},
  "start": "Start",
//	"parseParams": [""],
  "bnf": {
		"Start": [
			["ES", "return $$ = '|{#$str = ``;$str += `' + $1 + '`;}'"]
		],
		"ES": [
			["E", "$$ = $1"],
			["ES E", "$$ = $1 + $2"],			
		],
		"E": [
			["GET", "$$ = '`;$str += ('" + str1 + "');$str += `'"],
			["GET2", "$$ = '`;$str += appendIfExists('" + str1 + "');$str += `'"],			
			["INS", "$$ = '`;'" + str1 + "';$str += `'"],
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


