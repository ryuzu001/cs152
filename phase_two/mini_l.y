%{
void yyerror(char * s);
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
%}

%union{ int num; char* id; }

// from https://www.cs.ucr.edu/~amazl001/teaching/webpages1/token_list_format.html

%start	line
%token	FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN
%left SUB ADD MULT DIV MOD
%left EQ NEQ LT GT LTE GTE
%token SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN
%token <num> NUMBER
%token <id> STRING

%%

line:		FUNCTION	{printf("function here.\n");}
		;

%%

int main(){
	return yyparse();
}
