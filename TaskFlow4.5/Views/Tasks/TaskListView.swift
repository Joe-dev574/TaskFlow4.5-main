//
//  TaskList.swift
//  TaskFlow4.5
//
//  Created by Joseph DeWeese on 3/7/25.
//


import SwiftUI
import SwiftData

struct TaskListView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ItemTask.dateCreated, order: .reverse) private var tasks: [ItemTask]
    @State var showingAddTask = false
    @State var taskToEdit: ItemTask?
    @State var itemCategory: Category = .today
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    TaskRowView(itemTask: task) { event in
                        handleTaskRowEvent(event, for: task)
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(Color(.systemBackground))
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .swipeActions(edge: .leading) {
                        Button(role: .none) {
                            taskToEdit = task
                            showingAddTask = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteTask(task)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        taskToEdit = nil
                        showingAddTask = true
                    }) {
                        HStack(spacing: 7) {
                            Text("Add Task")
                                .font(.subheadline)
                                .foregroundStyle(.white)
                            
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                                .foregroundStyle(.white)
                        }
                        .padding(7)
                        .background(itemCategory.color.gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.horizontal, 7)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text("Tasks")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(itemCategory.color)
                        .padding(.horizontal, 12)
                }
            }
            .sheet(isPresented: $showingAddTask) {
//                TaskFormView(taskToEdit: $taskToEdit, itemCategory: $itemCategory)
                AddTaskView(taskToEdit: $taskToEdit, itemCategory: itemCategory)
                    .presentationDetents([.medium])
            }
            .background(Color(.systemGroupedBackground))
        }
    }
    
    // MARK: - Methods
    func handleTaskRowEvent(_ event: TaskRowEvent, for task: ItemTask) {
        switch event {
        case .toggleCompletion:
            task.toggleCompletion()
            saveContext()
        }
    }
    
    func deleteTask(_ task: ItemTask) {
        modelContext.delete(task)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    // MARK: - Task Form View
    struct TaskFormView: View {
        @Environment(\.dismiss) private var dismiss
        @Environment(\.modelContext) private var modelContext
        @Binding var taskToEdit: ItemTask?
        @Binding var itemCategory: Category
        @State private var taskName: String = ""
        @State private var taskDescription: String = ""
        @State private var dateCreated: Date = .now
        @State private var taskDueDate: Date = .now
        @State private var category: Category = .today
        
        private var isEditing: Bool {
            taskToEdit != nil
        }
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack {
                        Form {
                            Section(header: Text("Task Details")) {
                                TextField("Task Name", text: $taskName)
                                    .accessibilityLabel("Task name")
                                    .foregroundStyle(.mediumGrey)
                                TextField("Description", text: $taskDescription, axis: .vertical)
                                    .lineLimit(3...10)
                                    .accessibilityLabel("Task description")
                                    .foregroundStyle(.mediumGrey)
                            }.foregroundStyle(.mediumGrey)
                        }
                    }
                }
                .navigationTitle(isEditing ? "Edit Task" : "Add Task")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(isEditing ? "Save" : "Add") {
                            saveOrUpdateTask()
                            dismiss()
                        }
                        .disabled(taskName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .onAppear {
                    if let task = taskToEdit {
                        taskName = task.taskName
                        taskDescription = task.taskDescription
                    }
                }
            }
        }
        
        private func saveOrUpdateTask() {
            if let task = taskToEdit {
                task.updateTaskName(taskName)
                task.taskDescription = taskDescription
            } else {
                let newTask = ItemTask(taskName: taskName, taskDescription: taskDescription)
                modelContext.insert(newTask)
            }
            saveContext()
        }
        
        private func saveContext() {
            do {
                try modelContext.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
