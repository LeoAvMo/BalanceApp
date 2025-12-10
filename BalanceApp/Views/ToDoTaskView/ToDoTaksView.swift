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
    @Query private var tasks: [ToDoTask]
    
    @State private var filteredPriority: Priority? = nil
    @State private var topTask: ToDoTask? = nil
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
                            .padding(.vertical)
                        
                        // List title and rearranging button
                        HStack {
                            Text("All tasks")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Button {
                                
                            } label: {
                                HStack {
                                    Image(systemName: "square.and.pencil")
                                    Text("Edit")
                                }
                            }
                            .buttonStyle(.glassProminent)
                        }
                        .listRowSeparator(.hidden)
                        
                        // Actual List
                        Section {
                            ForEach(tasks) { todoTask in
                                Text(todoTask.name)
                            }
                        }
                        
                    }
                }
            }
            .listStyle(.inset)
            .task {
                topTask = tasks.first
            }
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
