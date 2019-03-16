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

   void assignTemp(string, string);
   string expressionTemp(string);
   string doLabel();
   string declareTemp();
   bool fromExp = false;

   string func_name;
   vector<string> ops;
   vector<string> ident_vector;
   vector<string> ident_vector_type;
   vector<string> ident_vector2;
   vector<string> ident_vector_temp;
   vector<string> comp_stuff;
   vector<string> label_vector_temp;
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
                     assignTemp(t2, t1);
                  }
                  | WHILE bool_exp BEGINLOOP statements ENDLOOP
                  {
                     string i = doLabel();
                     ident_vector2.push_back(": " + i);
                     while(comp_stuff.size() != 0){
                        if(comp_stuff.back() == "GT"){
                           comp_stuff.pop_back();
                           string s1 = declareTemp();
                           string s2 = ident_vector_temp.back();
                           ident_vector_temp.pop_back();
                           string s3 = ident_vector_temp.back();
                           ident_vector_temp.pop_back();
                           ident_vector2.push_back("> " + s1 + ", " + s3 + ", " + s2);
                           ident_vector_temp.push_back(s1);

                           // loop part ?:
                           ident_vector2.push_back("?:= " + label_vector_temp.back() + ", " + ident_vector_temp.back());
                           label_vector_temp.pop_back();
                           string l1 = doLabel();
                           ident_vector2.push_back(":= " + label_vector_temp.back());
                           string l2 = doLabel();
                           ident_vector2.push_back(": " + l2);
                        }
                        if(comp_stuff.back() == "LTE"){
                           comp_stuff.pop_back();
                           string s1 = declareTemp();
                           string s2 = ident_vector_temp.back();
                           ident_vector_temp.pop_back();
                           string s3 = ident_vector_temp.back();
                           ident_vector_temp.pop_back();
                           ident_vector2.push_back("<= " + s1 + ", " + s3 + ", " + s2);
                           ident_vector_temp.push_back(s1);

                           // loop part ?:
                           ident_vector2.push_back("?:= " + label_vector_temp.back() + ", " + ident_vector_temp.back());
                           label_vector_temp.pop_back();
                           string l1 = doLabel();
                           ident_vector2.push_back(":= " + label_vector_temp.back());
                           string l2 = doLabel();
                           ident_vector2.push_back(": " + l2);
                        }
                     }
                  }
                  | IF bool_exp THEN statements ENDIF
                  {
                     string l1 = doLabel();
                     string l2 = doLabel();
                     ident_vector2.push_back("?: " + l1 + ", " + label_vector_temp.back());
                     label_vector_temp.pop_back();
                     ident_vector2.push_back(": " + l2);
                  }
                  | IF bool_exp THEN statements ELSE statements ENDIF
                  {
                     string l1 = doLabel();
                     string l2 = doLabel();
                     string l3 = doLabel();
                     ident_vector2.push_back("?: " + l1 + ", " + label_vector_temp.back());
                     label_vector_temp.pop_back();
                     ident_vector2.push_back(":= " + l2);
                     ident_vector2.push_back(": " + l3);
                  }
                  | DO BEGINLOOP statements ENDLOOP WHILE bool_exp 
                  {
                     string l1 = doLabel();
                     ident_vector2.push_back(l1);
                  }
                  | READ vars
                  {
                     ident_vector2.push_back(".< " + ident_vector_temp.back());
                     ident_vector_temp.pop_back();
                  }
                  | CONTINUE {}
                  | RETURN expression {}
                     
                  | READ var { ident_vector2.push_back(".< " + ident_vector_temp.back()); ident_vector_temp.pop_back();}
                  ;
bool_exp:         relation_and_exp {}
                  | bool_exp OR relation_and_exp {}
                  ;
relation_and_exp: relation_exp1 {}
                  | relation_and_exp AND relation_exp1 {}
                  ;
relation_exp1:    expression comp expression
                  ;
comp:             EQ {comp_stuff.push_back("GT");}
                  | NEQ {comp_stuff.push_back("GT");}
                  | LT {comp_stuff.push_back("GT");}
                  | GT {comp_stuff.push_back("GT");}
                  | LTE {comp_stuff.push_back("LTE");}
                  | GTE {comp_stuff.push_back("GT");}
                  ;
