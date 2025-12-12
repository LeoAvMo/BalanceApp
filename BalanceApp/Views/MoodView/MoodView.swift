//
//  MoodView.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 09/12/25.
//

import SwiftUI
import SwiftData

struct MoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var moods: [Mood]
    
    var hasMoodForToday: Bool {
        return moods.contains { mood in
            Calendar.current.isDate(Date(), inSameDayAs: mood.date)
        }
    }
    
    var body: some View {
        Text("Hello, World!")
        
        if hasMoodForToday {
            
        }
        // if no mood registered today, display empty view and display fullscreen sheet
        // else display rest of the view
    }
}

#Preview {
    MoodView()
}
