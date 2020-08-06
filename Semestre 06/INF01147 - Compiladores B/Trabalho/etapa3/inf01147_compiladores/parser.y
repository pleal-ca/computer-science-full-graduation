%{
	/* 	Arrumar shift/reduce: yacc -v parser.y
		Arquivo y.output é gerado
 	*/

	#include "hashtable.h"
    #include "astree.c"
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
    int valor;
	Entry *symbol;
	ASTREE *astree;
}

%token KW_WORD  
%token KW_BOOL      
%token KW_BYTE      
%token KW_IF        
%token KW_THEN      
%token KW_ELSE      
%token KW_LOOP      
%token KW_INPUT     
%token KW_RETURN    
%token KW_OUTPUT      
%token TOKEN_ERROR 

%token <symbol> TK_IDENTIFIER 
%token <symbol> LIT_INTEGER 
%token <symbol> LIT_FALSE   
%token <symbol> LIT_TRUE    
%token <symbol> LIT_CHAR    
%token <symbol> LIT_STRING  

%left OPERATOR_AND 
%left OPERATOR_OR
%left '+' '-'
%left '/' '*'

%right KW_THEN KW_ELSE
%right UNARY_MINUS
%right POINTER
%right '&'

%nonassoc OPERATOR_LE  
%nonassoc OPERATOR_GE  
%nonassoc OPERATOR_EQ  
%nonassoc OPERATOR_NE  
%nonassoc '>' 
%nonassoc '<'

%type <astree> begin
%type <astree> program
%type <astree> decl simple_decl array_decl pointer_decl lit_list
%type <astree> func param_list decl_func_list 
%type <astree> exp exp_arit exp_logic command command_list command_block
%type <astree> func_call func_call_list
%type <astree> output_list
%type <astree> literals identifier

%%

begin: 
		program { $$ = astreeCreate(ASTREE_PROGRAM, NULL, $1, NULL, NULL, NULL); astreePrintTree(0, $$); astreeTranslate($$); }
	;

program:
		decl program	{ $$ = astreeCreate(ASTREE_DECL, NULL, $1, $2, NULL, NULL);		}
	|	decl			{ $$ = astreeCreate(ASTREE_DECL, NULL, $1, NULL, NULL, NULL);	}
	|	func program	{ $$ = astreeCreate(ASTREE_FUNC, NULL, $1, $2, NULL, NULL);		}
	|	func			{ $$ = astreeCreate(ASTREE_FUNC, NULL, $1, NULL, NULL, NULL);	}
	;

decl: 
		simple_decl		{ $$ = $1; }
	|	array_decl		{ $$ = $1; }
	|	pointer_decl	{ $$ = $1; }
	; 

simple_decl: 
		types identifier ':' literals ';' { $$ = astreeCreate(ASTREE_SIMPLE_DECL, NULL, $2, $4, NULL, NULL); }
	;
	
identifier:
		TK_IDENTIFIER { $$ = astreeCreate(ASTREE_SYMBOL, $1, NULL, NULL, NULL, NULL); }	
	;

types: 
		KW_WORD 
	|	KW_BOOL
	|	KW_BYTE
	;

literals: 
		LIT_INTEGER { $$ = astreeCreate(ASTREE_SYMBOL, $1, NULL, NULL, NULL, NULL); }
	|	LIT_FALSE	{ $$ = astreeCreate(ASTREE_SYMBOL, $1, NULL, NULL, NULL, NULL); }
	|	LIT_TRUE	{ $$ = astreeCreate(ASTREE_SYMBOL, $1, NULL, NULL, NULL, NULL); }
	|	LIT_CHAR	{ $$ = astreeCreate(ASTREE_SYMBOL, $1, NULL, NULL, NULL, NULL); }
	|	LIT_STRING	{ $$ = astreeCreate(ASTREE_SYMBOL, $1, NULL, NULL, NULL, NULL); }
	;

array_decl: 
		types identifier '[' LIT_INTEGER ']' ';' { 
			$$ = astreeCreate(ASTREE_ARRAY_DECL, 
							  NULL, 
							  $2, 
							  astreeCreate(ASTREE_SYMBOL, $4, NULL, NULL, NULL, NULL), 
							  NULL,
							  NULL);
		}
	
	|	types identifier '[' LIT_INTEGER ']' ':' lit_list ';' { 
			$$ = astreeCreate(ASTREE_ARRAY_DECL_INI, 
							  NULL, 
							  $2, 
							  astreeCreate(ASTREE_SYMBOL, $4, NULL, NULL, NULL, NULL), 
							  $7,
							  NULL);
		}
	;
	
