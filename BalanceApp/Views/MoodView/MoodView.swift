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
    @Query private var tasks: [ToDoTask]
    
    @State private var dailySuggestions: DailySuggestion?
    
    var todaysMood: Mood? {
        return moods.first(where: { Calendar.current.isDate(Date(), inSameDayAs: $0.date) })
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                MoodTypeResumeView(mood: todaysMood)
                
                HStack {
                    Image("Lumi")
                        .resizable()
                        .scaledToFit()
                        .padding(-20)
                        .frame(width: 30, height: 30)
                        .offset(x: -5)
                    Text("Lumi Suggestions")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                if let dailySuggestions {
                    VStack(spacing: 12) {
                        ForEach(dailySuggestions.suggestions, id: \.text) { suggestion in
                            SuggestionBlockView(suggestion: suggestion)
                        }
                    }
                } else {
                    NoSuggestionsView()
                }
            }
            
            .padding(.horizontal)
            .fullScreenCover(isPresented: .constant(!(todaysMood == nil))) {
                RegisterMoodView()
            }
            .navigationTitle("Mood")
        }
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

struct MoodTypeResumeView: View {
    var mood: Mood?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(mood?.moodType.moodColor().opacity(0.2) ?? .gray.opacity(0.2))
            HStack {
                Text(mood?.moodType.moodEmoji() ?? "☁️")
                    .font(.system(size: 45))
                VStack (alignment: .leading, spacing: 5){
                    Text(mood?.moodType.rawValue ?? "Looks a bit empty...")
                        .font(Font.title.bold())
                        .foregroundStyle(mood?.moodType.moodColor() ?? .primary)
                    
                    Text(mood?.moodType.moodDescription() ?? "Register a mood for today to begin with something awesome!")
                        .font(.caption)
                }
                .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding()
        }
        
    }
}

struct SuggestionBlockView: View {
    var suggestion: Suggestion
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .foregroundStyle(Color.accentColor.opacity(0.1))
            HStack {
                Text(suggestion.emoji)
                    .font(.largeTitle)
                Text(suggestion.text)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding()
        }
        
    }
}

struct NoSuggestionsView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .foregroundStyle(Color.accentColor.opacity(0.1))
            HStack {
                Text("💡")
                    .font(.largeTitle)
                Text("You can start adding tasks so Lumi can make suggestions on what you can do to make them easier to tackle! Be sure that you entered your mood for today.")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding()
        }
        
    }
}

