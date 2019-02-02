%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
%}

%union{
  int		int_val;
  char*		op_val;
}

// from https://www.cs.ucr.edu/~amazl001/teaching/webpages1/token_list_format.html

%start	start_here
%token	FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN
%left SUB ADD MULT DIV MOD
%left EQ NEQ LT GT LTE GTE
%token SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN
%token <int_val> NUMBER
%token <op_val> STRING
%%

start_here:
		test {printf("test");}
test:
		{printf("catch");}


%%

int yyerror(){}



