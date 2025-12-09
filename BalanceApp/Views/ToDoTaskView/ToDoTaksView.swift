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
            ScrollView {
                if !tasks.isEmpty {
                    ContentUnavailableView("No Tasks", systemImage: "checkmark.seal.fill", description: Text("It looks like you have no tasks left to do. Add some tasks to get started!"))
                } else {
                    MostImportantTaskView(topTask: topTask)
                        .padding()
                }
            }
            .task {
                topTask = placeholderTask
            }
            .navigationTitle("Tasks")
            .sheet(isPresented: $showSheet) {
                AddToDoTaskView()
                    .presentationDetents([.medium])
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

struct MostImportantTaskView: View{
    var topTask: ToDoTask?
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(topTask?.priority.priorityColor() ?? Color.gray)
                
                VStack {
                    Text(topTask?.name ?? "None")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
        
                
                
    }
}

let placeholderTask = ToDoTask(name: "Finire il rapporto di biotecnologia", priority: .high, dueDate: Date(), timeToComplete: 1800)
