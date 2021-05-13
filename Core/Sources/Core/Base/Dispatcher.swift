//
//  Dispatcher.swift
//  TicTacToe
//
//  Created by Andrew Galushka on 4/27/21.
//  Copyright © 2021 Andrew Galushka. All rights reserved.
//

import Foundation

/// This protocol is the basic component of interactive action creators
public protocol Dispatcher {
    func dispatch(action: Action)
}

/// It is possible to add some extensions which will implement
/// compatibility with differnt parts of the system
public extension Dispatcher {
    func dispatch(future: Future<Action>) {
        _ = future.map(transform: dispatch)
    }
    
    func dispatch(command: CommandWith<Dispatcher>) {
        command.perform(with: self)
    }
}