lit_list: 
		literals lit_list	{ $$ = astreeCreate(ASTREE_ARRAY_DECL_LITS, NULL, $1, $2, NULL, NULL);		}
	|	literals			{ $$ = astreeCreate(ASTREE_ARRAY_DECL_LITS, NULL, $1, NULL, NULL, NULL);	}
	;

pointer_decl:
		types '$' identifier ':' literals ';' { $$ = astreeCreate(ASTREE_POINTER_DECL, NULL, $3, $5, NULL, NULL); /* astreePrintTree(0, $$); */ }
	;

func: 
		types identifier '(' param_list ')' decl_func_list command_block { $$ = astreeCreate(ASTREE_FUNC1, NULL, $2, $4, $6, $7);	}
	|	types identifier '(' 			')' decl_func_list command_block { $$ = astreeCreate(ASTREE_FUNC2, NULL, $2, $5, $6, NULL);	}
	|  	types identifier '(' param_list ')' command_block { $$ = astreeCreate(ASTREE_FUNC3, NULL, $2, $4, $6, NULL);		}
	|  	types identifier '(' 			')' command_block { $$ = astreeCreate(ASTREE_FUNC4, NULL, $2, $5, NULL, NULL);	}	
	;

param_list:
		types identifier ',' param_list { $$ = astreeCreate(ASTREE_FUNC_PARAM, NULL, $2, $4, NULL, NULL);	}
	|	types identifier				{ $$ = astreeCreate(ASTREE_FUNC_PARAM, NULL, $2, NULL, NULL, NULL);	}		
	;
    
decl_func_list:
		simple_decl decl_func_list		{ $$ = astreeCreate(ASTREE_FUNC_DECL, NULL, $1, $2, NULL, NULL); }
	|	pointer_decl decl_func_list		{ $$ = astreeCreate(ASTREE_FUNC_DECL, NULL, $1, $2, NULL, NULL); }
    |	simple_decl						{ $$ = astreeCreate(ASTREE_FUNC_DECL, NULL, $1, NULL, NULL, NULL); }
    | 	pointer_decl					{ $$ = astreeCreate(ASTREE_FUNC_DECL, NULL, $1, NULL, NULL, NULL); }
    ;    

command_block: 
    	'{' command_list '}' { $$ = astreeCreate(ASTREE_CMD_BLOCK, NULL, $2, NULL, NULL, NULL); }
    ;

command_list:
    	command ';' command_list { $$ = astreeCreate(ASTREE_CMDL, NULL, $1, $3, NULL, NULL); }
	|   /* nil */ { $$ = NULL; }
	;

command:
		identifier '=' exp					{ $$ = astreeCreate(ASTREE_SCALA_ASS, NULL, $1, $3, NULL, NULL); }
	|	identifier '[' LIT_INTEGER ']' '=' exp	{
			$$ = astreeCreate(ASTREE_VECT_SCALA_ASS,
					NULL, $1, 
					astreeCreate(ASTREE_SYMBOL, $3, NULL, NULL, NULL, NULL),
					$6, NULL);
	}
	|	KW_IF '(' exp ')' KW_THEN command 	{ $$ = astreeCreate(ASTREE_IF, NULL, $3, $6, NULL, NULL); }
	|	KW_IF '(' exp ')' KW_THEN command KW_ELSE command { $$ = astreeCreate(ASTREE_IF_ELSE, NULL, $3, $6, $8, NULL); }
	|	KW_LOOP '(' exp ')' command 		{ $$ = astreeCreate(ASTREE_LOOP, NULL, $3, $5, NULL, NULL); }
	|	KW_INPUT identifier 				{ $$ = astreeCreate(ASTREE_INPUT, NULL, $2, NULL, NULL, NULL); }
	|	KW_OUTPUT output_list 				{ $$ = astreeCreate(ASTREE_OUTPUT, NULL, $2, NULL, NULL, NULL); }
	|	KW_RETURN exp 						{ $$ = astreeCreate(ASTREE_RETURN, NULL, $2, NULL, NULL, NULL); }
	|	command_block 						{ $$ = $1; }
	;

