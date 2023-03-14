//
//  GameConnector.swift
//  
//
//  Created by Andrii Halushka on 13.03.2023.
//

import Foundation

public extension Actions {
    enum GameConnector {
        public enum Idle {
            public struct Start: Action {
                public init() {}
            }
        }
        
        public enum ActiveGame {
            public struct Back: Action {
                public init() {}
            }
            
            public struct SquareTap: Action {
                public init(path: Board.SquerePath) {
                    self.path = path
                }
                
                public let path: Board.SquerePath
            }
        }
    }
}
