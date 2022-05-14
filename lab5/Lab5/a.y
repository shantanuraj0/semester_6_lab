%{
        #include <stdio.h>
        #include <string.h>
        #include "node.h"
        #include "SymTab.h"

        extern FILE *yyin;
        extern FILE *yyout;

        int yylex(void);
        void yyerror(char *);
        int yydebug = 1;
        
        node *mknode(node *, node *, char *); 
        void push_sym(char *, char*);
        void printsymtable();
        char *attChecker(char*);
        char *typeChecker(node *);
        int isOperation(char *);
%}



%union { 
        char *str;
        node *ptr;
};



%token <str> NUM
%token <str> ID

%start  start
%type <ptr> expr
%type <ptr> term
%type <ptr> factor

%left '+' '-'
%left '*' '/'



%%



start:   
        start expr  '\n'                {      
                                                printsymtable();
                                                printf("OUT: %s\n\n",typeChecker($2));
                                                printf("INP: ");
                                        }
        |                                   { }
	| error '\n'              	{yyerrok; }
        ;

expr:
        expr '+' term                   { $$ = mknode($1, $3, "+"); }
        |       expr '-' term           { $$ = mknode($1, $3, "-"); }
        |       term                    { $$ = $1; }  
        ;

term:
        term '*' factor                 { $$ = mknode($1, $3, "*"); }
        |       term '/' factor         { $$ = mknode($1, $3, "/"); }
        |       factor                  { $$ = $1; }
        ;

factor:
        '(' expr ')'                    { $$ = $2; }
        | NUM                           { $$ = mknode(0,0,$1); push_sym($1,"number"); }
        | ID                            { $$ = mknode(0,0,$1); push_sym($1,"string"); }
        ;

%%




node *mknode(node *left, node *right, char *value) { 
        char *newstr = strdup(value); 
        node *newnode = (node *)malloc(sizeof(node)); 
        newnode->left = left; 
        newnode->right = right; 
        newnode->value = newstr; 
        return newnode; 
}



void push_sym ( char *sym_name, char *sym_type ) { 
        symtable *s = getsym (sym_name);
        if (s == 0) s = putsym (sym_name,sym_type);
}



void printsymtable() 
{ 
        printf("\tSymbol table:\n");
        printf("name\t\t\ttype\n");
        symtable *s = sym_table;
        while (s != NULL) { 
                printf("%s\t\t\t%s\n", s->name,s->type); 
                s = s->next;
        }
} 



char *attChecker( char *sym_name ){
        symtable *s = getsym( sym_name );
        if ( s == 0 ) return NULL;
        else return  s->type;
}



int isOperation(char *op){
        return !strcmp(op, "+") || !strcmp(op, "-") || !strcmp(op, "*") || !strcmp(op, "/");
}



char *typeChecker( node *root ){
        char *v1,*v2;
        char *result = (char *)malloc(10); 
        if(root != NULL){
                if(isOperation(root->value)){
                        v1 = typeChecker(root->left);
                        v2 = typeChecker(root->right);

                        if(strcmp(v1,"Error")==0 || strcmp(v2,"Error")==0){
                                strcpy(result,"Error");
                                return result;
                        }
                        if(strcmp(v1,v2)==0){
                                if(strcmp(v1,"number")==0)
                                        strcpy(result,"number");
                                if(strcmp(v1,"string")==0)
                                        strcpy(result,"string");
                        }
                        if(strcmp(v1,v2)!=0){
                                printf("(%s %s %s) : Type mismatch.\n",v1,root->value,v2);
                                strcpy(result,"Error");
                        }
                        return result;
                }
                return attChecker(root->value);
        }
        return 0;
}



int main(int argc, char** argv) {
        if (argc >= 2){
                yyin = fopen(argv[1],"r");
                if(yyin==NULL){
                        printf("ERROR ! Invalid Input file.\n");
                        return 0;
                }
                if(argc >= 3){
                        yyout = fopen(argv[2],"w");
                }
                printf("INP: ");
                yyparse();
                fclose(yyin);
                if(argc >= 3) fclose(yyout);
        }
        else{
                printf("INP: ");
                yyparse();
        } 
        return 0;
}
