#ifndef _AST_H
#define _AST_H
#include <vector>
#include <string>
#include "Visitor.h"

/*class ProgramNonterminal;
class FieldDeclarationNonterminal;
class VarDeclarationNonterminal;
class IdentifierNonterminal;
class VarIdentifierNonterminal;
class ArrayIdentifierNonterminal;
class MethodDeclarationNonterminal;
class TypeIdentifierNonterminal;
class StatementNonterminal;
class ExpressionNonterminal;
class BlockStatementNonterminal;
class AssignmentStatementNonterminal;
class MethodCallNonterminal;
class NormalMethodNonterminal;
class CalloutMethodNonterminal;
class CalloutArgNonterminal;
class StringCalloutArgNonterminal;
class ExpressionCalloutArgNonterminal;
class IfStatementNonterminal;
class ForStatementNonterminal;
class ReturnStatementNonterminal;
class ContinueStatementNonterminal;
class BreakStatementNonterminal;
class LocationNonterminal;
class VarLocationNonterminal;
class ArrayLocationNonterminal;
class LiteralExpressionNonterminal;
class IntegerLiteralExpressionNonterminal;
class CharLiteralExpressionNonterminal;
class TrueLiteralExpressionNonterminal;
class FalseLiteralExpressionNonterminal;
class BinaryOperationNonterminal;
class UnaryOperationNonterminal;*/

enum class BinaryOp : char {
    plus_op,
    minus_op,
    multiply_op,
    divide_op,
    modulo_op,
    lessthan_op,
    greaterthan_op,
    lessequal_op,
    greaterequal_op,
    notequal_op,
    equalequal_op,
    and_op,
    or_op
};

enum class Datatype : char {
    int_type,
    void_type,
    bool_type
};

enum class AssignOp : char {
    plus_equal,
    minus_equal,
    equal
};

enum class UnOp : char {
    minus_op,
    not_op
};

class ASTNode {
public:
    ASTNode() {
    }
    ~ASTNode() {
    }
    virtual void accept(Visitor * v) = 0;
    std::string parseBinOp(BinaryOp op){
        switch(op){
            case BinaryOp::plus_op: 
            return "+";
            case BinaryOp::minus_op: 
            return "-";
            case BinaryOp::multiply_op: 
            return "*";
            case BinaryOp::divide_op: 
            return "/";
            case BinaryOp::modulo_op: 
            return "%";
            case BinaryOp::lessthan_op: 
            return "<";
            case BinaryOp::greaterthan_op: 
            return ">";
            case BinaryOp::lessequal_op: 
            return "<=";
            case BinaryOp::greaterequal_op: 
            return ">=";
            case BinaryOp::notequal_op: 
            return "!=";
            case BinaryOp::equalequal_op: 
            return "==";
            case BinaryOp::and_op: 
            return "&&";
            case BinaryOp::or_op: 
            return "||";
        }
        return "";
    }

    std::string parseDatatype(Datatype type){
        switch(type){
            case Datatype::int_type: 
            return "int";
            case Datatype::void_type: 
            return "void";
            case Datatype::bool_type: 
            return "bool";
        }
        return "";
    }

    std::string parseUnOp(UnOp op){
        if(op==UnOp::minus_op)
        {
            return "-";
        }
        else if(op==UnOp::not_op)
        {
            return "!";
        }
        else
        {
            return "";
        }
/*
        switch(op){
            case UnOp::minus_op: 
            return "-";
            case UnOp::not_op: 
            return "!";
        }*/
        //return "";
    }

    std::string parseAssignOp(AssignOp op){
        switch(op){
            case AssignOp::plus_equal: 
            return "+=";
            case AssignOp::minus_equal: 
            return "-=";
            case AssignOp::equal: 
            return "=";
        }
        return "";
    }
};

