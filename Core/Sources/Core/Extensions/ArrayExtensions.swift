//
//  ArrayExtensions.swift
//
//
//  Created by ira on 30.05.2024.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else {
            return nil
        }
        
        return self[index]
    }
}
