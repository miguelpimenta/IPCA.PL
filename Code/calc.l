%option noyywrap

%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>    
    #include "calc.tab.h"
    #define YY_DECL int yylex()
%}

DIGIT [0-9]
LETTER [\_A-Za-z]
OPERATOR ["+"|"*"|"/"|"="|"^"|"("|")"]

%%

{DIGIT}+		            { yylval.num = atoi(yytext); return NUMBER; }
{DIGIT}+\,{DIGIT}+ 	        { yylval.num = atoi(yytext); return NUMBER; }
{DIGIT}+\.{DIGIT}+ 	        { yylval.num = atoi(yytext); return NUMBER; }
{OPERATOR}                  { return *yytext; }
"-"                         { return SUB; }
("def")|("DEF")			    { return VAR_KEYWORD; }
("exit")|("EXIT")	        { return QUIT; }
("quit")|("QUIT")	        { return QUIT; }
[\_a-zA-Z0-9]+  			{ yylval.index = add_variable(yytext); return VARIABLE; }
\n                          { return NEWLINE; }
\.      				    { return PREV_VAL; } 
[ \t]					    { }

%%
