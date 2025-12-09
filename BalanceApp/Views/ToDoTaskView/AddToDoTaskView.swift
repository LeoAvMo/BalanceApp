//
//  AddTaskView.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 09/12/25.
//

import SwiftUI

struct AddToDoTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var priority: Priority = .low
    @State private var dueDate: Date = Date()
    @State private var timeToComplete: TimeInterval = 0
    @State private var seconds: Int = 0
    @State private var minutes: Int = 30
    @State private var hours: Int = 0
    var body: some View {
        NavigationStack {
            Form {
                TextField("Task Name", text: $name)
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases) { prio in
                        HStack {
                            Image(systemName: prio.indicatorImage())
                            Text(" \(prio.rawValue)")
                        }
                        .tag(prio)
                    }
                }
                .pickerStyle(.automatic)
                
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                VStack {
                    HStack {
                        Text("Duration")
                        Spacer()
                    }
                    
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Text(":")
                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.wheel)
                        Text(":")
                        Picker("Seconds", selection: $seconds) {
                            ForEach(0..<60) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add Task", systemImage: "checkmark") {
                        dismiss()
                    }
                }
                
            }
        }
    }
}

#Preview {
    AddToDoTaskView()
}
