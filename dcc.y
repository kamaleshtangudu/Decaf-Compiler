%{
    #include <iostream>
    #include <string>
    #include <vector>
    #include "AST.h"
    #include "Visitor.h"
    extern "C" int yylex();
    extern "C" int yyparse();
    extern "C" FILE * yyin;
    extern int yylineno;

    void yyerror(const char *s);
    extern ProgramNonterminal * start;
%}

%union {
    char *sval;
    int ival;
    char cval;
    ProgramNonterminal * program;
    std::vector<FieldDeclarationNonterminal *> * field_decl_list;
    FieldDeclarationNonterminal * field_decl;
    std::vector<VarIdentifierNonterminal *> * identifier_list;
    std::vector<ArrayIdentifierNonterminal *> * identifier_array_list;
    ArrayIdentifierNonterminal * identifier_array;
    std::vector<MethodDeclarationNonterminal *> * method_decl_list;
    MethodDeclarationNonterminal * method_decl;
    std::vector<TypeIdentifierNonterminal *> * type_identifier_list;
    TypeIdentifierNonterminal * type_identifier;
    BlockStatementNonterminal * block;
    std::vector<StatementNonterminal *> * statement_list;
    std::vector<VarDeclarationNonterminal *> * var_decl_list;
    VarDeclarationNonterminal * var_decl;
    Datatype type;
    StatementNonterminal * statement;
    AssignOp assign_op;
    MethodCallNonterminal * method_call;
    std::vector<ExpressionNonterminal *> * expr_list;
    std::vector<CalloutArgNonterminal *> * callout_arg_list;
    LocationNonterminal * location;
    ExpressionNonterminal * expr;
    CalloutArgNonterminal * callout_arg;
    LiteralExpressionNonterminal * literal;
}

%token COMMA
%token SEMICOLON
%token OPEN_PARANTHESIS
%token CLOSE_PARANTHESIS
%token OPEN_SQUAREBRACKET
%token CLOSE_SQUAREBRACKET
%token OPEN_CURLYBRACE
%token CLOSE_CURLYBRACE
%token BOOLEAN
%token BREAK
%token CALLOUT
%token CLASS
%token CONTINUE
%token ELSE
%token FALSE
%token FOR
%token IF
%token INT
%token RETURN
%token TRUE
%token VOID
%token PROGRAMME

%nonassoc LESSEQUAL LESSTHAN GREATEREQUAL GREATERTHAN

%left EQUALEQUAL NOTEQUAL
%left OR
%left AND
%left PLUS MINUS
%left MULTIPLY DIVIDE MODULO

%precedence NOT UMINUS
%token EQUAL PLUSEQUAL MINUSEQUAL

%token <sval> IDENTIFIER
%token <ival> INT_VALUE
%token <sval> STRING_VALUE
%token <cval> CHAR_VALUE

%type <program> program
%type <field_decl_list> field_decl_list
%type <field_decl> field_decl
%type <identifier_list> identifier_list
%type <identifier_array_list> identifier_array_list
%type <identifier_array> identifier_array
%type <method_decl_list> method_decl_list
%type <method_decl> method_decl
%type <type_identifier_list> type_identifier_list
%type <type_identifier> type_identifier
%type <block> block
%type <statement_list> statement_list
%type <var_decl_list> var_decl_list
%type <var_decl> var_decl
%type <type> type
%type <statement> statement
%type <assign_op> assign_op
%type <method_call> method_call
%type <expr_list> expr_list
%type <callout_arg_list> callout_arg_list
%type <location> location
%type <expr> expr
%type <callout_arg> callout_arg
%type <literal> literal

%%

program : CLASS PROGRAMME OPEN_CURLYBRACE field_decl_list method_decl_list CLOSE_CURLYBRACE { $$ = new ProgramNonterminal($4, $5); start = $$; }
        | CLASS PROGRAMME OPEN_CURLYBRACE field_decl_list CLOSE_CURLYBRACE  { $$ = new ProgramNonterminal($4, NULL); start = $$; }
        | CLASS PROGRAMME OPEN_CURLYBRACE method_decl_list CLOSE_CURLYBRACE { $$ = new ProgramNonterminal(NULL, $4); start = $$; }
        | CLASS PROGRAMME OPEN_CURLYBRACE CLOSE_CURLYBRACE { $$ = new ProgramNonterminal(NULL, NULL); start = $$; }
        ;

