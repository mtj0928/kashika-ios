//
//  Calculator.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/05/06.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

struct Calculator {

    func calculate(_ string: String) throws -> NSDecimalNumber {
        let tokens = Lexer.analyse(for: string)
        let expresion = try Expression.parse(tokens)
        return try expresion.calculate()
    }
}

enum CalculatorError: Error {
    case insufficientError
    case invalidError
    case zeroDevisionError
}

enum ExpressionOperation: String {
    case addition = "+"
    case subtraction = "-"

    func calculate(_ left: NSDecimalNumber, _ right: NSDecimalNumber) -> NSDecimalNumber {
        switch self {
        case .addition:
            return left.adding(right)
        case .subtraction:
            return left.subtracting(right)
        }
    }
}

enum TermOperation: String {
    case multiple = "×"
    case division = "÷"

    func calculate(_ left: NSDecimalNumber, _ right: NSDecimalNumber) throws -> NSDecimalNumber {
        switch self {
        case .multiple:
            return left.multiplying(by: right)
        case .division:
            guard !right.doubleValue.isZero else {
                throw CalculatorError.zeroDevisionError
            }
            return left.dividing(by: right)
        }
    }
}

struct Expression {
    let terms: [Term]
    let operations: [ExpressionOperation]

    init(term: Term) {
        self.terms = [term]
        operations = []
    }

    init(expression: Expression, operation: ExpressionOperation, term: Term) {
        var terms = expression.terms
        terms.append(term)
        self.terms = terms

        var operations = expression.operations
        operations.append(operation)
        self.operations = operations
    }

    func calculate() throws -> NSDecimalNumber {
        var results = try terms[0].calculate()
        for index in 1..<terms.count {
            let term = terms[index]
            let operation = operations[index - 1]
            results = operation.calculate(results, try term.calculate())
        }
        return results
    }

    static func parse(_ tokens: [Token]) throws -> Expression {
        var expression: Expression?

        var operation: ExpressionOperation?
        var tokensForTerm: [Token] = []

        for token in tokens {
            if let tmpOperation = ExpressionOperation(rawValue: token) {
                let term = try Term.parse(tokensForTerm)
                expression = expression == nil ? Expression(term: term)
                    : Expression(expression: expression!, operation: operation!, term: term)
                operation = tmpOperation
                tokensForTerm.removeAll()
                continue
            }
            tokensForTerm.append(token)
        }

        let term = try Term.parse(tokensForTerm)

        if let expression = expression {
            guard let operation = operation else {
                throw CalculatorError.invalidError
            }
            return Expression(expression: expression, operation: operation, term: term)
        }
        return Expression(term: term)
    }
}

struct Term {
    let factors: [Factor]
    let operations: [TermOperation]

    init(factor: Factor) {
        self.factors = [factor]
        operations = []
    }

    init(term: Term, operation: TermOperation, factor: Factor) {
        var factors = term.factors
        factors.append(factor)
        self.factors = factors

        var operations = term.operations
        operations.append(operation)
        self.operations = operations
    }

    func calculate() throws -> NSDecimalNumber {
        var results = factors[0].calculate()
        for index in 1..<factors.count {
            let operation = operations[index - 1]
            let factor = factors[index]
            results = try operation.calculate(results, factor.calculate())
        }
        return results
    }

    static func parse(_ tokens: [Token]) throws -> Term {
        var term: Term?

        var operation: TermOperation?
        var tokensForFactor: [Token] = []

        for token in tokens {
            if let tmpOperation = TermOperation(rawValue: token) {
                let factor = try Factor.parse(tokensForFactor)
                term = term == nil ? Term(factor: factor)
                    : Term(term: term!, operation: operation!, factor: factor)
                operation = tmpOperation
                tokensForFactor.removeAll()
                continue
            }
            tokensForFactor.append(token)
        }

        let factor = try Factor.parse(tokensForFactor)

        if let term = term {
            guard let operation = operation else {
                throw CalculatorError.invalidError
            }
            return Term(term: term, operation: operation, factor: factor)
        }
        return Term(factor: factor)
    }
}

struct Factor {
    let value: NSDecimalNumber

    static func parse(_ tokens: [Token]) throws -> Factor {
        guard !tokens.isEmpty else {
            throw CalculatorError.insufficientError
        }
        guard tokens.count == 1 else {
            throw CalculatorError.invalidError
        }

        let token = tokens[0]
        let value = NSDecimalNumber(string: token)
        return Factor(value: value)
    }

    func calculate() -> NSDecimalNumber {
        return value
    }
}

typealias Token = String

struct Lexer {
    static func analyse(for string: String) -> [Token] {
        var results: [String] = []
        var string = string

        var tmpString = ""
        while !string.isEmpty {
            let character = string.removeFirst()
            if isOperation(character) {
                results.append(tmpString)
                results.append(String(character))
                tmpString = ""
                continue
            }
            tmpString.append(character)
        }
        if !tmpString.isEmpty {
            results.append(tmpString)
        }
        return results
    }

    private static func isOperation(_ character: Character) -> Bool {
        let operations = [ExpressionOperation.addition.rawValue, ExpressionOperation.subtraction.rawValue,
                          TermOperation.multiple.rawValue, TermOperation.division.rawValue]
        return operations.contains(String(character))
    }
}
