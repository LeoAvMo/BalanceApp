//
//  ToDoTask.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 04/12/25.
//

import SwiftData
import SwiftUI

@Model
final class ToDoTask {
    var name: String
    var priority: Priority
    var dueDate: Date
    var timeToComplete: TimeInterval
    
    init(name: String = "", priority: Priority = .low, dueDate: Date = .now, timeToComplete: TimeInterval = 0.0) {
        self.name = name
        self.priority = priority
        self.dueDate = dueDate
        self.timeToComplete = timeToComplete
    }
}

enum Priority: String, Codable, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var id: Self { self }
    
    func toInt() -> Int {
        switch self {
            case .low: return 1
            case .medium: return 2
            case .high: return 3
        }
    }
    
    func indicatorImage() -> String {
        switch self {
            case .low: return "gauge.with.dots.needle.33percent"
            case .medium: return "gauge.with.dots.needle.50percent"
            case .high: return "gauge.with.dots.needle.67percent"
        }
    }
    
    func priorityColor() -> Color {
        switch self {
            case .low: return .green
            case .medium: return .orange
            case .high: return .red
        }
    }
    
}
