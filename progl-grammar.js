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
			["\\/(\\\\.|[^\\\\/\\s])+\\/", 
			 "yytext = yytext.substr(2, yyleng-3).replace(/\\\\(\\/)/g, '$1'); return 'REGEX';"],
			["\\@`(\\\\.|[^\\\\`])*`", 
			 "yytext = yytext.substr(2, yyleng-3).replace(/\\\\([~\\&])/g, '$1'); return 'TPL';"],
			["@\'(\\\\.|\\.)\'", "yytext = yytext.substr(2, yyleng-3); return 'CHAR'"],
			["`(\\\\.|[^\\\\`])*`",
			 "yytext = yytext.substr(1, yyleng-2).replace(/\\\\`/g, '`'); return 'STR';"], 			
			["\'(\\\\.|[^\\\\\'])*\'|\"(\\\\.|[^\\\\\"])*\"",
			 "yytext = yytext.substr(1, yyleng-2).replace(/\\\\u([0-9a-fA-F]{4})/, function(m, n){ return String.fromCharCode(parseInt(n, 16)) }).replace(/\\\\(.)/g, function(m, n){ if(n == 'n') return '\\n';if(n == 'r') return '\\r';if(n == 't') return '\\t'; if(n == '\\\\') return \"\\\\\\\\\"; return '\'+n;}); return 'STR';"], 
//			["\<[a-zA-Z0-9_\\\/\\s]*\>",
//       "yytext = yytext.replace(/^\<\\s*/, '').replace(/\\s*\>$/, ''); return 'PARENTS';"],
      ["\\\\[\\r\\n;]+", "return"],//allow \ at end of line
			["\\b\\_\\b", "return 'NULL'"],
			["[a-zA-Z_\\$][a-zA-Z0-9_\\$]*", "return 'ID'"],
//			["\\#[0-9]+", "yytext = yytext.substr(1);return 'LOCAL'"],			
			//TODO bignumber
      ["0[0-9]+\\b", "return 'OCT';"],
      ["0[xX][a-fA-F0-9]+\\b", "return 'HEX';"],
      ["\\b{int}{frac}?{exp}?f?\\b", "return 'INT';"],
      ["\\b{int}{frac}?{exp}?u?[slb]?\\b", "return 'FLOAT';"],
			["@if", "return 'IF'"],
			["@else", "return 'ELSE'"],
			["@elif", "return 'ELIF'"],						
			["@return", "return 'RETURN'"],
			["@continue", "return 'CONTINUE'"],
			["@break", "return 'BREAK'"],			
			["@goto", "return 'GOTO'"],	
			["@foreach", "return 'FOREACH'"],		
			["@for", "return 'FOR'"],
			["@each", "return 'EACH'"],
			["@while", "return 'WHILE'"],
			["@error", "return 'ERROR'"],			
			["@include", "return 'INCLUDE'"],
			["@exec", "return 'EXEC'"],
			["@addr", "return 'ADDR'"],
			["@class", "return 'CLASS'"],
			["@scope", "return 'SCOPE'"],
			["@ns", "return 'NS'"],						
			["@true", "return 'TRUE'"],
			["@false", "return 'FALSE'"],			
			["@debug", "return 'DEBUG'"],
			["@run", "return 'RUN'"],			
      ["\\(", "return '('"],
      ["\\)", "return ')'"],
      ["\\[", "return '['"],
      ["\\]", "return ']'"],
      ["\\{", "return '{'"],
      ["\\}", "return '}'"],
			["\\+\\+", "return '++'"],
			["\\-\\-", "return '--'"],
			["\\>\\=", "return '>='"],
			["\\<\\=", "return '<='"],
			["\\=\\>", "return '=>'"],			
			["\\=\\=", "return '=='"],
			["\\!\\=", "return '!='"],
			["\\+\\=", "return '+='"],
			["\\-\\=", "return '-='"],
			["\\*\\=", "return '*='"],
			["\\/\\=", "return '/='"],
			["\\|\\|", "return '||'"],
			["\\&\\&", "return '&&'"],
			["\\#\\#", "return '##'"],
			["\\@\\@", "return '@@'"],						
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
		["right", "=", "+=", "-=", "*=", "/="],
    ["left", "++", "--"],
    ["left", "??"], //8		
    ["left", "||"], //7
    ["left", "&&"], //6
		["left", "==", "!="], //5
		["left", "<", "<=", ">", ">="],	//4
    ["left", "+", "-", "^"], //3
    ["left", "*", "/", "%"],//2
    ["right", "!", "?"], //1
    ["right", "&", "#", "##", "@", "@@", "|", "=>"],
		["left", "(", ")", "[", "]", "{", "}", "."],
	],
  "start": "Start",
