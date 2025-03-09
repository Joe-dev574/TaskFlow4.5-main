//
//  TaskList.swift
//  TaskFlow4.5
//
//  Created by Joseph DeWeese on 3/7/25.
//


import SwiftUI
import SwiftData

// MARK: - Main App View
/// The main view of the task app, displaying a list of tasks and providing CRUD functionality.
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
                    .swipeActions(edge: .trailing) {
                        // Edit action
                        Button(role: .none) {
                            taskToEdit = task
                            showingAddTask = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                        
                        // Delete action
                        Button(role: .destructive) {
                            deleteTask(task)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        taskToEdit = nil
                        showingAddTask = true
                    }) {
                        HStack(spacing: 7) {
                            // Button label text
                            Text("Add Task")
                                .font(.subheadline)  // Smaller font for button appearance
                                .foregroundStyle(.white)  // White text for contrast
                            
                            
                            // Plus icon to indicate adding a new task
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)  // Larger icon size for visibility
                                .foregroundStyle(.white)  // White icon for consistency
                        }
                        .padding(7)  // Internal padding for the button content
                        .background(itemCategory.color.gradient)  // Gradient background matching category
                        .clipShape(
                            RoundedRectangle(cornerRadius: 10)
                        )  // Rounded corners for a button-like look
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                TaskFormView(taskToEdit: $taskToEdit)
            }
        }
    }
    // MARK: - Methods
    /// Handles events triggered from TaskRowView.
     func handleTaskRowEvent(_ event: TaskRowEvent, for task: ItemTask) {
        switch event {
        case .toggleCompletion:
            task.toggleCompletion()
            saveContext()
        }
    }
    
    /// Deletes the specified task from the model context.
     func deleteTask(_ task: ItemTask) {
        modelContext.delete(task)
        saveContext()
    }
    
    /// Saves changes to the model context.
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    
    // MARK: - Task Form View
    /// A form view for adding or editing a task.
    struct TaskFormView: View {
        // MARK: - Properties
        @Environment(\.dismiss) private var dismiss
        @Environment(\.modelContext) private var modelContext
        @Binding var taskToEdit: ItemTask?
        @State private var taskName: String = ""
        @State private var taskDescription: String = ""
        
        private var isEditing: Bool {
            taskToEdit != nil
        }
        
        // MARK: - Body
        var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Task Details")) {
                        TextField("Task Name", text: $taskName)
                            .accessibilityLabel("Task name")
                        TextField("Description", text: $taskDescription, axis: .vertical)
                            .lineLimit(3...10)
                            .accessibilityLabel("Task description")
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
        
        // MARK: - Methods
        /// Saves a new task or updates an existing one.
        private func saveOrUpdateTask() {
            if let task = taskToEdit {
                // Update existing task
                task.updateTaskName(taskName)
                task.taskDescription = taskDescription
            } else {
                // Create new task
                let newTask = ItemTask(taskName: taskName, taskDescription: taskDescription)
                modelContext.insert(newTask)
            }
            saveContext()
        }
        
        /// Saves changes to the model context.
        private func saveContext() {
            do {
                try modelContext.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}

