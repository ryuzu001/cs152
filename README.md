flex 861203598.lex

gcc -o lexer lex.yy.c -lfl

cat test.txt | ./lexer
