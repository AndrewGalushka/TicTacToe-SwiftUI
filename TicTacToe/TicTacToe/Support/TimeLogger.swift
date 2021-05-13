//
//  TimeLogger.swift
//  TicTacToe
//
//  Created by Andrii Halushka on 13.05.2021.
//

import Foundation

class TimeLogger {
    static let shared = TimeLogger()
    
    func logCurrentTime(prefix: String) {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "hh:mm:ss.SSSS"
        let time = dateFormatter.string(from: currentDate)
        
        print(prefix + time)
    }
}
