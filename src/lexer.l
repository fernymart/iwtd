%{
    #include <iostream>
    #include <string>
    #include "parser.tab.h"
    int line = 1;
%}

%option noyywrap
%option yylineno

letter [a-zA-Z]
digit [0-9]
digits (digit)+
id {letter}({letter}|{digit})*
whitespace (" " | [\t] | [\n] | [\r])

%%
"program"               { return PROGRAM; }
"var"                   { return VAR; }
"class"                 { return CLASS; }
"->"                    { return INHERIT; }
"main"                  { return MAIN; }

"in"                    { yylval.id = (char *) strdup(yytext); return INT; }
"flt"                   { yylval.id = (char *) strdup(yytext); return FLOAT; }
"st"                    { yylval.id = (char *) strdup(yytext); return STRING; }
"ch"                    { yylval.id = (char *) strdup(yytext); return CHAR; }

"fun"                   { return FUN; }
"vo"                    { return VOID; }
"rt"                    { return RETURN; }

"if"                    { return IF; }
"elif"                  { return ELIF; }
"else"                  { return ELSE; }

"wh"                    { return WHILE; }
"fo"                    { return FOR; }

"rd"                    { return READ; }
"wr"                    { return WRITE; }

{id}                    { yylval.id = (char *) strdup(yytext); return ID; }

[0-9]+                  { return CTE_INT; }
{digits}\.{digits}      { return CTE_FLT; }
[']{letter}|{digit}[']  { return CTE_CHR; }
["].*["]                { return CTE_STR; }



\.                      { return DOT; }
","                     { return COMMA; }
":"                     { return CLN; }
";"                     { return SMCLN; }

"+"                     { return ADD; }
"-"                     { return SUB; }
"*"                     { return MULT; }
"/"                     { return DIV; }

">="                    { return G_ET; }
"<="                    { return L_ET; }
"=="                    { return EQ; }
"!="                    { return NEQ; }
">"                     { return GT; }
"<"                     { return LT; }
"="                     { return ASGN; }
"<>"                    { return NEQ; }

"("                     { return LP; }
")"                     { return RP; }
"{"                     { return LCB; }
"}"                     { return RCB; }
"["                     { return LSB; }
"]"                     { return RSB; }

"||"                    { return OR; }
"&&"                    { return AND; }

\/\/.*                  ;
[ \t]*                  ;
[\n]                    line++;

%%

// tal vez es necesario agregar estas reglas arriba
// [\t]                    ;*/
// [\n]                    line++;
// {whitespace}            ;


// int yywrap(){
//     return 1;
// }
//
// int main(){
//     while(yylex());
//     return 0;
// }


