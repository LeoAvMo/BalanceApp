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
    
    func moodDescription() -> String {
        switch self {
            case .angry: return "It’s totally normal to feel frustrated or mad sometimes. Anger is often just a signal that a boundary was crossed. Take a moment to feel it so you can understand it, and then let it cool down naturally."
            case .sad:
                return "It’s okay to feel down right now. Sadness is usually your mind's way of asking for a break to recharge. Be kind to yourself and take it slow. This feeling is just a passing cloud, not the whole sky."
            case .serious:
                return "You don’t have to be smiling all the time. Being serious just means you are focused or thinking deeply about something. It’s a useful state for clarity, just remember to unclench your jaw and breathe when you're done."
            case .calm:
                return "It sounds like you are in a steady place. Being calm doesn't mean everything is perfect, but it gives you a nice mental break. Enjoy this quiet moment to just reset without feeling like you need to do anything."
            case .happy:
                return "It’s great that you’re feeling good! Enjoy this lightness while it’s here, it’s a wonderful boost for your day. Just ride the wave and let yourself smile without overthinking it or trying to force it to stay forever."
        }
    }
}
