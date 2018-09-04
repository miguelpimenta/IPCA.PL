%{
	/* Bison DEBUG mode */
	#define YYDEBUG 1

	#include "calc.h"	

	/* Flex functions */
	extern int yylex();
	extern int yyparse();
	extern void yyterminate();
	extern FILE* yyin;

	/* Store previous result */
	float pValue = 0;

%}

%union {
	int index;
	double num;
	double prevVal;
}

%token<num> NUMBER
%token<num> SUB
%token<prevVal> PREV_VAL
%token<index> VARIABLE
%token<num> VAR_KEYWORD 
%token QUIT
%token NEWLINE
%type<num> program_input
%type<num> line
%type<num> calculation
%type<prevVal> prevValue
%type<num> expr
%type<num> assignment

%left '+' '-'
%left '*' '/'
%left '^'
%left '(' ')'
%right '='

%start program_input
				
%%
program_input:
	| program_input line
	;
	
line: 
	NEWLINE 				{ printf("|:\n"); }
	| prevValue NEWLINE     { printf("\tResult: %s [Previous Result: %s]\n", ToFraction($1), 
								ToFraction(pValue)); pValue = $1; printf("\n|: "); }
	| calculation NEWLINE  	{ printf("\tResult: %s\n", ToFraction($1)); pValue = $1; 
								printf("\n|: "); }	
	| PREV_VAL NEWLINE      { printf("\tPrevious Result: %s\n", ToFraction(pValue)); 
								printf("\n|: "); }
	| QUIT NEWLINE          { Exit(); }
    ;

calculation: expr	
	| assignment
	;
		
expr: SUB expr					{ $$ = -$2; 												/*DBG*/ DbgOutput2("-", $$); }
    | NUMBER            		{ $$ = $1; 													/*DBG*/ DbgOutput1($1); } 
	| VARIABLE					{ $$ = variableValues[$1]; 									/*DBG*/ DbgOutput2("VAR ", $$); }		
	| '(' expr ')' 				{ if ($2 >= 1 ) { $$ = $2; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutput4("(", $2, ")"); }
	| expr '/' expr     		{ if ($3 == 0) { yyerror("Cant divide by 0\n|: "); return 0; }
									else if ($1 >= 1 && $3 >= 1) { $$ = $1 / $3; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult($1, "/", $3, $$); }                               
	| expr '*' expr     		{ if ($1 >= 1 && $3 >= 1) { $$ = $1 * $3; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult($1, "*", $3, $$); }	
	| expr '+' expr     		{ if ($1 >= 1 && $3 >= 1) { $$ = $1 + $3; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult($1, "+", $3, $$); }
	| expr SUB expr   			{ if ($1 >= 1 && $3 >= 1) { $$ = $1 - $3; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult($1, "-", $3, $$); }
	| expr '^' expr     		{ if ($1 >= 1) { $$ = pow($1, $3); } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult($1, "^", $3, $$); }
    ;

prevValue: PREV_VAL             {                          									/*DBG*/ DbgOutput1(pValue); } 
    | SUB prevValue             { $$ = -$2;                									/*DBG*/ DbgOutput2("-", pValue); }
	| prevValue '/' expr     	{ if ($3 == 0) { yyerror("Cant divide by 0\n|: "); return 0; }
									else if (pValue >= 1 && $3 >= 1) { $$ = pValue / $3; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult(pValue, "/", $3, $$); } 		
	| prevValue '*' expr     	{ if (pValue >= 1 && $3 >= 1) { $$ = pValue * $3; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult(pValue, "*", $3, $$); }
    | prevValue '+' expr     	{ if (pValue >= 1 && $3 >= 1) { $$ = pValue + $3; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult(pValue, "+", $3, $$); }									
    | prevValue SUB expr     	{ if (pValue >= 1 && $3 >= 1) { $$ = pValue - $3; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult(pValue, "-", $3, $$); }
    | prevValue '^' expr    	{ if (pValue >= 1 && $3 >= 1) { $$ = pow($1, $3); } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult(pValue, "^", $3, $$); }


	| expr '/' prevValue     	{ if (pValue == 0) { yyerror("Cant divide by 0\n|: "); return 0; }
									else if ($1 >= 1 && pValue >= 1) { $$ = $1 / pValue; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult($1, "/", pValue, $$); } 		
	| expr '*' prevValue     	{ if ($1 >= 1 && pValue >= 1) { $$ = $1 * pValue; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult($1, "*", pValue, $$); }
    | expr '+' prevValue     	{ if ($1 >= 1 && pValue >= 1) { $$ = $1 + pValue; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult($1, "+", pValue, $$); }									
    | expr SUB prevValue     	{ if ($1 >= 1 && pValue >= 1) { $$ = $1 - pValue; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult($1, "-", pValue, $$); }
    | expr '^' prevValue    	{ if ($1 >= 1 && pValue >= 1) { $$ = pow($1, pValue); } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult($1, "^", pValue, $$); }
									
	| prevValue '/' prevValue   { if (pValue == 0) { yyerror("Cant divide by 0\n|: "); return 0; }
									else if (pValue >= 1) { $$ = pValue / pValue; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult(pValue, "/", pValue, $$); } 		
	| prevValue '*' prevValue   { if (pValue >= 1) { $$ = pValue * pValue; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult(pValue, "*", pValue, $$); }
    | prevValue '+' prevValue   { if (pValue >= 1) { $$ = pValue + pValue; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult(pValue, "+", pValue, $$); }									
    | prevValue SUB prevValue   { if (pValue >= 1) { $$ = pValue - pValue; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult(pValue, "-", pValue, $$); }
    | prevValue '^' prevValue   { if (pValue >= 1) { $$ = pow(pValue, pValue); } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutResult(pValue, "^", pValue, $$); }
	| '(' prevValue ')'         { if (pValue >= 1) { $$ = pValue; } 
                                	else { yyerror("Cant use decimals\n|: "); return 0; } 	/*DBG*/ DbgOutput4("(", pValue, ")"); }
    ;

assignment: 
	VAR_KEYWORD VARIABLE '=' calculation { $$ = $4; set_variable($2, $4); 					/*DBG*/ DbgOutput2("VAR ", $$); }
	;
	
%%

int main(int argc, char **argv)
{
	// Bison Debug
	yydebug = 0; 
	dbgOn = false; 
    yyin = stdin;    
    printf("\e[1;1H\e[2J");
    printf("TP PL 2017/2018 - Calculator\n");
	/*if (strcmp(argv[1], "--bd") == 0) 
	{
		dbgOn = false;
		// Bison Debug
		yydebug = 1; 
		printf("Bison Debug = On\n\n");	
		printf(": ");
	}
	else if (strcmp(argv[1], "--showop") == 0) 
	{
		// Show Operations
		dbgOn = true; 
		printf("Show operations = On\n\n");		
		printf(": ");
	}
	else
	{
		printf(": ");
		do 
    	{ 
        	yyparse();
    	} while(!feof(yyin)); 
	}*/
    printf("|: ");

    do 
    { 
        yyparse();
    } while(!feof(yyin));

    return EXIT_SUCCESS;   
}
