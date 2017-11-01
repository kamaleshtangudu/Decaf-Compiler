#ifndef _PrintVisitor_CPP
#define _PrintVisitor_CPP

#include <iostream>
#include <vector>
#include "AST.h"
#include "Visitor.h"
using namespace std;
/* Here we are using Double Dispatch for the visit and accept methods.*/
class PrintVisitor : public Visitor
{
public:
    void visit(ProgramNonterminal * node) {
        cout<<"<program>"<<endl;
        if(node->getFdl() == NULL){
            cout<<"<field_declarations count = \"0\">"<<endl;
        }

        else{
            cout<<"<field_declarations count =\" "<<(node->getFdl())->size()<<"\">"<<endl;
            for(auto it = (node->getFdl())->begin() ; it != (node->getFdl())->end(); it++) {
                (*it)->accept(this);
            }               
        }
        cout<<"</field_declarations>"<<endl;
        if(node->getMdl() == NULL){
            cout<<"<method_declarations count = \"0\">"<<endl;
        }

        else{
            cout<<"<method_declarations count =\" "<<(node->getMdl())->size()<<"\">"<<endl;
            for(auto it = (node->getMdl())->begin() ; it != (node->getMdl())->end(); it++) {
                (*it)->accept(this);
            }               
        }
        cout<<"</method_declarations>"<<endl;
        cout<<"</program>"<<endl;
    }
    void visit(FieldDeclarationNonterminal * node) {
        cout<<node->parseDatatype(node->getType())<<" ";
        if (node->getVar_id_list()) {
            for(auto it = (node->getVar_id_list())->begin() ; it != (node->getVar_id_list())->end(); it++) {
                (*it)->accept(this);
            }   
        }
        if (node->getArray_id_list()) {
            for(auto it = (node->getArray_id_list())->begin() ; it != (node->getArray_id_list())->end(); it++) {
                (*it)->accept(this);
            }
        }
    }

    void visit(VarIdentifierNonterminal * node) {
        cout<<" "<<node->getId();
    }

    void visit(ArrayIdentifierNonterminal * node) {
        cout<<" "<<node->getId()<<"["<<node->getSize()<<"]";
    }

    void visit(MethodDeclarationNonterminal * node) {
        cout<<node->parseDatatype(node->getReturnType())<<" "<<node->getId()<<" ";
        cout<<"(";
        if (node->getArguments()) {
            for(auto it = (node->getArguments())->begin() ; it != (node->getArguments())->end(); it++) {
                (*it)->accept(this);
            }
        }
        cout<<")"<<endl;
        /* Block statement is called*/
        node->getBlock()->accept(this);
    }
    void visit(TypeIdentifierNonterminal * node) {
        cout<<node->parseDatatype(node->getType())<<" "<<node->getId()<<" ";
    }

    void visit(BlockStatementNonterminal * node) {
        cout<<"{"<<endl;
        cout<<"no of statements = ";
        if(node->getStmtlist() && node->getId_list()){
            cout<<node->getStmtlist()->size() + node->getId_list()->size()<<endl;
        for(auto it = (node->getId_list())->begin() ; it != (node->getId_list())->end(); it++) {
            (*it)->accept(this);
        }
        for(auto it = (node->getStmtlist())->begin() ; it != (node->getStmtlist())->end(); it++) {
            (*it)->accept(this);
        }
        }
        else if(node->getStmtlist()){
            cout<<node->getStmtlist()->size()<<endl;
            for(auto it = (node->getStmtlist())->begin() ; it != (node->getStmtlist())->end(); it++) {
            (*it)->accept(this);
        }
        }
        else if(node->getId_list()){
            cout<<node->getId_list()->size()<<endl;
            for(auto it = (node->getId_list())->begin() ; it != (node->getId_list())->end(); it++) {
            (*it)->accept(this);
        }
        }
        
        cout<<endl;
        
        cout<<"}"<<endl;
    }

