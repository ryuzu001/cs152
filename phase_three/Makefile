parser: mini_l.lex mini_l.y
		bison -v -d --file-prefix=y mini_l.y
		flex mini_l.lex
		g++ -o parser y.tab.c lex.yy.c -lfl --std=c++11
clean:
	rm -f lex.yy.c y.tab.c y.output .o parser y.tab.h