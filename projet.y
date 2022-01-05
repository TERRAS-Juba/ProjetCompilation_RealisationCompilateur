%{
#include <stdio.h>
#include <string.h>
#include "machine.c"
#include  <math.h>
int yylex();
void yyerror(char *s);
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;
typedef struct Tmaillon Tmaillon;
Tmaillon *tete;
char buffer[256];
char buffer2[256];
%}
%token ADD SUB DIV MUL POWER AND OR NOT MOD SUP SUPE INF INFE EQUAL DIFF AFFECT
%token PARO PARF CROO CROF ACCO ACCF 
%token DEL VIRGULE
%token INTEGER DOUBLE STRING CHAR BOOLEAN
%token CONSTANTE FONCTION IDENTIFIANT
%token BEGINPROG ENDPROG IF THEN ENDIF ELIF ENDELIF ELSE ENDELSE FOR BEGINFOR ENDFOR WHILE BEGINWHILE ENDWHILE INPUT OUTPUT INCREMENT DECREMENT FUNCTION_DECLARATION CONSTANTE_DECLARATION
%token INTEGER_DECLARATION DOUBLE_DECLARATION CHAR_DECLARATION STRING_DECLARATION BOOLEAN_DECLARATION TAB_DECLARATION STRUCT_DECLARATION
%left OR
%left AND
%left EQUAL DIFF
%left SUP SUPE INF INFE AFFECT
%left ADD SUB
%left MUL DIV MOD
%left NOT
%right POWER
%left PARO PARF
%type <entier> INTEGER;
%type <flottant> DOUBLE;
%type <caractere> CHAR;
%type <str> STRING;
%type <booleen> BOOLEAN;
%type <id> IDENTIFIANT;
%type <str> CONSTANTE
%union{
double flottant;
int entier;
char caractere[3];
char str[100];
char booleen[5];
char id[100];
}
%%
prog :
    | BEGINPROG corp ENDPROG
;
corp:
declaration | declaration corp | expa | expa corp
;
declaration:
declaration_integer | declaration_double | declaration_char | declaration_string | declaration_boolean | declaration_constante
;
declaration_integer:
INTEGER_DECLARATION IDENTIFIANT AFFECT INTEGER DEL {printf("entier\n");strcpy(buffer,"");itoa($4,buffer,10);AJOUTER_ENTITE(tete,buffer,"int",$2);}
;
declaration_double:
DOUBLE_DECLARATION IDENTIFIANT AFFECT DOUBLE DEL {printf("double\n");strcpy(buffer,"");snprintf(buffer, 256, "%f", $4);AJOUTER_ENTITE(tete,buffer,"double",$2);}
;
declaration_string:
STRING_DECLARATION IDENTIFIANT AFFECT STRING DEL{printf("string\n");AJOUTER_ENTITE(tete,$4,"string",$2);}
;
declaration_char:
CHAR_DECLARATION IDENTIFIANT AFFECT CHAR DEL{printf("char\n");AJOUTER_ENTITE(tete,$4,"char",$2);}
;
declaration_boolean:
BOOLEAN_DECLARATION IDENTIFIANT AFFECT BOOLEAN DEL {AJOUTER_ENTITE(tete,$4,"boolean",$2);}
;
declaration_constante:
CONSTANTE_DECLARATION CONSTANTE AFFECT INTEGER DEL {strcpy(buffer,"");itoa($4,buffer,10);AJOUTER_ENTITE(tete,buffer,"constante",$2);}|  CONSTANTE_DECLARATION CONSTANTE AFFECT DOUBLE DEL{strcpy(buffer,"");snprintf(buffer, 256, "%f", $4);AJOUTER_ENTITE(tete,buffer,"constante",$2);}
;  
expa:
INTEGER ADD INTEGER {printf("%d\n",$1+$3);} | DOUBLE ADD DOUBLE{printf("%lf\n",$1+$3);} | INTEGER ADD DOUBLE{printf("%lf\n",$1+$3);} | DOUBLE ADD INTEGER{printf("%lf\n",$1+$3);}
INTEGER SUB INTEGER {$1-$3;} | DOUBLE SUB DOUBLE{$1-$3;} | INTEGER SUB DOUBLE{$1-$3;} | DOUBLE SUB INTEGER{$1-$3;}
INTEGER MUL INTEGER {$1*$3;} | DOUBLE MUL DOUBLE{$1*$3;} | INTEGER MUL DOUBLE{$1*$3;} | DOUBLE MUL INTEGER{$1*$3;}
INTEGER DIV INTEGER {$1/$3;} | DOUBLE DIV DOUBLE{$1/$3;} | INTEGER DIV DOUBLE{$1/$3;} | DOUBLE DIV INTEGER{$1/$3;}
INTEGER POWER INTEGER {pow($1,$3);}
;
%%
void yyerror(char *s){
printf("Erreur synthaxique a la ligne : %d\n",yylineno);
}
int main()
{
 tete=CREATION_TABLE_SYMBOLES();
 yyin=fopen("test.txt","r");
 if(yyin==NULL){
 printf("Erreur d'ouverture de fichier");
 }else{
 yyparse();
 }
 fclose(yyin);
  return 0;
}