vars:             var COMMA vars
                  {
                     string t = declareTemp();
                     ident_vector_type.push_back("int");
                  }
                  | var
                  ;
var:              IDENT 
                  {
                  if(fromExp){
                        ident_vector_temp.push_back(expressionTemp($1));
                  }
                  else{
                     string tempId = $1;
                     if(tempId.find(';') != string::npos)
                     tempId.erase(tempId.find(';'));
                     if(tempId.find(" :=") != string::npos)
                     tempId.erase(tempId.find(" :="));
                     ident_vector_temp.push_back(tempId);
                  }
                  }
                  | IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET 
                  {
                     /* ident_vector = symbols
                        ident_vector_type = symbolTypes
                        ident_vector2 = statements
                        ident_vector_temp =  cross 
                        ops = label_vector_temp */
                  }
                  ;
expressions:	   expression COMMA expressions
                  | expression
                  ;
expression:       multip_exp
                  | multip_exp ADD multip_exp 
                  {
                     string s1 = declareTemp();
                     ident_vector.push_back(s1);
                     ident_vector_type.push_back("int");

                     string s2 = ident_vector_temp.back();
                     ident_vector_temp.pop_back();
                     string s3 = ident_vector_temp.back();
                     ident_vector_temp.pop_back();

                     ident_vector2.push_back("+ " + s1 + ", " + s2 + ", " + s3);
                     label_vector_temp.push_back(s1);
                  }
                  | multip_exp SUB multip_exp
                  ;
multip_exp:	      term
                  | term DIV term {
                     string s1 = declareTemp();
                     ident_vector_type.push_back("int");
                     string s2 = ident_vector_temp.back();
                     ident_vector_temp.pop_back();
                     string s3  = ident_vector_temp.back();
                     ident_vector_temp.pop_back();
                     ident_vector2.push_back("/ " + s1 + ", " + s2 + ", " + s3);
                     ident_vector_temp.push_back(s1);
                  }
                  | term MULT term {
                     string s1 = declareTemp();
                     ident_vector_type.push_back("int");
                     string s2 = ident_vector_temp.back();
                     ident_vector_temp.pop_back();
                     string s3  = ident_vector_temp.back();
                     ident_vector_temp.pop_back();
                     ident_vector2.push_back("* " + s1 + ", " + s2 + ", " + s3);
                     ident_vector_temp.push_back(s1);
                  }
                  | term MOD term {
                     string s1 = declareTemp();
                     ident_vector_type.push_back("int");
                     string s2 = ident_vector_temp.back();
                     ident_vector_temp.pop_back();
                     string s3  = ident_vector_temp.back();
                     ident_vector_temp.pop_back();
                     ident_vector2.push_back("* " + s1 + ", " + s2 + ", " + s3);
                     ident_vector_temp.push_back(s1);
                  }
                  ;
term:	            | var {fromExp = true;}
                  | NUMBER
                  | L_PAREN expression R_PAREN
                  | SUB var
                  | SUB NUMBER
                  | SUB L_PAREN expression R_PAREN
                  | IDENT L_PAREN expressions R_PAREN
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

void assignTemp(string str1, string str2){
   string tempStr = "__temp__" + to_string(numTemp);
   ident_vector2.push_back(". " + tempStr);
   ident_vector2.push_back("= " + tempStr + ", " + str2);
   ident_vector2.push_back("= " + str1 + ", " + tempStr);
   ident_vector_temp.push_back(tempStr);
   numTemp++;
}
string declareTemp(){
   string tempStr = "__temp__" + to_string(numTemp);
   numTemp++;
   ident_vector2.push_back(". " + tempStr);
   return tempStr;
}
string expressionTemp(string s1){
   string tempStr = "__temp__" + to_string(numTemp);
   numTemp++;
   if(s1.find(" ") != string::npos)
   s1.erase(s1.find(" "));
   if(s1.find("+") != string::npos)
   s1.erase(s1.find("+"));
   if(s1.find(";") != string::npos)
   s1.erase(s1.find(";"));
   ident_vector2.push_back(". " + tempStr);
   ident_vector2.push_back("= " + tempStr + ", " + s1);
   return tempStr;
}
string doLabel(){
   string s1 = "__label__" + to_string(numLabel++);
   label_vector_temp.push_back(s1);
   return s1;
}
