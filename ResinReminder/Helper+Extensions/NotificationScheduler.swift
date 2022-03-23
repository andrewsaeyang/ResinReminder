//
//  NotificationScheduler.swift
//  ResinReminder
//
//  Created by Andrew Saeyang on 3/22/22.
//

import Foundation
import UserNotifications

class NotificationScheduler {
    func scheduleNotification() {
        
        let content = UNMutableNotificationContent()
        
        content.title = "Resin Reminder"
        content.body = "Resin is full!"
        content.sound = .default
        
        var trigger: UNNotificationTrigger?
        
        
    }
    
    
    
    
}// End of class
