//
//  NSPredicate+extension.swift
//  kashika
//
//  Created by 松本淳之介 on 2020/04/12.
//  Copyright © 2020 JunnosukeMatsumoto. All rights reserved.
//

import Foundation

extension NSPredicate {

    private convenience init(expression property: String, _ operation: String, _ value: AnyObject) {
        self.init(format: "\(property) \(operation) %@", argumentArray: [value])
    }

    public convenience init(nilProperty property: String) {
        self.init(format: "\(property) == nil")
    }

    public convenience init(notNilProperty property: String) {
        self.init(format: "\(property) != nil")
    }

    public convenience init(_ property: String, equal value: AnyObject) {
        self.init(expression: property, "=", value)
    }

    public convenience init(equal value: AnyObject) {
        self.init(expression: "", "=", value)
    }

    public convenience init(_ property: String, notEqual value: AnyObject) {
        self.init(expression: property, "!=", value)
    }

    public convenience init(_ property: String, equalOrGreaterThan value: AnyObject) {
        self.init(expression: property, ">=", value)
    }

    public convenience init(_ property: String, equalOrLessThan value: AnyObject) {
        self.init(expression: property, "<=", value)
    }

    public convenience init(_ property: String, greaterThan value: AnyObject) {
        self.init(expression: property, ">", value)
    }

    public convenience init(_ property: String, lessThan value: AnyObject) {
        self.init(expression: property, "<", value)
    }

    public func compound(predicates: [NSPredicate], type: NSCompoundPredicate.LogicalType = .and) -> NSPredicate {
        var predicates = predicates
        predicates.insert(self, at: 0)
        switch type {
        case .and:
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        case .or:
            return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        case .not:
            return NSCompoundPredicate(notPredicateWithSubpredicate: compound(predicates: predicates))
        @unknown default:
            fatalError("Unknown Predicate LogicalType")
        }
    }

    public func and(_ predicate: NSPredicate) -> NSPredicate {
        return self.compound(predicates: [predicate], type: .and)
    }

    public func or(_ predicate: NSPredicate) -> NSPredicate {
        return self.compound(predicates: [predicate], type: .or)
    }

    public func not(_ predicate: NSPredicate) -> NSPredicate {
        return self.compound(predicates: [predicate], type: .not)
    }
}
