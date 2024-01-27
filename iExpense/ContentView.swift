//
//  ContentView.swift
//  iExpense
//
//  Created by Kevin Muniz on 1/24/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var expenses = [ExpenseItem]() {
        didSet {
            if let data = try? JSONEncoder().encode(expenses) {
                UserDefaults.standard.setValue(data, forKey: "expenses")
            }
          }
        }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "expenses") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                expenses = decodedItems
                return
            }
        }
        expenses = []
    }
}

struct ContentView: View {
    @State private var items = Expenses()
    @State private var expenseViewIsShowing = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(items.expenses) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(item.name)")
                                .font(.headline)
                            Text("\(item.type)")
                        }
                        Spacer()
                        
                        Text(item.amount, format: .currency(code: "USD"))
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
    
    func deleteItem(offset: IndexSet) {
        items.expenses.remove(atOffsets: offset)
    }
    
}

#Preview {
    ContentView()
}
