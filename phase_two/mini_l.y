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

%start	start
%token	FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN
%token SUB ADD MULT DIV MOD
%token EQ NEQ LT GT LTE GTE
%token SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN
%token <num> NUMBER
%token <ident> IDENT

%%

start:			functions {printf("prog_start -> functions");}
				;
functions:		function functions 
				|
				;
function:		FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY
				;
declarations:	{printf("declarations -> epsilon\n");}
				| declaration SEMICOLON declarations	{printf("declaration SEMICOLON declarations\n");}
				;
declaration:	idents COLON INTEGER 	{printf("declaration -> identifiers COLON INTEGER\n");}
				| idents COLON ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF INTEGER SEMICOLON {printf("declaration -> identifiers COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER");}
				;
idents:			ident {printf("identifiers -> ident\n");}
				| ident COMMA idents	{printf("identifiers -> ident COMMA identifiers\n");}
				;
ident:			IDENT		{printf("ident -> IDENT %s\n", $1);}
				;
number:			NUMBER
				;
statements:		statement statements
				|
				;
statement:		;
			

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
