//
//  TaskMetadata.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 15/12/25.
//

import AlarmKit
import SwiftUI

struct TaskMetadata: AlarmMetadata {
    var taskName: String
    var priority: Priority
    let createdAt: Date
    
    init(taskName: String = "Timer", priority: Priority = .low, createdAt: Date = Date.now) {
        self.taskName = taskName
        self.priority = priority
        self.createdAt = createdAt
    }
}
