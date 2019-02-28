var jison = require("jison");
var fs = require("fs");
var grammar = {
  "lex": {
    "macros": {
      "int": "-?(?:[0-9]|[1-9][0-9]+)",
      "esc": "\\\\",			
      "exp": "(?:[eE][-+]?[0-9]+)",
      "frac": "(?:\\.[0-9]+)",
      "br": "[\\n\\r;,]+"			
    },
    "rules": [
			["\\/\\*[^\\*]*\\*\\/", "return;"],//COMMENT
			["\\\/\\\/[^\\n\\r]*", "return;"],//COMMENT
			//			["#[^\\n\\r]+[\\n\\r]*", "return;"],
			["\\/(\\\\\\n|\\\\.|[^\\\\/\\s])+\\/", 
			 "yytext = yytext.substr(2, yyleng-3).replace(/\\\\(\\/)/g, '$1'); return 'REGEX';"],
			["\\@`(\\\\\\n|\\\\.|[^\\\\`])*`",
			 "yytext = yytext.substr(2, yyleng-3).replace(/\\\\([~\\&])/g, '$1'); return 'TPL';"],
			["@\'(\\\\\\n|\\\\.|[^\\\\\'])+\'",
			 "yytext = yytext.substr(2, yyleng-3).replace(/\\\\u([0-9a-fA-F]{4})/, function(m, n){ return String.fromCharCode(parseInt(n, 16)) }).replace(/\\\\(.)/, function(m, n){ if(n == 'n') return '\\n';if(n == 'r') return '\\r';if(n == 't') return '\\t'; return n;}); return 'BYTE';"],
			["@\"(\\\\\\n|\\\\.|[^\\\\\"])*\"",
			 "yytext = yytext.substr(2, yyleng-3).replace(/\\\\u([0-9a-fA-F]{4})/g, function(m, n){ return String.fromCharCode(parseInt(n, 16)) }).replace(/\\\\(.)/g, function(m, n){ if(n == 'n') return '\\n';if(n == 'r') return '\\r';if(n == 't') return '\\t'; return n;}); return 'BYTES';"],
			["`(\\\\\\n|\\\\.|[^\\\\`])*`",
			 "yytext = yytext.substr(1, yyleng-2).replace(/\\\\`/g, '`'); return 'STR';"], 			
			["\'(\\\\\\n|\\\\.|[^\\\\\'])*\'|\"(\\\\\\n|\\\\.|[^\\\\\"])*\"",
			 "yytext = yytext.substr(1, yyleng-2).replace(/\\\\u([0-9a-fA-F]{4})/, function(m, n){ return String.fromCharCode(parseInt(n, 16)) }).replace(/\\\\(.)/g, function(m, n){ if(n == 'n') return '\\n';if(n == 'r') return '\\r';if(n == 't') return '\\t'; if(n == '\\n'){return '\\\\n'}; return n;}); return 'STR';"], 
//			["\<[a-zA-Z0-9_\\\/\\s]*\>",
//       "yytext = yytext.replace(/^\<\\s*/, '').replace(/\\s*\>$/, ''); return 'PARENTS';"],
      ["\\\\{br}", "return"],//allow \ at end of line

			["@soul", "return 'SOUL'"],
			["@world", "return 'WORLD'"],			
			
			["@main", "return 'MAIN'"],			
			
			["@true", "return 'TRUE'"],
			["@false", "return 'FALSE'"],

			["@enum", "return 'ENUM'"],
			["@union", "return 'UNION'"],						
			["@type", "return 'TYPE'"],
			
			["@if", "return 'IF'"],
			["@else", "return 'ELSE'"],
			["@elif", "return 'ELIF'"],
			["@for", "return 'FOR'"],
			["@each", "return 'EACH'"],
			["@switch", "return 'SWITCH'"],
			["@case", "return 'CASE'"],						
			
			["@return", "return 'RETURN'"],
			["@continue", "return 'CONTINUE'"],
			["@break", "return 'BREAK'"],			
			["@goto", "return 'GOTO'"],
			
			["@env", "return 'ENV'"],
						
			["@load", "return 'LOAD'"],
//TODO addr
			["@addr", "return 'ADDR'"],			
			
//OS
			["@proc", "return 'PROC'"],			
			["@fs", "return 'FS'"],
//NET			
			["@net", "return 'NET'"],
			["@http", "return 'HTTP'"],
			["@https", "return 'HTTPS'"],						
			["@dir", "return 'DIR'"],
			["@pwd", "return 'PWD'"],
			
			["@stdin", "return 'STDIN'"],
			["@stdout", "return 'STDOUT'"],
			["@stderr", "return 'STDERR'"],			

			//CONCURRENCY
			["@go", "return 'GO'"],
			["@wait", "return 'WAIT'"],

			//ERR
			["@err[0-9a-zA-Z_]*\\b", "yytext = yytext.substr(4); return 'ERR'"],
			["@catch", "return 'CATCH'"],
			["@malloc", "return 'MALLOC'"],
			
			["@plugin", "return 'PLUGIN'"],						
			["@debug", "return 'DEBUG'"],

			["@suspend", "return 'SUSPEND'"],//Ctrl-Z
			["@resume", "return 'RESUME'"], //fg/bg			
			["@exit", "return 'EXIT'"], //kill
			["@forceexit", "return 'FORCEEXIT'"],//kill -9
			
			["@on", "return 'ON'"],
			["@syn", "return 'SYN'"],//for three way handshake
			["@synack", "return 'SYNACK'"],
			["@ack", "return 'ACK'"],

			["@ok", "return 'OK'"], //200
			
			["@redirect", "return 'REDIRECT'"],//201
			["@cached", "return 'CACHED'"], //304
			["@notfound", "return 'NOTFOUND'"], //404
			
			["@timeout", "return 'TIMEOUT'"], 
			
			["\\b\\_\\b", "return 'NULL'"],
			["[a-zA-Z_\\$][a-zA-Z0-9_\\$]*", "return 'ID'"],
//			["\\#[0-9]+", "yytext = yytext.substr(1);return 'LOCAL'"],			
			//TODO bignumber
      ["{int}{frac}{exp}?u?[slb]?\\b", "return 'FLOAT';"],			
      ["{int}{exp}?f?\\b", "return 'INT';"],
      ["0[0-9]+\\b", "return 'OCT';"],
      ["0[xX][a-fA-F0-9]+\\b", "return 'HEX';"],


      ["\\(", "return '('"],
      ["\\)", "return ')'"],
      ["\\[", "return '['"],
      ["\\]", "return ']'"],
      ["\\{", "return '{'"],
      ["\\}", "return '}'"],
			["\\-\\-\\>", "return '-->'"],//handler (speical func)
			["\\=\\=\\>", "return '==>'"],//special class
			["\\+\\+", "return '++'"],
			["\\-\\-", "return '--'"],
			["\\>\\=", "return '>='"],
			["\\<\\=", "return '<='"],
			["\\=\\>", "return '=>'"],
			["\\-\\>", "return '->'"],
			["\\<\\<", "return '<<'"],
			["\\=\\=", "return '=='"],
			["\\!\\=", "return '!='"],
			["\\+\\=", "return '+='"],
			["\\-\\=", "return '-='"],
			["\\*\\=", "return '*='"],
			["\\/\\=", "return '/='"],
			["\\:\\=", "return ':='"],			
			["\\|\\|", "return '||'"],
			["\\&\\&", "return '&&'"],
			["\\#\\#", "return '##'"],
			["\\@\\@", "return '@@'"],
			["\\.\\.\\.", "return '...'"],			
      ["\\#", "return '#'"],			
      ["\\>", "return '>'"],
      ["\\<", "return '<'"],
      ["\\&", "return '&'"],
      ["\\@", "return '@'"],
			["\\!", "return '!'"],
			["\\~", "return '~'"],			
			["=", "return '='"],
			["\\+", "return '+'"],
			["\\-", "return '-'"],
			["\\^", "return '^'"],
			["\\*", "return '*'"],
			["\\/", "return '/'"],
			["\\%", "return '%'"],
			["\\:", "return ':'"],
			["\\?", "return '?'"],
			["\\.", "return '.'"],
			["\\|", "return '|'"],			
			["{br}", "return ','"],
			
			[".", "return"]
    ]
  },
	"operators": [
		["right", "<<"],		
		["right", "=", "+=", "-=", "*=", "/=", ":="],
    ["left", "++", "--"],
    ["left", "??"], //8
    ["left", "||"], //7
    ["left", "&&"], //6
		["left", "==", "!="], //5
		["left", "<", "<=", ">", ">="],	//4
    ["left", "+", "-", "^"], //3
    ["left", "*", "/", "%"],//2
    ["right", "!", "?"], //1
    ["right", "&", "#", "@", "@@", "|", "->", "=>", "==>", "-->", "ON"],
		["left", "(", ")", "[", "]", "{", "}", "."],		
	],
  "start": "Start",
	"parseParams": ["lib"],
  "bnf": {
		Start: [
			["Expr", "return $$= $1"],
			["Expr ,", "return $$ = $1"],
		],
		Expr: [
			"Null",
			"True",
			"False",
			
			"Char",
			"Num",
			"Str",
			"Byte",
			"Bytes",
//			
			"Func",
			"Handler",			

			"ArrX",
			"DicX",
			"Obj",
			"Json",
			"JsonArr",			
//
			"Mid",
			
			"Assign",
			"Def",	
			"Env",
			"BlockMain",
			"EnumGet",

			"Keyword",
			["ADDR ( Expr )", "$$ = ['addr', $3]"],
			["( Expr )", "$$ = $2"],
		],
		Mid: [
			"Id",
			"Call",
			"ObjGet",
			"ItemsGet",			
			"Op",
			"On"
		],
		Null: "$$ = ['null']",
		True: "$$ = ['true']",
		False: "$$ = ['false']",		
		Char: "$$ = ['char', $1]",
		Num: [
			["FLOAT", "$$ = ['float', $1]"],
			["INT", "$$ = ['int', $1]"],
			["OCT", "$$ = ['oct', $1]"],
			["HEX", "$$ = ['hex', $1]"],
		],
		Str: "$$ = ['str', $1]",
		Byte: "$$ = ['byte', $1]",
		Bytes: "$$ = ['bytes', $1]",
		Tpl: [
			["TPL", "$$ = ['tpl', JSON.stringify(lib.proglparse(lib.tplparse($1)))]"],
			["TPL STR", "$$ = ['tpl', JSON.stringify(lib.proglparse(lib.tplparse($1))), $2]"],
		],
		Func: "$$ = ['func', $1]",
		Arr: [
			["[ ]", "$$ = []"],
			["[ Exprs ]", "$$ = $2"],
		],
		ArrX: [
			["Arr", "$$ = ['arr', $1]"],
			["Arr ItemsPostfix", "$$ = ['arr', $1].concat($2)"],
		],
    Dic: [
      ["{ }", "$$ = []"],
      ["{ Sentences }", "$$ = $2"],
    ],
		DicX: [
			["Dic", "$$ = ['dic', $1]"],
			["Dic ItemsPostfix", "$$ = ['dic', $1].concat($2)"],
		],
		Json: [
			["@ Dic", "$$ = ['json', $2]"],			
		],
		JsonArr: [
			["@ Arr", "$$ = ['jsonarr', $2]"],						
		],
		ItemsPostfix: [
			["ID INT", "$$ = [$1,$2]"],
			["INT ID", "$$ = [$2,$1]"],
			["INT", "$$ = [,$1]"],
			["ID", "$$ = [$1,,]"],
		],
    Block: [
      ["{ }", "$$ = []"],
      ["{ Sentences }", "$$ = $2"],
    ],
		BlockMain: [
			["| ID Block", "$$ = ['blockmain', lib.load($3), $2]"],
			["| Block", "$$ = ['blockmain', lib.load($2), '']"],
			["| ID Block STR", "$$ = ['blockmain', lib.load($3,$4), $2, $4]"],
			["| Block STR", "$$ = ['blockmain', lib.load($2,$3), '', $3]"],
		],
//		Switch: [
//			["| Ids", "$$ = ['switchdef', $2]"],
//			["EXEC ID", "$$ = ['switchexec', $2]"],			
//		],
		Env: [
//			["ENV ID ID", "$$ = ['env', $2, ['idlib', $3]]"],
			["ENV ID BlockMain", "$$ = ['env', $2, $3]"],
			["ENV BlockMain", "$$ = ['env', 'main', $2]"],
			["ENV Block", "$$ = ['env', 'main', ['blockmain', $2, 'main']]"],			
		],
		Id: [
			["ID", "$$ = ['id', $1]"],			
			["# ID", "$$ = ['idlocal', $2]"],
			["# INT", "$$ = ['idlocal', $2]"],					
			["ID # ID ", "$$ = ['idlocal', $3, $1]"],
			["ID # INT", "$$ = ['idlocal', $3, $1]"],
			["@@ ID", "$$ = ['idcond', $2]"],			
		],
		Sentence: [
			["SubSentence", "$$ = [$1]"],
		  ["KeyColon SubSentence", "$$ = [$2, $1]"],
		  ["KeyColon , SubSentence", "$$ = [$3, $1]"],			
		],
		SubSentence: [
			"Expr",
			"Ctrl",
			"Load",
		],
		Ctrl: [
			["If", "$$ = ['if', $1]"],
			["SWITCH Block", "$$ = ['switch', $2]"],
			["FOR Expr Block",
			 "$$ = ['for', [, $2, , $3]]"],
			["FOR Expr , Expr , Expr Block",
			 "$$ = ['for', [$2, $4, $6, $7]]"],
			["FOR ( Expr , Expr , Expr ) Block",
			 "$$ = ['for', [$3, $5, $7, $9]]"],
			["EACH IdOrNull IdOrNull Expr Block",
			 "$$ = ['each', [$2, $3, $4, $5]]"],
			["RETURN Expr", "$$ = ['return', $2]"],
			["RETURN", "$$ = ['return']"],			
			["BREAK", "$$ = ['break']"],
			["CONTINUE", "$$ = ['continue']"],
			["GOTO ID", "$$ = ['goto', $2]"],
			["ERR Expr", "$$ = ['err', $1, $2]"],
			["ERR", "$$ = ['err', $1]"],
		],
		IdOrNull: [
			["ID", "$$ = $1"],
			["NULL", "$$ = ''"],
		],
		Load: [
			["LOAD STR", "$$ = ['load', $2]"],
		],
		If: [
			["IF Expr BlockOrPre", "$$ = [$2, $3]"],
			["If ELIF Expr BlockOrPre", "$$ = $1; $1.push($3); $1.push($4)"],
			["If ; ELIF Expr BlockOrPre", "$$ = $1; $1.push($4); $1.push($5)"],			
			["If ELSE BlockOrPre", "$$ = $1; $1.push($3)"],
			["If ; ELSE BlockOrPre", "$$ = $1; $1.push($4)"],			
		],
		BlockOrPre: [
			["Block", "$$ = ['block', $1]"],
			["; Block", "$$ = ['block', $2]"],
		],
		KeyColon: [
			["ID :", "$$ = $1"],
			["STR :", "$$ = $1"],
			["INT :", "$$ = $1"],
			[":", "$$ = ''"],			
		],
		Sentences: [
      [",", "$$ = [];"],			
      ["Sentence", "$$ = [$1];"],
      [", Sentence", "$$ = [$2];"],			
      ["Sentences , Sentence", "$$ = $1; $1.push($3);"],
			["Sentences ,", "$$ = $1"],			//allow additional ,;
		],		
		Exprs: [
      [",", "$$ = [];"],			
      ["Expr", "$$ = [$1];"],
      [", Expr", "$$ = [$2];"],			
      ["Exprs , Expr", "$$ = $1; $1.push($3);"],
			["Exprs ,", "$$ = $1"],			//allow additional ,;
		],
		ObjGet: [
			["Expr . ID", "$$ = ['objget', $1, $3]"],
		],
		ItemsGet: [
			["Expr [ Expr ]", "$$ = ['itemsget', $1, $3]"],
			["Expr [ Expr : Expr ]", "$$ = ['itemsrange', $1, $3, $5]"],
			["Expr [ : Expr ]", "$$ = ['itemsrange', $1, , $4]"],
			["Expr [ Expr : ]", "$$ = ['itemsrange', $1, $3, ,]"],									
		],
		Getkey: [
			["ID", "$$ = ['str', $1]"],
			["( Expr )", "$$ = $2"],
		],
		FUNC: [//CLASS? ARGDEF RETURN BLOCK ERRFUNC
//			["-> FuncArgs Block Block", "$$ = $2.concat([$3,$4,])"],
			["-> FuncArgs Block Id", "$$ = $2.concat([$3,$4,])"],
			["-> FuncArgs Block", "$$ = $2.concat([$3,,])"],	
//			["-> Block Block", "$$ = [,[],,$2,$3,]"],
			["-> Block Id", "$$ = [,[],,$2,$3,]"],			
			["-> Block", "$$ = [,[],,$2,,]"],
		],
		FuncProto: [
			["-> FuncArgs", "$2[1].forEach(function(e){e[1]=e[0];e[0]=''}); $$ = ['funcproto', $2]"],			
		],
		FuncArgs: [
			["* ID Arg ID", "$$ = [$2, $3, $4,]"],
			["Arg ID", "$$ = ['', $1, $2,]"],
			["* ID ID", "$$ = [$2, [], $3,]"],
			["* ID Arg", "$$ = [$2, $3, ,]"],
			["Arg", "$$ = ['', $1, ,]"],
			["* ID", "$$ = [$2, [], ,]"],
			["ID", "$$ = ['', [], $1,]"],									
		],
		"Arg": [
			["( )", "$$ = []"],
			["( Argdefs )", "$$ = $2"],
		],
    "Argdefs": [
      ["Argdef", "$$ = [$1]; "],
			["Argdefs , Argdef", "$$ = $1; $1.push($3)"],
			["Argdefs , ...", "$$ = $1; $1.push(['', 'Variadic', ,])"],
			["...", "$$ = [['', 'Variadic', ,]]"],
    ],
		"Argdef": [
			["ID", "$$ = [$1,'Unknown',,]"],
			["ID ID", "$$ = [$1, $2,,]"],
			["ID = Expr", "$$ = [$1, , $3]"],
		],
		Call: [
			["Id CallArgs", "$$ = ['call', $1, $2];"],
			["KeywordFunc CallArgs", "$$ = ['call', $1, $2];"],			
			["ItemsGet CallArgs", "$$ = ['call', $1, $2];"],
			["Call CallArgs", "$$ = ['call', $1, $2];"],
			["ObjGet CallArgs", "$$ = ['callmethod', $1[1], $1[2], $2];"],
		],
		Class:[
			["=> * ID Ids Dic", "$$ = ['class', [$3, $4, $5]]"],
			["=> * ID Dic", "$$ = ['class', [$3, [], $4]]"],
			["=> Ids Dic", "$$ = ['class', ['', $2, $3]]"],			
			["=> Dic", "$$ = ['class', ['', [], $2]]"],
			["==> * ID Ids Dic", "$$ = ['class', [$3, $4, $5, '']]"],
			["==> * ID Dic", "$$ = ['class', [$3, [], $4, '']]"],
			["==> Ids Dic", "$$ = ['class', ['', $2, $3, '']]"],			
			["==> Dic", "$$ = ['class', ['', [], $2, '']]"],
		],
		Ids: [
			["ID", "$$=[$1]"],
			["Ids ID", "$$=$1; $1.push($2)"],			
		],
		Obj: [
			["& ID Dic", "$$ = ['obj', $2, $3];"],
			["& ID", "$$ = ['obj', $2, []];"],
		],
		CallArgs: [
			["( )", "$$ = []"],
			["( Exprs )", "$$ = $2"]
		],
		Def: [
			["ID := Expr", "$$ = ['def', $1, $3]"],
			["ID := Class", "$$ = ['def', $1, $3]"],
			["ID := Enum", "$$ = ['def', $1, $3]"],
			["ID := Tpl", "$$ = ['def', $1, $3]"],
			["ID Class", "$$ = ['def', $1, $2]"],
			["ID Func", "$$ = ['def', $1, $2]"],
			["ID := Type", "$$ = ['def', $1, $3]"],
			["ID FuncProto", "$$ = ['def', $1, $2]"],
			["ID Handler", "$$ = ['def', $1, $2]"],			
		],
		Type: [
			["TYPE ID", "$$= ['alias', $2]"],
			["TYPE ID ID", "$$= ['itemdef', $2, $3]"],
		],
		ClassId: [
			["ID", "$$ = $1"],
			["ID @ ID", "$$ = $1"],
		],
		Assign: "$$ = ['assign', $1]",
		ASSIGN: [
			["Expr = Expr", "$$ = [$1, $3]"],
			["Expr += Expr", "$$ = [$1, $3, 'add']"],
			["Expr ++", "$$ = [$1, ['int', '1'], 'add']"],
			["Expr -= Expr", "$$ = [$3, $1, 'subtract']"],
			["Expr --", "$$ = [$1, ['int', '1'], 'subtract']"],
			["Expr *= Expr",  "$$ = [$1, $3, 'multiply']"],
			["Expr /= Expr",  "$$ = [$1, $3, 'divide']"],
		],
		"Op": "$$ = ['op', $1[0], $1[1]]",
		"OP": [
			["! Expr", "$$ = ['not', [$2]]"],
			["Expr + Expr", "$$ = ['add', [$1, $3]]"],
			["Expr - Expr", "$$ = ['subtract', [$1, $3]]"],
			["Expr * Expr", "$$ = ['multiply', [$1, $3]]"],
			["Expr / Expr", "$$ = ['divide', [$1, $3]]"],
			["Expr % Expr", "$$ = ['mod', [$1, $3]]"],      
			["Expr >= Expr", "$$ = ['ge', [$1, $3]]"],
			["Expr <= Expr", "$$ = ['le', [$1, $3]]"],
			["Expr == Expr", "$$ = ['eq', [$1, $3]]"],
			["Expr != Expr", "$$ = ['ne', [$1, $3]]"],
			["Expr > Expr", "$$ = ['gt', [$1, $3]]"],
			["Expr < Expr", "$$ = ['lt', [$1, $3]]"],
			["Expr && Expr", "$$ = ['and', [$1, $3]]"],
			["Expr || Expr", "$$ = ['or', [$1, $3]]"],
		],
		Enum:[
			["ENUM Ids", "$$ = ['enum', $2]"],
		],
		EnumGet: [
			["ID ## ID", "$$ = ['enumget', $1, $3]"],
		],
		Keyword: [
			["FS", "$$ = ['fs']"],
			["NET", "$$ = ['net']"],
			["PROC", "$$ = ['proc']"],
			["STDIN", "$$ = ['stdin']"],
			["STDOUT", "$$ = ['stdout']"],
			["STDERR", "$$ = ['stderr']"],			
			["SOUL", "$$ = ['soul']"],
			["WORLD", "$$ = ['world']"],			
			["MAIN", "$$ = ['main']"],			
		],
		KeywordFunc: [
			["MALLOC", "$$ = ['idlib', 'malloc']"],
			["CATCH", "$$ = ['idlib', 'catch']"],						
		],
		Handler: "$$ = ['handler', $1]",		
		HANDLER: [
			["--> Block Id", "$$ = [$2, $3]"],
			["--> Block", "$$ = [$2, ,]"],
		]
  }
};
for(var k in grammar.bnf){
	var v = grammar.bnf[k];
	if(typeof v == "string"){
		grammar.bnf[k] = [[k.toUpperCase(), v]]
		continue;
	}
	for(var k2 in v){
		var v2 = v[k2];
		if(typeof v2 == "string"){
			v[k2] = [v2, "$$ = $1"];
		}
	}
}
var options = {};
var code = new jison.Generator(grammar, options).generate();
var filename = "progl-parser.js";
fs.writeFileSync(filename, code);
