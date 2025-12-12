//
//  RegisterMoodView.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 12/12/25.
//

import SwiftUI

struct RegisterMoodView: View {
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
                            }
                        }
                        .buttonStyle(.plain)
                        .frame(width: 65)
                    }
                }
                .frame(height: 105)
                
                Button("Register Mood", systemImage: "heart.fill"){
                    
                }
                .buttonStyle(.glassProminent)
                
            }
        }
        .padding()
    }
}

#Preview {
    RegisterMoodView()
}
