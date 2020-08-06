%{
	#include "hashtable.h"
    #include "astree.c"
    #include "semantics.c"
    #include "lex.yy.h"
	#include "tac.c"
	#include "genco.c"
    
    void yyerror(char *);
    int getLineNumber();
%}

%union{
    int value;
	Entry *symbol;
	ASTREE *astree;
}

%token <value> KW_WORD
%token <value> KW_BOOL
%token <value> KW_BYTE
    
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

%type <value>  types
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
		program { 
					$$ = astreeCreate(ASTREE_PROGRAM, -1, -1, NULL, $1, NULL, NULL, NULL); 
					//astreePrintTree(0, $$); 
					// astreeTranslate($$);
					astreeSemanticCheck($$);
					tac_print_list(generateCode($$));
				}
	;

program:
		decl program	{ $$ = astreeCreate(ASTREE_DECL, -1, -1, NULL, $1, $2, NULL, NULL);		}
	|	decl			{ $$ = astreeCreate(ASTREE_DECL, -1, -1, NULL, $1, NULL, NULL, NULL);	}
	|	func program	{ $$ = astreeCreate(ASTREE_FUNC, -1, -1, NULL, $1, $2, NULL, NULL);		}
	|	func			{ $$ = astreeCreate(ASTREE_FUNC, -1, -1, NULL, $1, NULL, NULL, NULL);	}
	;

decl: 
		simple_decl		{ $$ = $1; }
	|	array_decl		{ $$ = $1; }
	|	pointer_decl	{ $$ = $1; }
	; 

simple_decl: 
		types identifier ':' literals ';' { 
			$$ = astreeCreate(ASTREE_SIMPLE_DECL, $1, getLineNumber(), NULL, $2, $4, NULL, NULL);
		}
	;
	
identifier:
		TK_IDENTIFIER { $$ = astreeCreate(ASTREE_SYMBOL, -1, getLineNumber(), $1, NULL, NULL, NULL, NULL); }	
	;

types: 
		KW_WORD	{ $$ = $1; }
	|	KW_BOOL	{ $$ = $1; }
	|	KW_BYTE	{ $$ = $1; }
	;

literals: 
		LIT_INTEGER 
		{ 
			$$ = astreeCreate(ASTREE_SYMBOL, -1, getLineNumber(), $1, NULL, NULL, NULL, NULL);
			updateAndCheckNode($$, KW_WORD, -1, -1);
		}
	|	LIT_FALSE
		{
			$$ = astreeCreate(ASTREE_SYMBOL, -1, getLineNumber(), $1, NULL, NULL, NULL, NULL);
			updateAndCheckNode($$, KW_BOOL, -1, -1);			
		}
	|	LIT_TRUE	
		{ 
			$$ = astreeCreate(ASTREE_SYMBOL, -1, getLineNumber(), $1, NULL, NULL, NULL, NULL);
			updateAndCheckNode($$, KW_BOOL, -1, -1);						
		}
	|	LIT_CHAR	
		{ 
			$$ = astreeCreate(ASTREE_SYMBOL, -1, getLineNumber(), $1, NULL, NULL, NULL, NULL);
			updateAndCheckNode($$, KW_BYTE, -1, -1);			
		}
	|	LIT_STRING	{ $$ = astreeCreate(ASTREE_SYMBOL, -1, getLineNumber(), $1, NULL, NULL, NULL, NULL); }
	;

array_decl: 
		types identifier '[' LIT_INTEGER ']' ';' {
			$$ = astreeCreate(ASTREE_ARRAY_DECL,
							  $1, 
							  getLineNumber(),
							  NULL, 
							  $2, 
							  astreeCreate(ASTREE_SYMBOL, -1, -1, $4, NULL, NULL, NULL, NULL), 
							  NULL,
							  NULL);
		}
	
	|	types identifier '[' LIT_INTEGER ']' ':' lit_list ';' {
			$$ = astreeCreate(ASTREE_ARRAY_DECL_INI,
							  $1,
							  getLineNumber(),
							  NULL, 
							  $2, 
							  astreeCreate(ASTREE_SYMBOL, -1, -1, $4, NULL, NULL, NULL, NULL), 
							  $7,
							  NULL);
		}
	;
	
lit_list: 
		literals lit_list	{ $$ = astreeCreate(ASTREE_ARRAY_DECL_LITS, -1, -1, NULL, $1, $2, NULL, NULL);		}
	|	literals			{ $$ = astreeCreate(ASTREE_ARRAY_DECL_LITS, -1, -1, NULL, $1, NULL, NULL, NULL);	}
	;

pointer_decl:
		types '$' identifier ':' literals ';' { 
			$$ = astreeCreate(ASTREE_POINTER_DECL, $1, getLineNumber(), NULL, $3, $5, NULL, NULL); /* astreePrintTree(0, $$); */ 
		}
	;

