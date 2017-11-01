#ifndef _AST_H
#define _AST_H
#include <vector>
#include <string>

enum class UnOp : char {
    minus_op,
    not_op
};
enum class BinOp : char {
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


class ASTNode {
public:
    ASTNode() {
    }
    ~ASTNode() {
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
    std::string parseBinOp(BinOp op){
        switch(op){
            case BinOp::plus_op: 
            return "+";
            case BinOp::minus_op: 
            return "-";
            case BinOp::multiply_op: 
            return "*";
            case BinOp::divide_op: 
            return "/";
            case BinOp::modulo_op: 
            return "%";
            case BinOp::lessthan_op: 
            return "<";
            case BinOp::greaterthan_op: 
            return ">";
            case BinOp::lessequal_op: 
            return "<=";
            case BinOp::greaterequal_op: 
            return ">=";
            case BinOp::notequal_op: 
            return "!=";
            case BinOp::equalequal_op: 
            return "==";
            case BinOp::and_op: 
            return "&&";
            case BinOp::or_op: 
            return "||";
        }
        return "";
    }
    virtual void accept(Visitor * v) = 0;



    std::string parseUnOp(UnOp op){
        switch(op){
            case UnOp::minus_op: 
            return "-";
            case UnOp::not_op: 
            return "!";
        }
        return "";
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

class ASTProgram
{
    std::vector<ASTFieldDecl *> * fdl;
    std::vector<ASTMethodDecl *> * mdl;
public:
    ASTProgram(std::vector<ASTFieldDecl *> * fdl, std::vector<ASTMethodDecl *> * mdl){
        this->mdl = mdl;
        this->fdl = fdl;
    }
    std::vector<ASTMethodDecl *> * getMdl() {
        return this->mdl;
    }
    std::vector<ASTFieldDecl *> * getFdl() {
        return this->fdl;
    }
    ~ASTProgram() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
class ASTArrayIdentifier : public ASTIdentifier 
{
    std::string id;
    int size;
public:
    ASTArrayIdentifier(std::string id, int size) {
        this->id = id;
        this->size = size;      
    }
    std::string getId() {
        return this->id;
    }
    int getSize() {
        return this->size;
    }
    ~ASTArrayIdentifier() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
class ASTFieldDecl : public ASTNode
{
    Datatype type;
    std::vector<ASTVarIdentifier *> * var_id_list;
    std::vector<ASTArrayIdentifier *> * array_id_list;
public:
    std::vector<ASTVarIdentifier *> * getVar_id_list() {
        return this->var_id_list;
    }    
    ASTFieldDecl(std::vector<ASTVarIdentifier *> * var_id_list, Datatype type){
        this->type = type;
        this->var_id_list = var_id_list;
        this->array_id_list = NULL;
    }


    std::vector<ASTArrayIdentifier *> * getArray_id_list() {
        return this->array_id_list;
    }
    Datatype getType() {
        return this->type;
    }
    ~ASTFieldDecl() {
        
    }
    ASTFieldDecl(std::vector<ASTArrayIdentifier *> * array_id_list, Datatype type){
        this->type = type;
        this->array_id_list = array_id_list;
        this->var_id_list = NULL;
    }    
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTVarDecl : public ASTNode
{
    Datatype type;
    std::vector<ASTVarIdentifier *> * id_list;
public:
    ASTVarDecl(std::vector<ASTVarIdentifier *> * id_list, Datatype type) {
        this->type = type;
        this->id_list = id_list;
    }

    Datatype getType() {
        return this->type;
    }
    ~ASTVarDecl() {
        
    }
    std::vector<ASTVarIdentifier *> * getId_list() {
        return this->id_list;
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTIdentifier : public ASTNode 
{
public: 
    ASTIdentifier() {
        
    }
    ~ASTIdentifier() {
        
    }
    virtual void accept(Visitor * v) = 0;
};

class ASTVarIdentifier : public ASTIdentifier
{
    std::string id;
public:
    ASTVarIdentifier(std::string id) {
        this->id = id;
    }
    std::string getId() {
        return this->id;
    }
    ~ASTVarIdentifier() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};



class ASTMethodDecl : public ASTNode
{
    std::string id;
    Datatype returnType;
    std::vector<ASTTypeIdentifier *> * arguments;
    ASTBlockStatement * block;
public:
    ASTMethodDecl(std::string id, Datatype returnType, std::vector<ASTTypeIdentifier *> * arguments, ASTBlockStatement * block) {
        this->id = id;
        this->returnType = returnType;
        this->arguments = arguments;
        this->block = block;
    }
    ASTBlockStatement * getBlock() {
        return this->block;
    }    
    std::string getId() {
        return this->id;
    }
    Datatype getReturnType() {
        return this->returnType;
    }
    std::vector<ASTTypeIdentifier *> * getArguments() {
        return this->arguments;
    }

    ~ASTMethodDecl() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTTypeIdentifier : public ASTNode
{
    std::string id;
    Datatype type;
public:
    ASTTypeIdentifier(std::string id, Datatype type) {
        this->id = id;
        this->type = type;
    }
    ~ASTTypeIdentifier() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }    
    std::string getId() {
        return this->id;
    }
    Datatype getType() {
        return this->type;
    }

};

class stamnt : public ASTNode 
{
public:
    stamnt() {}
    virtual void accept(Visitor * v) = 0;
    ~stamnt() {
    }
    
};


class ASTExpression : public ASTNode
{
public:
    ASTExpression() {
        
    }
    ~ASTExpression() {
        
    }
    virtual void accept(Visitor * v) = 0;
};
class Forloop : public stamnt 
{
    ASTExpression * init_condition;
    ASTExpression * end_condition;
    ASTBlockStatement * block;
    std::string id_name;
public:
    ASTExpression * getEnd_condition() {
        return this->end_condition;
    }
    ASTExpression * getInit_condition() {
        return this->init_condition;
    }
    Forloop(std::string Idd, ASTExpression * init_condition, ASTExpression * end_condition, ASTBlockStatement * block) {
        this->id_name = Idd;
        this->init_condition = init_condition;
        this->end_condition = end_condition;
        this->block = block;
    }
    ASTBlockStatement * getBlock() {
        return this->block;
    }
    std::string getidValue()
    {
        return this->id_name;
    }
    ~Forloop() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
class ASTBlockStatement : public stamnt
{
    std::vector<ASTVarDecl *> * id_list;
    std::vector<stamnt *> * stmtlist;
public:
    ASTBlockStatement(std::vector<stamnt *> * stmtlist, std::vector<ASTVarDecl *> * id_list) {
        this->stmtlist = stmtlist;
        this->id_list = id_list;
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
    ~ASTBlockStatement() {
    }
    std::vector<stamnt *> * getStmtlist() {
        return this->stmtlist;
    }
    std::vector<ASTVarDecl *> * getId_list() {
        return this->id_list;
    }
        
};

class ASTAssignmentStatement : public stamnt
{

    ASTLocation * location;
    ASTExpression * expr;
public:
    AssignOp op;
    ASTAssignmentStatement(AssignOp op, ASTLocation * location, ASTExpression * expr) {
        this->op = op;
        this->location = location;
        this->expr = expr;
    }
    AssignOp getOp() {
        return this->op;
    }
    ASTLocation * getLocation() {
        return this->location;
    }
    ASTExpression * getExpr() {
        return this->expr;
    }
    ~ASTAssignmentStatement() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
class ASTNormalMethod : public ASTMethodCall 
{
    std::string id;
    std::vector<ASTExpression *> * arguments;
public:
    ASTNormalMethod(std::string id, std::vector<ASTExpression *> * arguments) {
        this->id = id;
        this->arguments = arguments;
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
    ~ASTNormalMethod() {
    }
    std::vector<ASTExpression *> * getArguments() {
        return this->arguments;
    }
        
    std::string getId() {
        return this->id;
    }
};
class ASTMethodCall : public stamnt, public ASTExpression 
{
public:
    ASTMethodCall() {
        
    }
    ~ASTMethodCall() {
        
    }
    virtual void accept(Visitor * v) = 0;
};



class calloutMethod : public ASTMethodCall 
{
    std::string method_name;
    std::vector<ASTCalloutArg *> * arguments;
public:
    ~calloutMethod() {
        
    }
    std::string getMethod_name() {
        return this->method_name;
    }
    calloutMethod(std::string method_name, std::vector<ASTCalloutArg *> * arguments) {
        this->method_name = method_name;
        this->arguments = arguments;
    }
    std::vector<ASTCalloutArg *> * getArguments() {
        return this->arguments;
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTExpressionCalloutArg : public ASTCalloutArg 
{
    ASTExpression * argument;
public:
    ASTExpressionCalloutArg(ASTExpression * argument) {
        this->argument = argument;
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
    ASTExpression * getArgument() {
        return this->argument;
    }
    ~ASTExpressionCalloutArg() {
        
    }
};


class ASTCalloutArg : public ASTExpression
{
public:
    ASTCalloutArg() {
        
    }
    ~ASTCalloutArg() {
        
    }
};


class ASTIfStatement : public stamnt 
{
    ASTExpression * condition;
    ASTBlockStatement * if_block;
    ASTBlockStatement * else_block;
public:
    ASTIfStatement(ASTExpression * condition, ASTBlockStatement * if_block, ASTBlockStatement * else_block) {
        this->condition = condition;
        this->if_block = if_block;
        this->else_block = else_block;
    }
    ASTExpression * getCondition() {
        return this->condition;
    }
    ~ASTIfStatement() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
    ASTBlockStatement * getIf_block() {
        return this->if_block;
    }
    ASTBlockStatement * getElse_block() {
        return this->else_block;
    }
};



class ASTReturnStatement : public stamnt
{
    ASTExpression * return_expr;
public:
    ASTReturnStatement(ASTExpression * return_expr) {
        this->return_expr = return_expr;
    }
    ~ASTReturnStatement() {
        
    }
    ASTExpression * getReturn_expr() {
        return this->return_expr;
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
class ASTVarLocation : public ASTLocation 
{
    std::string id;
public:
    ASTVarLocation(std::string id) {
        this->id = id;
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
    ~ASTVarLocation() {
        
    }
    std::string getId() {
        return this->id;
    }
};


class ASTBreakStatement : public stamnt
{
public:
    ASTBreakStatement() {
        
    }
    ~ASTBreakStatement() {
        
    }
    void accept(Visitor * v) {

    }
};

class ASTLocation : public ASTExpression
{
public:
    ASTLocation() {
        
    }
    ~ASTLocation() {
        
    }
    void accept(Visitor * v) = 0;
};



class ASTArrayLocation : public ASTLocation
{
    std::string id;
    ASTExpression * index;
public:
    ASTArrayLocation(std::string id, ASTExpression * index) {
        this->id = id;
        this->index = index;
    }
    std::string getId() {
        return this->id;
    }
    ASTExpression * getIndex() {
        return this->index;
    }
    ~ASTArrayLocation() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTContinueStatement : public stamnt
{
public:
    ASTContinueStatement() {
        
    }
    ~ASTContinueStatement() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
class ASTIntegerLiteralExpression : public ASTLiteralExpression
{
    int value;
public:
    ASTIntegerLiteralExpression(int value) {
        this->value = value;
    }
    int getValue() {
        return this->value;
    }
    ~ASTIntegerLiteralExpression() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
class ASTLiteralExpression : public ASTExpression
{
public:
    ASTLiteralExpression() {
        
    }
    ~ASTLiteralExpression() {
        
    }
    virtual void accept(Visitor * v) = 0;
};



class ASTCharLiteralExpression : public ASTLiteralExpression
{
    char value;
public:
    ASTCharLiteralExpression(char value) {
        this->value = value;
    }
    char getValue() {
        return this->value;
    }
    ~ASTCharLiteralExpression() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
class ASTUnaryOperationExpression : public ASTExpression
{
    ASTExpression * expr;
    
public:
    UnOp op;
    ASTUnaryOperationExpression(ASTExpression * expr, UnOp op) {
        this->expr = expr;
        this->op = op;
    }
    ASTExpression * getExpr() {
        return this->expr;
    }
    UnOp getOp () {
        return this->op;
    }
    ~ASTUnaryOperationExpression() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};


class ASTFalseLiteralExpression : public ASTLiteralExpression
{
public:
    ASTFalseLiteralExpression() {
        
    }
    bool getValue() {
        return false;
    }
    ~ASTFalseLiteralExpression() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTBinaryOperationExpression : public ASTExpression
{
    ASTExpression * left;
    ASTExpression * right;
    

public:
    BinOp op;
    ASTBinaryOperationExpression(ASTExpression * left, ASTExpression * right, BinOp op) {
        this->left = left;
        this->right = right;
        this->op = op;
    }
    ASTExpression * getLeft() {
        return this->left;
    }
    ASTExpression * getRight() {
        return this->right;
    }
    BinOp getOp() {
        return this->op;
    }
    ~ASTBinaryOperationExpression() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
class ASTTrueLiteralExpression : public ASTLiteralExpression
{
public:
    ASTTrueLiteralExpression() {
        
    }
    bool getValue() {
        return true;
    }
    ~ASTTrueLiteralExpression() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};

class ASTStringCalloutArg : public ASTCalloutArg 
{
    std::string argument;
public:
    ASTStringCalloutArg(std::string argument) {
        this->argument = argument;
    }
    std::string getArgument() {
        return this->argument;
    }
    ~ASTStringCalloutArg() {
        
    }
    void accept(Visitor * v) {
        v->visit(this);
    }
};
#endif

