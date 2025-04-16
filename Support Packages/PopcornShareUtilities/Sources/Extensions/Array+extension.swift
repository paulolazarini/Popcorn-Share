//
//  Array+extension.swift
//  PopcornShareUtilities
//
//  Created by Paulo Lazarini on 22/01/25.
//

import Foundation

public extension Array where Element: Hashable {
    func removeDuplicates(by idKey: KeyPath<Element, String>) -> [Element] {
        var seen: Set<String> = []
        return self.filter { seen.insert($0[keyPath: idKey]).inserted }
    }
}
