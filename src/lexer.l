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
"main"                  { return MAIN; }

"in"                    { yylval.id = (char *) strdup(yytext); return INT; }
"flt"                   { yylval.id = (char *) strdup(yytext); return FLOAT; }
"ch"                    { yylval.id = (char *) strdup(yytext); return CHAR; }

"crtCv"                {return CR_CANV;}
"clrCv"                {return CL_CANV;}
"delCv"                {return DL_CANV;}
"drRct"                {return DR_RECT;}
"drLne"                {return DR_LINE;}
"drPix"                {return DR_PIX;}

"fun"                   { return FUN; }
"vo"                    { return VOID; }
"rt"                    { return RETURN; }

"if"                    { return IF; }
"elif"                  { return ELIF; }
"else"                  { return ELSE; }

"wh"                    { return WHILE; }

"rd"                    { return READ; }
"wr"                    { return WRITE; }

{id}                    { yylval.id = (char *) strdup(yytext); return ID; }

[-]?[0-9]+              { yylval.id = (char *) strdup(yytext); return CTE_INT; }
[-]?{digit}+\.{digit}+  { yylval.id = (char *) strdup(yytext); return CTE_FLT; }
[']{letter}|{digit}[']  { yylval.id = (char *) strdup(yytext); return CTE_CHR; }
\"(\\.|[^"\\])*\"       { yylval.id = (char *) strdup(yytext); return CTE_STR; }



\.                      { return DOT; }
","                     { return COMMA; }
":"                     { return CLN; }
";"                     { return SMCLN; }

"+"                     { yylval.id = (char *) strdup(yytext); return ADD; }
"-"                     { yylval.id = (char *) strdup(yytext); return SUB; }
"*"                     { yylval.id = (char *) strdup(yytext); return MULT; }
"/"                     { yylval.id = (char *) strdup(yytext); return DIV; }

">="                    { yylval.id = (char *) strdup(yytext); return G_ET; }
"<="                    { yylval.id = (char *) strdup(yytext); return L_ET; }
"=="                    { yylval.id = (char *) strdup(yytext); return EQ; }
"!="                    { yylval.id = (char *) strdup(yytext); return NEQ; }
">"                     { yylval.id = (char *) strdup(yytext); return GT; }
"<"                     { yylval.id = (char *) strdup(yytext); return LT; }
"="                     { yylval.id = (char *) strdup(yytext); return ASGN; }

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


