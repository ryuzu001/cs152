
%{
	#include <string.h>
	#include <stdio.h>
	#include <stdlib.h>
    
    #include <string>
    #include <sstream>
    #include <vector>
	#include <iostream>
    using namespace std;

    extern "C" int yylex();
    void yyerror(const char *msg);
    extern int currLine;
    extern int currPosition;
	
    extern FILE * yyin;

    
    string newTemp();
    string newLabel();


	string func_name;
    vector<string> ops;
    vector<string> symbols;
    vector<string> symbolTypes;
    vector<string> statements;
    vector<string> cross;

    int labelCount = 0;
    int tempCount = 0;

%}


%union {
   int val;
   char* ident;
}

%error-verbose
%start prog_start
%token <val> NUMBER
%token <ident> IDENT 
%token FUNCTION  BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF  IF THEN ENDIF ELSE WHILE DO FOREACH IN BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE


%%

prog_start:		functions
    			;

functions:		function functions
				|
    			;
function: 		FUNCTION IDENT {func_name = string("func ") + $2;} SEMICOLON BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY
				{cout << func_name << endl;}
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

void yyerror(const char *msg) {
   printf("** Line %d, position %d: %s\n", currLine, currPosition, msg);

}

string newTemp(){
   tempCount++;
   string t = "t" + to_string(tempCount);
   return t;
}

string newLabel(){
   labelCount++;
   string l = "l" + to_string(labelCount);
   return l;
}