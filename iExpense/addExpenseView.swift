//
//  addExpenseView.swift
//  iExpense
//
//  Created by Kevin Muniz on 1/25/24.
//

import SwiftUI

struct addExpenseView: View {
    @Environment (\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Personal", "Business"]
    
    var expense: Item
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Name", text: $name)
                    
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    
                }
                    
                .toolbar {
                    Button("Save") {
                        saveItem()
                        dismiss()
                    }
                }
                .navigationTitle("Add New Expense")
            }
        }
    }
    func saveItem() {
        let item = Expense(name: name, type: type, amount: amount)
        expense.expenses.append(item)
    }
}
 
#Preview {
    addExpenseView(expense: Item())
}
