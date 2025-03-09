//
//  TaskRowView.swift
//  TaskFlow4.5
//
//  Created by Joseph DeWeese on 3/6/25.
//

import SwiftUI
import SwiftData


// MARK: - Task Row Event
/// An enumeration defining possible events for a task row.
enum TaskRowEvent {
    case toggleCompletion  // Event for toggling task completion
}
// MARK: - Task Row View
/// A view representing a single task row in the task list.
struct TaskRowView: View {
    // MARK: - Properties
    @Environment(\.modelContext) var modelContext
    let itemTask: ItemTask  // The task to display
    let onEvent: (TaskRowEvent) -> Void  // Closure to handle events (e.g., toggling completion)
    @State private var checked: Bool = false
    
    private func formatItemTaskDate(_ date: Date) -> String {
        
        if date.isToday {
            return "Today"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }
    // MARK: - Body
    var body: some View {
        HStack(alignment: .top) {
            // Button to toggle task completion
                        Button(action: {
                            onEvent(.toggleCompletion)  // Trigger toggle completion event when tapped
                        }) {
                            Image(systemName: itemTask.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(.gray)  // Placeholder color; replace with your desired color
                        }
                        .buttonStyle(.plain)  // Remove default button styling
            
            VStack {
                Text(itemTask.taskName)
                    .strikethrough(itemTask.isCompleted)  // Strikethrough if completed
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(itemTask.taskDescription)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .strikethrough(itemTask.isCompleted)  // Strikethrough if completed
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    
                    if let taskDueDate = itemTask.taskDueDate {
                        Text(formatItemTaskDate(taskDueDate))
                    }
                    
                    if let taskDueTime = itemTask.taskDueTime {
                        Text(taskDueTime, style: .time)
                    }
                    
                }.font(.caption)
                    .foregroundStyle(.mediumGrey)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
        }
        .padding(.vertical, 8)  // Vertical padding for the row
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Task: \(itemTask.taskName), \(itemTask.isCompleted ? "completed" : "not completed")")
                .accessibilityHint("Tap to toggle completion")
            }
        }
//#Preview {
//    #Preview { @MainActor in
//        TaskRowViewContainer()
//   //         .modelContainer(previewContainer)
//    }
//}

