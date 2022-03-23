//
//  TempFile.swift
//  ResinReminder
//
//  Created by Andrew Saeyang on 3/20/22.
//

import Foundation
class TaskController {
    
    // MARK: - Properties
    static let shared = TaskController()
    var task = Task(currentResin: 0, resinCap: 160)
    
    
    // MARK: - CRUD Functions
    func updateTask(currentResin: Int, resinCap: Int){
        self.task.currentResin = currentResin
        self.task.resinCap = resinCap
    }
}// End of class
