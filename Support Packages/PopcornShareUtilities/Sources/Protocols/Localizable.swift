//
//  Localizable.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 16/04/25.
//


import Foundation
import UIKit

public protocol Localizable {
    var localized: String { get }
}

public extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var tableName: String {
        String(describing: Self.self)
    }
    
    func localized(tableName: String, bundle: Bundle) -> String {
        NSLocalizedString(self.rawValue, tableName: tableName, bundle: bundle, comment: "")
    }
    
    func localizedWith(_ args: CVarArg...) -> String {
        return String(format: localized, locale: .current, arguments: args)
    }
}