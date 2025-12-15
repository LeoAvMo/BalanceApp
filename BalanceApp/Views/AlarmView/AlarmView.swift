//
//  AlarmView.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 09/12/25.
//

import SwiftUI
import SwiftData
import AlarmKit

struct AlarmView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ToDoTask.orderIndex) private var tasks: [ToDoTask]
    
    @State private var todoTask: ToDoTask?
    @State private var viewModel = AlarmViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ToDoTaskTimerView(todoTask: $todoTask, viewModel: viewModel) {
                        saveProgress()
                    }
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
                        TaskTimerEntryView(todoTask: toTask, activeTask: todoTask, timerIsRunning: viewModel.activeAlarm != nil) { selectedTask in
                            handleTaskSelection(selectedTask)
                        }
                    }
                }
            }
            // Save when Live Activity pauses remotely
            .onChange(of: viewModel.activeAlarm?.state) { oldValue, newState in
                if newState == .paused {
                     saveProgress()
                }
            }
            .listStyle(.inset)
            .navigationTitle("Focus")
        }
    }
    
    private func saveProgress() {
        guard let task = todoTask, let remaining = viewModel.currentRemainingTime() else { return }
        task.timeToComplete = remaining
        try? modelContext.save()
    }
    
    private func handleTaskSelection(_ selectedTask: ToDoTask) {
        if viewModel.activeAlarm != nil {
            saveProgress()
            viewModel.stopActiveAlarm()
        }
        if todoTask == selectedTask {
            todoTask = nil
        } else {
            self.todoTask = selectedTask
            viewModel.startTaskTimer(task: selectedTask)
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
    var viewModel: AlarmViewModel
    var onSave: () -> Void
    
    var isRunning: Bool { viewModel.activeAlarm != nil }
    var isPaused: Bool { viewModel.activeAlarm?.state == .paused }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.accentColor.opacity(0.1))
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
                    
                    if isRunning || isPaused {
                        Button {
                            onSave()
                            viewModel.stopActiveAlarm()
                            todoTask = nil
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Button {
                        toggleTimer()
                    } label: {
                        HStack {
                            if !isRunning { Text("Start") }
                            Image(systemName: isRunning && !isPaused ? "pause.fill" : "play.fill")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if let _ = viewModel.activeAlarm {
                    HStack {
                        Spacer()
                        // 1. If running: Use fireDate from Activity for ticking timer
                        if let fireDate = viewModel.currentFireDate() {
                            Text(timerInterval: Date.now...fireDate, countsDown: true)
                                .font(.largeTitle)
                                .monospacedDigit()
                                .bold()
                        }
                        // 2. If paused: Use remaining time from Activity/Alarm
                        else if let remaining = viewModel.currentRemainingTime() {
                            Text(Duration.seconds(remaining).formatted(.time(pattern: .hourMinuteSecond)))
                                .font(.largeTitle)
                                .monospacedDigit()
                                .bold()
                        }
                        Spacer()
                    }
                    .padding()
                } else {
                    HStack {
                        Picker("Hours", selection: $hours) { ForEach(0..<24) { Text("\($0)") } }.pickerStyle(.wheel)
                        Text(":")
                        Picker("Minutes", selection: $minutes) { ForEach(0..<60) { Text("\($0)") } }.pickerStyle(.wheel)
                        Text(":")
                        Picker("Seconds", selection: $seconds) { ForEach(0..<60) { Text("\($0)") } }.pickerStyle(.wheel)
                    }
                    .frame(height: 100)
                }
            }
            .padding()
        }
    }
    
    func toggleTimer() {
        if let _ = viewModel.activeAlarm {
            if isPaused {
                viewModel.resumeActiveAlarm()
            } else {
                onSave()
                viewModel.pauseActiveAlarm()
            }
        } else {
            if let task = todoTask {
                viewModel.startTaskTimer(task: task)
            } else {
                let totalSeconds = TimeInterval(hours * 3600 + minutes * 60 + seconds)
                if totalSeconds > 0 {
                    viewModel.startFreeTimer(duration: totalSeconds)
                }
            }
        }
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
                    .font(.title3)
                    .bold()
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
                    Image(systemName: isPlaying ? "xmark" : "play.fill")
                    if isPlaying {
                        Text("In Progress")
                            .monospacedDigit()
                    } else {
                        Text("\(Duration.seconds(todoTask.timeToComplete).formatted(.time(pattern: .hourMinuteSecond)))")
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .buttonStyle(.plain)
        .listRowBackground(isPlaying ? Color.accentColor.opacity(0.1) : Color.clear)
    }
}
