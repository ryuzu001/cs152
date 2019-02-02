flex 861203598.lex

gcc -o lexer lex.yy.c -lfl

cat test.txt | ./lexer




__________________________________



bison -d --file-prefix=y mini_l.y

flex mini_l.lex

gcc -o parser y.tab.c lex.yy.c -lfl

cat test.txt | ./parser