    void visit(AssignmentStatementNonterminal * node) {
        node->getLocation()->accept(this);
        cout<<" "<<node->parseAssignOp(node->op)<<" ";
        node->getExpr()->accept(this);
        cout<<endl;
    }
    void visit(MethodCallNonterminal * node) {
        cout<<""<<endl;
    }
    void visit(NormalMethodNonterminal * node) {
        cout<<node->getId()<<"(";
        if(node->getArguments()){
            for(auto it = (node->getArguments())->begin() ; it != (node->getArguments())->end(); it++) {
              (*it)->accept(this);
            }
        }
        cout<<")";
    }
    void visit(CalloutMethodNonterminal * node) {
        cout<<node->getMethod_name()<<"(";
        if(node->getArguments()){
            for(auto it = (node->getArguments())->begin() ; it != (node->getArguments())->end(); it++) {
              (*it)->accept(this);
            }
        }
        cout<<")"<<endl;
    }
    void visit(CalloutArgNonterminal * node) {
        
    }
    void visit(StringCalloutArgNonterminal * node) {
        cout<<node->getArgument();
    }
    void visit(ExpressionCalloutArgNonterminal * node) {
        node->getArgument()->accept(this);
    }
    void visit(IfStatementNonterminal * node) {
        cout<<"if(";
        node->getCondition()->accept(this);
        cout<<")"<<endl;
        node->getIf_block()->accept(this);
        if(node->getElse_block())
            node->getElse_block()->accept(this);
    }
    void visit(ForStatementNonterminal * node) {
    	cout << "for(" << endl;
    	 cout << node->getidValue() << endl; 
        node->getInit_condition()->accept(this);
        node->getEnd_condition()->accept(this);
        node->getBlock()->accept(this);

    }
    void visit(ReturnStatementNonterminal * node) {
        cout<<"return ";
        node->getReturn_expr()->accept(this);
    }
    void visit(ContinueStatementNonterminal * node) {
        cout<<"continue"<<endl;
    }
    void visit(BreakStatementNonterminal * node) {
        cout<<"break"<<endl;
    }
    void visit(LocationNonterminal * node) {
        cout<<""<<endl;
    }
    void visit(VarLocationNonterminal * node) {
        cout<<node->getId()<<" ";
    }
    void visit(ArrayLocationNonterminal * node) {
        cout<<node->getId()<<" ["<<node->getIndex()<<"]";
    }
    void visit(LiteralExpressionNonterminal * node) {
        cout<<""<<endl;
    }
    void visit(IntegerLiteralExpressionNonterminal * node) {
        cout<<" "<<node->getValue();
    }
    void visit(CharLiteralExpressionNonterminal * node) {
        cout<<" "<<node->getValue();
    }
    void visit(TrueLiteralExpressionNonterminal * node) {
        cout<<" "<<node->getValue();
    }
    void visit(FalseLiteralExpressionNonterminal * node) {
        cout<<" "<<node->getValue();
    }
    void visit(BinaryOperationNonterminal * node) {
        node->getLeft()->accept(this);
        cout<<" "<<node->parseBinOp(node->op)<<" ";
        node->getRight()->accept(this);
    }
    void visit(UnaryOperationNonterminal * node) {
        cout<<node->parseUnOp(node->op)<<" "<<endl;
        node->getExpr()->accept(this);
    }
    void visit(VarDeclarationNonterminal * node) {
        cout<<node->parseDatatype(node->getType())<<" ";
        for(auto it = (node->getId_list())->begin() ; it != (node->getId_list())->end(); it++) {
              (*it)->accept(this);
            }
        cout<<endl;
    }
    void visit(IdentifierNonterminal * node) {
        cout<<""<<endl;
    }
    void visit(StatementNonterminal * node) {
        cout<<""<<endl;
    }
    void visit(ExpressionNonterminal * node) {
        cout<<""<<endl;
    }
};
#ifdef TEST

int main()
{
    ProgramNonterminal * obj = new ProgramNonterminal("yolo",NULL,NULL);
    obj->accept(new PrintVisitor());
    return 0;
}

#endif
#endif