func: 
		types identifier '(' param_list ')' decl_func_list command_block
		{
			updateAndCheckNode($2, $1, FUNCTION, getLineNumber());
			$2 = fillParamList($2, $4);
			$$ = astreeCreate(ASTREE_FUNC1, $1, getLineNumber(), NULL, $2, $4, $6, $7);
			//tac_print_list(generateCode($$));			
		}
	|	types identifier '(' 			')' decl_func_list command_block
		{
			updateAndCheckNode($2, $1, FUNCTION, getLineNumber());
			$2 = fillParamList($2, NULL);
			$$ = astreeCreate(ASTREE_FUNC2, $1, getLineNumber(), NULL, $2, $5, $6, NULL);
			//tac_print_list(generateCode($$));
		}
	|  	types identifier '(' param_list ')' command_block
		{ 
			updateAndCheckNode($2, $1, FUNCTION, getLineNumber());
			$2 = fillParamList($2, $4);
			$$ = astreeCreate(ASTREE_FUNC3, $1, getLineNumber(), NULL, $2, $4, $6, NULL);
			//tac_print_list(generateCode($$));
		}
	|  	types identifier '(' 			')' command_block
		{
			updateAndCheckNode($2, $1, FUNCTION, getLineNumber());
			$2 = fillParamList($2, NULL);
			$$ = astreeCreate(ASTREE_FUNC4, $1, getLineNumber(), NULL, $2, $5, NULL, NULL);
			//tac_print_list(generateCode($$));
		}
	;

param_list:
		types identifier ',' param_list 
		{ 
			updateAndCheckNode($2, $1, -1, getLineNumber());
			$$ = astreeCreate(ASTREE_FUNC_PARAM, $1, getLineNumber(), NULL, $2, $4, NULL, NULL);
		}
	|	types identifier				
		{ 
			updateAndCheckNode($2, $1, -1, getLineNumber());
			$$ = astreeCreate(ASTREE_FUNC_PARAM, $1, getLineNumber(), NULL, $2, NULL, NULL, NULL);
		}		
	;
    
decl_func_list:
		simple_decl decl_func_list		{ $$ = astreeCreate(ASTREE_FUNC_DECL, -1, getLineNumber(), NULL, $1, $2, NULL, NULL); }
	|	pointer_decl decl_func_list		{ $$ = astreeCreate(ASTREE_FUNC_DECL, -1, getLineNumber(), NULL, $1, $2, NULL, NULL); }
    |	simple_decl						{ $$ = astreeCreate(ASTREE_FUNC_DECL, -1, getLineNumber(), NULL, $1, NULL, NULL, NULL); }
    | 	pointer_decl					{ $$ = astreeCreate(ASTREE_FUNC_DECL, -1, getLineNumber(), NULL, $1, NULL, NULL, NULL); }
    ;    

command_block: 
    	'{' command_list '}' { $$ = astreeCreate(ASTREE_CMD_BLOCK, -1, getLineNumber(), NULL, $2, NULL, NULL, NULL); }
    ;

command_list:
    	command ';' command_list { $$ = astreeCreate(ASTREE_CMDL, -1, getLineNumber(), NULL, $1, $3, NULL, NULL); }
	|   /* nil */ { $$ = NULL; }
	;

command:
		identifier '=' exp { 
			$$ = astreeCreate(ASTREE_SCALA_ASS, -1, getLineNumber(), NULL, $1, $3, NULL, NULL);
		}
	|	identifier '[' exp ']' '=' exp	{
			$$ = astreeCreate(ASTREE_VECT_SCALA_ASS,
					-1,
					getLineNumber(),
					NULL,
					$1, $3, $6, NULL);
	}
	|	KW_IF '(' exp ')' KW_THEN command 	{
			$$ = astreeCreate(ASTREE_IF, -1, getLineNumber(), NULL, $3, $6, NULL, NULL);
			//tac_print_list(generateCode($$));
		}
	|	KW_IF '(' exp ')' KW_THEN command KW_ELSE command { $$ = astreeCreate(ASTREE_IF_ELSE, -1, getLineNumber(), NULL, $3, $6, $8, NULL); }
	|	KW_LOOP '(' exp ')' command 		{
			$$ = astreeCreate(ASTREE_LOOP, -1, getLineNumber(), NULL, $3, $5, NULL, NULL);
			//tac_print_list(generateCode($$));
		}
	|	KW_INPUT identifier 				{ $$ = astreeCreate(ASTREE_INPUT, -1, getLineNumber(), NULL, $2, NULL, NULL, NULL);	}
	|	KW_OUTPUT output_list 				{ $$ = astreeCreate(ASTREE_OUTPUT, -1, getLineNumber(), NULL, $2, NULL, NULL, NULL); }
	|	KW_RETURN exp 						{ $$ = astreeCreate(ASTREE_RETURN, -1, getLineNumber(), NULL, $2, NULL, NULL, NULL); }
	|	command_block 						{ $$ = $1; }
	;

