//
//  ToDoTaksView.swift
//  BalanceApp
//
//  Created by Leo A.Molina on 09/12/25.
//

import SwiftUI
import SwiftData

struct ToDoTaksView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ToDoTask.orderIndex) private var tasks: [ToDoTask]
    
    @State private var filteredPriority: Priority? = nil
    @State private var selectedTask: ToDoTask? = nil
    
    private var topTask: ToDoTask? {
        if tasks.isEmpty {
            return nil
        } else {
            return tasks.first
        }
    }
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if tasks.isEmpty {
                        NoTasksView()
                            .listRowSeparator(.hidden)
                    } else {
                        // Most important task modal
                        MostImportantTaskView(topTask: topTask)
                            .listRowSeparator(.hidden)
                        
                        // List title and rearranging button
                        HStack {
                            Text("All tasks")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        
                        // Actual List
                        Section {
                            ForEach(tasks) { todoTask in
                                Button {
                                    selectedTask = todoTask
                                } label: {
                                    TaskEntryView(todoTask: todoTask)
                                }
                            }
                            .onMove(perform: moveTask)
                        }
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Tasks")
            .sheet(isPresented: $showSheet) {
                AddToDoTaskView()
                    .presentationDetents([.medium])

            }
            
            .sheet(item: $selectedTask) { todoTask in
                EditToDoTask(task: todoTask)
                    .presentationDetents([.medium])
            }
            .toolbar {
                Menu ("Sort by", systemImage: "arrow.up.arrow.down") {
                    
                    Button("Incoming date",
                           systemImage: "calendar",
                           action: sortByIncomingDate)
                    
                    Button("Least time",
                           systemImage: "arrow.trianglehead.2.counterclockwise.rotate.90",
                           action: sortByLeastTime)
                    
                    Button("Most time",
                           systemImage: "arrow.trianglehead.2.clockwise.rotate.90",
                           action: sortByMostTime)
                    
                    Button("Least to most priority",
                           systemImage: "chart.bar.xaxis.ascending",
                           action: sortByLeastPriority)
                    
                    Button("Most to least priority",
                           systemImage: "chart.bar.xaxis.descending",
                           action: sortByHighestPriority)
                    
                }
                Button("Add Task", systemImage: "plus") {
                    showSheet.toggle()
                }
            }
        }
    }
    
    private func moveTask(from source: IndexSet, to destination: Int) {
        var todoTasks = tasks
        todoTasks.move(fromOffsets: source, toOffset: destination)
        for (index, item) in todoTasks.enumerated() {
            item.orderIndex = index
        }
    }
    
    func sortByIncomingDate() {
        let sortedTasks: [ToDoTask] = tasks.sorted { $0.dueDate < $1.dueDate }
        var counter = 0
        for todoTask in sortedTasks {
            todoTask.orderIndex = counter
            counter += 1
        }
    }
    
    func sortByLeastTime() {
        let sortedTasks: [ToDoTask] = tasks.sorted { $0.timeToComplete < $1.timeToComplete }
        var counter = 0
        for todoTask in sortedTasks {
            todoTask.orderIndex = counter
            counter += 1
        }
    }
    
    func sortByMostTime() {
        let sortedTasks: [ToDoTask] = tasks.sorted { $0.timeToComplete > $1.timeToComplete }
        var counter = 0
        for todoTask in sortedTasks {
            todoTask.orderIndex = counter
            counter += 1
        }
    }

    func sortByLeastPriority() {
        let sortedTasks: [ToDoTask] = tasks.sorted { $0.priority.toInt() < $1.priority.toInt() }
        var counter = 0
        for todoTask in sortedTasks {
            todoTask.orderIndex = counter
            counter += 1
        }
    }
    
    func sortByHighestPriority() {
        let sortedTasks: [ToDoTask] = tasks.sorted { $0.priority.toInt() > $1.priority.toInt() }
        var counter = 0
        for todoTask in sortedTasks {
            todoTask.orderIndex = counter
            counter += 1
        }
    }
    
}

#Preview {
    ToDoTaksView()
}

struct NoTasksView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(.accent.opacity(0.1))
            VStack {
                Image("Lumi")
                    .resizable()
                    .scaledToFill()
                    .padding(-30)
                    .offset(y: 26)
                    .frame(width: 50, height: 50)
                    .padding(.top, 15)
                ContentUnavailableView("No Tasks", systemImage: "", description: Text("It looks like you have no tasks left to do. Add some tasks to get started!"))
            }
        }
    }
}

struct MostImportantTaskView: View {
    @Environment(\.modelContext) private var modelContext
    var topTask: ToDoTask?
    
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(.accent.opacity(0.1))
                VStack (spacing: 10){
                    HStack {
                        Image("Lumi")
                            .resizable()
                            .scaledToFit()
                            .padding(-15)
                            .offset(y: 1)
                            .frame(width: 30, height: 30)
                        Text("Your next task is:")
                            .font(.subheadline)
                        Spacer()
                        Button {
                            withAnimation {
                                if let topTask = topTask {
                                    modelContext.delete(topTask)
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "checkmark")
                                Text("Mark as done")
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                        }
                    }
                    
                    .buttonStyle(.borderedProminent)
                    HStack{
                        Text(topTask?.name ?? "None")
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                    }
                    
                    HStack {
                        Text("Due to: \(topTask?.dueDate.formatted(date: .numeric, time: .omitted) ?? "Unknown")")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        Spacer()
                        HStack {
                            Image(systemName: topTask?.priority.indicatorImage() ?? "gauge.with.dots.needle.0percent")
                            Text("\(topTask?.priority.rawValue ?? "Unknown") Priority")
                        }
                        .foregroundStyle(topTask?.priority.priorityColor() ?? .gray)
                        .font(.footnote)
                        .fontWeight(.semibold)
                    }
                    .padding(.horizontal, 8)
                }
                .padding()
            }  
            .frame(maxWidth: .infinity)
    }
}

struct TaskEntryView: View {
    @Environment(\.modelContext) private var modelContext
    var todoTask: ToDoTask
    
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
                Text("\(Duration.seconds(todoTask.timeToComplete).formatted())")
                    .font(.caption)
                    .foregroundStyle(.accent.opacity(0.8))
            }
            .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button {
                // Delete task
                withAnimation {
                    modelContext.delete(todoTask)
                }
                // Add +1 to user defaults of completed tasks
            } label: {
                Image(systemName: "checkmark")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
