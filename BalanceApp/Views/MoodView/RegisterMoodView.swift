//
//  RegisterMoodView.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 12/12/25.
//

import SwiftUI
import SwiftData

struct RegisterMoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMood: MoodType? = nil
    private let rows = [GridItem(.flexible(minimum: 30, maximum: 30))]
    
    var body: some View {
        Group {
            VStack {
                Text("How are you feeling today?")
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                LazyHGrid(rows: rows) {
                    ForEach(MoodType.allCases) { moodType in
                        Button {
                            selectedMood = moodType
                        } label: {
                            VStack(alignment: .center){
                                ZStack {
                                    if selectedMood == moodType {
                                        Circle()
                                            .fill(moodType.moodColor())
                                    }
                                    
                                    Text(moodType.moodEmoji())
                                        .font(.system(size: 60))
                                }
                                Text(moodType.rawValue)
                                    .foregroundStyle(selectedMood == moodType ? moodType.moodColor() : .gray)
                                    .bold(selectedMood == moodType ? true : false)
                            }
                        }
                        .buttonStyle(.plain)
                        .frame(width: 65)
                    }
                }
                .frame(height: 105)
                
                Button("Register Mood", systemImage: "heart.fill"){
                    modelContext.insert(Mood(date: Date(), moodType: selectedMood ?? .serious))
                    dismiss()
                }
                .disabled(selectedMood == nil)
                .buttonStyle(.glassProminent)
                
            }
        }
        .padding()
    }
}

#Preview {
    RegisterMoodView()
}
