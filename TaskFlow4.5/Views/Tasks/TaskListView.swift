//
//  TaskListView.swift
//  TaskFlow4.5
//
//  Created by Joseph DeWeese on 3/6/25.
//

import SwiftData
import SwiftUI

struct TaskListView: View {
    // MARK: - Environment and State Properties
    @Environment(\.modelContext) var modelContext
    @State private var showAddTaskSheet: Bool = false  // Toggles the add itemTask sheet visibility
    let item: Item
    @State var itemTasks: [ItemTask] = []
    @State var itemCategory: Category  // Item category
    
    
    var body: some View {
        NavigationStack {
            ZStack{
                ScrollView{
                    VStack(alignment: .leading, spacing: 7) {
                    
                            VStack(alignment: .leading) {
                                Text("All Tasks")
                                    .font(.system(.title3))
                                    .foregroundStyle(.mediumGrey)
                                    .padding(.horizontal, 4)
                          
                                    Text("\(itemTasks.count)")
                                        .font(.system(.title))
                                        .fontWeight(.semibold)
                                        .foregroundColor(itemCategory.color)
                                        .padding(.leading, 30)
                                        .padding(.top, 4)
                                }
                            .padding(.horizontal, 12)
                            .padding(4)
                        }
                        .padding(.horizontal, 12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(itemCategory.color.opacity(0.4), lineWidth: 2)
                            )
                    }
                .navigationTitle("Add Task")
                .navigationBarTitleDisplayMode(.inline)
                }
            addTaskButton  // Floating action button pinned to bottom-right
                .frame(
                    maxWidth: .infinity, maxHeight: .infinity,
                    alignment: .centerLastTextBaseline)
                .padding(.bottom, 12)
        }
            .blur(radius: showAddTaskSheet ? 8 : 0)  // Blurs content when sheet is active
            .sheet(isPresented: $showAddTaskSheet) {  // Presents sheet for adding new items
                AddTaskView( itemCategory: itemCategory)
                    .presentationDetents([.medium])
            }
            }
        
    // MARK: - Subviews
    /// Floating button to trigger the add item sheet
    private var addTaskButton: some View {
        Button(action: {
            showAddTaskSheet = true
            HapticsManager.notification(type: .success)  // Provides haptic feedback on tap
        }) {
            Image(systemName: "plus")
                .font(.callout)
                .foregroundStyle(.white)
                .frame(width: 45, height: 45)
                .background(.blue.gradient)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)
        }
        .padding()  // Adds padding around button
        .accessibilityLabel("Add New Item")
        .padding(.bottom, 10)
    }
    func delete(_ indexSet: IndexSet) {
        for index in indexSet {
            itemTasks.remove(at: index)
        }
        try! modelContext.save()
    }
}
