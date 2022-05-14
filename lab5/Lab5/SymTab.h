#include <stdlib.h>

typedef struct symtable
{
  char *name;    
  char *type;         
  struct symtable *next;
} symtable;

symtable *sym_table = NULL;

symtable *putsym ();
symtable *getsym ();

symtable * putsym ( char *name, char *type )
{
    symtable *temp;
    temp = (symtable *) malloc (sizeof(symtable));
    temp->name = strdup(name);
    temp->type = strdup(type);
    temp->next = (symtable *)sym_table;
    sym_table = temp;
    return temp; 
}
symtable * getsym ( char *name )
{
    symtable *temp = sym_table;
    while(temp != NULL){
        if (strcmp (temp->name,name) == 0)
            return temp;
        temp = temp->next;
    }
    return 0;
}