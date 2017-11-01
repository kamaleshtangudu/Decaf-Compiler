#ifndef _Visitor_H
#define _Visitor_H

class FieldDeclarationNonterminal;
class VarDeclarationNonterminal;
class IdentifierNonterminal;
class ProgramNonterminal;
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
class UnaryOperationNonterminal;

class Visitor
{
public:
    virtual void visit(ProgramNonterminal *) = 0;
    virtual void visit(FieldDeclarationNonterminal *) = 0;
    virtual void visit(VarDeclarationNonterminal *) = 0;
    virtual void visit(IdentifierNonterminal *) = 0;
    virtual void visit(VarIdentifierNonterminal *) = 0;
    virtual void visit(ArrayIdentifierNonterminal *) = 0;
    virtual void visit(MethodDeclarationNonterminal *) = 0;
    virtual void visit(TypeIdentifierNonterminal *) = 0;
    virtual void visit(StatementNonterminal *) = 0;
    virtual void visit(ExpressionNonterminal *) = 0;
    virtual void visit(BlockStatementNonterminal *) = 0;
    virtual void visit(AssignmentStatementNonterminal *) = 0;
    virtual void visit(MethodCallNonterminal *) = 0;
    virtual void visit(NormalMethodNonterminal *) = 0;
    virtual void visit(CalloutMethodNonterminal *) = 0;
    virtual void visit(CalloutArgNonterminal *) = 0;
    virtual void visit(StringCalloutArgNonterminal *) = 0;
    virtual void visit(ExpressionCalloutArgNonterminal *) = 0;
    virtual void visit(IfStatementNonterminal *) = 0;
    virtual void visit(ForStatementNonterminal *) = 0;
    virtual void visit(ReturnStatementNonterminal *) = 0;
    virtual void visit(ContinueStatementNonterminal *) = 0;
    virtual void visit(BreakStatementNonterminal *) = 0;
    virtual void visit(LocationNonterminal *) = 0;
    virtual void visit(VarLocationNonterminal *) = 0;
    virtual void visit(ArrayLocationNonterminal *) = 0;
    virtual void visit(LiteralExpressionNonterminal *) = 0;
    virtual void visit(IntegerLiteralExpressionNonterminal *) = 0;
    virtual void visit(CharLiteralExpressionNonterminal *) = 0;
    virtual void visit(TrueLiteralExpressionNonterminal *) = 0;
    virtual void visit(FalseLiteralExpressionNonterminal *) = 0;
    virtual void visit(BinaryOperationNonterminal *) = 0;
    virtual void visit(UnaryOperationNonterminal *) = 0;
};

#endif
