//
//  EditToDoTask.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 12/12/25.
//

import SwiftUI

struct EditToDoTask: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var task: ToDoTask
    
    @State private var name: String = ""
    @State private var priority: Priority = .low
    @State private var dueDate: Date = .now
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    
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
                
                DatePicker("Due Date", selection: $dueDate, in: Date.now..., displayedComponents: .date)
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
            .onAppear {
                name = task.name
                priority = task.priority
                dueDate = task.dueDate
                let taskTime = (timeIntervalToHoursMinutesSeconds(task.timeToComplete))
                hours = taskTime.0
                minutes = taskTime.1
                seconds = taskTime.2
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Modify", systemImage: "checkmark") {
                        modifyTask()
                        dismiss()
                    }
                    .disabled(name.isEmpty ||
                              seconds == 0 && minutes == 0 && hours == 0 ||
                              name == task.name &&
                              priority == task.priority &&
                              dueDate == task.dueDate &&
                              Int(task.timeToComplete) == Int(seconds + minutes * 60 + hours * 3600))
                }
            }
        }
    }
    
    func modifyTask() {
        task.name = name
        task.priority = priority
        task.dueDate = dueDate
        task.timeToComplete = TimeInterval(seconds + minutes * 60 + hours * 3600)
    }
    
    func timeIntervalToHoursMinutesSeconds(_ seconds: TimeInterval) -> (Int, Int, Int) {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds.truncatingRemainder(dividingBy: 3600)) / 60
        let seconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        return (hours, minutes, seconds)
    }
}

#Preview {
    EditToDoTask(task: ToDoTask())
}
