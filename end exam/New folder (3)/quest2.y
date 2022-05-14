%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
	
	double compound(double, double);
	double regular(double, double);
	double simple(double, double);
	
	int yylex(void);
	void yyerror(char*);
%}

%union {
	double val;
}


%token REGULAR
%token SIMPLE
%token COMPOUND
%token<val> NUM;

%type<val> E
%type<val> N

%%


S:
		S E '\n'					{ printf("%lf\n", $2); }
		|
		;


E:
		REGULAR'('E','E')'		{ $$ = regular($3, $5); }
		| COMPOUND'('E','E')'		{ $$ = compound($3, $5); }
		| N
		
		| SIMPLE'('E','E')'		{ $$ = simple($3, $5); }
		;


N:
		NUM
		;


%%


double compound(double x, double k) {
	double temp = x * pow(1 + 5.7/k, k);
	return temp;
}


double simple(double x, double k) {
	double temp = x + (x * 5.5 * k) / 100;
	return temp;
}

double regular(double x, double k) {
	double temp = x + (x * 2.01)/100 * k;
	return temp;
}


void yyerror(char* err) {
	printf("Error - %s\n", err);
}

int main() {
	yyparse();
	return 0;
}
