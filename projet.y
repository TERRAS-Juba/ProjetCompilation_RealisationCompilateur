%{
#include <stdio.h>
int yylex();
void yyerror(char *s);
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;
%}
%token ADD SUB DIV MUL POWER AND OR NOT MOD SUP SUPE INF INFE EQUAL DIFF AFFECT
%token PARO PARF CROO CROF ACCO ACCF 
%token DEL VIRGULE
%token INTEGER DOUBLE STRING CHAR BOOLEAN
%token CONSTANTE FONCTION IDENTIFIANT
%token BEGINPROG ENDPROG IF THEN ENDIF ELIF ENDELIF ELSE ENDELSE FOR BEGINFOR ENDFOR WHILE BEGINWHILE ENDWHILE INPUT OUTPUT INCREMENT DECREMENT FUNCTION_DECLARATION CONSTANT_DECLARATION
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

%%
prog :
    | BEGINPROG corp ENDPROG
;
corp:
	| declaration | declaration corp
;
declaration:
	| declaration_integer | declaration_double | declaration_char | declaration_string
;
declaration_integer:
	| INTEGER_DECLARATION IDENTIFIANT AFFECT INTEGER DEL
;
declaration_double:
	| DOUBLE_DECLARATION IDENTIFIANT AFFECT DOUBLE DEL
;
declaration_string:
	| STRING_DECLARATION IDENTIFIANT AFFECT STRING DEL
;
declaration_char:
	| CHAR_DECLARATION IDENTIFIANT AFFECT CHAR DEL
;
%%
void yyerror(char *s){
printf("Erreur synthaxique a la ligne : %d\n",yylineno);
}
int main()
{
  FILE* fichier = NULL;
  fichier = fopen("test.txt", "r");
  if (fichier==NULL) {
    printf("erreur d'ouverture du fichier\n");
  }
  yyin = fichier;
  yyparse();
  fclose(fichier);
  return 0;
}