//	"parseParams": ["m"],
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
//			
			"Func",			
			"Tpl",
			"ArrX",
			"DicX",
			"Obj",
			"Class",
//
			"Id",
			"Call",
			"ObjGet",
			"ObjGetX",			
			"ItemsGet",			
			"Op",
			"Assign",
			"Exec",
			"BlockMain",
			"Misc",
			["ADDR ( Expr )", "$$ = ['addr', $3]"],
			["( Expr )", "$$ = $2"],
		],		
		Null: "$$ = ['null']",
		Char: "$$ = ['char', $1]",
		Num: [
			["FLOAT", "$$ = ['float', $1]"],
			["INT", "$$ = ['int', $1]"],
			["OCT", "$$ = ['oct', $1]"],
			["HEX", "$$ = ['hex', $1]"],
		],
		Str: "$$ = ['str', $1]",
		Tpl: [
			["TPL", "$$ = ['tpl', $1]"],
			["TPL STR", "$$ = ['tpl', $1, $2]"],
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
      ["{ Elems }", "$$ = $2"],
    ],
		DicX: [
			["Dic", "$$ = ['dic', $1]"],
			["Dic ItemsPostfix", "$$ = ['dic', $1].concat($2)"],
		],
		ItemsPostfix: [
			["ID INT", "$$ = [$1,$2]"],
			["INT ID", "$$ = [$2,$1]"],
			["INT", "$$ = [,$1]"],
			["ID", "$$ = [$1,,]"],
		],
    Block: [
      ["{ }", "$$ = []"],
      ["{ Elems }", "$$ = $2"],
    ],
		BlockMain: [
			["| ID Block", "$$ = ['blockmain', $3, $2]"],
			["| Block", "$$ = ['blockmain', $2, '']"],
			["| ID Block STR", "$$ = ['blockmain', $3, $2, $4]"],
			["| Block STR", "$$ = ['blockmain', $2, '', $3]"],
		],
