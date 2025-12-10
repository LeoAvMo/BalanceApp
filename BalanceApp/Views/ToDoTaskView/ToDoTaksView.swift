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
                                        Text("\(Duration.seconds(todoTask.timeToComplete).formatted())")
                                            .font(.caption)
                                            .foregroundStyle(.accent.opacity(0.8))
                                    }
                                    .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Button {
                                        // Delete task
                                        // Add +1 to user defaults of completed tasks
                                    } label: {
                                        Image(systemName: "checkmark")
                                    }
                                    .buttonStyle(.borderedProminent)
                                    
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
            }
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
                    showSheet.toggle()
                }
            }
        }
    }
    
    private func deleteTodoTask(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tasks[index])
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
                            
                        } label: {
                            HStack {
                                Image(systemName: "clock.fill")
                                Text("\(Duration.seconds(topTask?.timeToComplete ?? 0).formatted())")
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

let placeholderTask = ToDoTask(name: "Finire il rapporto di biotecnologia", priority: .high, dueDate: Date(), timeToComplete: 1800)
