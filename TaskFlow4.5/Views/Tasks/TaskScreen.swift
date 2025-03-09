//
//  TaskScreen.swift
//  TaskFlow4.5
//
//  Created by Joseph DeWeese on 3/6/25.
//

import SwiftData
import SwiftUI

struct TaskScreen: View {
    // MARK: - Environment Properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Item Property
    let item: Item?
    @State var itemTasks: [ItemTask]
    @State var itemCategory: Category  // Item category
    @State private var showAddTaskSheet: Bool = false  // Toggles the add itemTask sheet visibility
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {  // Use ZStack to layer content and button
                ScrollView {  // Isolate scrolling to ItemList
                    VStack(alignment: .leading, spacing: 7) {
                        
                        HStack {
                            
                        }
                        .padding(.horizontal, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(itemCategory.color.opacity(0.4), lineWidth: 2)
                        )
                        //       TaskList(itemTasks: $itemTasks)
                    }
                }
                .sheet(isPresented: $showAddTaskSheet) {  // Presents sheet for adding new items
                    AddTaskView( itemCategory: itemCategory)
                        .presentationDetents([.medium])
                }
            }
        }
    }
}
  
