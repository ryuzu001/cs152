/*
   Ryan Yuzuki ryuzu001@ucr.edu
*/

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

   void doTemp(string, string);
   string doLabel();

	string func_name;
   vector<string> ops;
   vector<string> ident_vector;
   vector<string> ident_vector_type;
   vector<string> ident_vector2;
   vector<string> ident_vector_temp;
   int numTemp = 0;
   int numLabel = 0;

%}


%union {
   int val;
   char* ident;
}

%error-verbose
%start prog_start
%token <val> NUMBER
%token <ident> IDENT 
%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO FOREACH IN BEGINLOOP ENDLOOP CONTINUE READ WRITE AND OR NOT TRUE FALSE RETURN SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN SUB ADD MULT DIV MOD EQ NEQ LT GT LTE GTE

/* https://www.cs.ucr.edu/~amazl001/teaching/webpages2/syntax.html */

%%


prog_start:		   functions
    			      ;  
functions:		   function functions
				      |
    			      ;
function: 		   FUNCTION IDENT {func_name = string("func ") + $2;} SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY
				      {
                     /* declarations */
                     cout << func_name << endl;
                     for(unsigned i = 0; i < ident_vector.size(); i++){
                        if(ident_vector_type.at(i) == "int")
                           cout << ". " << ident_vector.at(i) << endl; 
                        else
                           cout << ".[] " << ident_vector.at(i) << ", " << ident_vector_type.at(i) << endl; 
                     }
                     /* statements */
                     for(unsigned i = 0; i < ident_vector2.size(); i++){
                        cout << ident_vector2.at(i) << endl;
                     }
                  }
			         ;
declarations:     declaration SEMICOLON declarations
                  |
                  ;
declaration:      idents COLON int_or_array
                  ;
idents:           IDENT 
                  {
                     string tempId = $1;
                     if(tempId.find(',') != string::npos)
                     tempId.erase(tempId.find(','));
                     ident_vector.push_back(tempId);
                  }
                  | idents COMMA IDENT
                  {
                     string tempId = $3;
                     if(tempId.find(' ') != string::npos)
                     tempId.erase(tempId.find(' '));
                     ident_vector.push_back(tempId);
                     ident_vector_type.push_back("int");
                  }
                  ;
int_or_array:     INTEGER { ident_vector_type.push_back("int"); }
                  | ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
                  { ident_vector_type.push_back(to_string($3)); }
                  ;
statements:       statement SEMICOLON statements
                  |
                  ;
statement:        var ASSIGN expression 
                  {
                     string t1 = ident_vector_temp.back();
                     ident_vector_temp.pop_back();
                     string t2 = ident_vector_temp.back();
                     ident_vector_temp.pop_back();
                     doTemp(t2, t1);
                  }
                  | WHILE bool_exp BEGINLOOP statements ENDLOOP
                  {
                     string i = doLabel();
                     ident_vector2.push_back(": " + i);
                  }
                  | READ var { ident_vector2.push_back(".< " + ident_vector_temp.back()); ident_vector_temp.pop_back();}
                  ;
bool_exp:         relation_and_exp
                  | bool_exp OR relation_and_exp {}
                  ;
relation_and_exp: relation_exp1
                  | relation_and_exp AND relation_exp1 {}
                  ;
relation_exp1:    expression comp expression
                  ;
comp:             EQ {}
                  | NEQ {}
                  | LT {}
                  | GT {}
                  | LTE {}
                  | GTE {}
                  ;
var:              IDENT 
                  {
                     string tempId = $1;
                     if(tempId.find(';') != string::npos)
                     tempId.erase(tempId.find(';'));
                     if(tempId.find(" :=") != string::npos)
                     tempId.erase(tempId.find(" :="));
                     ident_vector_temp.push_back(tempId);
                  }
                  | IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET 
                  {
                     /* ident_vector = symbols
                        ident_vector_type = symbolTypes
                        ident_vector2 = statements
                        ident_vector_temp =  cross 
                        ops = ops*/
                  }
                  ;
expression:       var  
                  | var DIV var 
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

void doTemp(string str1, string str2){
   string tempStr = "__temp__" + to_string(numTemp);
   ident_vector2.push_back(". " + tempStr);
   ident_vector2.push_back("= " + tempStr + ", " + str2);
   ident_vector2.push_back("= " + str1 + ", " + tempStr);
   numTemp++;
}
string doLabel(){
   return "__label__" + to_string(numLabel++);
}
