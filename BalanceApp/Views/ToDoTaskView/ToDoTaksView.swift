//
//  ToDoTaksView.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 09/12/25.
//

import SwiftUI

struct ToDoTaksView: View {
    @State private var filteredPriority: Priority? = nil
    var body: some View {
        NavigationStack {
            Group {
                Text("To Do Tasks")
            }
            .navigationTitle("Tasks")
            .toolbar {
                Menu ("Filter tasks", systemImage: "line.3.horizontal.decrease") {
                    ForEach(Priority.allCases) { priority in
                        Button(action: {
                            filteredPriority = priority
                        }) {
                            HStack {
                                Image(systemName: priority.indicatorImage())
                                Text(priority.rawValue.capitalized)
                            }
                        }
                    }
                    Button("Clear Filter", systemImage: "xmark") {
                        filteredPriority = nil
                    }
                }
                Button("Add Task", systemImage: "plus") {
                    
                }
            }
            // TODO: Add background view
            .background()
        }
    }
}

#Preview {
    ToDoTaksView()
}


