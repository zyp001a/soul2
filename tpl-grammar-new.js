var jison = require("jison");
var fs = require("fs");
var str1 = " + $1.replace(/\\^([A-Za-z0-9_]+) *([^\\^]*)\\^/g, function(m, n, o){ return 'call(mustGet(getExec(), `' + n + '`), [' + o +'])'}) + "
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
			["ES", "$$ = '|{#$buf = &Buffer;$buf.writeStr(`' + $1 + '`);}'; $$= $$.replace(/\\$buf.writeStr(``);/g, ''); return $$"]
		],
		"ES": [
			["E", "$$ = $1"],
			["ES E", "$$ = $1 + $2"],			
		],
		"E": [
			["GET", "$$ = '`);$buf.writeStr('" + str1 + "');$buf.writeStr(`'"],
			["GET2", "$$ = '`);$buf.writeStr(appendIfExists('" + str1 + "'));$buf.writeStr(`'"],			
			["INS", "$$ = '`);'" + str1 + "';$buf.writeStr(`'"],
			["EXEC", "$$ = '`);$buf.writeStr(exec(#' + $1 + '));$buf.writeStr(`'"],
			["EXEC2", "$$ = '`);$buf.writeStr(exec(#0.' + $1 + '));$buf.writeStr(`'"],
			["RAW", "$$ = $1"],
		],
  }
};
var options = {};
var code = new jison.Generator(grammar, options).generate();
var filename = "tpl-parser.js";
fs.writeFileSync(filename, code);


