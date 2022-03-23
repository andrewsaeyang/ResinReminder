//
//  TempFile.swift
//  ResinReminder
//
//  Created by Andrew Saeyang on 3/20/22.
//

import Foundation

class Task{
    var currentResin: Int
    var resinCap: Int
    var refreshRate: Int
    
    init(currentResin: Int, resinCap: Int, refreshRate: Int = 8) {
        self.currentResin = currentResin
        self.resinCap = resinCap
        self.refreshRate = refreshRate
    }
    
}// End of class
