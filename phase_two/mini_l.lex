/*
	Ryan Yuzuki
	ryuzu001@ucr.edu
	CS152 Winter 2019
*/

%{
	#include "y.tab.h"
	int currentLine = 1;
	int currentCol = 1;
%}


digit		[0-9]
letter		[a-zA-Z]
number		{digit}*
identifier	{letter}(({letter}|{digit}|[_])*({letter}|{digit}))*	


%%
[ ]					{currentCol++;}			// ignore spaces
[\t]				{currentCol++;}			// ignore tabs
[\n]				{currentLine++;currentCol = 1;}
"##"[^\n]*			{}			// ignore comments

"function"			{currentCol+=8;  return FUNCTION;}
"beginparams"		{currentCol+=11; return BEGIN_PARAMS;}
"endparams"			{currentCol+=9;  return END_PARAMS;}
"beginlocals"		{currentCol+=11; return BEGIN_LOCALS;}
"endlocals"			{currentCol+=9;  return END_LOCALS;}
"beginbody"			{currentCol+=9;  return BEGIN_BODY;}
"endbody"			{currentCol+=7;  return END_BODY;}
"integer"			{currentCol+=7;  return INTEGER;}
"array"				{currentCol+=5;  return ARRAY;}
"of"				{currentCol+=2;  return OF;}
"if"				{currentCol+=2;  return IF;}
"then"				{currentCol+=4;  return THEN;}
"endif"				{currentCol+=5;  return ENDIF;}
"else"				{currentCol+=4;  return ELSE;}
"while"				{currentCol+=5;  return WHILE;}
"do"				{currentCol+=2;  return DO;}
"beginloop"			{currentCol+=9;  return BEGINLOOP;}
"endloop"			{currentCol+=7;  return ENDLOOP;}
"continue"			{currentCol+=8;  return CONTINUE;}
"read"				{currentCol+=4;  return READ;}
"write"				{currentCol+=5;  return WRITE;}
"and"				{currentCol+=3;  return AND;}
"or"				{currentCol+=2;  return OR;}
"not"				{currentCol+=3;  return NOT;}
"true"				{currentCol+=4;  return TRUE;}
"false"				{currentCol+=5;  return FALSE;}
"return"			{currentCol+=6;  return RETURN;}

"-"					{currentCol++;   return SUB;}
"+"					{currentCol++;   return ADD;}
"*"					{currentCol++;   return MULT;}
"/"					{currentCol++;   return DIV;}
"%"					{currentCol++;   return MOD;}

"=="				{currentCol+=2;  return EQ;}
"<>"				{currentCol+=2;  return NEQ;}
"<"					{currentCol++;   return LT;}
">"					{currentCol++;   return GT;}
"<="				{currentCol+=2;  return LTE;}
">="				{currentCol+=2;  return GTE;}
	
{identifier}		{yylval.ident = (yytext);return IDENT;}
{number}			{yylval.num = atoi(yytext); return NUMBER;}

";"					{currentCol++;  return SEMICOLON;}
":"					{currentCol++;  return COLON;}
","					{currentCol++;  return COMMA;}
"("					{currentCol++;  return L_PAREN;}
")"					{currentCol++;  return R_PAREN;}
"["					{currentCol++;  return L_SQUARE_BRACKET;}
"]"					{currentCol++;  return R_SQUARE_BRACKET;}
":="				{currentCol+=2; return ASSIGN;}
.					{printf("Error at line %d, column %d: unrecognized symbol \"%s\"", currentLine, currentCol,yytext);exit(0);}


%%


