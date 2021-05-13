//
//  StoreSaver.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 13.03.2023.
//

import Core
import Foundation

class StoreDiskSaver {
    private func save<T: Encodable>(_ t: T) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(t)
        UserDefaults.standard.set(data, forKey: key(for: T.self))
    }
    
    private func fetch<T: Decodable>() -> T? {
        guard let data = UserDefaults.standard.data(forKey: key(for: T.self)) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    
    private func key<T>(for type: T.Type) -> String {
        String(describing: type)
    }
}

