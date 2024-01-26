//
//  ContentView.swift
//  iExpense
//
//  Created by Kevin Muniz on 1/24/24.
//

import SwiftUI

struct Expense: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Item {
    var expenses = [Expense]()
}

struct ContentView: View {
    @State private var items = Item()
    @State private var expenseViewIsShowing = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(items.expenses) { item in
                    HStack{
                        Text("Name: \(item.name)")
                        Text("Type: \(item.type)")
                        Text("Amount: \(item.amount.formatted())")
                    }
                }.onDelete(perform: deleteItem)
                
                
            }.toolbar {
                    Button("Add Expense", systemImage: "plus") {
                        expenseViewIsShowing.toggle()
                    }
            }
            .sheet(isPresented: $expenseViewIsShowing) {
                addExpenseView(expense: items)
            }            .navigationTitle("iExpense")
        }
    }
    func addItem() {
        let newItem = Expense(name: "test", type: "Financial", amount: 20.0)
        items.expenses.append(newItem)
    }
    
    func deleteItem(offset: IndexSet) {
        items.expenses.remove(atOffsets: offset)
    }
    
}

#Preview {
    ContentView()
}
