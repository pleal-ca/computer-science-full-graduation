%{
    #include "hashtable.h"
    #include "lex.yy.h"
    
    void yyerror(char *);
    int getLineNumber();

    // Just put it here.
    // "-Sir: no touching of the
    // symbols, please..."
    #define SYMBOL_UNDEFINED    0 
    #define SYMBOL_LIT_INTEGER  1 
    #define SYMBOL_LIT_FLOATING 2 
    #define SYMBOL_LIT_TRUE     3 
    #define SYMBOL_LIT_FALSE    4 
    #define SYMBOL_LIT_CHAR     5 
    #define SYMBOL_LIT_STRING   6 
    #define SYMBOL_IDENTIFIER   7
%}

%union{
    Entry* entry;
    int number;
}

%token <entry> KW_WORD  
%token KW_BOOL      
%token KW_BYTE      
%token KW_IF        
%token KW_THEN      
%token KW_ELSE      
%token KW_LOOP      
%token KW_INPUT     
%token KW_RETURN    
%token KW_OUTPUT    

%token OPERATOR_LE  
%token OPERATOR_GE  
%token OPERATOR_EQ  
%token OPERATOR_NE  
%token OPERATOR_AND 
%token OPERATOR_OR  

%token TK_IDENTIFIER 
%token <number> LIT_INTEGER 
%token LIT_FALSE   
%token LIT_TRUE    
%token LIT_CHAR    
%token LIT_STRING  

%token TOKEN_ERROR 

%%

program:
		decl program
	|	func program
	|	/* nil */
	;

decl: 
		simple_decl
	|	array_decl
	|	pointer_decl
	; 

simple_decl: 
		types TK_IDENTIFIER ':' literals ';'
	;

decl_func_list:
		simple_decl decl_func_list
	|	pointer_decl decl_func_list
    |	/* nil */
    ;
	
types: 
		KW_WORD
	|	KW_BOOL
	|	KW_BYTE
	;

literals: 
		LIT_INTEGER
	|	LIT_FALSE
	|	LIT_TRUE
	|	LIT_CHAR
	|	LIT_STRING
	;

array_decl: 
		types TK_IDENTIFIER '[' LIT_INTEGER ']' ';'
	|	types TK_IDENTIFIER '[' LIT_INTEGER ']' ':' lit_recursive ';'
	;
	
lit_recursive: 
		literals lit_recursive 
	|	literals
	;

pointer_decl:
		types '$' TK_IDENTIFIER ':' literals ';'
	;

func: 
		types TK_IDENTIFIER '(' param_list ')' decl_func_list command_block
	|  	types TK_IDENTIFIER '(' param_list ')'      command_block
	;
	
func_call:
    	TK_IDENTIFIER '(' call_list ')'
    ;

call_list:
    	exp call_list_recursive
    |	/* nil */
    ;
    
call_list_recursive:
    	',' exp call_list_recursive
    |   /* nil */
    ;

param_list:
		types TK_IDENTIFIER param_list_recursive
	|	/* nil */
	;
	
param_list_recursive:
    	',' types TK_IDENTIFIER param_list_recursive
    |	/* nil */
    ;

command_block: 
    	'{' commands_ended '}'
    ;

commands_ended:
    	commands ';' commands_ended
	|   /* nil */
	;

commands:
		TK_IDENTIFIER '=' exp
	|	TK_IDENTIFIER '[' exp ']' '=' exp
	|	KW_IF '(' exp ')' KW_THEN 
	|	KW_IF '(' exp ')' KW_THEN commands KW_ELSE commands
	|	KW_LOOP '(' exp ')' commands
	|	KW_INPUT TK_IDENTIFIER
	|	KW_OUTPUT output_list
	|	KW_RETURN exp
	|	command_block
	|	/* nil */
	;

output_list:
    	types output_list_recursive
    |	exp output_list_recursive
    ;

output_list_recursive:
		',' types output_list_recursive
	|	',' exp output_list_recursive
	|	/* nil */
	;

exp:
		func_call
	|	exp OPERATOR_LE exp
	|	exp OPERATOR_GE exp
	|	exp OPERATOR_EQ exp
	|	exp OPERATOR_NE exp
	|	exp OPERATOR_OR exp
	|	exp OPERATOR_AND exp
	|	exp '>' exp
	|	exp '<' exp
    |	exp '+' exp
	|	exp '-' exp
	|	exp '/' exp
	|	exp '*' exp
	|	'*'exp     
	|	'&'exp     
	|	'(' exp ')'
	|	TK_IDENTIFIER
	|	TK_IDENTIFIER '[' LIT_INTEGER ']'
	|	literals 
    ;
    
%%

void yyerror(char *s) {
	fprintf(stderr, "Error on line %d: %s\n", getLineNumber(), s);
}
