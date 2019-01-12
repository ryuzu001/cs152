









/*
	calculator
*/


		int num_digit = 0;
		int num_operators = 0;
		int num_paren = 0;
		int num_equal = 0;


digit		[0-9]*\.?[0-9]*
plus		"+"
minus		"-"
mult		"*"
div		"/"
l_paren		"("
r_paren		")"
equal		"="
expression	([0-9]|"+"|"-"|"*"|"/"|"("|")"|"=")


%%
{digit}		++num_digit;
{l_paren}	++num_paren;
{r_paren}	++num_paren;
{plus}		++num_operators;
{minus}		++num_operators;
{mult}		++num_operators;
{div}		++num_operators;
{equal}		++num_equal;
.		{printf("unrecognized character, exiting...");exit(0);}
%%


main()
{
	yylex();
	printf("num digits: %d\n", num_digit);
	printf("num operators: %d\n", num_operators);
	printf("num parenthesis: %d\n", num_paren);
	printf("num equals: %d\n", num_equal);
}