field_decl_list : field_decl { $$ = new std::vector<FieldDeclarationNonterminal *>(); $$->push_back($1); }
                | field_decl_list field_decl { $1->push_back($2); $$ = $1; }
                ;

field_decl : type identifier_list SEMICOLON { $$ = new FieldDeclarationNonterminal($2, $1); }
           | type identifier_array_list SEMICOLON { $$ = new FieldDeclarationNonterminal($2, $1); }
           ;

identifier_list : IDENTIFIER { $$ = new std::vector<VarIdentifierNonterminal *>(); $$->push_back(new VarIdentifierNonterminal(std::string($1))); }
                | identifier_list COMMA IDENTIFIER { $1->push_back(new VarIdentifierNonterminal(std::string($3))); $$ = $1; }
                ;

identifier_array_list : identifier_array { $$ = new std::vector<ArrayIdentifierNonterminal *>(); $$->push_back($1); }
                      | identifier_array_list COMMA identifier_array { $1->push_back($3); $$ = $1; }
                      ;

identifier_array : IDENTIFIER OPEN_SQUAREBRACKET INT_VALUE CLOSE_SQUAREBRACKET { $$ = new ArrayIdentifierNonterminal(std::string($1), $3); }
                 ;

method_decl_list : method_decl { $$ = new std::vector<MethodDeclarationNonterminal *>(); $$->push_back($1); }
                 | method_decl_list method_decl { $1->push_back($2); $$ = $1; }
                 ;

method_decl : type IDENTIFIER OPEN_PARANTHESIS type_identifier_list CLOSE_PARANTHESIS block { $$ = new MethodDeclarationNonterminal(std::string($2), $1, $4, $6); }
            | type IDENTIFIER OPEN_PARANTHESIS CLOSE_PARANTHESIS block { $$ = new MethodDeclarationNonterminal(std::string($2), $1, NULL, $5); }
            | VOID IDENTIFIER OPEN_PARANTHESIS type_identifier_list CLOSE_PARANTHESIS block { $$ = new MethodDeclarationNonterminal(std::string($2), Datatype::void_type, $4, $6); }
            | VOID IDENTIFIER OPEN_PARANTHESIS CLOSE_PARANTHESIS block { $$ = new MethodDeclarationNonterminal(std::string($2), Datatype::void_type, NULL, $5); }
            ;

type_identifier_list : type_identifier { $$ = new std::vector<TypeIdentifierNonterminal *>(); $$->push_back($1); }
                     | type_identifier_list COMMA type_identifier { $1->push_back($3); $$ = $1; }
                     ;

type_identifier : type IDENTIFIER { $$ = new TypeIdentifierNonterminal(std::string($2), $1); }
                ;

block : OPEN_CURLYBRACE var_decl_list statement_list CLOSE_CURLYBRACE { $$ = new BlockStatementNonterminal($3, $2); } 
      | OPEN_CURLYBRACE var_decl_list CLOSE_CURLYBRACE { $$ = new BlockStatementNonterminal(NULL, $2); }
      | OPEN_CURLYBRACE statement_list CLOSE_CURLYBRACE { $$ = new BlockStatementNonterminal($2, NULL); }
      | OPEN_CURLYBRACE CLOSE_CURLYBRACE { $$ = new BlockStatementNonterminal(NULL, NULL); }
      ;

statement_list : statement { $$ = new std::vector<StatementNonterminal *>(); $$->push_back($1); }
               | statement_list statement { $1->push_back($2); $$ = $1; }
               ;

var_decl_list : var_decl { $$ = new std::vector<VarDeclarationNonterminal *>(); $$->push_back($1); }
              | var_decl_list var_decl { $1->push_back($2); $$ = $1; }
              ;

var_decl : type identifier_list SEMICOLON { $$ = new VarDeclarationNonterminal($2, $1); }
         ;

type : INT { $$ = Datatype::int_type; }
     | BOOLEAN { $$ = Datatype::bool_type; }
     ;

