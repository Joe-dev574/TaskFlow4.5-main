//
//  TaskList.swift
//  TaskFlow4.5
//
//  Created by Joseph DeWeese on 3/7/25.
//

import SwiftUI
import SwiftData




struct TaskList: View {
    @Environment(\.modelContext) private var context
    @Binding var itemTasks: [ItemTask]  // Binding to the parent’s task array
    
    var body: some View {
        Text("Task List")
    }
}
#Preview {
    ContentView()
}