output_list:
	//    string ',' output_list		{ $$ = astreeCreate(ASTREE_OUTPUT_LIST, NULL, $1, $3, NULL, NULL); }
		exp_arit ',' output_list	{ $$ = astreeCreate(ASTREE_OUTPUT_LIST, NULL, $1, $3, NULL, NULL); }
	//|	string		{ $$ = $1; }
	|	exp_arit	{ $$ = $1; }
    ;

func_call:
    	identifier '(' func_call_list ')'	{ $$ = astreeCreate(ASTREE_FUNC_CALL, NULL, $1, $3, NULL, NULL);	}
    |	identifier '(' ')'					{ $$ = astreeCreate(ASTREE_FUNC_CALL, NULL, $1, NULL, NULL, NULL);	}
    ;

func_call_list:
    	exp ',' func_call_list	{ $$ = astreeCreate(ASTREE_FUNC_CALL_LIST, NULL, $1, $3, NULL, NULL); }
    |	exp						{ $$ = astreeCreate(ASTREE_FUNC_CALL_LIST, NULL, $1, NULL, NULL, NULL); }	
    ;

exp:
		exp_arit  	{ $$ = $1; }	
	|	exp_logic	{ $$ = $1; }			
	|	func_call 	{ $$ = $1; }	
	|	'-'exp     				{ $$ = astreeCreate(ASTREE_UNARY_MINUS, NULL, $2, NULL, NULL, NULL);		}	%prec UNARY_MINUS
	|	'*'exp					{ $$ = astreeCreate(ASTREE_POINTER, NULL, $2, NULL, NULL, NULL);			}	%prec POINTER
	|	'&'exp					{ $$ = astreeCreate(ASTREE_DEREFERENCE, NULL, $2, NULL, NULL, NULL);		}	
	|	'(' exp ')'				{ $$ = astreeCreate(ASTREE_EXP_PARENTESIS, NULL, $2, NULL, NULL, NULL);	}
    ;

exp_arit:
    	exp '+' exp 			{ $$ = astreeCreate(ASTREE_ADD, NULL, $1, $3, NULL, NULL); }
	|	exp '-' exp 			{ $$ = astreeCreate(ASTREE_SUB, NULL, $1, $3, NULL, NULL); }
	|	exp '/' exp 			{ $$ = astreeCreate(ASTREE_DIV, NULL, $1, $3, NULL, NULL); }
	|	exp '*' exp 			{ $$ = astreeCreate(ASTREE_MUL, NULL, $1, $3, NULL, NULL); }
	|	literals 						  { $$ = $1; }
	|	identifier	 					  { $$ = $1; }	
	|	identifier '[' LIT_INTEGER ']' 	  { 
			$$ = astreeCreate(ASTREE_VECT_ACCESS, 
								NULL, $1, 
								astreeCreate(ASTREE_SYMBOL, $3, NULL, NULL, NULL, NULL), 
								NULL, NULL); 
	}			
	;
 
exp_logic:
		exp OPERATOR_LE exp		{ $$ = astreeCreate(ASTREE_OPERATOR_LE, NULL, $1, $3, NULL, NULL); }
	|	exp OPERATOR_GE exp 	{ $$ = astreeCreate(ASTREE_OPERATOR_GE, NULL, $1, $3, NULL, NULL); }
	|	exp OPERATOR_EQ exp 	{ $$ = astreeCreate(ASTREE_OPERATOR_EQ, NULL, $1, $3, NULL, NULL); }
	|	exp OPERATOR_NE exp 	{ $$ = astreeCreate(ASTREE_OPERATOR_NE, NULL, $1, $3, NULL, NULL); }
	|	exp OPERATOR_OR exp 	{ $$ = astreeCreate(ASTREE_OPERATOR_OR, NULL, $1, $3, NULL, NULL); }
	|	exp OPERATOR_AND exp 	{ $$ = astreeCreate(ASTREE_OPERATOR_AND, NULL, $1, $3, NULL, NULL); }
	|	exp '>' exp 			{ $$ = astreeCreate(ASTREE_OPERATOR_GREATER, NULL, $1, $3, NULL, NULL); }
	|	exp '<' exp 			{ $$ = astreeCreate(ASTREE_OPERATOR_LESS, NULL, $1, $3, NULL, NULL); }
	;
       
%%

void yyerror(char *s) {
	fprintf(stderr, "Error on line %d: %s\n", getLineNumber(), s);
}
