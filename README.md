flex 861203598.lex

gcc -o lexer lex.yy.c -lfl

cat test.txt | ./lexer




__________________________________



flex mini_l.lex

bison mini_l.y

cat test.txt | ./parser

gcc -o parser mini_l.tab.c lex.yy.c -lfl
