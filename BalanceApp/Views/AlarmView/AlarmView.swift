//
//  AlarmView.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 09/12/25.
//

import SwiftUI
import SwiftData

// TODO: Add alarms and notifications.
// TODO: Make distinction between cancel and pause for timer.

struct AlarmView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ToDoTask.orderIndex) private var tasks: [ToDoTask]
    
    @State private var todoTask: ToDoTask?
    @State private var timer: Timer?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ToDoTaskTimerView(todoTask: $todoTask, timer: $timer)
                }
                .listRowSeparator(.hidden)
                
                if !tasks.isEmpty {
                    HStack {
                        Text("Some tasks to focus on")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    
                    ForEach(tasks.prefix(5)) { toTask in
                        TaskTimerEntryView(todoTask: toTask, activeTask: todoTask, timerIsRunning: timer != nil) { selectedTask in
                            handleTaskSelection(selectedTask)
                        }
                    }
                }
                
            }
            .listStyle(.inset)
            .navigationTitle("Focus")
        }
    }
    
    private func handleTaskSelection(_ selectedTask: ToDoTask) {
        if todoTask == selectedTask && timer != nil {
            timer?.invalidate()
            timer = nil
            todoTask = nil
        } else {
            self.todoTask = selectedTask
        }
    }
}

#Preview {
    AlarmView()
}

struct ToDoTaskTimerView: View {
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    
    @Binding var todoTask: ToDoTask?
    @Binding var timer: Timer?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.accent.opacity(0.1))
            VStack(alignment: .leading){
                
                HStack {
                    Image("Lumi")
                        .resizable()
                        .scaledToFit()
                        .padding(-15)
                        .offset(y: 1)
                        .frame(width: 30, height: 30)
                    Text(todoTask == nil ? "Start Timer" : "\(todoTask?.name ?? "Timer")")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    
                    if timer != nil {
                        Button {
                            
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(.glassProminent)
                    }
                    
                    
                    Button {
                        toggleTimer()
                    } label: {
                        HStack {
                            if timer == nil {
                                Text("Start")
                            }
                            Image(systemName: timer == nil ? "play.fill" : "pause.fill")
                        }
                    }
                    .buttonStyle(.glassProminent)
                    
                }
                
                if timer != nil {
                    HStack {
                        Spacer()
                        Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
                            .font(.largeTitle)
                            .monospacedDigit()
                            .bold()
                            .contentTransition(.numericText())
                        Spacer()
                    }
                    .padding()
                } else {
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
            .padding()
        }
        .onDisappear {
            stopTimer()
        }
        .onChange(of: todoTask) { _, newTask in
            if let task = newTask {
                
                timer?.invalidate()
                
                let totalSeconds = Int(task.timeToComplete)
                hours = totalSeconds / 3600
                minutes = totalSeconds % 3600 / 60
                seconds = totalSeconds % 60
                
                startTimer()
            }
            
        }
    }
    
    func toggleTimer() {
        if timer == nil {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func startTimer() {
        let totalSeconds = hours * 3600 + minutes * 60 + seconds
        guard totalSeconds > 0 else { return }
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let currentSeconds = hours * 3600 + minutes * 60 + seconds
            
            if currentSeconds > 0 {
                let newTotal = currentSeconds - 1
                hours = newTotal / 3600
                minutes = newTotal % 3600 / 60
                seconds = newTotal % 60
                
                if let task = todoTask {
                    task.timeToComplete = TimeInterval(newTotal)
                }
                
            } else {
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        todoTask = nil
    }
}

struct TaskTimerEntryView: View {
    @Bindable var todoTask: ToDoTask
    var activeTask: ToDoTask?
    var timerIsRunning: Bool
    var onStart: (ToDoTask) -> Void
    
    private var isPlaying: Bool {
        return activeTask == todoTask && timerIsRunning
    }
    
    var body: some View {
        HStack {
            Image(systemName: todoTask.priority.indicatorImage())
                .foregroundStyle(todoTask.priority.priorityColor())
                .font(.title)
            VStack(alignment: .leading) {
                Text(todoTask.name)
                    .font(.title)
                Text("Due to: \(todoTask.dueDate.formatted(date: .numeric, time: .omitted))")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                
            }
            .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button {
                onStart(todoTask)
            } label: {
                HStack {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    Text("\(Duration.seconds(todoTask.timeToComplete).formatted())")
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .buttonStyle(.plain)
        .listRowBackground(isPlaying ? Color.accentColor.opacity(0.1) : Color.clear)
    }
}
