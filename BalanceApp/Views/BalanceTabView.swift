//
//  BalanceTabView.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 09/12/25.
//

import SwiftUI

struct BalanceTabView: View {
    var body: some View {
        TabView {
            Tab("Tasks", systemImage: "list.bullet.clipboard.fill") {
                ToDoTaksView()
            }
            
            Tab("Mood", systemImage: "figure.mind.and.body") {
                MoodView()
            }
            
            Tab("Timer", systemImage: "alarm.fill") {
                AlarmView()
            }
            
        }
    }
}

#Preview {
    BalanceTabView()
}
