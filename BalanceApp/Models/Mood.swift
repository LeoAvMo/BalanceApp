//
//  Mood.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 12/12/25.
//

import SwiftData
import SwiftUI

@Model
final class Mood {
    var date: Date
    var moodType: MoodType
    
    init(date: Date = Date(), moodType: MoodType = .serious) {
        self.date = date
        self.moodType = moodType
    }
}

enum MoodType: String, Codable, CaseIterable, Identifiable {
    case angry = "Angry"
    case sad = "Sad"
    case serious = "Serious"
    case calm = "Calm"
    case happy = "Happy"
    
    var id: Self { self }
    
    func moodColor() -> Color {
        switch self {
            case .angry: return .red
            case .sad: return .teal
            case .serious: return .yellow
            case .calm: return .blue
            case .happy: return .green
        }
    }
    
    func moodEmoji() -> String {
        switch self {
            case .angry: return "😡"
            case .sad: return "😢"
            case .serious: return "😑"
            case .calm: return "🙂"
            case .happy: return "😄"
        }
    }
    
}
