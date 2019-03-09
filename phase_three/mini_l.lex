%{
#include <iostream>
#define YY_DECL yy::parser::symbol_type yylex()
#include "parser.tab.hh"

static yy::location loc;

int currentLine = 1;
int currentCol = 1;
%}

%option noyywrap 

%{
#define YY_USER_ACTION loc.columns(yyleng);
%}

	/* your definitions here */
digit		[0-9]
letter		[a-zA-Z]
number		{digit}*
identifier	{letter}(({letter}|{digit}|[_])*({letter}|{digit}))*	
	/* your definitions end */

%%

%{
loc.step(); 
%}

	/* your rules here */

	/* use this structure to pass the Token :
	 * return yy::parser::make_TokenName(loc)
	 * if the token has a type you can pass the
	 * as the first argument. as an example we put
	 * the rule to return token function.
	 */
[ ]					{currentCol++;}			// ignore spaces
[\t]					{currentCol++;}			// ignore tabs
[\n]					{currentLine++;currentCol = 1;}
"##"[^\n]*				{}			// ignore comments
	
"function"				{currentCol+=8;  return yy::parser::make_FUNCTION(loc);}
"beginparams"				{currentCol+=11; return yy::parser::make_BEGIN_PARAMS(loc);}
"endparams"				{currentCol+=9;  return yy::parser::make_END_PARAMS(loc);}
"beginlocals"				{currentCol+=11; return yy::parser::make_BEGIN_LOCALS(loc);}
"endlocals"				{currentCol+=9;  return yy::parser::make_END_LOCALS(loc);}
"beginbody"				{currentCol+=9;  return yy::parser::make_BEGIN_BODY(loc);}
"endbody"				{currentCol+=7;  return yy::parser::make_END_BODY(loc);}
"integer"				{currentCol+=7;  return yy::parser::make_INTEGER(loc);}
"array"					{currentCol+=5;  return yy::parser::make_ARRAY(loc);}
"of"					{currentCol+=2;  return yy::parser::make_OF(loc);}
"if"					{currentCol+=2;  return yy::parser::make_IF(loc);}
"then"					{currentCol+=4;  return yy::parser::make_THEN(loc);}
"endif"					{currentCol+=5;  return yy::parser::make_ENDIF(loc);}
"else"					{currentCol+=4;  return yy::parser::make_ELSE(loc);}
"while"					{currentCol+=5;  return yy::parser::make_WHILE(loc);}
"do"					{currentCol+=2;  return yy::parser::make_DO(loc);}
"beginloop"				{currentCol+=9;  return yy::parser::make_BEGINLOOP(loc);}
"endloop"				{currentCol+=7;  return yy::parser::make_ENDLOOP(loc);}
"continue"				{currentCol+=8;  return yy::parser::make_CONTINUE(loc);}
"read"					{currentCol+=4;  return yy::parser::make_READ(loc);}
"write"					{currentCol+=5;  return yy::parser::make_WRITE(loc);}
"and"					{currentCol+=3;  return yy::parser::make_AND(loc);}
"or"					{currentCol+=2;  return yy::parser::make_OR(loc);}
"not"					{currentCol+=3;  return yy::parser::make_NOT(loc);}
"true"					{currentCol+=4;  return yy::parser::make_TRUE(loc);}
"false"					{currentCol+=5;  return yy::parser::make_FALSE(loc);}
"return"				{currentCol+=6;  return yy::parser::make_RETURN(loc);}

"-"					{currentCol++;   return yy::parser::make_SUB(loc);}
"+"					{currentCol++;   return yy::parser::make_ADD(loc);}
"*"					{currentCol++;   return yy::parser::make_MULT(loc);}
"/"					{currentCol++;   return yy::parser::make_DIV(loc);}
"%"					{currentCol++;   return yy::parser::make_MOD(loc);}

"=="					{currentCol+=2;  return yy::parser::make_EQ(loc);}
"<>"					{currentCol+=2;  return yy::parser::make_NEQ(loc);}
"<"					{currentCol++;   return yy::parser::make_LT(loc);}
">"					{currentCol++;   return yy::parser::make_GT(loc);}
"<="					{currentCol+=2;  return yy::parser::make_LTE(loc);}
">="					{currentCol+=2;  return yy::parser::make_GTE(loc);}
	
{identifier}				{return yy::parser::make_IDENT(loc);}
{number}				{return yy::parser::make_NUM(loc);}

";"					{currentCol++;  return yy::parser::make_SEMICOLON(loc);}
":"					{currentCol++;  return yy::parser::make_COLON(loc);}
","					{currentCol++;  return yy::parser::make_COMMA(loc);}
"("					{currentCol++;  return yy::parser::make_L_PAREN(loc);}
")"					{currentCol++;  return yy::parser::make_R_PAREN(loc);}
"["					{currentCol++;  return yy::parser::make_L_SQUARE_BRACKET(loc);}
"]"					{currentCol++;  return yy::parser::make_R_SQUARE_BRACKET(loc);}
":="					{currentCol+=2; return yy::parser::make_ASSIGN(loc);}



 <<EOF>>	{return yy::parser::make_END(loc);}
	/* your rules end */

%%

