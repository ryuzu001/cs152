/*
	Ryan Yuzuki
	ryuzu001@ucr.edu
	CS152 Winter 2019
*/

%{
	int currentLine = 1;
	int currentCol = 1;
%}


digit		[0-9]
letter		[a-zA-Z]
number		{digit}*
identifier	{letter}(({letter}|{digit}|[_])*({letter}|{digit}))*	


%%
[ ]			{currentCol++;}			// ignore spaces
[\t]			{currentCol++;}			// ignore tabs
[\n]			{currentLine++;currentCol = 1;}
"##"[^\n]*		{}			// ignore comments

"function"		{printf("FUNCTION\n");currentCol+=8;}
"beginparams"		{printf("BEGIN_PARAMS\n");currentCol+=11;}
"endparams"		{printf("END_PARAMS\n");currentCol+=9;}
"beginlocals"		{printf("BEGIN_LOCALS\n");currentCol+=11;}
"endlocals"		{printf("END_LOCALS\n");currentCol+=9;}
"beginbody"		{printf("BEGIN_BODY\n");currentCol+=9;}
"endbody"		{printf("END_BODY\n");currentCol+=7;}
"integer"		{printf("INTEGER\n");currentCol+=7;}
"array"			{printf("ARRAY\n");currentCol+=5;}
"of"			{printf("OF\n");currentCol+=2;}
"if"			{printf("IF\n");currentCol+=2;}
"then"			{printf("THEN\n");currentCol+=4;}
"endif"			{printf("ENDIF\n");currentCol+=5;}
"else"			{printf("ELSE\n");currentCol+=4;}
"while"			{printf("WHILE\n");currentCol+=5;}
"do"			{printf("DO\n");currentCol+=2;}
"beginloop"		{printf("BEGINLOOP\n");currentCol+=9;}
"endloop"		{printf("ENDLOOP\n");currentCol+=7;}
"continue"		{printf("CONTINUE\n");currentCol+=8;}
"read"			{printf("READ\n");currentCol+=4;}
"write"			{printf("WRITE\n");currentCol+=5;}
"and"			{printf("AND\n");currentCol+=3;}
"or"			{printf("OR\n");currentCol+=2;}
"not"			{printf("NOT\n");currentCol+=3;}
"true"			{printf("TRUE\n");currentCol+=4;}
"false"			{printf("FALSE\n");currentCol+=5;}
"return"		{printf("RETURN\n");currentCol+6;}

"-"			{printf("SUB\n");currentCol++;}
"+"			{printf("ADD\n");currentCol++;}
"*"			{printf("MULT\n");currentCol++;}
"/"			{printf("DIV\n");currentCol++;}
"%"			{printf("MOD\n");currentCol++;}

"=="			{printf("EQ\n");currentCol+=2;}
"<>"			{printf("NEQ\n");currentCol+=2;}
"<"			{printf("LT\n");currentCol++;}
">"			{printf("GT\n");currentCol++;}
"<="			{printf("LTE\n");currentCol+=2;}
">="			{printf("GTE\n");currentCol+=2;}

{identifier}		{printf("IDENT %s\n", yytext);currentCol+=yyleng;}
{number}		{printf("NUMBER %s\n", yytext);currentCol+=yyleng;}

";"			{printf("SEMICOLON\n");currentCol++;}
":"			{printf("COLON\n");currentCol++;}
","			{printf("COMMA\n");currentCol++;}
"("			{printf("L_PAREN\n");currentCol++;}
")"			{printf("R_PAREN\n");currentCol++;}
"["			{printf("L_SQUARE_BRACKET\n");currentCol++;}
"]"			{printf("R_SQUARE_BRACKET\n");currentCol++;}
":="			{printf("ASSIGN\n");currentCol+=2;}
.			{printf("Error at line %d, column %d: unrecognized symbol \"%s\"", currentLine, currentCol,yytext);exit(0);}


%%


int main()
{
	yylex();
	printf("lines: %d\n", currentLine);
	return 0;
}