class ProgramNonterminal
{
    std::vector<FieldDeclarationNonterminal *> * fdl;
    std::vector<MethodDeclarationNonterminal *> * mdl;
public:
    ProgramNonterminal(std::vector<FieldDeclarationNonterminal *> * fdl, std::vector<MethodDeclarationNonterminal *> * mdl){
        this->mdl = mdl;
        this->fdl = fdl;
    }
    std::vector<MethodDeclarationNonterminal *> * getMdl() {
        return this->mdl;
    }
    std::vector<FieldDeclarationNonterminal *> * getFdl() {
        return this->fdl;
    }
    ~ProgramNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class FieldDeclarationNonterminal : public ASTNode
{
    Datatype type;
    std::vector<VarIdentifierNonterminal *> * var_id_list;
    std::vector<ArrayIdentifierNonterminal *> * array_id_list;
public:
    FieldDeclarationNonterminal(std::vector<VarIdentifierNonterminal *> * var_id_list, Datatype type){
        this->type = type;
        this->var_id_list = var_id_list;
        this->array_id_list = NULL;
    }
    FieldDeclarationNonterminal(std::vector<ArrayIdentifierNonterminal *> * array_id_list, Datatype type){
        this->type = type;
        this->array_id_list = array_id_list;
        this->var_id_list = NULL;
    }
    std::vector<VarIdentifierNonterminal *> * getVar_id_list() {
        return this->var_id_list;
    }
    std::vector<ArrayIdentifierNonterminal *> * getArray_id_list() {
        return this->array_id_list;
    }
    Datatype getType() {
        return this->type;
    }
    ~FieldDeclarationNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class VarDeclarationNonterminal : public ASTNode
{
    Datatype type;
    std::vector<VarIdentifierNonterminal *> * id_list;
public:
    VarDeclarationNonterminal(std::vector<VarIdentifierNonterminal *> * id_list, Datatype type) {
        this->type = type;
        this->id_list = id_list;
    }
    std::vector<VarIdentifierNonterminal *> * getId_list() {
        return this->id_list;
    }
    Datatype getType() {
        return this->type;
    }
    ~VarDeclarationNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class IdentifierNonterminal : public ASTNode 
{
public: 
    IdentifierNonterminal() {
        
    }
    ~IdentifierNonterminal() {
        
    }
    virtual void accept(Visitor * v) = 0;
};

class VarIdentifierNonterminal : public IdentifierNonterminal
{
    std::string id;
public:
    VarIdentifierNonterminal(std::string id) {
        this->id = id;
    }
    std::string getId() {
        return this->id;
    }
    ~VarIdentifierNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ArrayIdentifierNonterminal : public IdentifierNonterminal 
{
    std::string id;
    int size;
public:
    ArrayIdentifierNonterminal(std::string id, int size) {
        this->id = id;
        this->size = size;      
    }
    std::string getId() {
        return this->id;
    }
    int getSize() {
        return this->size;
    }
    ~ArrayIdentifierNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class MethodDeclarationNonterminal : public ASTNode
{
    std::string id;
    Datatype returnType;
    std::vector<TypeIdentifierNonterminal *> * arguments;
    BlockStatementNonterminal * block;
public:
    MethodDeclarationNonterminal(std::string id, Datatype returnType, std::vector<TypeIdentifierNonterminal *> * arguments, BlockStatementNonterminal * block) {
        this->id = id;
        this->returnType = returnType;
        this->arguments = arguments;
        this->block = block;
    }
    std::string getId() {
        return this->id;
    }
    Datatype getReturnType() {
        return this->returnType;
    }
    std::vector<TypeIdentifierNonterminal *> * getArguments() {
        return this->arguments;
    }
    BlockStatementNonterminal * getBlock() {
        return this->block;
    }
    ~MethodDeclarationNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class TypeIdentifierNonterminal : public ASTNode
{
    std::string id;
    Datatype type;
public:
    TypeIdentifierNonterminal(std::string id, Datatype type) {
        this->id = id;
        this->type = type;
    }
    ~TypeIdentifierNonterminal() {
        
    }
    std::string getId() {
        return this->id;
    }
    Datatype getType() {
        return this->type;
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class StatementNonterminal : public ASTNode 
{
public:
    StatementNonterminal() {
        
    }
    ~StatementNonterminal() {
        
    }
    virtual void accept(Visitor * v) = 0;
};


class ExpressionNonterminal : public ASTNode
{
public:
    ExpressionNonterminal() {
        
    }
    ~ExpressionNonterminal() {
        
    }
    virtual void accept(Visitor * v) = 0;
};

class BlockStatementNonterminal : public StatementNonterminal
{
    std::vector<VarDeclarationNonterminal *> * id_list;
    std::vector<StatementNonterminal *> * stmtlist;
public:
    BlockStatementNonterminal(std::vector<StatementNonterminal *> * stmtlist, std::vector<VarDeclarationNonterminal *> * id_list) {
        this->stmtlist = stmtlist;
        this->id_list = id_list;
    }
    std::vector<VarDeclarationNonterminal *> * getId_list() {
        return this->id_list;
    }
    std::vector<StatementNonterminal *> * getStmtlist() {
        return this->stmtlist;
    }
    ~BlockStatementNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class AssignmentStatementNonterminal : public StatementNonterminal
{

    LocationNonterminal * location;
    ExpressionNonterminal * expr;
public:
    AssignOp op;
    AssignmentStatementNonterminal(AssignOp op, LocationNonterminal * location, ExpressionNonterminal * expr) {
        this->op = op;
        this->location = location;
        this->expr = expr;
    }
    AssignOp getOp() {
        return this->op;
    }
    LocationNonterminal * getLocation() {
        return this->location;
    }
    ExpressionNonterminal * getExpr() {
        return this->expr;
    }
    ~AssignmentStatementNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class MethodCallNonterminal : public StatementNonterminal, public ExpressionNonterminal 
{
public:
    MethodCallNonterminal() {
        
    }
    ~MethodCallNonterminal() {
        
    }
    virtual void accept(Visitor * v) = 0;
};

class NormalMethodNonterminal : public MethodCallNonterminal 
{
    std::string id;
    std::vector<ExpressionNonterminal *> * arguments;
public:
    NormalMethodNonterminal(std::string id, std::vector<ExpressionNonterminal *> * arguments) {
        this->id = id;
        this->arguments = arguments;
    }
    std::string getId() {
        return this->id;
    }
    std::vector<ExpressionNonterminal *> * getArguments() {
        return this->arguments;
    }
    ~NormalMethodNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class CalloutMethodNonterminal : public MethodCallNonterminal 
{
    std::string method_name;
    std::vector<CalloutArgNonterminal *> * arguments;
public:
    CalloutMethodNonterminal(std::string method_name, std::vector<CalloutArgNonterminal *> * arguments) {
        this->method_name = method_name;
        this->arguments = arguments;
    }
    std::string getMethod_name() {
        return this->method_name;
    }
    std::vector<CalloutArgNonterminal *> * getArguments() {
        return this->arguments;
    }
    ~CalloutMethodNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class CalloutArgNonterminal : public ExpressionNonterminal
{
public:
    CalloutArgNonterminal() {
        
    }
    ~CalloutArgNonterminal() {
        
    }
};

class StringCalloutArgNonterminal : public CalloutArgNonterminal 
{
    std::string argument;
public:
    StringCalloutArgNonterminal(std::string argument) {
        this->argument = argument;
    }
    std::string getArgument() {
        return this->argument;
    }
    ~StringCalloutArgNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ExpressionCalloutArgNonterminal : public CalloutArgNonterminal 
{
    ExpressionNonterminal * argument;
public:
    ExpressionCalloutArgNonterminal(ExpressionNonterminal * argument) {
        this->argument = argument;
    }
    ExpressionNonterminal * getArgument() {
        return this->argument;
    }
    ~ExpressionCalloutArgNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class IfStatementNonterminal : public StatementNonterminal 
{
    ExpressionNonterminal * condition;
    BlockStatementNonterminal * if_block;
    BlockStatementNonterminal * else_block;
public:
    IfStatementNonterminal(ExpressionNonterminal * condition, BlockStatementNonterminal * if_block, BlockStatementNonterminal * else_block) {
        this->condition = condition;
        this->if_block = if_block;
        this->else_block = else_block;
    }
    ExpressionNonterminal * getCondition() {
        return this->condition;
    }
    BlockStatementNonterminal * getIf_block() {
        return this->if_block;
    }
    BlockStatementNonterminal * getElse_block() {
        return this->else_block;
    }
    ~IfStatementNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ForStatementNonterminal : public StatementNonterminal 
{
    ExpressionNonterminal * init_condition;
    ExpressionNonterminal * end_condition;
    BlockStatementNonterminal * block;
    std::string id_name;
public:
    ForStatementNonterminal(std::string Idd, ExpressionNonterminal * init_condition, ExpressionNonterminal * end_condition, BlockStatementNonterminal * block) {
        this->id_name = Idd;
        this->init_condition = init_condition;
        this->end_condition = end_condition;
        this->block = block;
    }
    ExpressionNonterminal * getInit_condition() {
        return this->init_condition;
    }
    ExpressionNonterminal * getEnd_condition() {
        return this->end_condition;
    }
    BlockStatementNonterminal * getBlock() {
        return this->block;
    }
    std::string getidValue()
    {
        return this->id_name;
    }
    ~ForStatementNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ReturnStatementNonterminal : public StatementNonterminal
{
    ExpressionNonterminal * return_expr;
public:
    ReturnStatementNonterminal(ExpressionNonterminal * return_expr) {
        this->return_expr = return_expr;
    }
    ExpressionNonterminal * getReturn_expr() {
        return this->return_expr;
    }
    ~ReturnStatementNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ContinueStatementNonterminal : public StatementNonterminal
{
public:
    ContinueStatementNonterminal() {
        
    }
    ~ContinueStatementNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class BreakStatementNonterminal : public StatementNonterminal
{
public:
    BreakStatementNonterminal() {
        
    }
    ~BreakStatementNonterminal() {
        
    }
    void accept(Visitor * v) {
         v->visit(this);
    }
};

class LocationNonterminal : public ExpressionNonterminal
{
public:
    LocationNonterminal() {
        
    }
    ~LocationNonterminal() {
        
    }
    void accept(Visitor * v) = 0;
};

class VarLocationNonterminal : public LocationNonterminal 
{
    std::string id;
public:
    VarLocationNonterminal(std::string id) {
        this->id = id;
    }
    std::string getId() {
        return this->id;
    }
    ~VarLocationNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ArrayLocationNonterminal : public LocationNonterminal
{
    std::string id;
    ExpressionNonterminal * index;
public:
    ArrayLocationNonterminal(std::string id, ExpressionNonterminal * index) {
        this->id = id;
        this->index = index;
    }
    std::string getId() {
        return this->id;
    }
    ExpressionNonterminal * getIndex() {
        return this->index;
    }
    ~ArrayLocationNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class LiteralExpressionNonterminal : public ExpressionNonterminal
{
public:
    LiteralExpressionNonterminal() {
        
    }
    ~LiteralExpressionNonterminal() {
        
    }
    virtual void accept(Visitor * v) = 0;
};

class IntegerLiteralExpressionNonterminal : public LiteralExpressionNonterminal
{
    int value;
public:
    IntegerLiteralExpressionNonterminal(int value) {
        this->value = value;
    }
    int getValue() {
        return this->value;
    }
    ~IntegerLiteralExpressionNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class CharLiteralExpressionNonterminal : public LiteralExpressionNonterminal
{
    char value;
public:
    CharLiteralExpressionNonterminal(char value) {
        this->value = value;
    }
    char getValue() {
        return this->value;
    }
    ~CharLiteralExpressionNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class TrueLiteralExpressionNonterminal : public LiteralExpressionNonterminal
{
public:
    TrueLiteralExpressionNonterminal() {
        
    }
    bool getValue() {
        return true;
    }
    ~TrueLiteralExpressionNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class FalseLiteralExpressionNonterminal : public LiteralExpressionNonterminal
{
public:
    FalseLiteralExpressionNonterminal() {
        
    }
    bool getValue() {
        return false;
    }
    ~FalseLiteralExpressionNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class BinaryOperationNonterminal : public ExpressionNonterminal
{
    ExpressionNonterminal * left;
    ExpressionNonterminal * right;
    

public:
    BinaryOp op;
    BinaryOperationNonterminal(ExpressionNonterminal * left, ExpressionNonterminal * right, BinaryOp op) {
        this->left = left;
        this->right = right;
        this->op = op;
    }
    ExpressionNonterminal * getLeft() {
        return this->left;
    }
    ExpressionNonterminal * getRight() {
        return this->right;
    }
    BinaryOp getOp() {
        return this->op;
    }
    ~BinaryOperationNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class UnaryOperationNonterminal : public ExpressionNonterminal
{
    ExpressionNonterminal * expr;
    
public:
    UnOp op;
    UnaryOperationNonterminal(ExpressionNonterminal * expr, UnOp op) 
    {
        this->expr = expr;
        this->op = op;
    }
    ExpressionNonterminal * getExpr() {
        return this->expr;
    }
    UnOp getOp () {
        return this->op;
    }
    ~UnaryOperationNonterminal() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
#endif

