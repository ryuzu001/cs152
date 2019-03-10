
%{
   #include "y.tab.h"
   int currLine = 1, currPosition = 1;
   extern "C" int yylex();
%}

digit		[0-9]
letter		[a-zA-Z]
number		{digit}*
identifier {letter}(({letter}|{digit}|[_])*({letter}|{digit}))* 

%%
[\n]			{}
[\t]+			{currPosition = yyleng;}
"##".*				{currPosition += yyleng;}

"function"              {currPosition += yyleng; return FUNCTION;}
"beginparams"           {currPosition += yyleng; return BEGIN_PARAMS;}
"endparams"             {currPosition += yyleng; return END_PARAMS;}
"beginlocals"           {currPosition += yyleng; return BEGIN_LOCALS;}
"endlocals"            {currPosition += yyleng; return END_LOCALS;}
"integer"                  {currPosition += yyleng; return INTEGER;}
"array"            {currPosition += yyleng; return ARRAY;}
"of"            {currPosition += yyleng; return OF;}
"if"            {currPosition += yyleng; return IF;}
"then"            {currPosition += yyleng; return THEN;}
"endif"            {currPosition += yyleng; return ENDIF;}
"else"            {currPosition += yyleng; return ELSE;}
"while"            {currPosition += yyleng; return WHILE;}
"do"            {currPosition += yyleng; return DO;}
"foreach"        {currPosition += yyleng; return FOREACH;}
"in"            {currPosition += yyleng; return IN;}
"beginbody"        {currPosition += yyleng; return BEGIN_BODY;}
"endbody"        {currPosition += yyleng; return END_BODY;}
"beginloop"        {currPosition += yyleng; return BEGINLOOP;}
"endloop"        {currPosition += yyleng; return ENDLOOP;}
"continue"        {currPosition += yyleng; return CONTINUE;}
"read"            {currPosition += yyleng; return READ;}
"write"            {currPosition += yyleng; return WRITE;}
"and"            {currPosition += yyleng; return AND;}
"or"            {currPosition += yyleng; return OR;}
"not"            {currPosition += yyleng; return NOT;}
"true"            {currPosition += yyleng; return TRUE;}
"false"            {currPosition += yyleng; return FALSE;}
"return"        {currPosition += yyleng; return RETURN;}

"-"            {currPosition += yyleng; return SUB;}
"+"            {currPosition += yyleng; return ADD;}
"*"            {currPosition += yyleng; return MULT;}
"/"            {currPosition += yyleng; return DIV;}
"%"            {currPosition += yyleng; return MOD;} 

"=="            {currPosition += yyleng; return EQ;}
"<>"            {currPosition += yyleng; return NEQ;}
"<"            {currPosition += yyleng; return LT;}
">"            {currPosition += yyleng; return GT;}
"<="            {currPosition += yyleng; return LTE;}
">="            {currPosition += yyleng; return GTE;}



";"            {currPosition += yyleng; return SEMICOLON;}
":"            {currPosition += yyleng; return COLON;}
","            {currPosition += yyleng; return COMMA;}
"("            {currPosition += yyleng; return L_PAREN;}
")"            {currPosition += yyleng; return R_PAREN;}
"["            {currPosition += yyleng; return L_SQUARE_BRACKET;}
"]"            {currPosition += yyleng; return R_SQUARE_BRACKET;}
":="            {currPosition += yyleng; return ASSIGN;}
" "				{currPosition += yyleng;}


{number}                {yylval.val = atoi(yytext); currPosition += yyleng; return NUMBER;}
{identifier}            {yylval.ident = yytext; currPosition += yyleng; return IDENT;}

%%