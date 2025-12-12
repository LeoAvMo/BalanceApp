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
        NavigationStack {
            ScrollView {
                
            }
            .fullScreenCover(isPresented: .constant(!hasMoodForToday)) {
                RegisterMoodView()
            }
            .navigationTitle("Mood")
        
        }
        
        // if no mood registered today, display empty view and display fullscreen sheet
        // else display rest of the view
    }
}

#Preview {
    MoodView()
}

struct NoMoodView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image("Lumi")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 140)
                .padding(-30)
            Text("No Mood Registered")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Start the day by adding a mood and discover the best way to achieve your tasks!")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
