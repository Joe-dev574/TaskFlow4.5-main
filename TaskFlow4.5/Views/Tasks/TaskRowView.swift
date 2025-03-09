//
//  TaskRowView.swift
//  TaskFlow4.5
//
//  Created by Joseph DeWeese on 3/6/25.
//

import SwiftUI
import SwiftData


import SwiftUI
import SwiftData

enum TaskRowEvent {
    case toggleCompletion
}

struct TaskRowView: View {
    @Environment(\.modelContext) private var modelContext
    let itemTask: ItemTask
    let onEvent: (TaskRowEvent) -> Void
    @State private var checked: Bool = false

    private func formatItemTaskDate(_ date: Date) -> String {
        if date.isToday {
            return "Today"
        } else if date.isYesterday {
            return "Yesterday"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: {
                checked.toggle()
                onEvent(.toggleCompletion)
            }) {
                Image(systemName: checked ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(checked ? .green : .gray)
                    .font(.system(size: 24))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(checked ? "Mark as incomplete" : "Mark as complete")

            VStack(alignment: .leading, spacing: 4) {
                Text(itemTask.taskName)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .strikethrough(checked, color: .gray)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !itemTask.taskDescription.isEmpty {
                    Text(itemTask.taskDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .strikethrough(checked, color: .gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text(formatItemTaskDate(itemTask.dateCreated))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .onAppear {
            checked = itemTask.isCompleted
        }
        .onChange(of: itemTask.isCompleted) { newValue in
            checked = newValue
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Task: \(itemTask.taskName), \(checked ? "completed" : "not completed")")
        .accessibilityHint("Tap the button to toggle completion")
    }
}

extension Date {
    var isYesterday: Bool { Calendar.current.isDateInYesterday(self) }
 
}