statement : SEMICOLON { $$ = NULL; }
          | location assign_op expr SEMICOLON { $$ = new AssignmentStatementNonterminal($2, $1, $3); }
          | method_call SEMICOLON { $$ = $1; }
          | IF OPEN_PARANTHESIS expr CLOSE_PARANTHESIS block ELSE block { $$ = new IfStatementNonterminal($3, $5, $7); }
          | IF OPEN_PARANTHESIS expr CLOSE_PARANTHESIS block { $$ = new IfStatementNonterminal($3, $5, NULL); }
          | FOR IDENTIFIER EQUAL expr COMMA expr block { $$ = new ForStatementNonterminal($2, $4, $6, $7); }
          | RETURN expr SEMICOLON { $$ = new ReturnStatementNonterminal($2); }
          | RETURN SEMICOLON { $$ = new ReturnStatementNonterminal(NULL); }
          | BREAK SEMICOLON { $$ = new BreakStatementNonterminal(); }
          | CONTINUE SEMICOLON { $$ = new ContinueStatementNonterminal(); }
          | block { $$ = $1; }
          ;

assign_op : EQUAL { $$ = AssignOp::equal; }
          | PLUSEQUAL { $$ = AssignOp::plus_equal; }
          | MINUSEQUAL { $$ = AssignOp::minus_equal; }
          ;

method_call : IDENTIFIER OPEN_PARANTHESIS expr_list CLOSE_PARANTHESIS { $$ = new NormalMethodNonterminal(std::string($1), $3); }
            | IDENTIFIER OPEN_PARANTHESIS CLOSE_PARANTHESIS { $$ = new NormalMethodNonterminal(std::string($1), NULL); }
            | CALLOUT OPEN_PARANTHESIS STRING_VALUE COMMA callout_arg_list CLOSE_PARANTHESIS { $$ = new CalloutMethodNonterminal(std::string($3), $5); }
            | CALLOUT OPEN_PARANTHESIS STRING_VALUE CLOSE_PARANTHESIS { $$ = new CalloutMethodNonterminal(std::string($3), NULL); }
            ;
  
expr_list : expr { $$ = new std::vector<ExpressionNonterminal *>(); $$->push_back($1); }
          | expr_list COMMA expr { $1->push_back($3); $$ = $1; }
          ;

callout_arg_list : callout_arg { $$ = new std::vector<CalloutArgNonterminal *>(); $$->push_back($1); }
                 | callout_arg_list COMMA callout_arg { $1->push_back($3); $$ = $1; }
                 ;

location : IDENTIFIER { $$ = new VarLocationNonterminal(std::string($1)); }
         | IDENTIFIER OPEN_SQUAREBRACKET expr CLOSE_SQUAREBRACKET { $$ = new ArrayLocationNonterminal(std::string($1), $3); }
         ;

expr : location { $$ = $1; }
     | method_call { $$ = $1; }
     | literal { $$ = $1; }
     | expr OR expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::or_op); }
     | expr AND expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::and_op); }
     | expr EQUALEQUAL expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::equalequal_op); }
     | expr NOTEQUAL expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::notequal_op); }
     | expr LESSTHAN expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::lessthan_op); }
     | expr LESSEQUAL expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::lessequal_op); }
     | expr GREATEREQUAL expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::greaterthan_op); }
     | expr GREATERTHAN expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::greaterequal_op); }
     | expr PLUS expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::plus_op); }
     | expr MINUS expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::minus_op); }
     | expr MULTIPLY expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::multiply_op); }
     | expr DIVIDE expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::divide_op); }
     | expr MODULO expr { $$ = new BinaryOperationNonterminal($1, $3, BinaryOp::modulo_op); }
     | NOT expr { $$ = new UnaryOperationNonterminal($2, UnOp::not_op); }
     | MINUS expr %prec UMINUS { $$ = new UnaryOperationNonterminal($2, UnOp::minus_op); }
     | OPEN_PARANTHESIS expr CLOSE_PARANTHESIS { $$ = $2; }
     ;

callout_arg : expr  { $$ = new ExpressionCalloutArgNonterminal($1); }
            | STRING_VALUE { $$ = new StringCalloutArgNonterminal(std::string($1)); }
            ;

literal : INT_VALUE { $$ = new IntegerLiteralExpressionNonterminal($1); }
        | CHAR_VALUE { $$ = new CharLiteralExpressionNonterminal($1); }
        | TRUE { $$ = new TrueLiteralExpressionNonterminal(); }
        | FALSE { $$ = new FalseLiteralExpressionNonterminal(); }
        ;

%%


void yyerror (const char *s) {
    std::cerr << "Parse Error on Line : " << yylineno << std::endl << "Message : " << s << std::endl;
    exit(-1);
}