//		Switch: [
//			["| Ids", "$$ = ['switchdef', $2]"],
//			["EXEC ID", "$$ = ['switchexec', $2]"],			
//		],
		Exec: [
			["EXEC ID Id", "$$ = ['exec', $2, $3]"],
			["EXEC ID BlockMain", "$$ = ['exec', $2, $3]"],
			["EXEC BlockMain", "$$ = ['exec', 'main', $2]"],
		],
		Id: [
			["ID", "$$ = ['id', $1]"],			
			["# ID", "$$ = ['idlocal', $2]"],
			["# INT", "$$ = ['idlocal', $2]"],					
			["ID # ID ", "$$ = ['idlocal', $3, $1]"],
			["ID # INT", "$$ = ['idlocal', $3, $1]"],						
			["## ID", "$$ = ['idglobal', $2]"],
			["ID ## ID ", "$$ = ['idglobal', $3, $1]"],			
		],
		Elem: [
			["Expr", "$$ = [$1]"],
			["Ctrl", "$$ = [$1]"],
			["Include", "$$ = [$1]"],
		  ["KeyColon Expr", "$$ = [$2, $1]"],
		  ["KeyColon , Expr", "$$ = [$3, $1]"],						
		],
		"Ctrl": [
			["If", "$$ = ['if', $1]"],
			["WHILE Expr Block",
			 "$$ = ['for', [, $2, , $3]]"],
			["FOR Expr , Expr , Expr Block",
			 "$$ = ['for', [$2, $4, $6, $7]]"],
			["EACH IdOrNull IdOrNull Expr Block",
			 "$$ = ['each', [$2, $3, $4, $5]]"],
			["RETURN Expr", "$$ = ['return', $2]"],
			["RETURN", "$$ = ['return']"],			
			["BREAK", "$$ = ['break']"],
			["CONTINUE", "$$ = ['continue']"],
			["GOTO ID", "$$ = ['goto', $2]"],
			["ERROR Expr", "$$ = ['error', $2]"],
			["ERROR Expr NUM", "$$ = ['error', $2, $3]"],	
		],
		IdOrNull: [
			["ID", "$$ = $1"],
			["NULL", "$$ = ''"],
		],
		Include: [
			["INCLUDE ID", "$$ = ['include', $2]"],
			["INCLUDE STR", "$$ = ['include', $2]"],
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
			["NUM :", "$$ = $1"],
		],
		Elems: [
      [",", "$$ = [];"],			
      ["Elem", "$$ = [$1];"],
      [", Elem", "$$ = [$2];"],			
      ["Elems , Elem", "$$ = $1; $1.push($3);"],
			["Elems ,", "$$ = $1"],			//allow additional ,;
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
		ObjGetX: [
			["Expr . ( Expr ) # ID", "$$ = ['objgetx', $1, $4, $7]"],
		],
		ItemsGet: [
			["Expr [ Expr ]", "$$ = ['itemsget', $1, $3]"],			
		],
		Getkey: [
			["ID", "$$ = ['str', $1]"],
			["( Expr )", "$$ = $2"],
		],
		"FUNC": [//CLASS? ARGDEF RETURN BLOCK AFTERBLOCK
			["@ FuncArgs Block Block", "$$ = $2.concat([$3,$4,])"],
			["@ FuncArgs Block", "$$ = $2.concat([$3,,])"],	
			["@ FuncArgs", "$$ = $2.concat([,,])"],
			["@ Block Block", "$$ = [,,,$2,$3,]"],
			["@ Block", "$$ = [,,,$2,,]"],
		],
		"FuncArgs": [
			["ID Arg ID", "$$ = [$1, $2, $3,]"],
			["Arg ID", "$$ = [, $1, $2,]"],
			["ID ID", "$$ = [$1, , $2,]"],
			["ID Arg", "$$ = [$1, $2, ,]"],
			["Arg", "$$ = [, $1, ,]"],
			["ID", "$$ = [$1, , ,]"],						
		],
		"Arg": [
			["( )", "$$ = []"],
			["( Argdefs )", "$$ = $2"],
		],
    "Argdefs": [
      ["Argdef", "$$ = [$1]; "],
			["Argdefs , Argdef", "$$ = $1; $1.push($3)"],
    ],
		"Argdef": [
			["ID", "$$ = [$1,,,]"],
			["ID ID", "$$ = [$1, $2,,]"],
			["ID = Expr", "$$ = [$1, , $3]"],
		],
		Call: [
			["Id CallArgs", "$$ = ['call', $1, $2];"],
			["ItemsGet CallArgs", "$$ = ['call', $1, $2];"],
			["Call CallArgs", "$$ = ['call', $1, $2];"],
			["ObjGet CallArgs", "$$ = ['callmethod', $1[1], $1[2], $2];"],
			["ObjGetX CallArgs", "$$ = ['callreflect', $1[1], $1[2], $2];"],			
		],
		Class:[
			["CLASS Ids Dic", "$$ = ['class', $1, $2]"],
			["CLASS Dic", "$$ = ['class', [], $2]"],			
		],
		Ids: [
			["ID", "$$=[$1]"],
			["Ids ID", "$$=$1; $1.push($1)"],			
		],
		Obj: [
			["& ID Dic", "$$ = ['obj', $2, $3];"],
			["& ID", "$$ = ['obj', $2, []];"],
		],
		CallArgs: [
			["( )", "$$ = []"],
			["( Exprs )", "$$ = $2"]
		],
		"Assign": "$$ = ['assign', $1]",
		"ASSIGN": [
			["Expr = Expr", "$$ = [$1, $3]"],
			["Expr += Expr", "$$ = [$1, $3, 'add']"],
			["Expr ++", "$$ = [$1, ['num', '1'], 'add']"],
			["Expr -= Expr", "$$ = [$3, $1, 'subtract']"],
			["Expr --", "$$ = [$1, ['num', '1'], 'subtract']"],
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
		Misc: [
			["TEST", "$$ = ['test']"]
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
