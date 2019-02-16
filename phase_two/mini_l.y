%{
void yyerror(char * s);
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
extern int yylex();
 extern int currentLine;
 extern int currentCol;
 FILE * yyin;
%}

%union{ int num; char* ident; }

// from https://www.cs.ucr.edu/~amazl001/teaching/webpages1/token_list_format.html
// https://www.youtube.com/watch?v=__-wUHG2rfM

%start	prog_start
%token	FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN
%token SUB ADD MULT DIV MOD
%token EQ NEQ LT GT LTE GTE
%token SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN
%token <num> NUMBER
%token <ident> IDENT

%%

prog_start:			functions {printf("prog_start -> functions\n");}
				;
functions:			function functions {printf("functions -> function functions\n");}
				|	{printf("functions -> epsilon\n");}
				;
function:			FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {printf("function -> FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY\n");}
				;
declarations:			declaration SEMICOLON declarations	{printf("declarations -> declaration SEMICOLON declarations\n");}
				| {printf("declarations -> epsilon\n");}
				;
declaration:			identifiers COLON INTEGER 	{printf("declaration -> identifiers COLON INTEGER\n");}
				| identifiers COLON ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF INTEGER {printf("declaration -> identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");}
				|
				;
identifiers:			ident {printf("identifiers -> ident\n");}
				| ident COMMA identifiers	{printf("identifiers -> ident COMMA identifiers\n");}
				;
ident:				IDENT		{printf("ident -> IDENT %s\n", $1);}
				;
number:				NUMBER;
statements:			statement SEMICOLON statements	{printf("statements -> statement SEMICOLON statements\n");}
				|	{printf("statements -> epsilon\n");}
				;
statement:			READ vars	{printf("statement -> READ vars\n");}
				| var ASSIGN expression		{printf("statement -> var ASSIGN expression\n");}
				| DO BEGINLOOP statements ENDLOOP WHILE bool_exp {printf("statement -> DO BEGINLOOP statements ENDLOOP WHILE bool_exp\n");}
				| IF bool_exp THEN statements ENDIF	{printf("statement -> IF bool_exp THEN statements ENDIF\n");}
				| IF bool_exp THEN statements ELSE statements ENDIF {printf("statement -> IF bool_exp THEN statements ELSE statements ENDIF\n");}
				| WHILE bool_exp BEGINLOOP statements ENDLOOP {printf("statement -> WHILE bool_exp BEGINLOOP statements ENDLOOP\n");}
				| CONTINUE	{printf("statement -> CONTINUE\n");}
				| WRITE	vars	{printf("statement -> WRITE vars\n");}
				| RETURN expression	{printf("statement -> RETURN expression\n");}
				;
expression:			multiplicative_expression	{printf("expression -> multiplicative_expression\n");}
				| multiplicative_expression ADD expression {printf("expression -> multiplicative_expression ADD multiplicative_expression\n");}
				| multiplicative_expression SUB expression {printf("expression -> multiplicative_expression SUB multiplicative_expression\n");}
				;
multiplicative_expression:	term	{printf("multiplicative_expression -> term\n");}
				| term MOD term	{printf("multiplicative_expression -> term MOD term\n");}
				| term MULT term {printf("multiplicative_expression -> term MULT term\n");}
				;
term:				NUMBER	{printf("term -> NUMBER\n");}
				| var {printf("term -> var\n");}
				| L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");}
				;
vars:				var COMMA vars	{printf("vars -> var COMMA vars\n");}
				| var		{printf("vars -> var\n");}
				;
var:				ident		{printf("var -> ident\n");}
				| ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("var -> ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n");}
				;
bool_exp:			relation_and_exp	{printf("bool_exp -> relation_and_exp\n");}
				| relation_and_exp OR bool_exp	{printf("bool_exp -> relation_and_exp OR relation_and_exp\n");}
				;
relation_and_exp:		relation_exp		{printf("relation_and_exp -> relation_exp\n");}
				| relation_exp AND relation_and_exp {printf("relation_and_exp -> relation_exp AND relation_exp\n");}
				;
relation_exp:			expression comp expression	{printf("relation_exp -> expression comp expression\n");}
				| TRUE				{printf("relation_exp -> TRUE\n");}
				| FALSE				{printf("relation_exp -> FALSE\n");}
				| L_PAREN bool_exp R_PAREN	{printf("relation_exp -> L_PAREN bool_exp R_PAREN\n");}
				| NOT relation_exp		{printf("relation_exp -> NOT relation_exp\n");}
				;
comp:				EQ	{printf("comp -> EQ\n");}
				| NEQ	{printf("comp -> NEQ\n");}
				| LT	{printf("comp -> LT\n");}
				| GT	{printf("comp -> GT\n");}
				| LTE	{printf("comp -> LTE\n");}
				| GTE	{printf("comp -> GTE\n");}
				;
%%

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}
void yyerror(char *msg) {
   printf("** Line %d, position %d: %s\n", currentLine, currentCol, msg);
}
