/*
	Ryan Yuzuki
	ryuzu001@ucr.edu
	CS152 Winter 2019
	861203598
*/

%{
	int currentLine = 1;
	int currentCol = 0;
%}


digit		[0-9]
letter		[a-z]|[A-Z]
number		{digit}+
identifier	{letter}({letter}|{digit}|[_]({letter}|{digit}))*
notidentifier	{digit}({letter}|{digit}|[_]({letter}|{digit}))*	
notidentifier2	({letter}|{digit})({letter}|{digit}|[_]({letter}|{digit}))*[_]	


%%
[ ]			{currentCol+=yyleng;}			// ignore spaces
[\t]			{currentCol+=yyleng;}			// ignore tabs
[\n]			{currentLine++;currentCol = 0;}
"##"[^\n]*		{}			// ignore comments

"function"		{printf("FUNCTION\n");currentCol+=yyleng;}
"beginparams"		{printf("BEGIN_PARAMS\n");currentCol+=yyleng;}
"endparams"		{printf("END_PARAMS\n");currentCol+=yyleng;}
"beginlocals"		{printf("BEGIN_LOCALS\n");currentCol+=yyleng;}
"endlocals"		{printf("END_LOCALS\n");currentCol+=yyleng;}
"beginbody"		{printf("BEGIN_BODY\n");currentCol+=yyleng;}
"endbody"		{printf("END_BODY\n");currentCol+=yyleng;}
"integer"		{printf("INTEGER\n");currentCol+=yyleng;}
"array"			{printf("ARRAY\n");currentCol+=yyleng;}
"of"			{printf("OF\n");currentCol+=yyleng;}
"if"			{printf("IF\n");currentCol+=yyleng;}
"then"			{printf("THEN\n");currentCol+=yyleng;}
"endif"			{printf("ENDIF\n");currentCol+=yyleng;}
"else"			{printf("ELSE\n");currentCol+=yyleng;}
"while"			{printf("WHILE\n");currentCol+=yyleng;}
"do"			{printf("DO\n");currentCol+=yyleng;}
"beginloop"		{printf("BEGINLOOP\n");currentCol+=yyleng;}
"endloop"		{printf("ENDLOOP\n");currentCol+=yyleng;}
"continue"		{printf("CONTINUE\n");currentCol+=yyleng;}
"read"			{printf("READ\n");currentCol+=yyleng;}
"write"			{printf("WRITE\n");currentCol+=yyleng;}
"and"			{printf("AND\n");currentCol+=yyleng;}
"or"			{printf("OR\n");currentCol+=yyleng;}
"not"			{printf("NOT\n");currentCol+=yyleng;}
"true"			{printf("TRUE\n");currentCol+=yyleng;}
"false"			{printf("FALSE\n");currentCol+=yyleng;}
"return"		{printf("RETURN\n");currentCol+=yyleng;}

"-"			{printf("SUB\n");currentCol++;}
"+"			{printf("ADD", currentCol);currentCol++;}
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
":="			{printf("ASSIGN");currentCol+=2;}

{notidentifier}		{printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currentLine, currentCol, yytext); exit(0);}
{notidentifier2}		{printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currentLine, currentCol, yytext); exit(0);}
.			{printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currentLine, currentCol+1,yytext);exit(0);}


%%


int main()
{
	yylex();
	return 0;
}