output_list:
		exp_arit ',' output_list	{ $$ = astreeCreate(ASTREE_OUTPUT_LIST, -1, getLineNumber(), NULL, $1, $3, NULL, NULL); }
	|	exp_arit					{ $$ = astreeCreate(ASTREE_OUTPUT_LIST, -1, getLineNumber(), NULL, $1, NULL, NULL, NULL); }
    ;

func_call:
    	identifier '(' func_call_list ')'	{ $$ = astreeCreate(ASTREE_FUNC_CALL, -1, getLineNumber(), NULL, $1, $3, NULL, NULL); }
    |	identifier '(' ')'					{ $$ = astreeCreate(ASTREE_FUNC_CALL, -1, getLineNumber(), NULL, $1, NULL, NULL, NULL);	}
    ;

func_call_list:
    	exp ',' func_call_list	{ $$ = astreeCreate(ASTREE_FUNC_CALL_LIST, -1, getLineNumber(), NULL, $1, $3, NULL, NULL);   }
    |	exp						{ $$ = astreeCreate(ASTREE_FUNC_CALL_LIST, -1, getLineNumber(), NULL, $1, NULL, NULL, NULL); }	
    ;

exp:
		exp_arit  	{ $$ = $1; }	
	|	exp_logic	{ $$ = $1; }			
	|	func_call 	{ $$ = $1; }	
	|	'-'exp						{ $$ = astreeCreate(ASTREE_UNARY_MINUS, -1, getLineNumber(), NULL, $2, NULL, NULL, NULL);			}	%prec UNARY_MINUS
	|	'*'exp						{ $$ = astreeCreate(ASTREE_POINTER_DEREFERENCE, -1, getLineNumber(), NULL, $2, NULL, NULL, NULL);	}	%prec POINTER
	|	'&'identifier				{ $$ = astreeCreate(ASTREE_POINTER_REFERENCE, -1, getLineNumber(), NULL, $2, NULL, NULL, NULL);		}
	|   '&'identifier '[' exp ']'	{ $$ = astreeCreate(ASTREE_POINTER_REFERENCE_ARRAY, -1, getLineNumber(), NULL, $2, $4, NULL, NULL); }
	|	'(' exp ')'					{ $$ = astreeCreate(ASTREE_EXP_PARENTESIS, -1, getLineNumber(), NULL, $2, NULL, NULL, NULL);		}
    ;

exp_arit:
    	exp '+' exp 			{ 
			$$ = astreeCreate(ASTREE_ADD, -1, getLineNumber(), NULL, $1, $3, NULL, NULL);
		}
	|	exp '-' exp 			{ $$ = astreeCreate(ASTREE_SUB, -1, getLineNumber(), NULL, $1, $3, NULL, NULL); }
	|	exp '/' exp 			{ $$ = astreeCreate(ASTREE_DIV, -1, getLineNumber(), NULL, $1, $3, NULL, NULL); }
	|	exp '*' exp 			{ $$ = astreeCreate(ASTREE_MUL, -1, getLineNumber(), NULL, $1, $3, NULL, NULL); }
	|	literals 						  { $$ = $1; }
	|	identifier	 					  { $$ = $1; }	
	|	identifier '[' exp ']' 	  { 
			$$ = astreeCreate(ASTREE_VECT_ACCESS, 
								-1,
								getLineNumber(),  
								NULL,
								$1, $3, NULL, NULL); 
	}			
	;
 
exp_logic:
		exp OPERATOR_LE exp		{ $$ = astreeCreate(ASTREE_OPERATOR_LE, -1, getLineNumber(), NULL, $1, $3, NULL, NULL);		}
	|	exp OPERATOR_GE exp 	{ $$ = astreeCreate(ASTREE_OPERATOR_GE, -1, getLineNumber(), NULL, $1, $3, NULL, NULL);		}
	|	exp OPERATOR_EQ exp 	{ $$ = astreeCreate(ASTREE_OPERATOR_EQ, -1, getLineNumber(), NULL, $1, $3, NULL, NULL);		}
	|	exp OPERATOR_NE exp 	{ $$ = astreeCreate(ASTREE_OPERATOR_NE, -1, getLineNumber(), NULL, $1, $3, NULL, NULL);		}
	|	exp OPERATOR_OR exp 	{ $$ = astreeCreate(ASTREE_OPERATOR_OR, -1, getLineNumber(), NULL, $1, $3, NULL, NULL);		}
	|	exp OPERATOR_AND exp 	{ $$ = astreeCreate(ASTREE_OPERATOR_AND, -1, getLineNumber(), NULL, $1, $3, NULL, NULL);	}
	|	exp '>' exp 			{ $$ = astreeCreate(ASTREE_OPERATOR_GREATER, -1, getLineNumber(), NULL, $1, $3, NULL, NULL); }
	|	exp '<' exp 			{ $$ = astreeCreate(ASTREE_OPERATOR_LESS, -1, getLineNumber(), NULL, $1, $3, NULL, NULL);	}
	;

%%

void yyerror(char *s) {
	fprintf(stderr, "Error on line %d: %s\n", getLineNumber(), s);
}