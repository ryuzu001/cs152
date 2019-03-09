%{
%}

%skeleton "lalr1.cc"
%require "3.0.4"
%defines
%define api.token.constructor
%define api.value.type variant
%define parse.error verbose
%locations


%code requires
{
	/* you may need these deader files 
	 * add more header file if you need more
	 */
#include <list>
#include <string>
#include <functional>
	/* define the sturctures using as types for non-terminals */

	/* end the structures for non-terminal types */
}


%code
{
#include "parser.tab.hh"

	/* you may need these deader files 
	 * add more header file if you need more
	 */
#include <sstream>
#include <map>
#include <regex>
#include <set>
yy::parser::symbol_type yylex();

	/* define your symbol table, global variables,
	 * list of keywords or any function you may need here */
	
	/* end of your code */
}

%token <int> INT "num"
%token <std::string> STR "ident"

%token END 0 "end of file";

	/* specify tokens, type of non-terminals and terminals here */
%token	FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN IDENT NUM
	/* end of token specifications */

%%

%start	prog_start;
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
				| identifiers COLON ARRAY L_SQUARE_BRACKET number R_SQUARE_BRACKET OF INTEGER {printf("declaration -> identifiers COLON ARRAY L_SQUARE_BRACKET NUM R_SQUARE_BRACKET OF INTEGER\n");}
				|
				;
identifiers:			ident {printf("identifiers -> ident\n");}
				| ident COMMA identifiers	{printf("identifiers -> ident COMMA identifiers\n");}
				;
ident:				IDENT		{printf("ident -> IDENT\n");}
				;
number:				NUM;
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
				| term DIV term {printf("multiplicative_expression -> term DIV term\n");}
				;
term:				NUM	{printf("term -> NUMBER\n");}
				| var {printf("term -> var\n");}
				| L_PAREN expression R_PAREN {printf("term -> L_PAREN expression R_PAREN\n");}
				| ident L_PAREN expression R_PAREN {printf("term -> ident L_PAREN expression R_PAREN\n");}
				| SUB term	{printf("term -> SUB term\n");}
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
	/* define your grammars here use the same grammars 
	 * you used Phase 2 and modify their actions to generate codes
	 * assume that your grammars start with prog_start
	 */


%%

int main(int argc, char *argv[])
{
	yy::parser p;
	return p.parse();
}

void yy::parser::error(const yy::location& l, const std::string& m)
{
	std::cerr << l << ": " << m << std::endl;
}
