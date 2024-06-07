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
            public struct Reset: Action {
                public init() {}
            }
            
            public struct Back: Action {
                public init() {}
            }
            
            public struct SquareTap: Action {
                public init(x: Int, y: Int) {
                    self.x = x
                    self.y = y
                }
                
                public let x: Int
                public let y: Int
            }
        }
    }
}
